---
title: COMP723 Lecture 4.1 - K-Nearest Neighbours
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture4.pptx]
related: [COMP723, K-Nearest Neighbors (KNN), Classification (Supervised Learning), Data Preprocessing and Data Quality]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP723 Lecture 4.1 - K-Nearest Neighbours

> [!tip] Going Deeper
> [[K-Nearest Neighbors (KNN)]] has a full concept page with intuition, the credit-scoring worked example, scaling issues, and scikit-learn code. This note summarises the lecture's framing.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **What three things does the Nearest Neighbour algorithm require?**
- **Contrast "rote-learner" and "nearest neighbour" as instance-based classifiers.**
- **What happens if k is too small? Too large?**
- **Why is KNN called a "lazy learner," and what's the trade-off vs. "eager learners" like decision trees?**
- **Why do height, weight, and income need scaling before computing distance?**
- **How is distance computed for nominal (non-numeric) attributes?**

---

## Notes

### Instance-Based Classifiers

The lecture introduces **instance-based classifiers** as a family that **stores the training records** and uses them directly to predict the class of unseen cases — no abstract model is built. Two examples:

- **Rote-learner** — memorises the entire training set and only classifies a new instance if its attributes **match a training example exactly**. (Extremely brittle — almost never useful in practice, but useful as a conceptual baseline.)
- **Nearest neighbour** — uses the `k` "closest" points (by some distance metric) to classify.

### The Nearest Neighbour Algorithm

Three things are required: **(1)** the set of stored records, **(2)** a **distance metric** to compute distance between records, and **(3)** the value of **`k`**. To classify an unknown record: compute its distance to all training records, identify the `k` nearest, and use their class labels (e.g. majority vote) to determine the unknown record's class.

For **numeric data**, **Euclidean distance** is the standard metric. For **nominal data** (the credit-scoring example), a **0/1 match-based distance** is used instead: attributes either match (distance 0) or don't (distance 1).

### Choosing k and Scaling

- **k too small** → sensitive to noise points (a single odd neighbour can swing the vote).
- **k too large** → the neighbourhood may include points belonging to other classes.

**Scaling** is critical: the lecture's example notes that height (1.5m–1.8m), weight (40kg–150kg), and income ($10K–$1M) are on wildly different scales — without normalization, the attribute with the largest numeric range will dominate the distance calculation regardless of its actual relevance.

### Lazy vs. Eager Learning

KNN is a **lazy learner**: it does **not build a model explicitly** during training. This is contrasted with **eager learners** such as decision tree induction and rule-based systems, which do the work of building a compact model upfront. The trade-off: KNN training is trivial, but **classifying unknown records is relatively expensive** (distance to every stored record must be computed each time).

### Issues with k-NN

Beyond the choice of `k` and distance metric, the lecture flags that **the distance metric must be defined carefully by the data miner** — e.g. for nominal data with inherent ordering (such as age groupings), a simple match/no-match distance can be misleading: `d((21,30),(51,60))` should arguably be greater than `d((21,30),(41,50))`, but a 0/1 distance treats both as equally "not matching."

---

## Summary

K-Nearest Neighbours is the lecture's example of an **instance-based, lazy learner**: it stores all training data and defers all "work" to prediction time, computing distances to find the `k` most similar training records and voting among their classes. Its accuracy depends heavily on **three choices**: the value of `k` (too small → noise-sensitive, too large → dilutes the local signal), the **distance metric** (Euclidean for numeric, match-based for nominal — though ordering in nominal data can be lost), and **feature scaling** (attributes with larger numeric ranges otherwise dominate). See [[K-Nearest Neighbors (KNN)]] for the full concept page, including the connection between `k` and the [[Bias-Variance Tradeoff]] covered later in this lecture.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Instance-based/lazy learning, k-NN algorithm, choosing k, scaling | [[K-Nearest Neighbors (KNN)]] | ✓ Verified |
| Distance metrics for nominal vs. numeric data | [[K-Nearest Neighbors (KNN)]] | ✓ Verified |
