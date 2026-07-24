# Filter peaks by replicate occurrence

Filter peaks by replicate occurrence

## Usage

``` r
filter_replicate_peaks(data, min_fraction = 2/3, ppm = 1)
```

## Arguments

- data:

  Standardized peak table with `replicate_id`.

- min_fraction:

  Minimum fraction of replicates within each sample group.

- ppm:

  Matching tolerance.

## Value

Peaks retained in the requested replicate fraction.
