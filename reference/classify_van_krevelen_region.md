# Classify formulae into van Krevelen regions

Boundaries differ among studies. The default is an explicit, ordered,
mutually exclusive operational scheme and can be replaced by the user.
Lower bounds are inclusive and upper bounds are exclusive, except the
last matching fallback.

## Usage

``` r
classify_van_krevelen_region(data, regions = default_vk_regions())
```

## Arguments

- data:

  Formula data frame with H_C and O_C, or CHONPS counts.

- regions:

  Boundary table returned by
  [`default_vk_regions()`](https://xiaowu20.github.io/DOMformulaR/reference/default_vk_regions.md).

## Value

Character region vector.
