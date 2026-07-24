plot_return <- function(plot, data, return_data) {
  attr(plot, "plot_data") <- data
  if (isTRUE(return_data)) list(plot = plot, data = data) else plot
}

theme_dom <- function(theme) {
  if (is.null(theme)) ggplot2::theme_bw() else theme
}

#' Plot mass errors
#'
#' @param data Assigned formula table.
#' @param distribution Draw a histogram instead of m/z versus mass error.
#' @param group Optional grouping column.
#' @param alpha Point transparency.
#' @param point_size Point size.
#' @param xlim,ylim Optional coordinate limits.
#' @param facet Optional faceting column.
#' @param theme ggplot2 theme object.
#' @param return_data Return a list with plot and plot data.
#' @return A ggplot object or list.
#' @export
plot_mass_error <- function(
  data,
  distribution = FALSE,
  group = NULL,
  alpha = 0.6,
  point_size = 1.2,
  xlim = NULL,
  ylim = NULL,
  facet = NULL,
  theme = NULL,
  return_data = FALSE
) {
  if (!all(c("mass_error_ppm", "mz_observed") %in% names(data))) {
    rlang::abort("Data must contain mz_observed and mass_error_ppm.")
  }
  mapping <- if (is.null(group)) {
    ggplot2::aes(x = .data$mz_observed, y = .data$mass_error_ppm)
  } else {
    ggplot2::aes(
      x = .data$mz_observed, y = .data$mass_error_ppm,
      colour = .data[[group]]
    )
  }
  if (isTRUE(distribution)) {
    plot <- ggplot2::ggplot(data, ggplot2::aes(x = .data$mass_error_ppm)) +
      ggplot2::geom_histogram(bins = 40, colour = "white", fill = "#4C78A8") +
      ggplot2::labs(x = "Mass error (ppm)", y = "Formula count")
  } else {
    plot <- ggplot2::ggplot(data, mapping) +
      ggplot2::geom_point(alpha = alpha, size = point_size) +
      ggplot2::geom_hline(yintercept = 0, linewidth = 0.4, linetype = 2) +
      ggplot2::labs(x = "Observed m/z", y = "Mass error (ppm)")
  }
  if (!is.null(facet)) {
    plot <- plot + ggplot2::facet_wrap(stats::as.formula(paste("~", facet)))
  }
  plot <- plot + ggplot2::coord_cartesian(xlim = xlim, ylim = ylim) + theme_dom(theme)
  plot_return(plot, data, return_data)
}

#' Plot a van Krevelen diagram
#'
#' @param data Formula table.
#' @param group Grouping column, default `element_class`.
#' @param intensity_weighted Scale points by intensity.
#' @param alpha Point transparency.
#' @param point_size Base point size.
#' @param xlim,ylim Coordinate limits.
#' @param facet Optional faceting column.
#' @param theme ggplot2 theme.
#' @param return_data Return plot and data.
#' @return A ggplot object or list.
#' @export
plot_van_krevelen <- function(
  data,
  group = "element_class",
  intensity_weighted = FALSE,
  alpha = 0.6,
  point_size = 1.3,
  xlim = c(0, 1.2),
  ylim = c(0.3, 2.25),
  facet = NULL,
  theme = NULL,
  return_data = FALSE
) {
  if (!all(c("H_C", "O_C") %in% names(data))) {
    data <- calculate_element_ratios(data)
  }
  mapping <- ggplot2::aes(x = .data$O_C, y = .data$H_C)
  if (!is.null(group)) {
    mapping$colour <- rlang::expr(.data[[!!group]])
  }
  if (isTRUE(intensity_weighted)) {
    mapping$size <- rlang::expr(.data$intensity)
  }
  plot <- ggplot2::ggplot(data, mapping) +
    ggplot2::geom_point(alpha = alpha, size = if (intensity_weighted) NULL else point_size) +
    ggplot2::coord_cartesian(xlim = xlim, ylim = ylim) +
    ggplot2::labs(x = "O/C", y = "H/C", colour = group) +
    theme_dom(theme)
  if (isTRUE(intensity_weighted)) {
    plot <- plot + ggplot2::labs(size = "Intensity")
  }
  if (!is.null(facet)) {
    plot <- plot + ggplot2::facet_wrap(stats::as.formula(paste("~", facet)))
  }
  plot_return(plot, data, return_data)
}

