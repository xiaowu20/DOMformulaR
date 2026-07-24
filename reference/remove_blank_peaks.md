# Remove peaks attributable to blanks

Remove peaks attributable to blanks

## Usage

``` r
remove_blank_peaks(data, blank_samples = NULL, ppm = 1, sample_blank_fold = 3)
```

## Arguments

- data:

  Sample and blank peak table.

- blank_samples:

  Character vector identifying blank sample IDs. If omitted, rows with
  `blank_flag == TRUE` are used.

- ppm:

  Matching tolerance.

- sample_blank_fold:

  A sample peak is retained when its intensity is greater than this
  multiple of the matched blank intensity.

## Value

Nonblank sample peaks with `blank_status`.
