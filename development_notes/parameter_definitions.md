# Parameter definitions

| Parameter | Default | Meaning and boundary |
|---|---:|---|
| `mass_error_ppm` | 0.75 | Inclusive absolute ppm error for the supported ion model |
| `elements` | C 4–50, H 0–120, O 1–57, N 0–5, P 0–1, S 0–3 | Neutral-formula atom-count ranges |
| `ratios$H_C` | 0.30–2.25 | Inclusive H/C range |
| `ratios$O_C` | 0–1.15 | Inclusive O/C range |
| `ratios$N_C`, `P_C`, `S_C` | 0–Inf | Configurable inclusive heteroatom ratios |
| `min_dbe` | 0 | Minimum DBE |
| `dbe_o_range` | -10–10 | Inclusive DBE minus O range; this is not DBE/O |
| `max_nps` | 2 | Maximum N+P+S atom count |
| `max_candidates` | 50 | Above this count, no candidate is accepted as an ordinary ranked assignment |
| `ion_type` | `[M-H]-` | Only supported ion model in version 0.1.0 |
| `require_integer_dbe` | TRUE | Requires DBE within \(10^{-10}\) of an integer |
| `senior_rules` | TRUE | Enables the conservative nominal-valence screen |
| `nitrogen_rule` | TRUE | Enables nominal-mass and nitrogen parity |
| `ranking_weights` | 1, 0.15, 0.05 | Weights for absolute ppm error, N+P+S, and P+S |
| `min_signal_to_noise` | 6 | Workflow-level peak filter; ignored only when explicitly set to `NULL` |
| `min_intensity` | NULL | Optional minimum peak intensity |
| `mz_range` | -Inf–Inf | Optional inclusive m/z range |
| `blank_samples` | NULL | Blank filtering is not claimed when blank IDs are absent |
| `replicate_min_fraction` | NULL | Replicate consistency is not claimed when omitted |

The example YAML quotes the key `"N"` because YAML 1.1 otherwise parses an unquoted `N` as boolean false in the R `yaml` package.
