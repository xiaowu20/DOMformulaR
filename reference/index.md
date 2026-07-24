# Package index

## Peak tables

- [`read_dom_config()`](https://xiaowu20.github.io/DOMformulaR/reference/read_dom_config.md)
  : Read a YAML workflow configuration
- [`read_peak_table()`](https://xiaowu20.github.io/DOMformulaR/reference/read_peak_table.md)
  : Read a peak table
- [`standardize_peak_table()`](https://xiaowu20.github.io/DOMformulaR/reference/standardize_peak_table.md)
  : Standardize peak-table columns
- [`validate_peak_table()`](https://xiaowu20.github.io/DOMformulaR/reference/validate_peak_table.md)
  : Validate a standardized peak table
- [`inspect_peak_quality()`](https://xiaowu20.github.io/DOMformulaR/reference/inspect_peak_quality.md)
  : Inspect peak-table quality
- [`filter_peaks()`](https://xiaowu20.github.io/DOMformulaR/reference/filter_peaks.md)
  : Filter peaks by analytical thresholds
- [`remove_blank_peaks()`](https://xiaowu20.github.io/DOMformulaR/reference/remove_blank_peaks.md)
  : Remove peaks attributable to blanks
- [`filter_replicate_peaks()`](https://xiaowu20.github.io/DOMformulaR/reference/filter_replicate_peaks.md)
  : Filter peaks by replicate occurrence
- [`summarize_peak_table()`](https://xiaowu20.github.io/DOMformulaR/reference/summarize_peak_table.md)
  : Summarize a peak table

## Formula assignment

- [`dom_config()`](https://xiaowu20.github.io/DOMformulaR/reference/dom_config.md)
  : Create a CHONPS workflow configuration
- [`generate_chonps_formulas()`](https://xiaowu20.github.io/DOMformulaR/reference/generate_chonps_formulas.md)
  : Generate a CHONPS formula library
- [`assign_molecular_formulas()`](https://xiaowu20.github.io/DOMformulaR/reference/assign_molecular_formulas.md)
  : Assign CHONPS molecular formula candidates
- [`filter_formula_candidates()`](https://xiaowu20.github.io/DOMformulaR/reference/filter_formula_candidates.md)
  : Filter formula candidates
- [`rank_formula_candidates()`](https://xiaowu20.github.io/DOMformulaR/reference/rank_formula_candidates.md)
  : Rank formula candidates
- [`select_best_formula()`](https://xiaowu20.github.io/DOMformulaR/reference/select_best_formula.md)
  : Select the best formula per peak

## Metrics and classification

- [`calculate_element_ratios()`](https://xiaowu20.github.io/DOMformulaR/reference/calculate_element_ratios.md)
  : Calculate elemental ratios
- [`calculate_dbe()`](https://xiaowu20.github.io/DOMformulaR/reference/calculate_dbe.md)
  : Calculate double-bond equivalents
- [`calculate_ai_mod()`](https://xiaowu20.github.io/DOMformulaR/reference/calculate_ai_mod.md)
  : Calculate modified aromaticity index
- [`calculate_nosc()`](https://xiaowu20.github.io/DOMformulaR/reference/calculate_nosc.md)
  : Calculate nominal oxidation state of carbon
- [`calculate_formula_metrics()`](https://xiaowu20.github.io/DOMformulaR/reference/calculate_formula_metrics.md)
  : Calculate all formula-level DOM indices
- [`default_vk_regions()`](https://xiaowu20.github.io/DOMformulaR/reference/default_vk_regions.md)
  : Default mutually exclusive van Krevelen regions
- [`classify_element_group()`](https://xiaowu20.github.io/DOMformulaR/reference/classify_element_group.md)
  : Classify CHONPS elemental groups
- [`classify_van_krevelen_region()`](https://xiaowu20.github.io/DOMformulaR/reference/classify_van_krevelen_region.md)
  : Classify formulae into van Krevelen regions
- [`summarize_formula_classes()`](https://xiaowu20.github.io/DOMformulaR/reference/summarize_formula_classes.md)
  : Summarize elemental formula classes

## Comparison and workflow

- [`compare_samples()`](https://xiaowu20.github.io/DOMformulaR/reference/compare_samples.md)
  : Compare molecular composition among samples
- [`calculate_shared_formulas()`](https://xiaowu20.github.io/DOMformulaR/reference/calculate_shared_formulas.md)
  : Calculate shared molecular formulae
- [`run_dom_workflow()`](https://xiaowu20.github.io/DOMformulaR/reference/run_dom_workflow.md)
  : Run a complete CHONPS DOM workflow
- [`export_dom_results()`](https://xiaowu20.github.io/DOMformulaR/reference/export_dom_results.md)
  : Export standardized DOM results
- [`plot_element_classes()`](https://xiaowu20.github.io/DOMformulaR/reference/plot_element_classes.md)
  : Plot elemental class composition
- [`plot_formula_metrics()`](https://xiaowu20.github.io/DOMformulaR/reference/plot_formula_metrics.md)
  : Plot formula-metric distributions
- [`plot_mass_error()`](https://xiaowu20.github.io/DOMformulaR/reference/plot_mass_error.md)
  : Plot mass errors
- [`plot_molecular_richness()`](https://xiaowu20.github.io/DOMformulaR/reference/plot_molecular_richness.md)
  : Plot molecular richness
- [`plot_sample_composition()`](https://xiaowu20.github.io/DOMformulaR/reference/plot_sample_composition.md)
  : Plot sample composition
- [`plot_shared_formulas()`](https://xiaowu20.github.io/DOMformulaR/reference/plot_shared_formulas.md)
  : Plot shared formula occurrence
- [`plot_van_krevelen()`](https://xiaowu20.github.io/DOMformulaR/reference/plot_van_krevelen.md)
  : Plot a van Krevelen diagram

## Experimental integrations

Evidence-bounded helpers. These functions do not replace raw optical
preprocessing, reaction validation, or ecological null models.

- [`integrate_dom_optics()`](https://xiaowu20.github.io/DOMformulaR/reference/integrate_dom_optics.md)
  : Integrate prepared UV-visible and EEM summary metrics
- [`calculate_thermodynamic_indices()`](https://xiaowu20.github.io/DOMformulaR/reference/calculate_thermodynamic_indices.md)
  : Calculate formula-level carbon oxidation energetics proxy
- [`calculate_pmd_pairs()`](https://xiaowu20.github.io/DOMformulaR/reference/calculate_pmd_pairs.md)
  : Detect paired-mass-difference transformation candidates
- [`join_pmd_kegg()`](https://xiaowu20.github.io/DOMformulaR/reference/join_pmd_kegg.md)
  : Join PMD candidates to a user-supplied KEGG mapping
- [`summarize_molecular_assembly()`](https://xiaowu20.github.io/DOMformulaR/reference/summarize_molecular_assembly.md)
  : Summarize descriptive molecular assembly turnover
