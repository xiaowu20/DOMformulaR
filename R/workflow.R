standard_output_columns <- function() {
  c(
    "sample_id", "replicate_id", "mz_observed", "mz_corrected",
    "neutral_mass", "intensity", "signal_to_noise", "charge", "ion_type",
    "molecular_formula", "mass_error_ppm", "candidate_count",
    "C", "H", "O", "N", "P", "S",
    "H_C", "O_C", "N_C", "P_C", "S_C",
    "DBE", "DBE_C", "DBE_O", "AI_mod", "NOSC",
    "element_class", "vk_region", "formula_status",
    "acceptance_reason", "source_file"
  )
}

normalize_assigned_output <- function(data) {
  columns <- standard_output_columns()
  for (name in setdiff(columns, names(data))) {
    data[[name]] <- NA
  }
  data[columns]
}

#' Run a complete CHONPS DOM workflow
#'
#' Reads or standardizes data, validates and filters peaks, assigns CHONPS
#' candidates, calculates indices and summaries, constructs ggplot objects,
#' and optionally exports reproducibility artifacts.
#'
#' @param input File path or data frame.
#' @param config A `dom_config` or YAML path.
#' @param column_map Optional vendor-to-standard column mapping.
#' @param min_signal_to_noise Optional S/N threshold.
#' @param min_intensity Optional intensity threshold.
#' @param mz_range Inclusive m/z range.
#' @param blank_samples Optional blank sample IDs.
#' @param replicate_min_fraction Optional replicate occurrence fraction.
#' @param output_dir Optional export directory.
#' @return A `dom_result` S3 object.
#' @export
#' @examples
#' path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
#' result <- run_dom_workflow(path, config = dom_config(
#'   elements = list(
#'     C = c(4, 20), H = c(0, 45), O = c(1, 20),
#'     N = c(0, 2), P = c(0, 1), S = c(0, 1)
#'   )
#' ))
#' result
run_dom_workflow <- function(
  input,
  config = dom_config(),
  column_map = NULL,
  min_signal_to_noise = 6,
  min_intensity = NULL,
  mz_range = c(-Inf, Inf),
  blank_samples = NULL,
  replicate_min_fraction = NULL,
  output_dir = NULL
) {
  started <- Sys.time()
  warnings <- character()
  config <- if (is.character(config) && length(config) == 1L) {
    read_dom_config(config)
  } else {
    config
  }
  peaks <- if (is.character(input) && length(input) == 1L) {
    read_peak_table(input, column_map = column_map)
  } else {
    standardize_peak_table(input, column_map = column_map)
  }
  cleaned <- withCallingHandlers(
    filter_peaks(peaks, min_signal_to_noise, min_intensity, mz_range),
    warning = function(w) {
      warnings <<- c(warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  if (!is.null(blank_samples)) {
    cleaned <- remove_blank_peaks(cleaned, blank_samples)
  } else {
    cleaned$blank_status <- "unknown"
  }
  if (!is.null(replicate_min_fraction)) {
    cleaned <- filter_replicate_peaks(cleaned, replicate_min_fraction)
  } else {
    cleaned$replicate_status <- "not_evaluated"
  }
  assignment <- assign_molecular_formulas(cleaned, config, return_all = TRUE)
  assigned <- normalize_assigned_output(assignment$assigned)
  sample_summary <- if (nrow(assigned)) {
    richness <- compare_samples(assigned)$richness
    peak_summary <- summarize_peak_table(cleaned)
    merge(peak_summary, richness, by = "sample_id", all.x = TRUE)
  } else {
    summarize_peak_table(cleaned)
  }
  figures <- if (nrow(assigned)) {
    list(
      mass_error = plot_mass_error(assigned),
      van_krevelen = plot_van_krevelen(assigned),
      element_classes = plot_element_classes(assigned),
      molecular_richness = plot_molecular_richness(assigned)
    )
  } else {
    list()
  }
  finished <- Sys.time()
  log <- data.frame(
    started = format(started, tz = "UTC", usetz = TRUE),
    finished = format(finished, tz = "UTC", usetz = TRUE),
    elapsed_seconds = as.numeric(difftime(finished, started, units = "secs")),
    input_peaks = nrow(peaks),
    cleaned_peaks = nrow(cleaned),
    assigned_peaks = nrow(assigned),
    stringsAsFactors = FALSE
  )
  result <- structure(
    list(
      cleaned_peaks = cleaned,
      formula_candidates = assignment$candidates,
      assigned_formulas = assigned,
      formula_metrics = assigned,
      sample_summary = sample_summary,
      figures = figures,
      parameters = config,
      log = log,
      warnings = unique(warnings)
    ),
    class = "dom_result"
  )
  if (!is.null(output_dir)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    export_dom_results(result, file.path(output_dir, "assigned_formulas.csv"))
    utils::write.csv(
      result$formula_candidates,
      file.path(output_dir, "formula_candidates.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      result$sample_summary,
      file.path(output_dir, "sample_summary.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(result$log, file.path(output_dir, "run_log.csv"), row.names = FALSE)
    yaml::write_yaml(unclass(config), file.path(output_dir, "parameters.yml"))
    saveRDS(result, file.path(output_dir, "dom_result.rds"))
    for (name in names(figures)) {
      ggplot2::ggsave(
        file.path(output_dir, paste0(name, ".png")),
        figures[[name]],
        width = 7,
        height = 5,
        dpi = 300
      )
    }
  }
  result
}

#' @export
print.dom_result <- function(x, ...) {
  cat("<dom_result>\n")
  cat("  Cleaned peaks:", nrow(x$cleaned_peaks), "\n")
  cat("  Assigned formulae:", nrow(x$assigned_formulas), "\n")
  cat("  Samples:", length(unique(x$cleaned_peaks$sample_id)), "\n")
  if (length(x$warnings)) {
    cat("  Captured warnings:", length(x$warnings), "\n")
  }
  invisible(x)
}

#' @export
summary.dom_result <- function(object, ...) {
  list(
    run = object$log,
    samples = object$sample_summary,
    formula_classes = if (nrow(object$assigned_formulas)) {
      summarize_formula_classes(object$assigned_formulas)
    } else {
      data.frame()
    },
    warnings = object$warnings
  )
}

#' @export
plot.dom_result <- function(x, type = c("van_krevelen", "mass_error", "element_classes"), ...) {
  type <- match.arg(type)
  switch(type,
    van_krevelen = plot_van_krevelen(x$assigned_formulas, ...),
    mass_error = plot_mass_error(x$assigned_formulas, ...),
    element_classes = plot_element_classes(x$assigned_formulas, ...)
  )
}

#' @export
as.data.frame.dom_result <- function(x, row.names = NULL, optional = FALSE, ...) {
  x$assigned_formulas
}
