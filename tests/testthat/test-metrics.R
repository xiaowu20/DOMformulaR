test_that("known formula metrics are calculated independently", {
  x <- data.frame(C = 10, H = 12, O = 5, N = 0, P = 0, S = 0)
  y <- calculate_formula_metrics(x)
  expect_equal(y$H_C, 1.2)
  expect_equal(y$O_C, 0.5)
  expect_equal(y$DBE, 5)
  expect_equal(y$DBE_C, 0.5)
  expect_equal(y$DBE_O, 1)
  expect_equal(y$NOSC, -0.2)
})

test_that("zero carbon produces missing ratios and NOSC", {
  x <- data.frame(C = 0, H = 2, O = 1, N = 0, P = 0, S = 0)
  y <- calculate_formula_metrics(x)
  expect_true(is.na(y$H_C))
  expect_true(is.na(y$NOSC))
})

test_that("P and S terms enter formula metrics as documented", {
  x <- data.frame(C = 10, H = 14, O = 5, N = 1, P = 1, S = 1)
  expect_equal(calculate_dbe(x), 5)
  expect_true(is.finite(calculate_ai_mod(x)))
  expect_true(is.finite(calculate_nosc(x)))
})

test_that("element classes use atom counts", {
  classes <- classify_element_group(known_formulae)
  expect_equal(classes, c("CHO", "CHON", "CHOS", "CHOP", "CHONPS"))
})

test_that("van Krevelen boundaries are mutually exclusive", {
  x <- data.frame(
    C = c(10, 10, 10), H = c(20, 20, 10), O = c(2, 8, 5),
    N = c(0, 1, 0), P = 0, S = 0
  )
  regions <- classify_van_krevelen_region(x)
  expect_length(regions, 3)
  expect_false(any(is.na(regions)))
  expect_equal(regions[1], "lipid_like")
  expect_equal(regions[2], "amino_sugar_like")
})

test_that("thermodynamic proxy follows published linear equation", {
  x <- data.frame(C = 10, H = 12, O = 5, N = 0, P = 0, S = 0)
  y <- calculate_thermodynamic_indices(x)
  expect_equal(y$NOSC, -0.2)
  expect_equal(y$delta_g_cox_kj_mol_c, 66)
})
