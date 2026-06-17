---
title: Self-Organizing Map (SOM)
type: concept
sources: [https://en.wikipedia.org/wiki/Self-organizing_map]
related: [Neural Network Training Workflow, Deep Neural Networks (DNN)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Self-Organizing Map (SOM)

> [!check] Verified
> Confirmed via [Wikipedia: Self-organizing map](https://en.wikipedia.org/wiki/Self-organizing_map).

## The Core Idea

A Self-Organizing Map (SOM, also called a Kohonen map) is a type of artificial neural network trained using **unsupervised learning** to produce a low-dimensional (typically 2D) representation of higher-dimensional input data, while preserving the topological relationships between data points — similar inputs map to nearby locations on the grid.

## Intuition: A Self-Arranging Grid

Picture a 2D grid of "nodes," where each node has a weight vector of the same dimensionality as your input data (e.g., if your data has 10 features, each node has a 10-element weight vector — initially random).

Training proceeds by repeatedly:
1. Picking a random training example
2. Finding the node whose weight vector is **closest** to this example (the "winner" / "best matching unit")
3. Adjusting the winner's weights to be a bit *more* like this example
4. Adjusting the winner's **neighbours on the grid** to also move a bit toward this example (by a smaller amount, decreasing with grid-distance from the winner)

Over many iterations, nodes that are physically close on the grid end up with similar weight vectors — and since similar inputs activate nearby nodes, the 2D grid becomes a "map" where spatial proximity reflects similarity in the original high-dimensional data. This is why SOMs are useful for **visualising** high-dimensional data: you can plot which grid cell each data point activates and see clusters emerge spatially.

## Key Properties

- **Unsupervised** — no labelled targets are needed; the network discovers structure in the data on its own
- **Competitive learning** — nodes "compete" to represent each input; the winning node (and its neighbours) adjust their weights to better match the input
- **Dimensionality reduction + clustering** — useful for visualising high-dimensional data and for grouping similar data points

## In Practice: A SOM with MiniSom (Python)

SOMs aren't built into PyTorch/scikit-learn directly, but the lightweight `minisom` package implements the algorithm:

```python
# pip install minisom
from minisom import MiniSom
import numpy as np

# data: shape (n_samples, n_features), e.g. normalised sensor readings
data = np.random.rand(100, 10)

# 10x10 grid, input dimension 10
som = MiniSom(x=10, y=10, input_len=10, sigma=1.0, learning_rate=0.5)
som.random_weights_init(data)
som.train_random(data, num_iteration=1000)

# Find which grid cell each data point maps to
for sample in data[:5]:
    winner = som.winner(sample)  # (row, col) on the 10x10 grid
    print(winner)
```

After training, `som.distance_map()` gives a 2D array you can visualise as a heatmap — clusters in your original data appear as regions of the grid that data points consistently map to.

## Why It's Mentioned Alongside Deep Learning

SOMs represent an earlier (1980s-90s era) neural network approach to unsupervised learning/clustering — distinct from the deep, gradient-trained architectures (CNNs, RNNs) that dominate modern deep learning, but still a recognised building block in the broader neural network toolkit (e.g., MATLAB's clustering toolbox uses SOMs). For most modern unsupervised tasks, you'd more likely reach for `sklearn.cluster.KMeans`, `sklearn.decomposition.PCA`, or `t-SNE`/`UMAP` for visualisation — SOMs are a conceptual ancestor worth knowing but less commonly used in practice today.

## Common Pitfalls & Practical Tips

- **Normalise your input data first** — since SOM training relies on distance comparisons between weight vectors and inputs, features on very different scales (e.g., "age in years" vs "income in dollars") will dominate the distance calculation unless scaled (e.g., `sklearn.preprocessing.StandardScaler`).
- **Grid size is a hyperparameter** — too small, and distinct clusters get forced together; too large, and you may not have enough data to meaningfully populate every cell.
- **SOMs vs. K-Means:** both do unsupervised clustering, but SOMs additionally preserve *topology* (neighbouring clusters in the grid are similar), which K-Means doesn't — useful when you care about visualising relationships *between* clusters, not just the clusters themselves.

**Source:** [Wikipedia: Self-organizing map](https://en.wikipedia.org/wiki/Self-organizing_map)
