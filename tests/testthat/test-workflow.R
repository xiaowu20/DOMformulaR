test_that("single and multisample workflows run", {
  path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
  result <- run_dom_workflow(path, small_config())
  expect_s3_class(result, "dom_result")
  expect_equal(length(unique(result$cleaned_peaks$sample_id)), 2)
  expect_gt(nrow(result$assigned_formulas), 0)
  expect_true(all(c("cleaned_peaks", "formula_candidates", "figures", "log") %in% names(result)))
})

test_that("S3 methods return expected objects", {
  path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
  result <- run_dom_workflow(path, small_config())
  expect_output(print(result), "dom_result")
  expect_type(summary(result), "list")
  expect_s3_class(plot(result), "ggplot")
  expect_equal(as.data.frame(result), result$assigned_formulas)
})

test_that("workflow exports standard results", {
  path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
  output <- tempfile("dom-output-")
  result <- run_dom_workflow(path, small_config(), output_dir = output)
  expected <- c(
    "assigned_formulas.csv", "formula_candidates.csv", "sample_summary.csv",
    "run_log.csv", "parameters.yml", "dom_result.rds"
  )
  expect_true(all(file.exists(file.path(output, expected))))
  expect_true(all(c("mz_observed", "neutral_mass", "DBE", "element_class") %in%
    names(result$assigned_formulas)))
})

test_that("sample comparison and shared formula functions are consistent", {
  path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
  assigned <- run_dom_workflow(path, small_config())$assigned_formulas
  comparison <- compare_samples(assigned)
  shared <- calculate_shared_formulas(assigned, min_samples = 2)
  expect_equal(nrow(comparison$jaccard), 2)
  expect_true(all(shared$sample_count >= 2))
})

test_that("optical, PMD, KEGG, and assembly extension contracts work", {
  formula_summary <- data.frame(sample_id = c("A", "B"), richness = c(10, 12))
  optical <- data.frame(sample_id = c("A", "B"), FI = c(1.4, 1.6))
  expect_equal(nrow(integrate_dom_optics(formula_summary, optical)), 2)

  formulae <- data.frame(
    sample_id = "A", mz_observed = c(200, 218.010565),
    molecular_formula = c("C10H12O5", "C10H14O6")
  )
  transformations <- data.frame(transformation_id = "H2O", mass_difference = 18.010565)
  edges <- calculate_pmd_pairs(formulae, transformations, tolerance = 1e-6)
  expect_equal(nrow(edges), 1)
  annotated <- join_pmd_kegg(
    edges,
    data.frame(transformation_id = "H2O", reaction_id = "user_mapping")
  )
  expect_equal(annotated$reaction_id, "user_mapping")
  expect_type(summarize_molecular_assembly(formulae), "list")
  no_edges <- calculate_pmd_pairs(formulae[1, ], transformations)
  expect_equal(nrow(no_edges), 0)
})

test_that("plot functions return ggplot objects and data", {
  path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
  assigned <- run_dom_workflow(path, small_config())$assigned_formulas
  expect_s3_class(plot_mass_error(assigned), "ggplot")
  expect_s3_class(plot_van_krevelen(assigned), "ggplot")
  expect_s3_class(plot_element_classes(assigned), "ggplot")
  expect_s3_class(plot_formula_metrics(assigned), "ggplot")
  expect_s3_class(plot_shared_formulas(assigned), "ggplot")
  expect_s3_class(plot_molecular_richness(assigned), "ggplot")
  returned <- plot_van_krevelen(assigned, return_data = TRUE)
  expect_named(returned, c("plot", "data"))
})
