#' Calculate shared molecular formulae
#'
#' @param data Assigned formula table.
#' @param min_samples Minimum number of samples in which a formula must occur.
#' @return Formula occurrence table with a semicolon-separated sample set.
#' @export
calculate_shared_formulas <- function(data, min_samples = 1L) {
  required <- c("sample_id", "molecular_formula")
  if (!all(required %in% names(data))) {
    rlang::abort("Data must contain sample_id and molecular_formula.")
  }
  unique_pairs <- unique(data[required])
  samples <- split(unique_pairs$sample_id, unique_pairs$molecular_formula)
  result <- data.frame(
    molecular_formula = names(samples),
    sample_count = vapply(samples, function(x) length(unique(x)), integer(1)),
    samples = vapply(samples, function(x) paste(sort(unique(x)), collapse = ";"), character(1)),
    stringsAsFactors = FALSE
  )
  result[result$sample_count >= min_samples, , drop = FALSE]
}

#' Compare molecular composition among samples
#'
#' Computes molecular richness, pairwise Jaccard similarity, and optional
#' intensity-based Bray-Curtis dissimilarity. These are descriptive summaries;
#' inferential tests require independent biological replicates.
#'
#' @param data Assigned formula table.
#' @param intensity Use formula intensity for Bray-Curtis dissimilarity.
#' @return List with `richness`, `jaccard`, and `bray_curtis`.
#' @export
compare_samples <- function(data, intensity = TRUE) {
  required <- c("sample_id", "molecular_formula")
  if (!all(required %in% names(data))) {
    rlang::abort("Data must contain sample_id and molecular_formula.")
  }
  samples <- sort(unique(data$sample_id))
  formulas <- sort(unique(data$molecular_formula))
  presence <- matrix(
    0,
    nrow = length(samples),
    ncol = length(formulas),
    dimnames = list(samples, formulas)
  )
  abundance <- presence
  for (i in seq_len(nrow(data))) {
    presence[data$sample_id[i], data$molecular_formula[i]] <- 1
    if (isTRUE(intensity) && "intensity" %in% names(data)) {
      abundance[data$sample_id[i], data$molecular_formula[i]] <-
        abundance[data$sample_id[i], data$molecular_formula[i]] + data$intensity[i]
    }
  }
  richness <- data.frame(
    sample_id = samples,
    molecular_richness = rowSums(presence),
    stringsAsFactors = FALSE
  )
  jaccard <- matrix(NA_real_, length(samples), length(samples), dimnames = list(samples, samples))
  bray <- jaccard
  for (i in seq_along(samples)) {
    for (j in seq_along(samples)) {
      union_count <- sum(presence[i, ] | presence[j, ])
      jaccard[i, j] <- if (union_count > 0) {
        sum(presence[i, ] & presence[j, ]) / union_count
      } else {
        NA_real_
      }
      denominator <- sum(abundance[i, ] + abundance[j, ])
      bray[i, j] <- if (denominator > 0) {
        sum(abs(abundance[i, ] - abundance[j, ])) / denominator
      } else {
        NA_real_
      }
    }
  }
  list(richness = richness, jaccard = jaccard, bray_curtis = bray)
}
