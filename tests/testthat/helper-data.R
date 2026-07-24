small_config <- function(max_nps = 3L) {
  dom_config(
    elements = list(
      C = c(4L, 15L), H = c(0L, 36L), O = c(1L, 15L),
      N = c(0L, 2L), P = c(0L, 1L), S = c(0L, 1L)
    ),
    max_nps = max_nps
  )
}

known_formulae <- data.frame(
  C = c(10, 10, 10, 10, 10),
  H = c(12, 13, 12, 13, 14),
  O = c(5, 5, 5, 5, 5),
  N = c(0, 1, 0, 0, 1),
  P = c(0, 0, 0, 1, 1),
  S = c(0, 0, 1, 0, 1)
)

independent_masses <- c(
  C = 12.00000000000, H = 1.00782503223, O = 15.99491461957,
  N = 14.00307400443, P = 30.97376199842, S = 31.97207117440
)

independent_formula_mass <- function(x) {
  sum(unlist(x[c("C", "H", "O", "N", "P", "S")]) * independent_masses)
}
