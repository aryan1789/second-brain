---
title: COMP723 Lecture 6.1 - Clustering and K-Means
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture6.pptx]
related: [COMP723, K-Means Clustering, Classification (Supervised Learning), Self-Organizing Map (SOM)]
created: 13-06-2026
last-updated: 13-06-2026
---

# COMP723 Lecture 6.1 - Clustering and K-Means

> [!tip] Going Deeper
> [[K-Means Clustering]] is a new concept page covering this lecture's distance-measure properties, the K-means algorithm, the K=2 convergence walkthrough, initialization pitfalls, and a scikit-learn example in full. This note summarises the lecture's framing of slides 1-20.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **How does clustering (unsupervised learning) differ from classification? Give 3 example applications of clustering.**
- **What is the "basic idea" of clustering, in one sentence?**
- **List the 3 properties a valid distance measure must satisfy. Why does each matter?**
- **Name the two main families of clustering algorithms, and give 2 examples of each.**
- **Walk through the K-means algorithm's Initialize/Alternate/Stop steps from memory.**
- **For K=2, describe what happens in "Iterative Step 1" and "Iterative Step 2" of convergence.**
- **What can go wrong with K-means, and what 2 kinds of heuristics help prevent it?**

---

## Notes

### Clustering: Unsupervised Learning

Clustering is **unsupervised learning** — it "requires data, but no labels." The goal is to **detect patterns** in data without a predefined target. Example applications from the lecture:

- Grouping **emails or search results**
- Discovering **customer shopping patterns**
- Finding **regions of images** — "useful when [you] don't know what you're looking for"

### The Basic Idea

> "Group together similar instances" — e.g. 2D points.

The lecture illustrates this with scatter plots of 2D points, where visually-obvious groups of nearby points form the clusters a good algorithm should recover.

### What Could "Similar" Mean? Distance Measures

The simplest option for similarity is **small (squared) Euclidean distance**. Crucially, **clustering results are crucially dependent on the measure of similarity (distance)** chosen — a different distance function can produce entirely different clusters from the same data. See [[K-Means Clustering]] for the three formal properties (symmetric, positivity/self-similarity, triangle inequality) that any valid distance measure must satisfy, and why each property matters intuitively.

### Clustering Algorithms: The Landscape

The lecture lists the major families:

- **Partition algorithms (Flat)**: K-means, Mixture of Gaussians (statistical), Spectral Clustering, [[Self-Organizing Map (SOM)|Self-Organizing Maps (SOM)]]
- **Hierarchical algorithms**: Bottom-up (**agglomerative**) and top-down (**divisive**)

### K-Means: The Algorithm

K-means is described as **"an iterative clustering algorithm"**:

- **Initialize:** Pick `K` random points as cluster centres.
- **Alternate:**
  - Assign data points to the closest cluster centre.
  - Change the cluster centre to the **average of its assigned points**.
- **Stop** when no point's assignment changes.

### Convergence Walkthrough (K=2)

The lecture works through convergence visually for `K = 2`:

1. **Pick K random points** as cluster centres (means) — shown for K=2.
2. **Iterative Step 1**: Assign data points to the closest cluster centre.
3. **Iterative Step 2**: Change the cluster centre to the average of the assigned points.
4. **Repeat until convergence** — the centres stop moving once assignments stabilise.

### Some K-Means Insights

- **Initialization matters** — "it does matter what you pick as centres and how many!" Poor choices of initial centres (or of `K` itself) are a key source of poor results.
- **What can go wrong?** K-means is not guaranteed to find the "right" clusters — it can converge to a poor solution, or fail to separate clusters that aren't well-suited to the chosen distance measure.
- **Various schemes exist for preventing non/poor convergence**, including **split/merge heuristics** and smarter **initialization heuristics**.
- The lecture shows an example where **K-means is not able to properly cluster** some data with its default distance function, but **changing the features (distance function) can help** — i.e. the choice of features is itself part of the modelling decision, not just the algorithm.

---

## Summary

This lecture introduces **clustering** as the unsupervised counterpart to classification: group similar instances together without labels, useful for discovering structure (emails, shopping patterns, image regions) when you don't know what you're looking for in advance. **K-means** is the canonical example: an iterative algorithm that initializes `K` random centres, then alternates between assigning points to their closest centre and recomputing centres as the mean of their assigned points, until assignments stop changing. The quality of the result depends heavily on the **distance measure** (which must be symmetric, positive/self-similar, and satisfy the triangle inequality) and on **initialization** — poor initial centres or an unsuitable distance function can cause poor convergence, which split/merge and initialization heuristics, or a change of features, can help fix. See [[K-Means Clustering]] for the full algorithm, scikit-learn usage, and the Elbow Method for choosing `K`.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Clustering as unsupervised learning, K-means algorithm, convergence, distance measure properties, initialization pitfalls | [[K-Means Clustering]] | ✓ Verified |
| Self-Organizing Maps as a clustering algorithm | [[Self-Organizing Map (SOM)]] | ✓ Verified |
