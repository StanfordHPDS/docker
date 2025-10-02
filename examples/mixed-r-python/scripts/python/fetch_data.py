#!/usr/bin/env python
"""Fetch and preprocess data."""

import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from pathlib import Path
import requests
import json

def fetch_palmer_penguins():
    """Fetch Palmer Penguins dataset."""
    url = "https://raw.githubusercontent.com/allisonhorst/palmerpenguins/main/inst/extdata/penguins.csv"
    response = requests.get(url)
    
    # Save raw data
    raw_path = Path("data/raw/penguins.csv")
    raw_path.parent.mkdir(parents=True, exist_ok=True)
    raw_path.write_text(response.text)
    
    # Load and process
    df = pd.read_csv(raw_path)
    
    # Remove rows with missing values
    df_clean = df.dropna()
    
    # Create numeric features for ML
    df_numeric = df_clean[['bill_length_mm', 'bill_depth_mm', 
                          'flipper_length_mm', 'body_mass_g']]
    
    # Standardize features
    scaler = StandardScaler()
    df_scaled = pd.DataFrame(
        scaler.fit_transform(df_numeric),
        columns=df_numeric.columns,
        index=df_numeric.index
    )
    
    # Add back categorical columns
    df_processed = pd.concat([
        df_clean[['species', 'island', 'sex']].reset_index(drop=True),
        df_scaled.reset_index(drop=True)
    ], axis=1)
    
    # Save processed data
    processed_path = Path("data/processed/penguins_scaled.csv")
    processed_path.parent.mkdir(parents=True, exist_ok=True)
    df_processed.to_csv(processed_path, index=False)
    
    # Save metadata
    metadata = {
        'n_rows_raw': len(df),
        'n_rows_clean': len(df_clean),
        'features_scaled': list(df_numeric.columns),
        'scaler_mean': scaler.mean_.tolist(),
        'scaler_std': scaler.scale_.tolist()
    }
    
    meta_path = Path("data/processed/metadata.json")
    with open(meta_path, 'w') as f:
        json.dump(metadata, f, indent=2)
    
    print(f"✅ Data fetched and processed: {len(df_clean)} rows")
    return df_processed

if __name__ == "__main__":
    fetch_palmer_penguins()