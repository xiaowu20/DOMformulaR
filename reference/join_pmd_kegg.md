# Join PMD candidates to a user-supplied KEGG mapping

The package does not query KEGG or claim enzymatic support. Users must
provide a licensed, versioned mapping table.

## Usage

``` r
join_pmd_kegg(pmd_pairs, kegg_map)
```

## Arguments

- pmd_pairs:

  Output from
  [`calculate_pmd_pairs()`](https://xiaowu20.github.io/DOMformulaR/reference/calculate_pmd_pairs.md).

- kegg_map:

  Mapping table containing `transformation_id`.

## Value

Joined PMD annotation table.
