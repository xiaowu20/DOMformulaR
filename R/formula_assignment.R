formula_string_chonps <- function(data) {
  elements <- c("C", "H", "O", "N", "P", "S")
  vapply(seq_len(nrow(data)), function(i) {
    paste0(vapply(elements, function(element) {
      number <- as.integer(data[[element]][i])
      if (is.na(number) || number == 0L) {
        ""
      } else if (number == 1L) {
        element
      } else {
        paste0(element, number)
      }
    }, character(1)), collapse = "")
  }, character(1))
}

formula_mass_chonps <- function(data) {
  masses <- atomic_masses_chonps()
  as.numeric(as.matrix(data[c("C", "H", "O", "N", "P", "S")]) %*% masses)
}

candidate_validity <- function(data, config) {
  metrics <- calculate_formula_metrics(data)
  ratios <- config$ratios
  dbe_minus_o <- metrics$DBE - data$O
  valid <- metrics$H_C >= ratios$H_C[1] & metrics$H_C <= ratios$H_C[2] &
    metrics$O_C >= ratios$O_C[1] & metrics$O_C <= ratios$O_C[2] &
    metrics$N_C >= ratios$N_C[1] & metrics$N_C <= ratios$N_C[2] &
    metrics$P_C >= ratios$P_C[1] & metrics$P_C <= ratios$P_C[2] &
    metrics$S_C >= ratios$S_C[1] & metrics$S_C <= ratios$S_C[2] &
    metrics$DBE >= config$min_dbe &
    dbe_minus_o >= config$dbe_o_range[1] &
    dbe_minus_o <= config$dbe_o_range[2] &
    data$N + data$P + data$S <= config$max_nps
  if (config$require_integer_dbe) {
    valid <- valid & abs(metrics$DBE - round(metrics$DBE)) < 1e-10
  }
  if (config$senior_rules) {
    valence_sum <- 4 * data$C + data$H + 2 * data$O +
      3 * data$N + 3 * data$P + 2 * data$S
    max_valence <- ifelse(data$C > 0, 4, 3)
    valid <- valid & valence_sum %% 2 == 0 & valence_sum >= 2 * max_valence
  }
  if (config$nitrogen_rule) {
    nominal_mass <- 12 * data$C + data$H + 16 * data$O +
      14 * data$N + 31 * data$P + 32 * data$S
    valid <- valid & nominal_mass %% 2 == data$N %% 2
  }
  valid & is.finite(valid)
}

generate_formula_block <- function(config, fixed_n, fixed_p, fixed_s) {
  er <- config$elements
  rows <- lapply(seq.int(er$C[1], er$C[2]), function(carbon) {
    h_upper <- min(er$H[2], ceiling(config$ratios$H_C[2] * carbon))
    o_upper <- min(er$O[2], floor(config$ratios$O_C[2] * carbon))
    if (h_upper < er$H[1] || o_upper < er$O[1]) {
      return(NULL)
    }
    grid <- expand.grid(
      C = carbon,
      H = seq.int(er$H[1], h_upper),
      O = seq.int(er$O[1], o_upper),
      N = fixed_n,
      P = fixed_p,
      S = fixed_s,
      KEEP.OUT.ATTRS = FALSE
    )
    grid[candidate_validity(grid, config), , drop = FALSE]
  })
  do.call(rbind, rows)
}

#' Generate a CHONPS formula library
#'
#' Generates neutral molecular formulae under the configured atom, ratio, DBE,
#' nominal-valence, nitrogen-rule, and heteroatom constraints. Only C, H, O,
#' N, P, and S are represented.
#'
#' @param config A `dom_config`.
#' @param mass_range Optional inclusive neutral-mass range used to reduce output.
#' @return Data frame with formula, elemental counts, theoretical neutral mass,
#'   and calculated indices.
#' @references Koch BP, Dittmar T, Witt M, Kattner G (2007).
#'   \doi{10.1021/ac061949s}
#' @export
#' @examples
#' cfg <- dom_config(elements = list(
#'   C = c(4, 10), H = c(0, 24), O = c(1, 10),
#'   N = c(0, 1), P = c(0, 1), S = c(0, 1)
#' ))
#' library <- generate_chonps_formulas(cfg, c(100, 300))
generate_chonps_formulas <- function(config = dom_config(), mass_range = c(-Inf, Inf)) {
  er <- config$elements
  blocks <- list()
  index <- 0L
  for (nitrogen in seq.int(er$N[1], er$N[2])) {
    for (phosphorus in seq.int(er$P[1], er$P[2])) {
      for (sulfur in seq.int(er$S[1], er$S[2])) {
        if (nitrogen + phosphorus + sulfur > config$max_nps) {
          next
        }
        index <- index + 1L
        blocks[[index]] <- generate_formula_block(
          config, nitrogen, phosphorus, sulfur
        )
      }
    }
  }
  formulas <- do.call(rbind, blocks)
  if (is.null(formulas) || !nrow(formulas)) {
    return(data.frame())
  }
  formulas$neutral_mass_theoretical <- formula_mass_chonps(formulas)
  formulas <- formulas[
    formulas$neutral_mass_theoretical >= mass_range[1] &
      formulas$neutral_mass_theoretical <= mass_range[2], ,
    drop = FALSE
  ]
  formulas$molecular_formula <- formula_string_chonps(formulas)
  calculate_formula_metrics(formulas)
}

