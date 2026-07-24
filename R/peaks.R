#' Filter peaks by analytical thresholds
#'
#' @param data Standardized peak table.
#' @param min_signal_to_noise Optional minimum S/N. Missing S/N values are
#'   retained with a warning.
#' @param min_intensity Optional minimum intensity.
#' @param mz_range Inclusive m/z range.
#' @return Filtered data frame.
#' @export
filter_peaks <- function(
  data,
  min_signal_to_noise = NULL,
  min_intensity = NULL,
  mz_range = c(-Inf, Inf)
) {
  validate_peak_table(data)
  keep <- data$mz >= mz_range[1] & data$mz <= mz_range[2]
  if (!is.null(min_intensity)) {
    keep <- keep & data$intensity >= min_intensity
  }
  if (!is.null(min_signal_to_noise)) {
    if (!"signal_to_noise" %in% names(data) || all(is.na(data$signal_to_noise))) {
      rlang::warn("S/N filtering was requested but no S/N values are available; it was skipped.")
    } else {
      missing_sn <- is.na(data$signal_to_noise)
      if (any(missing_sn)) {
        rlang::warn("Peaks with missing S/N were retained.")
      }
      keep <- keep & (missing_sn | data$signal_to_noise >= min_signal_to_noise)
    }
  }
  out <- data[keep, , drop = FALSE]
  out[order(out$sample_id, out$mz), , drop = FALSE]
}

nearest_ppm_index <- function(value, candidates, ppm) {
  if (!length(candidates)) {
    return(NA_integer_)
  }
  error <- abs(candidates - value) / value * 1e6
  index <- which.min(error)
  if (error[index] <= ppm) index else NA_integer_
}

#' Remove peaks attributable to blanks
#'
#' @param data Sample and blank peak table.
#' @param blank_samples Character vector identifying blank sample IDs. If
#'   omitted, rows with `blank_flag == TRUE` are used.
#' @param ppm Matching tolerance.
#' @param sample_blank_fold A sample peak is retained when its intensity is
#'   greater than this multiple of the matched blank intensity.
#' @return Nonblank sample peaks with `blank_status`.
#' @export
remove_blank_peaks <- function(
  data,
  blank_samples = NULL,
  ppm = 1,
  sample_blank_fold = 3
) {
  validate_peak_table(data)
  is_blank <- if (!is.null(blank_samples)) {
    data$sample_id %in% blank_samples
  } else if ("blank_flag" %in% names(data) && any(!is.na(data$blank_flag))) {
    data$blank_flag %in% TRUE
  } else {
    rlang::warn("No blank identifiers were available; blank filtering was skipped.")
    data$blank_status <- "unknown"
    return(data)
  }
  blanks <- data[is_blank, , drop = FALSE]
  samples <- data[!is_blank, , drop = FALSE]
  samples$blank_status <- "not_detected_in_blank"
  keep <- rep(TRUE, nrow(samples))
  for (i in seq_len(nrow(samples))) {
    index <- nearest_ppm_index(samples$mz[i], blanks$mz, ppm)
    if (!is.na(index)) {
      keep[i] <- samples$intensity[i] > sample_blank_fold * blanks$intensity[index]
      samples$blank_status[i] <- if (keep[i]) "above_blank_fold" else "removed_as_blank"
    }
  }
  samples[keep, , drop = FALSE]
}

#' Filter peaks by replicate occurrence
#'
#' @param data Standardized peak table with `replicate_id`.
#' @param min_fraction Minimum fraction of replicates within each sample group.
#' @param ppm Matching tolerance.
#' @return Peaks retained in the requested replicate fraction.
#' @export
filter_replicate_peaks <- function(data, min_fraction = 2 / 3, ppm = 1) {
  validate_peak_table(data)
  if (!"replicate_id" %in% names(data) || all(is.na(data$replicate_id))) {
    rlang::warn("No replicate identifiers were available; replicate filtering was skipped.")
    data$replicate_status <- "unknown"
    return(data)
  }
  data$replicate_status <- "below_required_frequency"
  keep <- rep(FALSE, nrow(data))
  for (sample in unique(data$sample_id)) {
    ids <- which(data$sample_id == sample)
    subset <- data[ids, , drop = FALSE]
    replicates <- unique(subset$replicate_id[!is.na(subset$replicate_id)])
    required <- ceiling(length(replicates) * min_fraction)
    for (i in seq_len(nrow(subset))) {
      present <- vapply(replicates, function(rep) {
        any(abs(subset$mz[subset$replicate_id == rep] - subset$mz[i]) /
          subset$mz[i] * 1e6 <= ppm)
      }, logical(1))
      if (sum(present) >= required) {
        keep[ids[i]] <- TRUE
        data$replicate_status[ids[i]] <- "meets_required_frequency"
      }
    }
  }
  data[keep, , drop = FALSE]
}

#' Summarize a peak table
#'
#' @param data Standardized peak table.
#' @return Per-sample peak counts and intensity summaries.
#' @export
summarize_peak_table <- function(data) {
  validate_peak_table(data)
  parts <- split(data, data$sample_id)
  do.call(rbind, lapply(parts, function(x) {
    data.frame(
      sample_id = x$sample_id[1],
      peak_count = nrow(x),
      total_intensity = sum(x$intensity),
      median_mz = stats::median(x$mz),
      median_intensity = stats::median(x$intensity),
      stringsAsFactors = FALSE
    )
  }))
}
