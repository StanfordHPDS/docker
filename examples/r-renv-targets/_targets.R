# Load packages and functions
library(targets)
library(tarchetypes)

tar_option_set(packages = c("tidyverse"))

# Source functions
tar_source("R/functions.R")

# Define pipeline
list(
  # Raw data
  tar_target(
    raw_data_file,
    "data/raw/example.csv",
    format = "file"
  ),
  
  # Read data
  tar_target(
    raw_data,
    read_raw_data(raw_data_file)
  ),
  
  # Process data
  tar_target(
    processed_data,
    process_data(raw_data)
  ),
  
  # Fit model
  tar_target(
    model,
    fit_model(processed_data)
  ),
  
  # Create plot
  tar_target(
    plot,
    create_plot(processed_data, model)
  ),
  
  # Save plot
  tar_target(
    plot_file,
    {
      dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
      ggsave("outputs/figures/model_fit.png", plot, width = 8, height = 6, dpi = 300)
      "outputs/figures/model_fit.png"
    },
    format = "file"
  ),
  
  # Render report
  tar_quarto(
    report,
    "reports/analysis.qmd"
  )
)