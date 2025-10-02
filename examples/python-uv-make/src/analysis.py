"""Analysis module."""
import pandas as pd
import json
from pathlib import Path

def run_analysis():
    """Run analysis on prepared data."""
    df = pd.read_csv("data/processed/cleaned_data.csv")

    # Simple analysis
    results = {
        'mean_y': df['y'].mean(),
        'std_y': df['y'].std(),
        'correlation': df['x'].corr(df['y'])
    }

    # Save results
    output_path = Path("outputs/results.json")
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with open(output_path, 'w') as f:
        json.dump(results, f, indent=2)

    print(f"Analysis complete: {output_path}")
    return results

if __name__ == "__main__":
    run_analysis()
