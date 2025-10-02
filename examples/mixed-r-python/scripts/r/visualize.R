#!/usr/bin/env Rscript

library(ggplot2)
library(dplyr)
library(readr)
library(here)
library(gt)

# Read clustered data
df <- read_csv(here("data/processed/penguins_clustered.csv"))

# Create PCA visualization with clusters
p_clusters <- ggplot(df, aes(x = pca1, y = pca2)) +
  geom_point(aes(color = factor(cluster), shape = species), 
             size = 3, alpha = 0.7) +
  scale_color_viridis_d(name = "Cluster") +
  labs(
    title = "Penguin Clusters in PCA Space",
    x = "First Principal Component",
    y = "Second Principal Component"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# Save cluster plot
ggsave(
  here("outputs/figures/penguin_clusters.png"),
  p_clusters,
  width = 8, height = 6, dpi = 300
)

# Create species comparison by measurements
df_long <- df |>
  select(species, bill_length_mm:body_mass_g) |>
  tidyr::pivot_longer(
    cols = bill_length_mm:body_mass_g,
    names_to = "measurement",
    values_to = "value"
  ) |>
  mutate(
    measurement = case_when(
      measurement == "bill_length_mm" ~ "Bill Length (mm)",
      measurement == "bill_depth_mm" ~ "Bill Depth (mm)",
      measurement == "flipper_length_mm" ~ "Flipper Length (mm)",
      measurement == "body_mass_g" ~ "Body Mass (g)"
    )
  )

p_species <- ggplot(df_long, aes(x = species, y = value, fill = species)) +
  geom_violin(alpha = 0.7) +
  geom_boxplot(width = 0.1, fill = "white", alpha = 0.8) +
  facet_wrap(~measurement, scales = "free_y") +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Penguin Measurements by Species",
    x = NULL,
    y = "Standardized Value"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Save species plot
ggsave(
  here("outputs/figures/penguin_species_comparison.png"),
  p_species,
  width = 10, height = 8, dpi = 300
)

# Create summary table
summary_table <- df |>
  group_by(species) |>
  summarise(
    n = n(),
    mean_bill_length = mean(bill_length_mm),
    mean_flipper_length = mean(flipper_length_mm),
    mean_body_mass = mean(body_mass_g),
    .groups = "drop"
  ) |>
  gt() |>
  tab_header(
    title = "Penguin Species Summary",
    subtitle = "Standardized measurements"
  ) |>
  fmt_number(
    columns = starts_with("mean_"),
    decimals = 2
  ) |>
  cols_label(
    species = "Species",
    n = "Count",
    mean_bill_length = "Avg Bill Length",
    mean_flipper_length = "Avg Flipper Length",
    mean_body_mass = "Avg Body Mass"
  )

# Save summary table
gtsave(summary_table, here("outputs/tables/species_summary.html"))

cat("✅ Visualizations created successfully\n")