#' Create a CHONPS workflow configuration
#'
#' Returns a parameter list for negative-ion formula assignment. Version 0.1.0
#' supports only C, H, O, N, P, and S and only singly charged `[M-H]-`.
#'
#' @param mass_error_ppm Absolute mass-error tolerance in parts per million.
#' @param elements Named list of inclusive integer ranges for C, H, O, N, P, S.
#' @param ratios Named list of inclusive ratio ranges.
#' @param min_dbe Minimum double-bond equivalent.
#' @param dbe_o_range Inclusive range for DBE minus O.
#' @param max_nps Maximum allowed sum of N, P, and S atoms.
#' @param max_candidates Maximum candidates retained per peak after ranking.
#' @param ion_type Ion model. Only `[M-H]-` is supported.
#' @param require_integer_dbe Require integer DBE values.
#' @param senior_rules Apply a conservative nominal-valence Senior-rule screen.
#' @param nitrogen_rule Apply the nominal-mass parity rule using N.
#' @param ranking_weights Named weights for mass error, N+P+S, and P+S.
#' @return A `dom_config` list.
#' @export
#' @examples
#' cfg <- dom_config(mass_error_ppm = 0.75)
dom_config <- function(
  mass_error_ppm = 0.75,
  elements = list(
    C = c(4L, 50L), H = c(0L, 120L), O = c(1L, 57L),
    N = c(0L, 5L), P = c(0L, 1L), S = c(0L, 3L)
  ),
  ratios = list(
    H_C = c(0.3, 2.25), O_C = c(0, 1.15),
    N_C = c(0, Inf), P_C = c(0, Inf), S_C = c(0, Inf)
  ),
  min_dbe = 0,
  dbe_o_range = c(-10, 10),
  max_nps = 2L,
  max_candidates = 50L,
  ion_type = "[M-H]-",
  require_integer_dbe = TRUE,
  senior_rules = TRUE,
  nitrogen_rule = TRUE,
  ranking_weights = c(mass_error = 1, nps = 0.15, ps = 0.05)
) {
  allowed <- c("C", "H", "O", "N", "P", "S")
  if (!identical(sort(names(elements)), sort(allowed))) {
    rlang::abort("`elements` must contain exactly C, H, O, N, P, and S.")
  }
  if (!identical(ion_type, "[M-H]-")) {
    rlang::abort("DOMformulaR 0.1.0 supports only singly charged `[M-H]-` ions.")
  }
  if (!is.numeric(mass_error_ppm) || length(mass_error_ppm) != 1L ||
    !is.finite(mass_error_ppm) || mass_error_ppm <= 0) {
    rlang::abort("`mass_error_ppm` must be one positive finite number.")
  }
  for (element in allowed) {
    value <- elements[[element]]
    if (length(value) != 2L || any(!is.finite(value)) ||
      any(value < 0) || value[1] > value[2] ||
      any(value != as.integer(value))) {
      rlang::abort(paste0("Invalid inclusive range for element ", element, "."))
    }
    elements[[element]] <- as.integer(value)
  }
  required_ratios <- c("H_C", "O_C", "N_C", "P_C", "S_C")
  if (!identical(sort(names(ratios)), sort(required_ratios))) {
    rlang::abort("`ratios` must contain exactly H_C, O_C, N_C, P_C, and S_C.")
  }
  for (ratio in required_ratios) {
    value <- ratios[[ratio]]
    if (!is.numeric(value) || length(value) != 2L ||
      any(is.na(value)) || value[1] < 0 || value[1] > value[2]) {
      rlang::abort(paste0("Invalid inclusive range for ratio ", ratio, "."))
    }
  }
  if (!is.numeric(dbe_o_range) || length(dbe_o_range) != 2L ||
    any(is.na(dbe_o_range)) || dbe_o_range[1] > dbe_o_range[2]) {
    rlang::abort("`dbe_o_range` must be an ordered numeric range.")
  }
  if (!is.numeric(min_dbe) || length(min_dbe) != 1L || !is.finite(min_dbe)) {
    rlang::abort("`min_dbe` must be one finite number.")
  }
  if (!is.numeric(max_nps) || length(max_nps) != 1L ||
    !is.finite(max_nps) || max_nps < 0 || max_nps != as.integer(max_nps)) {
    rlang::abort("`max_nps` must be one non-negative integer.")
  }
  if (!is.numeric(max_candidates) || length(max_candidates) != 1L ||
    !is.finite(max_candidates) || max_candidates < 1 ||
    max_candidates != as.integer(max_candidates)) {
    rlang::abort("`max_candidates` must be one positive integer.")
  }
  required_weights <- c("mass_error", "nps", "ps")
  if (!is.numeric(ranking_weights) ||
    !identical(sort(names(ranking_weights)), sort(required_weights)) ||
    any(!is.finite(ranking_weights)) || any(ranking_weights < 0) ||
    ranking_weights[["mass_error"]] == 0) {
    rlang::abort(
      paste(
        "`ranking_weights` must be non-negative finite weights named",
        "mass_error, nps, and ps, with mass_error greater than zero."
      )
    )
  }
  structure(
    list(
      mass_error_ppm = mass_error_ppm,
      elements = elements,
      ratios = ratios,
      min_dbe = min_dbe,
      dbe_o_range = dbe_o_range,
      max_nps = as.integer(max_nps),
      max_candidates = as.integer(max_candidates),
      ion_type = ion_type,
      proton_mass = 1.007276466621,
      require_integer_dbe = isTRUE(require_integer_dbe),
      senior_rules = isTRUE(senior_rules),
      nitrogen_rule = isTRUE(nitrogen_rule),
      ranking_weights = ranking_weights
    ),
    class = c("dom_config", "list")
  )
}

#' Read a YAML workflow configuration
#'
#' @param path YAML file path.
#' @return A validated `dom_config`.
#' @export
read_dom_config <- function(path) {
  values <- yaml::read_yaml(path)
  do.call(dom_config, values)
}

atomic_masses_chonps <- function() {
  c(
    C = 12.00000000000,
    H = 1.00782503223,
    O = 15.99491461957,
    N = 14.00307400443,
    P = 30.97376199842,
    S = 31.97207117440
  )
}
