test_that("required input columns are enforced", {
  expect_error(
    standardize_peak_table(data.frame(mz = 200, intensity = 1)),
    "sample_id"
  )
})

test_that("vendor columns can be mapped", {
  raw <- data.frame(Sample = "A", Mass = 200, Abundance = 10)
  out <- standardize_peak_table(
    raw,
    c(sample_id = "Sample", mz = "Mass", intensity = "Abundance")
  )
  expect_equal(out$sample_id, "A")
  expect_equal(out$mz, 200)
})

test_that("invalid m/z and intensity are rejected", {
  base <- data.frame(sample_id = "A", mz = 200, intensity = 1)
  invalid_mz <- base
  invalid_mz$mz <- -1
  expect_error(standardize_peak_table(invalid_mz), "positive finite")
  invalid_intensity <- base
  invalid_intensity$intensity <- -1
  expect_error(standardize_peak_table(invalid_intensity), "non-negative")
})

test_that("duplicate peaks and sorting produce warnings", {
  duplicate <- data.frame(
    sample_id = c("A", "A"), mz = c(200, 200), intensity = c(1, 1)
  )
  expect_warning(standardize_peak_table(duplicate), "duplicate")
  unsorted <- data.frame(
    sample_id = c("A", "A"), mz = c(201, 200), intensity = c(1, 1)
  )
  expect_warning(standardize_peak_table(unsorted), "not sorted")
})

test_that("optional unknowns remain missing", {
  out <- standardize_peak_table(data.frame(sample_id = "A", mz = 200, intensity = 1))
  expect_true(is.na(out$signal_to_noise))
  expect_true(is.na(out$charge))
  expect_true(is.na(out$blank_flag))
})

test_that("simulated data read and quality inspection work", {
  path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
  peaks <- read_peak_table(path)
  quality <- inspect_peak_quality(peaks)
  expect_equal(nrow(peaks), 14)
  expect_equal(nrow(quality), 2)
})
