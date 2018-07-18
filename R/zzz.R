.onAttach <- function(...) {
  cat("\n Some coefficient for ‘Oxygen electrode measurements’ were attached\n")
  options(o2_per_mL = 8.05)
  options(heat_artefact_pmax = 0.150)
  options(heat_artefact_psii = 0.009)
}
