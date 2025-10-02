.PHONY: all clean

# Default target
all: outputs/figures/penguin_clusters.png

# Fetch and preprocess data with Python
data/processed/penguins_scaled.csv: scripts/python/fetch_data.py
	@mkdir -p data/raw data/processed
	@echo "📊 Fetching and preprocessing data..."
	uv run scripts/python/fetch_data.py

# Perform clustering analysis with Python
data/processed/penguins_clustered.csv: data/processed/penguins_scaled.csv scripts/python/clustering.py
	@echo "🔬 Performing clustering analysis..."
	uv run scripts/python/clustering.py

# Run R visualization
outputs/figures/penguin_clusters.png: data/processed/penguins_clustered.csv scripts/r/visualize.R
	@mkdir -p outputs/figures outputs/tables
	@echo "📈 Creating visualizations..."
	Rscript scripts/r/visualize.R

# Run bridge analysis (R + Python via reticulate)
bridge: fetch-data
	@echo "🌉 Running bridge analysis..."
	Rscript scripts/r/bridge_analysis.R

# Full analysis including bridge
full: visualize bridge

# Render Quarto report
report: full
	@echo "📄 Rendering report..."
	cd reports && quarto render analysis.qmd

# Clean outputs
clean:
	rm -rf data/processed/* outputs/figures/* outputs/tables/* reports/*.html

# Clean everything including raw data
clean-all: clean
	rm -rf data/raw/*