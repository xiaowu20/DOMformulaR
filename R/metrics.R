require_formula_columns <- function(data, columns = c("C", "H", "O", "N", "P", "S")) {
  missing_columns <- setdiff(columns, names(data))
  if (length(missing_columns)) {
    rlang::abort(paste("Missing formula columns:", paste(missing_columns, collapse = ", ")))
  }
  invisible(TRUE)
}

#' Calculate elemental ratios
#'
#' @param data Formula data frame containing C, H, O, N, P, and S.
#' @return Input data with H/C, O/C, N/C, P/C, and S/C columns. Ratios are
#'   `NA` when C is zero or missing.
#' @export
calculate_element_ratios <- function(data) {
  require_formula_columns(data)
  carbon_ok <- !is.na(data$C) & data$C > 0
  safe_ratio <- function(numerator) {
    out <- rep(NA_real_, nrow(data))
    out[carbon_ok] <- numerator[carbon_ok] / data$C[carbon_ok]
    out
  }
  data$H_C <- safe_ratio(data$H)
  data$O_C <- safe_ratio(data$O)
  data$N_C <- safe_ratio(data$N)
  data$P_C <- safe_ratio(data$P)
  data$S_C <- safe_ratio(data$S)
  data
}

#' Calculate double-bond equivalents
#'
#' Uses `DBE = 1 + C - H/2 + N/2 + P/2`. O and divalent S do not enter the
#' valence expression. This is a formula-level index, not a structure count.
#'
#' @param data Formula data frame.
#' @return Numeric DBE vector.
#' @references Koch BP et al. (2007). \doi{10.1021/ac061949s}
#' @export
calculate_dbe <- function(data) {
  require_formula_columns(data)
  1 + data$C - data$H / 2 + data$N / 2 + data$P / 2
}

#' Calculate modified aromaticity index
#'
#' Uses the commonly applied DOM formula expression. Values are set to zero
#' when the numerator is non-positive or denominator is non-positive.
#' Interpretation for P- and S-containing formulae requires caution.
#'
#' @param data Formula data frame.
#' @return Numeric AI_mod vector.
#' @references Koch BP, Dittmar T (2006). \doi{10.1002/rcm.2386}
#' @export
calculate_ai_mod <- function(data) {
  require_formula_columns(data)
  numerator <- 1 + data$C - data$O / 2 - data$S -
    (data$H + data$N + data$P) / 2
  denominator <- data$C - data$O / 2 - data$N - data$S - data$P
  result <- rep(NA_real_, nrow(data))
  valid <- is.finite(numerator) & is.finite(denominator)
  result[valid] <- 0
  positive <- valid & numerator > 0 & denominator > 0
  result[positive] <- numerator[positive] / denominator[positive]
  result
}

#' Calculate nominal oxidation state of carbon
#'
#' Uses elemental formal oxidation states H +1, O -2, N -3, S -2, and P +5.
#' Values are `NA` when C is zero or missing.
#'
#' @param data Formula data frame.
#' @return Numeric NOSC vector.
#' @references LaRowe DE, Van Cappellen P (2011). \doi{10.1016/j.gca.2011.01.020}
#' @export
calculate_nosc <- function(data) {
  require_formula_columns(data)
  result <- rep(NA_real_, nrow(data))
  valid <- !is.na(data$C) & data$C > 0
  result[valid] <- 4 - (
    4 * data$C[valid] + data$H[valid] - 3 * data$N[valid] -
      2 * data$O[valid] - 2 * data$S[valid] + 5 * data$P[valid]
  ) / data$C[valid]
  result
}

#' Calculate all formula-level DOM indices
#'
#' @param data Formula data frame containing CHONPS atom counts.
#' @return Input data with elemental ratios, DBE, DBE/C, DBE/O, AI_mod,
#'   and NOSC.
#' @export
#' @examples
#' calculate_formula_metrics(data.frame(C = 10, H = 12, O = 5, N = 0, P = 0, S = 0))
calculate_formula_metrics <- function(data) {
  data <- calculate_element_ratios(data)
  data$DBE <- calculate_dbe(data)
  data$DBE_C <- ifelse(data$C > 0, data$DBE / data$C, NA_real_)
  data$DBE_O <- ifelse(data$O > 0, data$DBE / data$O, NA_real_)
  data$AI_mod <- calculate_ai_mod(data)
  data$NOSC <- calculate_nosc(data)
  data
}
