# Integrate prepared UV-visible and EEM summary metrics

This function joins sample-level optical DOM metrics to formula
summaries. It does not preprocess raw EEM matrices, perform blank/Raman
corrections, or fit PARAFAC models. Those steps require
instrument-specific quality control.

## Usage

``` r
integrate_dom_optics(formula_summary, optical_data)
```

## Arguments

- formula_summary:

  Data frame with `sample_id`.

- optical_data:

  Data frame with `sample_id` and prepared metrics such as `UV254`,
  `SUVA254`, `FI`, `BIX`, `HIX`, or PARAFAC component scores.

## Value

Joined data frame.
