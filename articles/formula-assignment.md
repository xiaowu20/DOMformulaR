# CHONPS formula assignment

DOMformulaR independently enumerates neutral C, H, O, N, P, and S
formulae, converts theoretical neutral mass to `[M-H]-`, applies ppm,
ratio, DBE, nominal-valence, parity, and heteroatom rules, and retains
every candidate before deterministic ranking.

The default parameter set is derived from the audited FTMSAnalysis/TRFu
project workflow for comparability. The originating workflow is
described by Fu et al. (2023), DOI 10.1021/acs.analchem.2c04113, and the
TRFu formula-assignment algorithm is described by Fu et al. (2020), DOI
10.1016/j.aca.2020.05.048. It is not a universal default. Candidate
ranking is not a posterior probability and does not convert exact-mass
matching into compound identification.

DOMformulaR does not implement the Gaussian FTMSCombine alignment
described by Fu et al. (2023), nor the complete isotope-, deuterium-,
and halogen-aware FTMSDeu workflow. The Fu et al. (2023) citation
records workflow provenance and does not indicate that Gaussian
alignment was performed.

``` r

library(DOMformulaR)
cfg <- dom_config(elements = list(
  C = c(4, 12), H = c(0, 30), O = c(1, 12),
  N = c(0, 2), P = c(0, 1), S = c(0, 1)
))
head(generate_chonps_formulas(cfg, c(150, 300)))
```

    ##     C  H O N P S neutral_mass_theoretical molecular_formula       H_C       O_C
    ## 63  5 10 5 0 0 0                 150.0528           C5H10O5 2.0000000 1.0000000
    ## 631 6  2 5 0 0 0                 153.9902            C6H2O5 0.3333333 0.8333333
    ## 65  6  4 5 0 0 0                 156.0059            C6H4O5 0.6666667 0.8333333
    ## 67  6  6 5 0 0 0                 158.0215            C6H6O5 1.0000000 0.8333333
    ## 69  6  8 5 0 0 0                 160.0372            C6H8O5 1.3333333 0.8333333
    ## 71  6 10 5 0 0 0                 162.0528           C6H10O5 1.6666667 0.8333333
    ##     N_C P_C S_C DBE     DBE_C DBE_O    AI_mod      NOSC
    ## 63    0   0   0   1 0.2000000   0.2 0.0000000 0.0000000
    ## 631   0   0   0   6 1.0000000   1.2 1.0000000 1.3333333
    ## 65    0   0   0   5 0.8333333   1.0 0.7142857 1.0000000
    ## 67    0   0   0   4 0.6666667   0.8 0.4285714 0.6666667
    ## 69    0   0   0   3 0.5000000   0.6 0.1428571 0.3333333
    ## 71    0   0   0   2 0.3333333   0.4 0.0000000 0.0000000

Additional formula-assignment references are Kujawinski and Behn (2006),
DOI 10.1021/ac0600306, and Koch et al. (2007), DOI 10.1021/ac061949s.
Recent methods relevant to external comparison and uncertainty control
include MFAssignR (Schum et al., 2020, DOI
10.1016/j.envres.2020.110114), ICBM-OCEAN (Merder et al., 2020, DOI
10.1021/acs.analchem.9b05659), the mass-error-distribution method of Gao
et al. (2024), DOI 10.1021/acs.analchem.4c00489, and the data-set
consistency method of Dewey et al. (2025), DOI
10.1021/acs.analchem.4c06826. These methods are comparison or
development targets and are not claimed as implemented functionality.
