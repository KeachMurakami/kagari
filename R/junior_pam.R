read_junior_pam <-
  function(file_path, col_types = cols(), .verbose = F, ...){

    data_body <-
      suppressWarnings(readr::read_csv(file_path, col_types = col_types, skip = 1)) %>%
      dplyr::slice(-1)
    if(.verbose){
      data_body <-
        readr::read_csv(file_path, col_types = col_types, skip = 1) %>%
        dplyr::slice(-1)
    }

    data_body %>%
      dplyr::transmute(time = paste(Date, Time),
                       time = lubridate::ymd_hms(time),
                       ppfd = `1:PAR`, y2 = `1:Y (II)`,
                       fm = `1:Fm'`, f = `1:F`, ...)
  }
