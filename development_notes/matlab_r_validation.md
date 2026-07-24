# Matlab and R validation

## Private DXC cross-validation

The package was run against the calibrated standardized DXC input used by the revised Matlab and R workflows. The real input and per-peak output remain local and are excluded from the public repository.

| Metric | Result |
|---|---:|
| Input peaks after standard preparation | 2,146 |
| DOMformulaR assignments | 719 |
| Revised R reference assignments | 719 |
| Peaks matched by m/z | 719 |
| Identical selected formulae | 719 |
| Formula agreement on matched peaks | 100% |
| Maximum absolute mass-error difference | \(5.55\times10^{-16}\) ppm |
| Most recent package runtime | 2.43 s |

The revised Matlab implementation also produced 719 CHONPS assignments and matched the revised R implementation. Agreement between independent implementations verifies computational consistency under the shared parameter set. It does not establish that every candidate is a unique chemical structure.

The original Matlab output contained 850 assignments. Against the optimized 719-assignment baseline, 686 peaks overlapped within 0.01 ppm, 660 normalized formulae agreed, 26 overlapping peaks differed in formula, 164 legacy assignments were not accepted by the revised rules, and 33 revised assignments were absent from the legacy output. The legacy output is therefore not an interchangeable reference.

## Simulated tests

The public tests use independently calculated exact masses and simulated peaks. They cover CHO, N-, P-, S-, and mixed CHONPS formulae, both ppm tolerance boundaries, multiple-candidate retention and ranking, no-match behavior, malformed configuration, field mapping, filtering, blanks, replicates, metrics, class summaries, plotting, export, optical joins, PMD contracts, user-supplied KEGG joins, and descriptive assembly summaries.

The current suite contains 78 passing assertions. No real DXC data are included.
