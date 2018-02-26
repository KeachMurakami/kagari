# Default output file is .XLS
# Since neither {readxl} nor {xlsx} deals with the files, the files must be manually converted into another format.

read_mch <-
  function(file_path, col_types = cols(), ..., .verbose = F){

    data_all <-
      suppressWarnings(readr::read_csv(file_path, col_types = col_types, ...))

    if(.verbose){
      data_all <-
        readr::read_csv(file_path, col_types = col_types)
    }

    data_all %>%
      dplyr::transmute(time = paste(Date, Time),
                       time = lubridate::ymd_hms(time),
                       rh = Ch1_Value,
                       temp = Ch2_Value,
                       co2 = Ch3_Value)
  }

plot_mch <-
  function(.tbl, shown_variables = c("rh", "temp", "co2")){
    .tbl %>%
      tidyr::gather(variable, value, -time) %>%
      dplyr::filter(variable %in% shown_variables) %>%
      ggplot(aes(time, value)) +
      geom_point() +
      facet_grid(variable ~ ., scale = "free")
  }
