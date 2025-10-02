#!/usr/bin/env python
"""Perform clustering analysis."""

import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
import json
from pathlib import Path

def perform_clustering():
    """Cluster penguins based on their measurements."""
    # Load processed data
    df = pd.read_csv("data/processed/penguins_scaled.csv")
    
    # Get numeric columns for clustering
    numeric_cols = ['bill_length_mm', 'bill_depth_mm', 
                    'flipper_length_mm', 'body_mass_g']
    X = df[numeric_cols]
    
    # Perform PCA for visualization
    pca = PCA(n_components=2)
    X_pca = pca.fit_transform(X)
    
    # Perform K-means clustering
    kmeans = KMeans(n_clusters=3, random_state=42)
    clusters = kmeans.fit_predict(X)
    
    # Add results to dataframe
    df['cluster'] = clusters
    df['pca1'] = X_pca[:, 0]
    df['pca2'] = X_pca[:, 1]
    
    # Save results
    output_path = Path("data/processed/penguins_clustered.csv")
    df.to_csv(output_path, index=False)
    
    # Save clustering metadata
    metadata = {
        'n_clusters': 3,
        'inertia': float(kmeans.inertia_),
        'pca_variance_explained': pca.explained_variance_ratio_.tolist(),
        'cluster_centers': kmeans.cluster_centers_.tolist()
    }
    
    meta_path = Path("data/processed/clustering_metadata.json")
    with open(meta_path, 'w') as f:
        json.dump(metadata, f, indent=2)
    
    print(f"✅ Clustering complete: {len(df)} samples in 3 clusters")
    return df

if __name__ == "__main__":
    perform_clustering()