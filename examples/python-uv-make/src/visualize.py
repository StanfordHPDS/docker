"""Visualization module."""
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

def create_visualizations():
    """Create visualizations from analysis results."""
    df = pd.read_csv("data/processed/cleaned_data.csv")
    
    # Create figure
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.scatter(df['x'], df['y'], alpha=0.6)
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_title('Data Visualization')
    
    # Save figure
    output_path = Path("outputs/figures/plot.png")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()
    
    print(f"Figure saved: {output_path}")

if __name__ == "__main__":
    create_visualizations()