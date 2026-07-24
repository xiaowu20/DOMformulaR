# DOMformulaR

[![R-CMD-check](https://github.com/xiaowu20/DOMformulaR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/xiaowu20/DOMformulaR/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/xiaowu20/DOMformulaR/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/xiaowu20/DOMformulaR/actions/workflows/test-coverage.yaml)

`DOMformulaR` is an R package for reproducible formula-candidate
assignment and visualization of dissolved organic matter
ultrahigh-resolution mass-spectrometry peak tables.

Version 0.1.0 supports only C, H, O, N, P, and S. It supports singly
charged negative-ion `[M-H]-` data. It does not contain F, Cl, Br, Na,
K, Si, or other element logic.

Accurate-mass and chemical-rule matching produces molecular-formula
candidates, not structural identifications. Results depend on
calibration, resolving power, peak extraction, ion mode, blanks,
replicates, parameters, and manual review. The package does not replace
MS/MS, standards, blanks, or replicate experiments.

## Installation

``` r

remotes::install_github("xiaowu20/DOMformulaR")
```

## Minimal workflow

``` r

library(DOMformulaR)

path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
config_path <- system.file("extdata", "example_config.yml", package = "DOMformulaR")

result <- run_dom_workflow(
  path,
  config = config_path,
  min_signal_to_noise = 6
)

result
head(as.data.frame(result))
plot(result, "van_krevelen")
```

The workflow returns a transparent S3 `dom_result` containing cleaned
peaks, all formula candidates, selected assignments, formula metrics,
sample summaries, ggplot objects, parameters, logs, and captured
warnings.

## Main capabilities

The package imports and maps vendor peak tables, validates numeric and
identifier fields, filters peaks, handles blank and replicate occurrence
rules, enumerates CHONPS candidates, retains and ranks multiple
candidates, calculates H/C, O/C, N/C, P/C, S/C, DBE, DBE/C, DBE/O,
AI_mod, and NOSC, classifies elemental and operational van Krevelen
groups, compares samples, exports reproducibility artifacts, and returns
editable ggplot2 objects.

Experimental integration helpers join prepared UV-visible/EEM summary
metrics, calculate a formula-level carbon-oxidation energy proxy, detect
paired-mass-difference candidates, join user-supplied KEGG mappings, and
summarize descriptive molecular turnover. They do not preprocess raw EEM
cubes, query KEGG, establish biochemical reactions, or implement
ecological null-model assembly inference.

## Method limits

Van Krevelen boundaries vary among publications and are configurable.
AI_mod, NOSC, and thermodynamic proxies are formula-derived descriptors
whose interpretation depends on the sample system. PMD edges are
mass-consistent transformation candidates, not measured reaction fluxes.
Sample comparisons are descriptive unless the design contains
independent biological replicates.

## Citation

Use:

``` r

citation("DOMformulaR")
```

Analyses performed with DOMformulaR should cite both the package and the
methodological sources corresponding to the functions used. DOMformulaR
is an independent R implementation of the CHONPS formula-assignment and
downstream-analysis components derived from the audited
FTMSAnalysis/TRFu workflow. The originating FTMSAnalysis workflow and
the TRFu formula-assignment algorithm are described by Fu et al. (2023)
and Fu et al. (2020), respectively.

DOMformulaR does not currently implement the Gaussian-based FTMSCombine
alignment algorithm or the complete isotope-, deuterium-, and
halogen-aware FTMSDeu workflow. Citation of Fu et al. (2023) documents
workflow provenance and does not imply that Gaussian alignment was
performed by this package.

Primary workflow references:

- Fu, Q.-L., Fujii, M., and Riedel, T. (2020). Development and
  comparison of formula assignment algorithms for ultrahigh-resolution
  mass spectra of natural organic matter. *Analytica Chimica Acta*,
  1125, 247–257. <https://doi.org/10.1016/j.aca.2020.05.048>
- Fu, Q.-L., Fujii, M., and Ma, R. (2023). Development of a
  Gaussian-based alignment algorithm for the ultrahigh-resolution mass
  spectra of dissolved organic matter. *Analytical Chemistry*, 95(5),
  2796–2803. <https://doi.org/10.1021/acs.analchem.2c04113>

Formula-assignment rules and molecular indices are further documented by
Kujawinski and Behn (2006), Koch et al. (2007), Koch and Dittmar (2006),
and LaRowe and Van Cappellen (2011). Recent comparison and
uncertainty-control methods are listed in
[`development_notes/reference_audit.md`](https://xiaowu20.github.io/DOMformulaR/development_notes/reference_audit.md).
No software DOI has been minted. A DOI can be added after archiving a
release with Zenodo.

## Development

Version 0.1.0 is an initial CHONPS-only release under the MIT License.
Report reproducible problems through the GitHub issue tracker. See
`CONTRIBUTING.md` before changing formula rules.
