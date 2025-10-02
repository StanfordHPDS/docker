#!/usr/bin/env Rscript

library(reticulate)
library(dplyr)
library(ggplot2)
library(here)

# Use the project's Python environment
use_virtualenv(here(".venv"), required = TRUE)

# Import Python modules
pd <- import("pandas")
np <- import("numpy")

# Run Python analysis from R
source_python(here("scripts/python/clustering.py"))

# Load the results
df_clustered <- perform_clustering()

# Convert to R dataframe
df_r <- as.data.frame(df_clustered)

# Additional R analysis on Python results
cluster_summary <- df_r |>
  group_by(cluster, species) |>
  summarise(count = n(), .groups = "drop") |>
  tidyr::pivot_wider(names_from = species, values_from = count, values_fill = 0)

# Create a heatmap of cluster composition
p_heatmap <- cluster_summary |>
  tidyr::pivot_longer(cols = -cluster, names_to = "species", values_to = "count") |>
  ggplot(aes(x = factor(cluster), y = species, fill = count)) +
  geom_tile() +
  geom_text(aes(label = count), color = "white", size = 5) +
  scale_fill_viridis_c() +
  labs(
    title = "Cluster Composition by Species",
    x = "Cluster",
    y = "Species",
    fill = "Count"
  ) +
  theme_minimal()

# Save the plot
ggsave(
  here("outputs/figures/cluster_species_heatmap.png"),
  p_heatmap,
  width = 6, height = 4, dpi = 300
)

cat("✅ Bridge analysis complete\n")