#' Plot elemental class composition
#'
#' @param data Assigned formula table.
#' @param weight `count` or `intensity`.
#' @param position Bar position.
#' @param theme ggplot2 theme.
#' @param return_data Return plot and summarized data.
#' @return A ggplot object or list.
#' @export
plot_element_classes <- function(
  data,
  weight = c("count", "intensity"),
  position = "stack",
  theme = NULL,
  return_data = FALSE
) {
  weight <- match.arg(weight)
  summary <- summarize_formula_classes(data, weight)
  plot <- ggplot2::ggplot(
    summary,
    ggplot2::aes(x = .data$sample_id, y = .data$fraction, fill = .data$element_class)
  ) +
    ggplot2::geom_col(position = position) +
    ggplot2::labs(x = "Sample", y = paste0(weight, " fraction"), fill = "Element class") +
    theme_dom(theme)
  plot_return(plot, summary, return_data)
}

#' Plot formula-metric distributions
#'
#' @param data Assigned formula table.
#' @param metric One of H_C, O_C, DBE, AI_mod, or NOSC.
#' @param group Optional grouping column.
#' @param bins Histogram bins.
#' @param facet Optional faceting column.
#' @param theme ggplot2 theme.
#' @param return_data Return plot and data.
#' @return A ggplot object or list.
#' @export
plot_formula_metrics <- function(
  data,
  metric = "DBE",
  group = NULL,
  bins = 35,
  facet = NULL,
  theme = NULL,
  return_data = FALSE
) {
  allowed <- c("H_C", "O_C", "DBE", "AI_mod", "NOSC")
  if (!metric %in% allowed || !metric %in% names(data)) {
    rlang::abort(paste("`metric` must be an available column among", paste(allowed, collapse = ", ")))
  }
  mapping <- if (is.null(group)) {
    ggplot2::aes(x = .data[[metric]])
  } else {
    ggplot2::aes(x = .data[[metric]], fill = .data[[group]])
  }
  plot <- ggplot2::ggplot(data, mapping) +
    ggplot2::geom_histogram(bins = bins, position = "identity", alpha = 0.65) +
    ggplot2::labs(x = metric, y = "Formula count", fill = group) +
    theme_dom(theme)
  if (!is.null(facet)) {
    plot <- plot + ggplot2::facet_wrap(stats::as.formula(paste("~", facet)))
  }
  plot_return(plot, data, return_data)
}

#' Plot sample composition
#'
#' @inheritParams plot_element_classes
#' @return A ggplot object or list.
#' @export
plot_sample_composition <- function(
  data,
  weight = c("count", "intensity"),
  position = "stack",
  theme = NULL,
  return_data = FALSE
) {
  plot_element_classes(data, weight, position, theme, return_data)
}

#' Plot shared formula occurrence
#'
#' Uses an occurrence-frequency bar chart that remains readable for many
#' samples. It does not default to a Venn diagram.
#'
#' @param data Assigned formula table.
#' @param min_samples Minimum occurrence count.
#' @param theme ggplot2 theme.
#' @param return_data Return plot and data.
#' @return A ggplot object or list.
#' @export
plot_shared_formulas <- function(
  data,
  min_samples = 1L,
  theme = NULL,
  return_data = FALSE
) {
  shared <- calculate_shared_formulas(data, min_samples)
  counts <- as.data.frame(table(shared$sample_count), stringsAsFactors = FALSE)
  names(counts) <- c("sample_count", "formula_count")
  counts$sample_count <- as.integer(as.character(counts$sample_count))
  plot <- ggplot2::ggplot(
    counts,
    ggplot2::aes(x = .data$sample_count, y = .data$formula_count)
  ) +
    ggplot2::geom_col(fill = "#4C78A8") +
    ggplot2::labs(x = "Number of samples", y = "Molecular formulae") +
    theme_dom(theme)
  plot_return(plot, counts, return_data)
}

#' Plot molecular richness
#'
#' @param data Assigned formula table.
#' @param theme ggplot2 theme.
#' @param return_data Return plot and data.
#' @return A ggplot object or list.
#' @export
plot_molecular_richness <- function(data, theme = NULL, return_data = FALSE) {
  richness <- compare_samples(data)$richness
  plot <- ggplot2::ggplot(
    richness,
    ggplot2::aes(x = .data$sample_id, y = .data$molecular_richness)
  ) +
    ggplot2::geom_col(fill = "#54A24B") +
    ggplot2::labs(x = "Sample", y = "Molecular richness") +
    theme_dom(theme)
  plot_return(plot, richness, return_data)
}
