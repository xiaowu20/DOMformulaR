#' Classify CHONPS elemental groups
#'
#' Classification uses atom counts, not formula-string matching.
#'
#' @param data Formula data frame.
#' @return Character vector such as CHO, CHON, CHOS, CHOP, or CHONSP.
#' @export
classify_element_group <- function(data) {
  require_formula_columns(data)
  vapply(seq_len(nrow(data)), function(i) {
    paste0(
      "CHO",
      if (data$N[i] > 0) "N" else "",
      if (data$P[i] > 0) "P" else "",
      if (data$S[i] > 0) "S" else ""
    )
  }, character(1))
}

#' Default mutually exclusive van Krevelen regions
#'
#' @return Data frame of ordered region boundaries.
#' @export
default_vk_regions <- function() {
  data.frame(
    region = c(
      "lipid_like", "protein_like", "amino_sugar_like", "carbohydrate_like",
      "lignin_like", "tannin_like", "condensed_aromatic_like", "unclassified"
    ),
    O_C_min = c(0, 0, 0.67, 0.67, 0.1, 0.6, 0, -Inf),
    O_C_max = c(0.3, 0.67, 1.2, 1.2, 0.67, 1.2, 0.67, Inf),
    H_C_min = c(1.5, 1.5, 1.5, 1.5, 0.7, 0.5, 0, -Inf),
    H_C_max = c(2.25, 2.25, 2.25, 2.4, 1.5, 1.5, 0.7, Inf),
    require_N = c(FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE),
    exclude_N = c(TRUE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE),
    priority = seq_len(8),
    stringsAsFactors = FALSE
  )
}

#' Classify formulae into van Krevelen regions
#'
#' Boundaries differ among studies. The default is an explicit, ordered,
#' mutually exclusive operational scheme and can be replaced by the user.
#' Lower bounds are inclusive and upper bounds are exclusive, except the last
#' matching fallback.
#'
#' @param data Formula data frame with H_C and O_C, or CHONPS counts.
#' @param regions Boundary table returned by [default_vk_regions()].
#' @return Character region vector.
#' @export
classify_van_krevelen_region <- function(data, regions = default_vk_regions()) {
  if (!all(c("H_C", "O_C") %in% names(data))) {
    data <- calculate_element_ratios(data)
  }
  result <- rep("unclassified", nrow(data))
  ordered <- regions[order(regions$priority), , drop = FALSE]
  for (i in seq_len(nrow(ordered))) {
    region <- ordered[i, ]
    eligible <- result == "unclassified" &
      data$O_C >= region$O_C_min & data$O_C < region$O_C_max &
      data$H_C >= region$H_C_min & data$H_C < region$H_C_max
    if (isTRUE(region$require_N) && "N" %in% names(data)) {
      eligible <- eligible & data$N > 0
    }
    if (isTRUE(region$exclude_N) && "N" %in% names(data)) {
      eligible <- eligible & data$N == 0
    }
    eligible[is.na(eligible)] <- FALSE
    result[eligible] <- region$region
  }
  result
}

#' Summarize elemental formula classes
#'
#' @param data Assigned formula table.
#' @param weight One of `count` or `intensity`.
#' @return Per-sample class counts or intensity sums and fractions.
#' @export
summarize_formula_classes <- function(data, weight = c("count", "intensity")) {
  weight <- match.arg(weight)
  if (!"element_class" %in% names(data)) {
    data$element_class <- classify_element_group(data)
  }
  values <- if (weight == "count") rep(1, nrow(data)) else data$intensity
  aggregate_value <- stats::aggregate(
    values,
    by = list(sample_id = data$sample_id, element_class = data$element_class),
    FUN = sum,
    na.rm = TRUE
  )
  names(aggregate_value)[3] <- "value"
  totals <- stats::ave(
    aggregate_value$value,
    aggregate_value$sample_id,
    FUN = sum
  )
  aggregate_value$fraction <- aggregate_value$value / totals
  aggregate_value$weight <- weight
  aggregate_value
}
