read_junior_pam <-
  function(file_path, ...){

    data_body <-
      file_path %>%
      readr::read_csv(skip = 1) %>%
      dplyr::slice(-1)

    data_body %>%
      dplyr::select(date = Date, hhmmss = Time, type = Type,
                    ppfd = `1:PAR`, y2 = `1:Y (II)`,
                    fm = `1:Fm'`, f = `1:F`, ...) %>%
      dplyr::mutate(time = paste(date, hhmmss),
                    time = lubridate::ymd_hms(time))
  }
