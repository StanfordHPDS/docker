# Functions for the targets pipeline

library(tidyverse)

#' Read raw data
read_raw_data <- function(file_path) {
  # If data doesn't exist, create example data
  if (!file.exists(file_path)) {
    dir.create(dirname(file_path), showWarnings = FALSE, recursive = TRUE)
    data <- tibble(
      x = 1:100,
      y = 1:100 + rnorm(100, 0, 10)
    )
    write_csv(data, file_path)
  }
  read_csv(file_path, show_col_types = FALSE)
}

#' Process data
process_data <- function(data) {
  data |>
    mutate(
      y_squared = y^2,
      group = if_else(x <= 50, "A", "B")
    )
}

#' Fit model
fit_model <- function(data) {
  lm(y ~ x + I(x^2), data = data)
}

#' Create plot
create_plot <- function(data, model) {
  predictions <- data |>
    mutate(fitted = fitted(model))
  
  ggplot(predictions, aes(x = x)) +
    geom_point(aes(y = y), alpha = 0.6) +
    geom_line(aes(y = fitted), color = "blue", linewidth = 1) +
    theme_minimal() +
    labs(title = "Data with Model Fit",
         x = "X", y = "Y")
}