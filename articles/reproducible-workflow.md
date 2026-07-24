# Reproducible end-to-end workflow

``` r

library(DOMformulaR)
path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
cfg_path <- system.file("extdata", "example_config.yml", package = "DOMformulaR")
output <- file.path(tempdir(), "domformula-example")
result <- run_dom_workflow(path, cfg_path, output_dir = output)
list.files(output)
```

    ##  [1] "assigned_formulas.csv"  "dom_result.rds"         "element_classes.png"   
    ##  [4] "formula_candidates.csv" "mass_error.png"         "molecular_richness.png"
    ##  [7] "parameters.yml"         "run_log.csv"            "sample_summary.csv"    
    ## [10] "van_krevelen.png"

The output directory contains selected formulae, all candidates, a
sample summary, parameter snapshot, run log, serialized result, and
figures. Unknown blank or replicate evidence remains explicit.
