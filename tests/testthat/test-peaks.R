test_that("intensity and signal filtering are explicit", {
  x <- standardize_peak_table(data.frame(
    sample_id = "A", mz = c(200, 201, 202),
    intensity = c(1, 10, 100), signal_to_noise = c(4, 6, NA)
  ))
  expect_warning(y <- filter_peaks(x, min_signal_to_noise = 6, min_intensity = 10))
  expect_equal(y$mz, c(201, 202))
})

test_that("blank peaks are removed by fold threshold", {
  x <- standardize_peak_table(data.frame(
    sample_id = c("blank", "sample", "sample"),
    mz = c(200, 200.00005, 210),
    intensity = c(100, 200, 500)
  ))
  y <- remove_blank_peaks(x, blank_samples = "blank", ppm = 1, sample_blank_fold = 3)
  expect_equal(y$mz, 210)
})

test_that("blank filtering skips with an explicit warning", {
  x <- standardize_peak_table(data.frame(sample_id = "A", mz = 200, intensity = 1))
  expect_warning(y <- remove_blank_peaks(x), "skipped")
  expect_equal(y$blank_status, "unknown")
})

test_that("replicate occurrence filtering works", {
  x <- standardize_peak_table(data.frame(
    sample_id = "A",
    replicate_id = c("r3", "r1", "r2", "r1"),
    mz = c(199.99995, 200, 200.00005, 210),
    intensity = 1
  ))
  y <- filter_replicate_peaks(x, min_fraction = 2 / 3, ppm = 1)
  expect_true(all(y$mz < 201))
  expect_equal(nrow(y), 3)
})
