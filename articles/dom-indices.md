# DOM formula indices

``` r

library(DOMformulaR)
x <- data.frame(C = 10, H = 12, O = 5, N = 0, P = 0, S = 0)
calculate_formula_metrics(x)
```

    ##    C  H O N P S H_C O_C N_C P_C S_C DBE DBE_C DBE_O    AI_mod NOSC
    ## 1 10 12 5 0 0 0 1.2 0.5   0   0   0   5   0.5     1 0.3333333 -0.2

DBE is `1 + C - H/2 + N/2 + P/2`. AI_mod follows Koch and Dittmar
(2006), DOI 10.1002/rcm.2386. NOSC uses formal elemental oxidation
states and is linked to the framework of LaRowe and Van Cappellen
(2011), DOI 10.1016/j.gca.2011.01.020. P- and S-containing formulae
require cautious interpretation because formula-level indices do not
specify bonding or oxidation state.
