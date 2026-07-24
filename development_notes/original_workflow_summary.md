# Original workflow summary

The source project used Matlab scripts and workbook-oriented intermediate files. The audited legacy route combined peak filtering, calibration-dependent mass handling, formula enumeration, candidate selection, class calculation, plotting, and export with implicit workspace state and hard-coded assumptions. The legacy DXC result contained 850 formula assignments.

The revised project separated import, validation, filtering, neutral-mass conversion, CHONPS enumeration, chemical-rule filtering, deterministic ranking, formula metrics, summaries, figures, and export. Using the calibrated standardized DXC input, the independent optimized Matlab and R implementations each produced 719 CHONPS assignments with identical selected formulae.

`DOMformulaR` is a clean package implementation of the CHONPS route. It does not copy the legacy Matlab files and does not expose the previous halogen development branch. Version 0.1.0 supports only singly charged negative-ion `[M-H]-` peak tables. Formula assignment is an accurate-mass candidate annotation, not a structural identification.

The package keeps all candidates, their ranks, the selected formula, mass error, formula status, acceptance reason, parameters, run log, warnings, and editable ggplot objects. It accepts multiple samples and replicate identifiers, but statistical interpretation remains constrained by the actual sampling design.
