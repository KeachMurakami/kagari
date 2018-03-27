read_field_lambda <-
  function(file_path, unit_select = c("photon", "irradiance")[1], col_types = cols(), ..., .verbose = F){

    measured_times <-
      file_path %>%
      data.table::fread(nrows = 1) %>%
      names %>%
      stringr::str_subset(pattern = "^[:digit:]{4}") %>%
      lubridate::ymd_hms() %>%
      dplyr::data_frame(log_number = seq_along(.), time = .)

    column_num <-
      suppressWarnings(readr::read_csv(file_path, skip = 39, col_types = col_types)) %>%
      ncol - 1

    column_names <-
      paste0(rep(c("irradiance", "photon"), times = column_num/2), "_", rep(1:(column_num/2), each = 2))

    data_body <-
      suppressWarnings(readr::read_csv(file_path, skip = 39, col_names = c("wavelength", column_names), col_types = col_types, ...))
    if(.verbose){
      data_body <-
        readr::read_csv(file_path, skip = 39, col_names = c("wavelength", column_names), col_types = col_types, ...)
    }

    data_body %>%
      tidyr::gather(variable, value, -wavelength) %>%
      tidyr::separate(variable, c("unit", "log_number")) %>%
      dplyr::mutate(file = file_path,
                    log_number = as.numeric(log_number)) %>%
      dplyr::filter(unit == unit_select) %>%
      dplyr::left_join(., measured_times, by = "log_number")
  }

calc_reflectance <-
  function(tbl, design_vector = c(standard = F, target_object = T)){

    standards <- which(!design_vector)

    if(!design_vector[1]){
      group <- cumsum(!design_vector)
    } else {
      group <- cumsum(design_vector)
    }

    tbl %>%
      dplyr::mutate(is_object = log_number %!in% standards,
                    group_number = group[log_number]) %>%
             {
               white_spectra <-
                 dplyr::filter(., is_object == F) %>%
                 dplyr::transmute(wavelength, group_number, raw_standard = value)
               leaf_spectra <-
                 dplyr::filter(., is_object == T) %>%
                 dplyr::rename(raw_leaf = value)

               dplyr::left_join(leaf_spectra,
                                white_spectra,
                                by = c("wavelength", "group_number")) %>%
                 dplyr::transmute(file, time, log_number, unit, wavelength, reflectance = raw_leaf / raw_standard) %>%
                 return()
             }
  }


calc_band <-
  function(tbl_group, band_1 , band_2){
    tbl_group %>%
    {
      band_1 <-
        dplyr::filter(., dplyr::between(wavelength, range(band_1)[1], range(band_1)[2])) %>%
        summarise(band_1 = sum(reflectance, na.rm = T))
      band_2 <-
        dplyr::filter(., dplyr::between(wavelength, range(band_2)[1], range(band_2)[2])) %>%
        dplyr::summarise(band_2 = sum(reflectance, na.rm = T))
      left_join(band_1, band_2, by = group_vars(tbl_group))
    }
  }

`_calc_index` <-
  function(tbl_group, width, center_shorter, center_longer){
    band_half <- width / 2
    calc_band(tbl_group, (center_shorter - band_half):(center_shorter + band_half), (center_longer - band_half):(center_longer + band_half))
  }

calc_pri <-
  function(tbl_group, width){
    `_calc_index`(tbl_group, center_shorter = 531, center_longer = 570, width) %>%
      dplyr::mutate(pri = (band_1 - band_2)/(band_1 + band_2))
  }
