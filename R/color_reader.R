read_color_reader <-
  function(file_path, col_types = cols(), ..., .verbose = F){

    time_cols <- rlang::quos(c(paste0("X", 2:7)))

    data_all <-
      file_path %>%
      readr::read_csv(col_names = F, col_types = col_types)

    data_times <-
      data_all[c(1, 7),] %>%
      dplyr::transmute(time = lubridate::ymd_hms(paste0(X2, "-", X3, "-", X4, " ", X5, ":", X6, ":", X7)),
                       measured_object = c("target", "sample"))

    data_info <-
      data_all[2:6, 1:2]

    data_body <-
      dplyr::bind_cols(
        data_all[8:9, 2:5] %>%
          set_colnames(c("L", "a", "b", "dE76")),
        data_all[10:11, 3:5] %>%
          set_colnames(c("C", "H", "dE94"))
      ) %>%
      dplyr::mutate(measured_object = c("target", "sample")) %>%
      dplyr::mutate(L = as.numeric(L)) %>%
      dplyr::left_join(., data_times, by = "measured_object") %>%
      dplyr::select(measured_object, time, everything())

    attributes(data_body)$info <- data_info

    return(data_body)
    }
