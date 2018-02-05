read_li6400 <-
  function(file_path, col_types = cols(), .verbose = F, ...){
    data_all <-
      suppressWarnings(readr::read_csv(file_path, col_names = FALSE, ...))
    if(.verbose){
      data_all <-
        readr::read_csv(file_path, col_names = FALSE, ...)
    }

    data_all$X1 %>% {
      log_rows <<-
        grep(., pattern = "^[0-9]+\t")
      change_rows <<-
        grep(., pattern = "^[0-9]{2}:")
      pam_rows <<-
        grep(., pattern = "=")
      data_rows <-
        unique(c(log_rows, change_rows, pam_rows))
      info_rows <<-
        seq_along(.) %>%
        `%in%`(data_rows) %>%
        `!` %>%
        which
    }

    change_rows <- change_rows[-1]

    data_info <-
      data_all %>%
      dplyr::slice(info_rows)

    variables <-
      data_info %>%
      tail(1) %$%
      X1 %>%
      stringr::str_split(pattern = "\\\"\\t\"") %>%
      .[[1]] %>%
      stringr::str_replace(pattern = "\\?", replacement = "")

    date_started <-
      unlist(data_info[2,1]) %>%
      stringr::str_sub(start = 5, end = 15) %>%
      lubridate::mdy()

    data_body <-
      data_all %>%
      dplyr::slice(log_rows) %>%
      tidyr::separate(col = X1, into = variables, sep = "\\t") %>%
      dplyr::mutate(time = lubridate::hms(HHMMSS))

    for_check_overnight <-
      data_body$time@hour %>%
      {c(head(., 1), ., tail(., 1))}

    # check overnight
    date_changing_point <-
      (tail(for_check_overnight, -1) - head(for_check_overnight, -1)) %>%
      `<`(0) %>%
      which

    date_correction <-
      rep(length(date_changing_point), nrow(data_body))

    for(i in rev(seq_along(date_changing_point))){
      date_correction[1:(date_changing_point[i] - 1)] <- i - 1
    }

    data_body_cleaned <-
      data_body %>%
      dplyr::mutate(time = lubridate::ymd_hms(paste0(date_started + date_correction, " ", HHMMSS))) %>%
      dplyr::select(-HHMMSS) %>%
      dplyr::mutate_if(is.character, dplyr::funs(as.numeric)) %>%
      dplyr::mutate(file = paste0(basename(file_path)))


    ### information: changes in operational parameters (e.g. PPFD, Ca) during measurement
    if(length(change_rows) == 0){
      operation_info <- NULL
    } else {
      operation_info <-
        data_all %>%
        dplyr::slice(change_rows) %>%
        tidyr::extract(X1, into = c("time", "log"),
                       regex = "(.+:[0-9]+) (.+)") %>%
        dplyr::mutate(time = lubridate::ymd_hms(paste0(date_started + date_correction[change_rows], " ", time)))
    }

    attributes(data_body_cleaned)$info <- operation_info

    return(data_body_cleaned)
  }
