# Calculate formula-level carbon oxidation energetics proxy

Adds the nominal oxidation state of carbon and the empirical standard
Gibbs energy proxy `60.3 - 28.5 * NOSC` in kJ per mol C. This proxy does
not represent an in situ reaction free energy and does not include
activities, electron acceptors, pH, or temperature corrections.

## Usage

``` r
calculate_thermodynamic_indices(data)
```

## Arguments

- data:

  Formula data frame.

## Value

Input data with `NOSC` and `delta_g_cox_kj_mol_c`.

## References

LaRowe DE, Van Cappellen P (2011).
[doi:10.1016/j.gca.2011.01.020](https://doi.org/10.1016/j.gca.2011.01.020)
