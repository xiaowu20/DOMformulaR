test_that("formula library contains known CHONPS classes", {
  library <- generate_chonps_formulas(small_config(), c(200, 310))
  expected <- c("C10H12O5", "C10H13O5N", "C10H12O5S", "C10H13O5P", "C10H14O5NPS")
  expect_true(all(expected %in% library$molecular_formula))
})

test_that("independent masses assign known formulae", {
  proton <- 1.007276466621
  neutral <- apply(known_formulae, 1, function(row) independent_formula_mass(as.list(row)))
  peaks <- standardize_peak_table(data.frame(
    sample_id = "A",
    mz = neutral - proton,
    intensity = 1000,
    signal_to_noise = 20,
    charge = -1L
  ))
  result <- assign_molecular_formulas(peaks, small_config(), return_all = TRUE)
  expected <- c("C10H12O5", "C10H13O5N", "C10H12O5S", "C10H13O5P", "C10H14O5NPS")
  expect_true(all(expected %in% result$assigned$molecular_formula))
  expect_true(all(abs(result$assigned$mass_error_ppm) < 1e-8))
})

test_that("ppm boundary is inclusive", {
  cfg <- small_config()
  neutral <- independent_formula_mass(as.list(known_formulae[1, ]))
  ion <- neutral - cfg$proton_mass
  peaks <- standardize_peak_table(data.frame(
    sample_id = "A",
    mz = ion * (1 + cfg$mass_error_ppm / 1e6),
    intensity = 1
  ))
  result <- assign_molecular_formulas(peaks, cfg)
  expect_true("C10H12O5" %in% result$assigned$molecular_formula)
  peaks$mz <- ion * (1 - cfg$mass_error_ppm / 1e6)
  result <- assign_molecular_formulas(peaks, cfg)
  expect_true("C10H12O5" %in% result$assigned$molecular_formula)
})

test_that("no valid formula returns empty results", {
  peaks <- standardize_peak_table(data.frame(sample_id = "A", mz = 9999, intensity = 1))
  result <- assign_molecular_formulas(peaks, small_config())
  expect_equal(nrow(result$assigned), 0)
  expect_equal(nrow(result$candidates), 0)
})

test_that("multiple candidates are retained and ranked", {
  candidates <- data.frame(
    peak_id = c(1, 1),
    mass_error_ppm = c(0.2, 0.1),
    N = c(0, 1), P = 0, S = 0,
    molecular_formula = c("C10H12O5", "C9H11O5N")
  )
  ranked <- rank_formula_candidates(candidates, c(mass_error = 1, nps = 0, ps = 0))
  expect_equal(ranked$candidate_count, c(2L, 2L))
  expect_equal(ranked$molecular_formula[1], "C9H11O5N")
  expect_equal(select_best_formula(ranked)$formula_status, "ranked_candidate")
})

test_that("unranked candidates can be selected directly", {
  candidates <- data.frame(
    peak_id = c(1L, 1L),
    mass_error_ppm = c(0.2, 0.1),
    N = c(0L, 0L),
    P = c(0L, 0L),
    S = c(0L, 0L),
    molecular_formula = c("C10H12O5", "C9H10O6")
  )
  selected <- select_best_formula(candidates)
  expect_equal(selected$molecular_formula, "C9H10O6")
  expect_equal(selected$formula_status, "ranked_candidate")
})

test_that("configuration prohibits non-CHONPS elements and other ion modes", {
  expect_error(
    dom_config(elements = c(dom_config()$elements, list(Cl = c(0, 1)))),
    "exactly"
  )
  expect_error(dom_config(ion_type = "[M+H]+"), "only")
})

test_that("configuration rejects malformed constraints", {
  expect_error(dom_config(ratios = list(H_C = c(0, 2))), "exactly")
  expect_error(dom_config(max_candidates = 0), "positive integer")
  expect_error(
    dom_config(ranking_weights = c(mass_error = 0, nps = 1, ps = 1)),
    "greater than zero"
  )
})
