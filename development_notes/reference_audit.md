# Reference audit

| Method item | Verified source | What the source supports | Package use and limitation |
|---|---|---|---|
| Automated formula assignment and homologous-series assistance | Kujawinski and Behn, 2006, DOI `10.1021/ac0600306` | Automated analysis of ultrahigh-resolution mass spectra and formula-assignment logic | Supports algorithmic context; package ranking is independently implemented and does not claim structure |
| Constrained CHONPS search, sub-ppm accuracy, DBE and chemical plausibility rules | Koch et al., 2007, DOI `10.1021/ac061949s` | Formula assignment with constrained elemental search and chemical rules | Supports the rule framework; project ranges and 0.75 ppm remain project-specific |
| Modified aromaticity index | Koch and Dittmar, 2006, DOI `10.1002/rcm.2386` | Formula-based aromaticity index for high-resolution organic-matter data | Used in `calculate_ai_mod()`; bonding and P/S interpretation remain uncertain |
| NOSC and carbon-oxidation energy relation | LaRowe and Van Cappellen, 2011, DOI `10.1016/j.gca.2011.01.020` | NOSC equation and empirical \(\Delta G^\circ_{\mathrm{Cox}}=60.3-28.5\,NOSC\) at 25 °C and 1 bar | Used as a formula-level standard-state proxy; not an in situ reaction Gibbs energy |

The previously entered DOI `10.1016/j.gca.2010.11.034` was invalid and was corrected after checking the original article. The correct paper is *Degradation of natural organic matter: A thermodynamic analysis*, *Geochimica et Cosmochimica Acta* 75, 2030–2042.

No package default should be described as a universal literature default. Mass tolerance, atom ranges, signal-to-noise threshold, and ranking weights require instrument-, calibration-, and project-specific validation.
