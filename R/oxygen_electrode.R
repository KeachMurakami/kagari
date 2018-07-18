#' Calculate Pg
#'
#' @description.
#' This function calculates gross photosynthetic rates (Pg) from net O2 evolution and dark O2 uptake rates.
#' @param calb signal amplitude corresponding to 1 mL O2 which was injected for the calibration, unit: grid.
#' @param positive a slope corresponding to net O2 evolution rate, unit: grid min^-1.
#' @param negative a slope corresponding to dark O2 uptake rate, unit: grid min^-1.
#' @param amp an expansion coefficient, no-unit.
#' @param leaf_area an area of the enclosed leaf in the chamber, unit: m^2.
#' @param artefact a factor to correct non-photosynthetic signal, i.e. heating by irradiance, unit: grid min^-1.
#' @export
#' @return a numeric vector
calc_gross_o2 <-
  function(calb, posisitve, negative, amp, leaf_area, artefact) {
    ((posisitve - negative) / calb - artefact) * options()$o2_per_mL / (amp * 60 * leaf_area)
  }


#' Calculate Pmax
#'
#' @description.
#' This function calculates maximum gross photosynthetic rates (Pmax) from net O2 evolution and dark O2 uptake rates.
#' @param calb signal amplitude corresponding to 1 mL O2 which was injected for the calibration, unit: grid.
#' @param positive a slope corresponding to net O2 evolution rate at saturating irradiance, unit: grid min^-1.
#' @param negative a slope corresponding to dark O2 uptake rate, unit: grid min^-1.
#' @param amp an expansion coefficient, no-unit.
#' @param leaf_area an area of the enclosed leaf in the chamber, unit: m^2.
#' @export
#' @return a numeric vector
calc_pgmax_o2 <-
  function(calb, posisitve, negative, amp, leaf_area) {
    calc_gross_o2(calb, posisitve, negative, amp, leaf_area, artefact = options()$heat_artefact_pmax)
  }


#' Calculate functional PSII content
#'
#' @description.
#' This function calculates functional PSII contents according to Chow et al. (doi:10.1071/ PP9910397).
#' @param calb signal amplitude corresponding to 1 mL O2 which was injected for the calibration, unit: grid.
#' @param positive a slope corresponding to net O2 evolution rate under repeatitive single-turnover flashes and weak far-red light, unit: grid min^-1.
#' @param negative a slope corresponding to O2 uptake rate under weak far-red light, unit: grid min^-1.
#' @param amp an expansion coefficient, no-unit.
#' @param leaf_area an area of the enclosed leaf in the chamber, unit: m^2.
#' @param hz a frequency of single-turnover flash, unit: s-1, default: 10.
#' @param e_per_o2 a number of electron consumed in PSII to evolve one O2, unit: mol mol^-1, default: 4.
#' @param artefact a factor to correct non-photosynthetic signal, i.e. heating by irradiance, unit: grid min^-1.
#' @export
#' @return a numeric vector
calc_psii <-
  function(calb, positive, negative, amp, leaf_area, hz = 10, e_per_o2 = 4, artefact = options()$heat_artefact_psii) {
    ((positive - negative) / calb - artefact) * options()$o2_per_mL * e_per_o2 / (amp * 60 * leaf_area * hz)
  }


#' Calculate cyt f content
#'
#' @description.
#' This function calculates cytochrome f content according to Dwyer et al. (2012; doi:10.1093/jxb/ers156).
#' @param pmax maximum gross photosynthetic O2 evolution rate, unit: micro mol m^-2 s^-1
#' @param psii functional PSII content, unit: micro mol m^-2.
#' @param coefs coefficients for the calculation reported by Dwyer et al. (2012).
#' @export
#' @return a numeric vector
calc_cytf <-
  function(pmax, psii, coefs = c(.0217, .004)) {
    coefs[1] / (1 / pmax - coefs[2] / psii)
  }

