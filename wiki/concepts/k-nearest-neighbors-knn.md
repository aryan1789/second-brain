---
title: K-Nearest Neighbors (KNN)
type: concept
sources: [raw/lecture-notes/COMP723/Lecture4.pptx, https://www.geeksforgeeks.org/machine-learning/k-nearest-neighbours/, https://www.pinecone.io/learn/k-nearest-neighbor/]
related: [Classification (Supervised Learning), Data Preprocessing and Data Quality, Bias-Variance Tradeoff, Cross-Validation]
created: 12-06-2026
last-updated: 12-06-2026
---

# K-Nearest Neighbors (KNN)

> [!check] Verified
> Confirmed via [GeeksforGeeks: K-Nearest Neighbour Algorithm](https://www.geeksforgeeks.org/machine-learning/k-nearest-neighbours/) and [Pinecone: K-Nearest Neighbor Explained](https://www.pinecone.io/learn/k-nearest-neighbor/)

## The Core Idea

K-Nearest Neighbors is an **instance-based classifier**: instead of building an explicit model during training, it simply **stores all the training records**. To classify a new (unknown) record, it:

1. **Computes the distance** from the new record to every stored training record.
2. **Identifies the `k` nearest** training records (smallest distances).
3. **Assigns the majority class** among those `k` neighbours (a vote) — optionally **weighted by distance** (`w = 1/d` or `w = 1-d`, so closer neighbours count more).

The lecture's framing of the basic idea: *"If it walks like a duck, quacks like a duck, then it's probably a duck"* — classify a new thing by what it most resembles among things you've already seen.

## Worked Example: Credit Scoring with k=3

To classify **Sam** (Debt=High, Income=High, Married=Yes), find the 3 nearest neighbours — say **Joe, Sue, and Mary** — whose risk values are `Good, Good, Poor`. The majority vote is `Good`, so Sam is classified as **Good Risk**. For **nominal (categorical) data**, Euclidean distance doesn't apply directly — the lecture uses a simple **0/1 match-based distance**: two instances are "close" (distance 0) if an attribute value matches exactly, and "far" (distance 1) otherwise.

## "Lazy Learning": No Training, Expensive Classification

KNN is called a **lazy learner** — it does **not build a model explicitly** during training (training is essentially just storing the data). This is the opposite of **eager learners** like [[Decision Trees and Information Gain|decision trees]] or rule-based systems, which do significant work upfront to produce a compact model. The trade-off: KNN's "training" is instant, but **classifying each new record is relatively expensive** — it requires computing the distance to *every* stored training record.

## Choosing k

- **k too small** → the prediction is **sensitive to noise points** (a single mislabeled or unusual neighbour can flip the vote).
- **k too large** → the neighbourhood may include points from **other classes**, diluting the signal from the truly local pattern.

This is a direct instance of the [[Bias-Variance Tradeoff]]: small `k` → low bias, high variance (very flexible, follows the data closely, including noise); large `k` → high bias, low variance (smoother, more stable, but may miss local structure). The right `k` is typically chosen via [[Cross-Validation]].

## Scaling Issues

Because KNN relies directly on **distance**, attributes measured on very different scales can dominate the distance calculation. The lecture's example: a person's **height** might range 1.5m–1.8m, **weight** 40kg–150kg, and **income** $10K–$1M — without rescaling, income differences alone would swamp the distance metric, making height and weight essentially irrelevant. The fix is **normalization** (see [[Data Preprocessing and Data Quality]]) — rescale all attributes to comparable ranges before computing distances.

For **nominal data with inherent ordering** (e.g. age groupings), the lecture also notes that a simple match/no-match distance can be misleading: the distance between age groups `(21,30)` and `(51,60)` should arguably be *greater* than between `(21,30)` and `(41,50)` — i.e. `d((21,30),(51,60)) > d((21,30),(41,50))` — but a naive match-based distance treats all non-matches as equally "far."

## In Practice: scikit-learn

```python
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline

# ALWAYS scale features before KNN -- distances are meaningless otherwise
model = make_pipeline(
    StandardScaler(),
    KNeighborsClassifier(n_neighbors=3, weights='distance')  # weights='distance' = w = 1/d
)
model.fit(X_train, y_train)
predictions = model.predict(X_test)
```

## Common Pitfalls & Practical Tips

- **Always scale your features.** This is the single most common KNN mistake — forgetting to normalize means whichever attribute happens to have the largest numeric range dominates every distance calculation.
- **Choose `k` via [[Cross-Validation]]**, not by guessing — plot accuracy vs. `k` and pick the value that generalises best, not just the one that fits training data best.
- **Prediction cost scales with training set size.** For large datasets, computing distances to every training point at prediction time becomes a bottleneck; approximate nearest-neighbour structures (k-d trees, ball trees — used internally by scikit-learn's `algorithm='auto'`) help, but very large/high-dimensional datasets remain challenging (the "curse of dimensionality": in high dimensions, distances between points tend to become similar, making "nearest" less meaningful).
- **Define your distance metric deliberately for nominal/ordinal data** — a plain match/no-match distance can throw away useful ordering information (as in the age-grouping example above).

## Related Concepts

- [[Classification (Supervised Learning)]] — the general task; KNN is one classifier among several (compare [[Naive Bayes Classifier]], [[Decision Trees and Information Gain]]).
- [[Data Preprocessing and Data Quality]] — normalization is a prerequisite for meaningful KNN distances.
- [[Bias-Variance Tradeoff]] — the choice of `k` directly trades bias for variance.
- [[Cross-Validation]] — the standard method for choosing `k`.

**Source:** [GeeksforGeeks: K-Nearest Neighbour Algorithm](https://www.geeksforgeeks.org/machine-learning/k-nearest-neighbours/); [Pinecone: K-Nearest Neighbor Explained](https://www.pinecone.io/learn/k-nearest-neighbor/)
