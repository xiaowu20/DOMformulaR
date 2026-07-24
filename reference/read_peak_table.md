# Read a peak table

Reads CSV, TSV, TXT, or Excel files. Excel support is optional and
requires `readxl`. Use `column_map` to map vendor columns to standard
names.

## Usage

``` r
read_peak_table(path, column_map = NULL, sheet = 1)
```

## Arguments

- path:

  Input file path.

- column_map:

  Named character vector whose names are standard columns and values are
  source columns.

- sheet:

  Excel sheet name or number.

## Value

A standardized data frame.

## Examples

``` r
path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
peaks <- read_peak_table(path)
```