#' Calculate Pmax, functional PSII content, and cyt f content
#'
#' @description.
#' This function calculates three key parameters.
#' @param calb signal amplitude corresponding to 1 mL O2 which was injected for the calibration, unit: grid.
#' @param positive_pmax a slope corresponding to net O2 evolution rate under repeatitive single-turnover flashes and weak far-red light, unit: grid min^-1.
#' @param negative_pmax a slope corresponding to O2 uptake rate under weak far-red light, unit: grid min^-1.
#' @param positive_psii a slope corresponding to net O2 evolution rate under repeatitive single-turnover flashes and weak far-red light, unit: grid min^-1.
#' @param negative_psii a slope corresponding to O2 uptake rate under weak far-red light, unit: grid min^-1.
#' @param amp_pmax an expansion coefficient, no-unit.
#' @param amp_psii an expansion coefficient, no-unit.
#' @param leaf_area an area of the enclosed leaf in the chamber, unit: m^2.
#' @param artefact a factor to correct non-photosynthetic signal, i.e. heating by irradiance, unit: grid min^-1.
#' @param hz a frequency of single-turnover flash, unit: s-1, default: 10.
#' @param e_per_o2 a number of electron consumed in PSII to evolve one O2, unit: mol mol^-1, default: 4.
#' @export
#' @return a lst
calc_oxy <-
  function(calb, positive_pmax, negative_pmax, positive_psii, negative_psii, amp_pmax = 5, amp_psii = 20, leaf_area, hz = 10, e_per_o2 = 4) {
    pmax <-
      calc_pgmax_o2(calb, positive_pmax, negative_pmax, amp_pmax, leaf_area)

    psii <-
      calc_psii(calb, positive_psii, negative_psii, amp_psii, leaf_area, hz, e_per_o2)

    cytf <- calc_cytf(pmax, psii)

    tibble::lst(pmax, psii, cytf) %>%
      return()
  }

#' Calculate and add columns of Pmax, functional PSII content, and cyt f content
#'
#' @description.
#' This function calculates three key parameters and addes, or mutates, them to the input tibble.
#' @param .tbl tibble.
#' @param calb signal amplitude corresponding to 1 mL O2 which was injected for the calibration, unit: grid.
#' @param positive_pmax a slope corresponding to net O2 evolution rate under repeatitive single-turnover flashes and weak far-red light, unit: grid min^-1.
#' @param negative_pmax a slope corresponding to O2 uptake rate under weak far-red light, unit: grid min^-1.
#' @param positive_psii a slope corresponding to net O2 evolution rate under repeatitive single-turnover flashes and weak far-red light, unit: grid min^-1.
#' @param negative_psii a slope corresponding to O2 uptake rate under weak far-red light, unit: grid min^-1.
#' @param amp_pmax an expansion coefficient, no-unit.
#' @param amp_psii an expansion coefficient, no-unit.
#' @param leaf_area an area of the enclosed leaf in the chamber, unit: m^2.
#' @param artefact a factor to correct non-photosynthetic signal, i.e. heating by irradiance, unit: grid min^-1.
#' @param hz a frequency of single-turnover flash, unit: s-1, default: 10.
#' @param e_per_o2 a number of electron consumed in PSII to evolve one O2, unit: mol mol^-1, default: 4.
#' @export
#' @return a tibble
mutate_oxy <-
  function(.tbl, calb, positive_pmax, negative_pmax, positive_psii, negative_psii, amp_pmax = 5, amp_psii = 20, leaf_area, hz = 10, e_per_o2 = 4) {
    .calb <- rlang::enquo(calb)
    pm <- rlang::enquo(positive_pmax)
    nm <- rlang::enquo(negative_pmax)
    p2 <- rlang::enquo(positive_psii)
    n2 <- rlang::enquo(negative_psii)

    .tbl %>%
      dplyr::mutate(pmax = calc_pgmax_o2(rlang::UQ(.calb), rlang::UQ(pm), rlang::UQ(nm), amp_pmax, leaf_area),
                    psii = calc_psii(rlang::UQ(.calb), rlang::UQ(p2), rlang::UQ(n2), amp_psii, leaf_area, hz, e_per_o2),
                    cytf = calc_cytf(pmax, psii)) %>%
      return()
  }
