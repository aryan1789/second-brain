---
title: K-Means Clustering
type: concept
sources: [raw/lecture-notes/COMP723/Lecture6.pptx, https://www.geeksforgeeks.org/machine-learning/k-means-clustering-introduction/, https://www.ibm.com/think/topics/k-means-clustering]
related: [Classification (Supervised Learning), K-Nearest Neighbors (KNN), Self-Organizing Map (SOM), Data Preprocessing and Data Quality]
created: 13-06-2026
last-updated: 13-06-2026
---

# K-Means Clustering

> [!check] Verified
> Confirmed via [GeeksforGeeks: K-Means Clustering – Introduction](https://www.geeksforgeeks.org/machine-learning/k-means-clustering-introduction/) and [IBM: What is k-means clustering?](https://www.ibm.com/think/topics/k-means-clustering)

## The Core Idea

**Clustering** is **unsupervised learning**: the data has no labels, and the goal is to **group together similar instances** — e.g. group 2D points, customer records, emails, or image regions into clusters that reflect underlying structure. This contrasts directly with [[Classification (Supervised Learning)]], where every training instance already has a known class label. Clustering is especially useful when you **don't know what you're looking for** — the goal is to *discover* structure, not predict a known target.

**K-Means** is the most common clustering algorithm: an **iterative algorithm** that partitions data into `k` clusters, where `k` is chosen in advance.

```
1. Initialize: pick k random points as cluster centres (centroids)
2. Alternate:
   a. Assignment step  — assign each data point to its closest cluster centre
   b. Update step      — move each cluster centre to the average (mean)
                          of the points assigned to it
3. Stop when no point's assignment changes (convergence)
```

## Worked Convergence Walkthrough (K=2)

The lecture illustrates convergence step by step for `K = 2`:

1. **Pick 2 random points** as the initial cluster centres (means).
2. **Iterative Step 1** — assign every data point to whichever of the 2 centres is closest.
3. **Iterative Step 2** — recompute each centre as the **average of the points now assigned to it**; the centres shift toward the "centre of mass" of their cluster.
4. **Repeat** steps 1-2 until no point changes its assignment between iterations — at this point the algorithm has **converged**.

## What Counts as "Similar"? Distance Measures

Clustering results are **crucially dependent on the measure of similarity (or distance)** used between points. The simplest option is **squared Euclidean distance**, but any valid distance measure `D(A,B)` must satisfy three properties:

- **Symmetric:** `D(A,B) = D(B,A)` — otherwise "A looks like B but B does not look like A", which is nonsensical for a similarity measure.
- **Positivity and self-similarity:** `D(A,B) >= 0`, and `D(A,B) = 0` if and only if `A = B` — otherwise there would be distinct objects the measure cannot tell apart.
- **Triangle inequality:** `D(A,B) + D(B,C) >= D(A,C)` — otherwise you could have "A is like B, B is like C, but A is not like C at all", which breaks the intuitive notion of similarity.

Changing the **features** used (i.e. changing the distance function) can directly fix cases where K-means fails to find the "obvious" clusters in the data — the choice of features is as important as the algorithm itself.

## Some K-Means Insights: What Can Go Wrong

- **Initialization matters** — *which* points are picked as initial centres, and *how many* (`k`), strongly affect the final clusters. Poor initial centres can lead to **poor convergence** (the algorithm converges to a bad local optimum).
- **Various schemes exist for preventing non/poor convergence**, including **split/merge heuristics** (splitting a cluster that's too large/diverse, or merging two clusters that are too similar) and smarter initialization strategies (e.g. spreading initial centres apart rather than picking them purely at random).
- K-means can fail to properly cluster data whose true groupings aren't well-captured by Euclidean distance on the raw features (e.g. non-spherical or elongated clusters) — in these cases, **changing the features/distance function** can help recover the intended clusters.

## Other Clustering Algorithms

The lecture situates K-means within a broader family:

| Category | Examples |
|---|---|
| **Partition (Flat) algorithms** | K-means, Mixture of Gaussians (statistical), Spectral Clustering, [[Self-Organizing Map (SOM)]] |
| **Hierarchical algorithms** | Bottom-up (**agglomerative**) — start with every point as its own cluster and merge; Top-down (**divisive**) — start with one cluster and split |

[[Self-Organizing Map (SOM)]] is itself a clustering technique, but uses **competitive learning** over a neural grid rather than iterative centroid updates — both share the same unsupervised "group similar things" goal.

## In Practice: scikit-learn

```python
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler

# Scale features first -- K-means is distance-based, just like KNN
X_scaled = StandardScaler().fit_transform(X)

kmeans = KMeans(n_clusters=3, init='k-means++', n_init=10, random_state=42)
labels = kmeans.fit_predict(X_scaled)

print(kmeans.cluster_centers_)  # final centroid positions
print(kmeans.inertia_)          # sum of squared distances to nearest centroid
```

`init='k-means++'` is a smarter initialization (spreads initial centroids apart) that directly addresses the "initialization matters" problem above. `n_init=10` runs the whole algorithm 10 times with different initializations and keeps the best result — a practical mitigation for poor convergence.

## Choosing K

Because `k` is chosen *before* running the algorithm, a common technique is the **Elbow Method**: run K-means for a range of `k` values, plot `inertia` (within-cluster sum of squared distances) against `k`, and pick the `k` at the "elbow" where adding more clusters stops meaningfully reducing inertia.

## Common Pitfalls & Practical Tips

- **Always scale features before clustering** — exactly as with [[K-Nearest Neighbors (KNN)]], unscaled attributes with large numeric ranges will dominate the Euclidean distance (see [[Data Preprocessing and Data Quality]]).
- **K-means assumes roughly spherical, similarly-sized clusters** — it struggles with elongated, non-convex, or very differently-sized clusters. If results look wrong, try different features/distance functions or a different algorithm (e.g. hierarchical or spectral clustering).
- **Run multiple initializations** (`n_init` in scikit-learn) — a single random initialization can converge to a poor local optimum.
- **K-means is for unsupervised data** — if labels exist, [[Classification (Supervised Learning)|classification]] algorithms are usually more appropriate and easier to evaluate.

## Related Concepts

- [[Classification (Supervised Learning)]] — the supervised counterpart; clustering is unsupervised.
- [[K-Nearest Neighbors (KNN)]] — another distance-based algorithm; shares the same scaling/distance-metric concerns.
- [[Self-Organizing Map (SOM)]] — an alternative unsupervised clustering approach using competitive neural learning.
- [[Data Preprocessing and Data Quality]] — normalization is a prerequisite for meaningful distance-based clustering.

**Source:** [GeeksforGeeks: K-Means Clustering – Introduction](https://www.geeksforgeeks.org/machine-learning/k-means-clustering-introduction/); [IBM: What is k-means clustering?](https://www.ibm.com/think/topics/k-means-clustering); COMP723 Lecture 6 (clustering properties, distance measures, convergence walkthrough).
