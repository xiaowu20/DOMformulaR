args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3L) {
  stop("Usage: Rscript run_local_validation.R PACKAGE_DIR PEAK_CSV REFERENCE_CSV")
}
package_dir <- normalizePath(args[1], mustWork = TRUE)
peak_path <- normalizePath(args[2], mustWork = TRUE)
reference_path <- normalizePath(args[3], mustWork = TRUE)
devtools::load_all(package_dir, quiet = TRUE)

config <- dom_config(
  senior_rules = FALSE,
  nitrogen_rule = FALSE,
  ranking_weights = c(mass_error = 1, nps = 0.15, ps = 0)
)
result <- run_dom_workflow(peak_path, config = config, min_signal_to_noise = 6)
reference <- utils::read.csv(reference_path, check.names = FALSE)
package_output <- result$assigned_formulas
package_mz <- ifelse(
  is.na(package_output$mz_corrected),
  package_output$mz_observed,
  package_output$mz_corrected
)
reference_mz <- ifelse(
  is.na(reference$mz_corrected),
  reference$mz_observed,
  reference$mz_corrected
)
nearest <- vapply(package_mz, function(value) {
  which.min(abs(reference_mz - value))
}, integer(1))
ppm <- abs(reference_mz[nearest] - package_mz) / package_mz * 1e6
matched <- ppm <= 0.01
same_counts <- matched &
  package_output$C == reference$C[nearest] &
  package_output$H == reference$H[nearest] &
  package_output$O == reference$O[nearest] &
  package_output$N == reference$N[nearest] &
  package_output$P == reference$P[nearest] &
  package_output$S == reference$S[nearest]

metrics <- data.frame(
  input_peaks = nrow(result$cleaned_peaks),
  package_assigned = nrow(package_output),
  reference_assigned = nrow(reference),
  matched_mz = sum(matched),
  identical_formula_counts = sum(same_counts),
  formula_agreement_on_matches = sum(same_counts) / max(1, sum(matched)),
  max_mass_error_delta_ppm = max(
    abs(package_output$mass_error_ppm[matched] - reference$mass_error_ppm[nearest[matched]])
  ),
  elapsed_seconds = result$log$elapsed_seconds,
  stringsAsFactors = FALSE
)
out_dir <- file.path(package_dir, "development_notes", "private_validation")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
utils::write.csv(metrics, file.path(out_dir, "metrics.csv"), row.names = FALSE)
utils::write.csv(
  data.frame(
    mz = package_mz,
    formula = package_output$molecular_formula,
    matched = matched,
    same_formula_counts = same_counts,
    nearest_ppm = ppm
  ),
  file.path(out_dir, "peak_comparison.csv"),
  row.names = FALSE
)
print(metrics)
