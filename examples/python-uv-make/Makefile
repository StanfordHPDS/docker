# Makefile for Python Data Science Pipeline

# Variables
PYTHON := python
DATA_DIR := data
OUTPUT_DIR := outputs
SRC_DIR := src

# Phony targets
.PHONY: all setup data analysis visualize report clean help

# Default target
all: data analysis visualize report
	@echo "✓ Pipeline complete!"

# Help
help:
	@echo "Available targets:"
	@echo "  make setup      - Set up Python environment"
	@echo "  make all        - Run complete pipeline"
	@echo "  make data       - Prepare data"
	@echo "  make analysis   - Run analysis"
	@echo "  make visualize  - Create visualizations"
	@echo "  make report     - Generate Quarto report"
	@echo "  make clean      - Clean generated files"

# Setup environment
setup:
	@echo "Setting up Python environment..."
	uv sync
	@echo "✓ Environment ready"

# Data preparation
$(DATA_DIR)/processed/cleaned_data.csv: $(SRC_DIR)/data_prep.py
	@echo "Preparing data..."
	uv run $(SRC_DIR)/data_prep.py
	@echo "✓ Data prepared"

data: $(DATA_DIR)/processed/cleaned_data.csv

# Analysis
$(OUTPUT_DIR)/results.json: $(SRC_DIR)/analysis.py $(DATA_DIR)/processed/cleaned_data.csv
	@echo "Running analysis..."
	@mkdir -p $(OUTPUT_DIR)
	uv run $(SRC_DIR)/analysis.py
	@echo "✓ Analysis complete"

analysis: $(OUTPUT_DIR)/results.json

# Visualization
$(OUTPUT_DIR)/figures/plot.png: $(SRC_DIR)/visualize.py $(OUTPUT_DIR)/results.json
	@echo "Creating visualizations..."
	@mkdir -p $(OUTPUT_DIR)/figures
	uv run $(SRC_DIR)/visualize.py
	@echo "✓ Visualizations created"

visualize: $(OUTPUT_DIR)/figures/plot.png

# Quarto report
$(OUTPUT_DIR)/reports/analysis.html: reports/analysis.qmd $(OUTPUT_DIR)/results.json $(OUTPUT_DIR)/figures/plot.png
	@echo "Rendering report..."
	@mkdir -p $(OUTPUT_DIR)/reports
	uv run quarto render reports/analysis.qmd --to html --output-dir ../$(OUTPUT_DIR)/reports
	@echo "✓ Report generated"

report: $(OUTPUT_DIR)/reports/analysis.html

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	rm -rf $(DATA_DIR)/processed/*
	rm -rf $(OUTPUT_DIR)/*
	rm -rf $(SRC_DIR)/__pycache__
	@echo "✓ Clean complete"