#' Filter formula candidates
#'
#' @param candidates Candidate data frame with CHONPS counts.
#' @param config A `dom_config`.
#' @return Chemically admissible candidates.
#' @export
filter_formula_candidates <- function(candidates, config = dom_config()) {
  required <- c("C", "H", "O", "N", "P", "S")
  if (!all(required %in% names(candidates))) {
    rlang::abort("Candidates must contain C, H, O, N, P, and S columns.")
  }
  candidates[candidate_validity(candidates, config), , drop = FALSE]
}

#' Rank formula candidates
#'
#' Ranking is deterministic and transparent: absolute mass error, N+P+S count,
#' P+S count, and formula string. It is not a probability of identification.
#'
#' @param candidates Candidate data frame.
#' @param weights Named numeric vector for `mass_error`, `nps`, and `ps`.
#' @return Ranked candidates with `candidate_count`, `score`, and
#'   `candidate_rank`.
#' @export
rank_formula_candidates <- function(
  candidates,
  weights = c(mass_error = 1, nps = 0.15, ps = 0.05)
) {
  if (!nrow(candidates)) {
    return(candidates)
  }
  required <- c("peak_id", "mass_error_ppm", "N", "P", "S")
  if (!all(required %in% names(candidates))) {
    rlang::abort("Candidate ranking requires peak_id, mass_error_ppm, N, P, and S.")
  }
  candidates$score <- weights[["mass_error"]] * abs(candidates$mass_error_ppm) +
    weights[["nps"]] * (candidates$N + candidates$P + candidates$S) +
    weights[["ps"]] * (candidates$P + candidates$S)
  counts <- table(candidates$peak_id)
  candidates$candidate_count <- as.integer(counts[as.character(candidates$peak_id)])
  candidates <- candidates[order(
    candidates$peak_id,
    candidates$score,
    abs(candidates$mass_error_ppm),
    candidates$molecular_formula
  ), , drop = FALSE]
  candidates$candidate_rank <- stats::ave(
    candidates$score, candidates$peak_id,
    FUN = seq_along
  )
  rownames(candidates) <- NULL
  candidates
}

#' Select the best formula per peak
#'
#' @param candidates Ranked or unranked candidates.
#' @param max_candidates Maximum acceptable candidate count. Peaks exceeding
#'   this limit are returned with `formula_status = "ambiguous_excess"`.
#' @param weights Named ranking weights passed to [rank_formula_candidates()]
#'   when candidates are not already ranked.
#' @return One row per candidate-bearing peak.
#' @export
select_best_formula <- function(
  candidates,
  max_candidates = 50L,
  weights = c(mass_error = 1, nps = 0.15, ps = 0.05)
) {
  if (!nrow(candidates)) {
    return(candidates)
  }
  if (!"candidate_rank" %in% names(candidates)) {
    candidates <- rank_formula_candidates(candidates, weights)
  }
  selected <- candidates[candidates$candidate_rank == 1L, , drop = FALSE]
  selected$formula_status <- ifelse(
    selected$candidate_count > max_candidates,
    "ambiguous_excess",
    ifelse(selected$candidate_count == 1L, "unique_candidate", "ranked_candidate")
  )
  selected$acceptance_reason <- ifelse(
    selected$formula_status == "unique_candidate",
    "single candidate passed configured exact-mass and chemical rules",
    ifelse(
      selected$formula_status == "ranked_candidate",
      "top-ranked candidate; alternative candidates retained",
      "candidate count exceeded configured maximum"
    )
  )
  selected
}

