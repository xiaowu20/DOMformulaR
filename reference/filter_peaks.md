# Filter peaks by analytical thresholds

Filter peaks by analytical thresholds

## Usage

``` r
filter_peaks(
  data,
  min_signal_to_noise = NULL,
  min_intensity = NULL,
  mz_range = c(-Inf, Inf)
)
```

## Arguments

- data:

  Standardized peak table.

- min_signal_to_noise:

  Optional minimum S/N. Missing S/N values are retained with a warning.

- min_intensity:

  Optional minimum intensity.

- mz_range:

  Inclusive m/z range.

## Value

Filtered data frame.
