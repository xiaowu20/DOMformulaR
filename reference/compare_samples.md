# Compare molecular composition among samples

Computes molecular richness, pairwise Jaccard similarity, and optional
intensity-based Bray-Curtis dissimilarity. These are descriptive
summaries; inferential tests require independent biological replicates.

## Usage

``` r
compare_samples(data, intensity = TRUE)
```

## Arguments

- data:

  Assigned formula table.

- intensity:

  Use formula intensity for Bray-Curtis dissimilarity.

## Value

List with `richness`, `jaccard`, and `bray_curtis`.