#' Assign CHONPS molecular formula candidates
#'
#' Uses calibrated m/z when `mz_corrected` is available; otherwise uses `mz`.
#' The supported ion model is singly charged negative-ion `[M-H]-`. All
#' candidates are retained before ranking.
#'
#' @param peaks Standardized peak table.
#' @param config A `dom_config`.
#' @param return_all Return both selected assignments and all candidates.
#' @return A list with `assigned` and `candidates`, or assigned data frame.
#' @references Kujawinski EB, Behn MD (2006). \doi{10.1021/ac0600306};
#'   Koch BP et al. (2007). \doi{10.1021/ac061949s}
#' @export
assign_molecular_formulas <- function(
  peaks,
  config = dom_config(),
  return_all = TRUE
) {
  validate_peak_table(peaks)
  if ("charge" %in% names(peaks) &&
    any(!is.na(peaks$charge) & peaks$charge != -1L)) {
    rlang::abort("Formula assignment supports only charge -1.")
  }
  ion_mz <- if ("mz_corrected" %in% names(peaks)) {
    ifelse(is.na(peaks$mz_corrected), peaks$mz, peaks$mz_corrected)
  } else {
    peaks$mz
  }
  peak_id <- seq_len(nrow(peaks))
  er <- config$elements
  blocks <- list()
  block_index <- 0L
  for (nitrogen in seq.int(er$N[1], er$N[2])) {
    for (phosphorus in seq.int(er$P[1], er$P[2])) {
      for (sulfur in seq.int(er$S[1], er$S[2])) {
        if (nitrogen + phosphorus + sulfur > config$max_nps) {
          next
        }
        formulas <- generate_formula_block(
          config, nitrogen, phosphorus, sulfur
        )
        if (!nrow(formulas)) {
          next
        }
        neutral_mass <- formula_mass_chonps(formulas)
        theoretical_ion <- neutral_mass - config$proton_mass
        ordering <- order(theoretical_ion)
        theoretical_ion <- theoretical_ion[ordering]
        neutral_mass <- neutral_mass[ordering]
        formulas <- formulas[ordering, , drop = FALSE]
        tolerance_fraction <- config$mass_error_ppm / 1e6
        lower <- ion_mz / (1 + tolerance_fraction)
        upper <- ion_mz / (1 - tolerance_fraction)
        left <- findInterval(lower, theoretical_ion, left.open = TRUE)
        right <- findInterval(upper, theoretical_ion)
        hits <- which(right > left)
        if (!length(hits)) {
          next
        }
        rows <- lapply(hits, function(i) {
          ids <- seq.int(left[i] + 1L, right[i])
          data.frame(
            peak_id = peak_id[i],
            sample_id = peaks$sample_id[i],
            replicate_id = peaks$replicate_id[i],
            mz_observed = peaks$mz[i],
            mz_corrected = if ("mz_corrected" %in% names(peaks)) {
              peaks$mz_corrected[i]
            } else {
              NA_real_
            },
            ion_mass = ion_mz[i],
            neutral_mass = neutral_mass[ids],
            theoretical_ion_mass = theoretical_ion[ids],
            mass_error_ppm = (ion_mz[i] - theoretical_ion[ids]) /
              theoretical_ion[ids] * 1e6,
            intensity = peaks$intensity[i],
            signal_to_noise = peaks$signal_to_noise[i],
            charge = -1L,
            ion_type = config$ion_type,
            formulas[ids, , drop = FALSE],
            stringsAsFactors = FALSE
          )
        })
        block_index <- block_index + 1L
        blocks[[block_index]] <- do.call(rbind, rows)
      }
    }
  }
  candidates <- if (length(blocks)) do.call(rbind, blocks) else data.frame()
  if (!nrow(candidates)) {
    assigned <- data.frame()
  } else {
    candidates$molecular_formula <- formula_string_chonps(candidates)
    candidates <- calculate_formula_metrics(candidates)
    candidates <- rank_formula_candidates(candidates, config$ranking_weights)
    assigned <- select_best_formula(
      candidates,
      config$max_candidates,
      config$ranking_weights
    )
    assigned$element_class <- classify_element_group(assigned)
    assigned$vk_region <- classify_van_krevelen_region(assigned)
    assigned$source_file <- peaks$source_file[assigned$peak_id]
  }
  result <- list(assigned = assigned, candidates = candidates)
  if (isTRUE(return_all)) result else assigned
}
