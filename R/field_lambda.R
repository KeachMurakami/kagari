

read_spectra <-
  function(file_path, unit_select = "photon"){

    file_path %>%
      fread(nrows = 1)

    column_num <-
      file_path %>%
      readr::read_csv(skip = 39) %>%
      ncol - 1

    column_names <-
      paste0(rep(c("lumen", "photon"), times = column_num/2), "_", rep(1:(column_num/2), each = 2))

    readr::read_csv(file_path, skip = 39, col_names = c("wavelength", column_names)) %>%
      tidyr::gather(variable, value, -wavelength) %>%
      tidyr::separate(variable, c("unit", "log_number")) %>%
      dplyr::mutate(file = file_path,
                    log_number = as.numeric(log_number)) %>%
      dplyr::filter(unit == unit_select)
  }

calc_reflectance <-
  function(tbl, design_vector = c(standard = F, target_object = T)){

    tbl %>%
      dplyr::mutate(is_object = log_number %% length(design_vector) %in% which(design_vector),
                    group_number = (log_number - 1) %/% length(design_vector) + 1) %>%
             {
               white_spectra <<-
                 dplyr::filter(., is_object == F) %>%
                 dplyr::rename(raw_standard = value) %>%
                 dplyr::select(-log_number)
               leaf_spectra <<-
                 dplyr::filter(., is_object == T) %>%
                 dplyr::rename(raw_leaf = value)
             }

    dplyr::left_join(leaf_spectra,
                     white_spectra,
                     by = c("wavelength", "group_number", "file", "unit")) %>%
      dplyr::transmute(file, log_number, group_number, unit, wavelength, reflectance = raw_leaf / raw_standard)
  }


# calc_pri_spectr <-
#   function(tbl, band530 = c(526, 536), band570 = c(565, 575)){
#     tbl %>%
#       select(wavelength, log_number, reflectance) %>%
#       {
#         band530 <-
#           filter(., between(wavelength, band530[1], band530[2])) %>%
#           group_by(log_number) %>%
#           summarise(r530 = sum(reflectance))
#         band570 <-
#           filter(., between(wavelength, band570[1], band570[2])) %>%
#           group_by(log_number) %>%
#           summarise(r570 = sum(reflectance))
#         left_join(band530, band570, by = c("log_number")) %>%
#           mutate(pri = calc_pri(r530, r570))
#       }
#   }
