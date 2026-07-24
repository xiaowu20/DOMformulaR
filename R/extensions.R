#' Integrate prepared UV-visible and EEM summary metrics
#'
#' This function joins sample-level optical DOM metrics to formula summaries.
#' It does not preprocess raw EEM matrices, perform blank/Raman corrections, or
#' fit PARAFAC models. Those steps require instrument-specific quality control.
#'
#' @param formula_summary Data frame with `sample_id`.
#' @param optical_data Data frame with `sample_id` and prepared metrics such as
#'   `UV254`, `SUVA254`, `FI`, `BIX`, `HIX`, or PARAFAC component scores.
#' @return Joined data frame.
#' @export
integrate_dom_optics <- function(formula_summary, optical_data) {
  if (!"sample_id" %in% names(formula_summary) ||
    !"sample_id" %in% names(optical_data)) {
    rlang::abort("Both inputs must contain `sample_id`.")
  }
  if (anyDuplicated(optical_data$sample_id)) {
    rlang::abort("`optical_data` must contain one row per sample_id.")
  }
  merge(formula_summary, optical_data, by = "sample_id", all.x = TRUE)
}

#' Calculate formula-level carbon oxidation energetics proxy
#'
#' Adds the nominal oxidation state of carbon and the empirical standard Gibbs
#' energy proxy `60.3 - 28.5 * NOSC` in kJ per mol C. This proxy does not
#' represent an in situ reaction free energy and does not include activities,
#' electron acceptors, pH, or temperature corrections.
#'
#' @param data Formula data frame.
#' @return Input data with `NOSC` and `delta_g_cox_kj_mol_c`.
#' @references LaRowe DE, Van Cappellen P (2011).
#'   \doi{10.1016/j.gca.2011.01.020}
#' @export
calculate_thermodynamic_indices <- function(data) {
  if (!"NOSC" %in% names(data)) {
    data$NOSC <- calculate_nosc(data)
  }
  data$delta_g_cox_kj_mol_c <- 60.3 - 28.5 * data$NOSC
  data
}

#' Detect paired-mass-difference transformation candidates
#'
#' PMD matches are mass-consistent edges, not observed biochemical reactions.
#'
#' @param data Assigned formula table with `sample_id`, `mz_observed`, and
#'   `molecular_formula`.
#' @param transformations Data frame with `transformation_id`, `mass_difference`,
#'   and optional annotation columns.
#' @param tolerance Absolute mass-difference tolerance in daltons.
#' @return Candidate PMD edge table.
#' @export
calculate_pmd_pairs <- function(data, transformations, tolerance = 0.0005) {
  required_data <- c("sample_id", "mz_observed", "molecular_formula")
  required_transform <- c("transformation_id", "mass_difference")
  if (!all(required_data %in% names(data))) {
    rlang::abort("Formula data lack required PMD columns.")
  }
  if (!all(required_transform %in% names(transformations))) {
    rlang::abort("Transformations require transformation_id and mass_difference.")
  }
  edges <- list()
  edge_index <- 0L
  for (sample in unique(data$sample_id)) {
    sample_data <- data[data$sample_id == sample, , drop = FALSE]
    if (nrow(sample_data) < 2L) {
      next
    }
    ordering <- order(sample_data$mz_observed)
    sample_data <- sample_data[ordering, , drop = FALSE]
    for (i in seq_len(nrow(sample_data) - 1L)) {
      differences <- sample_data$mz_observed[(i + 1L):nrow(sample_data)] -
        sample_data$mz_observed[i]
      for (j in seq_len(nrow(transformations))) {
        hit <- which(abs(differences - transformations$mass_difference[j]) <= tolerance)
        if (length(hit)) {
          for (h in hit) {
            edge_index <- edge_index + 1L
            target <- i + h
            edges[[edge_index]] <- data.frame(
              sample_id = sample,
              source_formula = sample_data$molecular_formula[i],
              target_formula = sample_data$molecular_formula[target],
              observed_difference = differences[h],
              transformation_id = transformations$transformation_id[j],
              mass_error_da = differences[h] - transformations$mass_difference[j],
              stringsAsFactors = FALSE
            )
          }
        }
      }
    }
  }
  if (length(edges)) do.call(rbind, edges) else data.frame()
}

#' Join PMD candidates to a user-supplied KEGG mapping
#'
#' The package does not query KEGG or claim enzymatic support. Users must
#' provide a licensed, versioned mapping table.
#'
#' @param pmd_pairs Output from [calculate_pmd_pairs()].
#' @param kegg_map Mapping table containing `transformation_id`.
#' @return Joined PMD annotation table.
#' @export
join_pmd_kegg <- function(pmd_pairs, kegg_map) {
  if (!"transformation_id" %in% names(pmd_pairs) ||
    !"transformation_id" %in% names(kegg_map)) {
    rlang::abort("Both inputs must contain `transformation_id`.")
  }
  merge(pmd_pairs, kegg_map, by = "transformation_id", all.x = TRUE)
}

#' Summarize descriptive molecular assembly turnover
#'
#' Returns richness and pairwise Jaccard/Bray-Curtis matrices. It does not
#' implement a null-model ecological assembly test and should not be described
#' as evidence of deterministic or stochastic processes.
#'
#' @param data Assigned formula table.
#' @return Output from [compare_samples()].
#' @export
summarize_molecular_assembly <- function(data) {
  compare_samples(data, intensity = TRUE)
}
