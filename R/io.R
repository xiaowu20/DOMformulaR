#' Read a peak table
#'
#' Reads CSV, TSV, TXT, or Excel files. Excel support is optional and requires
#' `readxl`. Use `column_map` to map vendor columns to standard names.
#'
#' @param path Input file path.
#' @param column_map Named character vector whose names are standard columns and
#'   values are source columns.
#' @param sheet Excel sheet name or number.
#' @return A standardized data frame.
#' @export
#' @examples
#' path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
#' peaks <- read_peak_table(path)
read_peak_table <- function(path, column_map = NULL, sheet = 1) {
  if (!file.exists(path)) {
    rlang::abort(paste0("Peak-table file does not exist: ", path))
  }
  extension <- tolower(tools::file_ext(path))
  raw <- switch(extension,
    csv = utils::read.csv(path, check.names = FALSE),
    tsv = utils::read.delim(path, check.names = FALSE),
    txt = utils::read.delim(path, check.names = FALSE),
    xls = ,
    xlsx = {
      if (!requireNamespace("readxl", quietly = TRUE)) {
        rlang::abort("Reading Excel files requires the optional `readxl` package.")
      }
      as.data.frame(readxl::read_excel(path, sheet = sheet))
    },
    rlang::abort("Supported input extensions are csv, tsv, txt, xls, and xlsx.")
  )
  out <- standardize_peak_table(raw, column_map = column_map)
  out$source_file[is.na(out$source_file)] <- normalizePath(
    path,
    winslash = "/", mustWork = TRUE
  )
  out
}

#' Standardize peak-table columns
#'
#' @param data A data frame.
#' @param column_map Optional named character vector mapping standard names to
#'   source names. Required standard names are `sample_id`, `mz`, `intensity`.
#' @return A data frame using the DOMformulaR input schema.
#' @export
standardize_peak_table <- function(data, column_map = NULL) {
  if (!is.data.frame(data)) {
    rlang::abort("`data` must be a data frame.")
  }
  if (anyDuplicated(names(data))) {
    rlang::abort("Input column names must be unique.")
  }
  if (!is.null(column_map)) {
    if (is.null(names(column_map)) || any(names(column_map) == "")) {
      rlang::abort("`column_map` must be named standard_name = source_name.")
    }
    missing_source <- setdiff(unname(column_map), names(data))
    if (length(missing_source)) {
      rlang::abort(paste("Mapped source columns are missing:", paste(missing_source, collapse = ", ")))
    }
    for (standard_name in names(column_map)) {
      names(data)[names(data) == column_map[[standard_name]]] <- standard_name
    }
  }
  required <- c("sample_id", "mz", "intensity")
  missing_required <- setdiff(required, names(data))
  if (length(missing_required)) {
    rlang::abort(paste("Missing required columns:", paste(missing_required, collapse = ", ")))
  }
  optional <- list(
    replicate_id = NA_character_,
    mz_corrected = NA_real_,
    signal_to_noise = NA_real_,
    charge = NA_integer_,
    blank_flag = NA,
    source_file = NA_character_
  )
  for (name in names(optional)) {
    if (!name %in% names(data)) {
      data[[name]] <- optional[[name]]
    }
  }
  ordered <- c(required, names(optional))
  data <- data[c(ordered, setdiff(names(data), ordered))]
  data$sample_id <- as.character(data$sample_id)
  data$replicate_id <- as.character(data$replicate_id)
  data$source_file <- as.character(data$source_file)
  validate_peak_table(data)
}

#' Validate a standardized peak table
#'
#' Validation errors stop processing. Duplicate rows and unsorted m/z values
#' produce warnings because they can be handled downstream.
#'
#' @param data Standardized peak table.
#' @return The input data, invisibly.
#' @export
validate_peak_table <- function(data) {
  required <- c("sample_id", "mz", "intensity")
  missing_required <- setdiff(required, names(data))
  if (length(missing_required)) {
    rlang::abort(paste("Missing required columns:", paste(missing_required, collapse = ", ")))
  }
  if (any(is.na(data$sample_id) | !nzchar(as.character(data$sample_id)))) {
    rlang::abort("`sample_id` cannot contain missing or empty values.")
  }
  numeric_columns <- intersect(c("mz", "mz_corrected", "intensity", "signal_to_noise"), names(data))
  for (name in numeric_columns) {
    if (!is.numeric(data[[name]])) {
      rlang::abort(paste0("`", name, "` must be numeric."))
    }
  }
  if (any(!is.finite(data$mz) | data$mz <= 0)) {
    rlang::abort("`mz` must contain positive finite values.")
  }
  if (any(!is.finite(data$intensity) | data$intensity < 0)) {
    rlang::abort("`intensity` must contain non-negative finite values.")
  }
  if ("charge" %in% names(data)) {
    known <- !is.na(data$charge)
    if (any(data$charge[known] != -1L)) {
      rlang::abort("Version 0.1.0 accepts only charge -1 when charge is known.")
    }
  }
  duplicate_key <- duplicated(data[c("sample_id", "replicate_id", "mz", "intensity")])
  if (any(duplicate_key)) {
    rlang::warn("Exact duplicate peak records are present and retained.")
  }
  split_mz <- split(data$mz, data$sample_id)
  if (any(vapply(split_mz, is.unsorted, logical(1)))) {
    rlang::warn("m/z values are not sorted within at least one sample.")
  }
  invisible(data)
}

#' Inspect peak-table quality
#'
#' @param data Standardized peak table.
#' @return One-row-per-sample quality summary.
#' @export
inspect_peak_quality <- function(data) {
  validate_peak_table(data)
  parts <- split(data, data$sample_id)
  rows <- lapply(parts, function(x) {
    data.frame(
      sample_id = x$sample_id[1],
      peak_count = nrow(x),
      mz_min = min(x$mz),
      mz_max = max(x$mz),
      intensity_sum = sum(x$intensity),
      missing_signal_to_noise = if ("signal_to_noise" %in% names(x)) {
        sum(is.na(x$signal_to_noise))
      } else {
        nrow(x)
      },
      duplicate_rows = sum(duplicated(x[c("mz", "intensity")])),
      mz_decimal_digits_warning = any(nchar(sub("^[^.]*\\.?", "", format(x$mz, scientific = FALSE))) < 5),
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

#' Export standardized DOM results
#'
#' @param x A `dom_result` or data frame.
#' @param path Output file path.
#' @param format One of `csv`, `tsv`, `rds`, or `xlsx`.
#' @return The normalized output path, invisibly.
#' @export
export_dom_results <- function(x, path, format = tools::file_ext(path)) {
  data <- if (inherits(x, "dom_result")) x$assigned_formulas else x
  format <- tolower(format)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  switch(format,
    csv = utils::write.csv(data, path, row.names = FALSE, na = ""),
    tsv = utils::write.table(data, path, sep = "\t", row.names = FALSE, quote = TRUE, na = ""),
    rds = saveRDS(data, path),
    xlsx = {
      if (!requireNamespace("openxlsx", quietly = TRUE)) {
        rlang::abort("XLSX export requires the optional `openxlsx` package.")
      }
      openxlsx::write.xlsx(data, path, overwrite = TRUE)
    },
    rlang::abort("`format` must be csv, tsv, rds, or xlsx.")
  )
  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}
