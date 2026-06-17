---
title: Cross-Validation
type: concept
sources: [raw/lecture-notes/COMP723/Lecture4.pptx, https://www.machinelearningmastery.com/k-fold-cross-validation/, https://www.geeksforgeeks.org/machine-learning/k-fold-cross-validation-in-machine-learning/]
related: [Knowledge Discovery (KDD) Process, Classification (Supervised Learning), Confusion Matrix Metrics, K-Nearest Neighbors (KNN), Overfitting and Underfitting]
created: 12-06-2026
last-updated: 12-06-2026
---

# Cross-Validation

> [!check] Verified
> Confirmed via [Machine Learning Mastery: A Gentle Introduction to k-fold Cross-Validation](https://www.machinelearningmastery.com/k-fold-cross-validation/) and [GeeksforGeeks: K-Fold Cross Validation](https://www.geeksforgeeks.org/machine-learning/k-fold-cross-validation-in-machine-learning/)

## The Core Idea

Instead of a single fixed train/test split, **k-fold cross-validation** divides the whole dataset into `k` equally-sized **folds**. Each fold takes a turn being the **test set**, while the remaining `k-1` folds form the **training set** for that round. This produces `k` separate train/test experiments — **a given data point will be in the training set for some rounds and the test set for exactly one round**. The final performance estimate is the **average** across all `k` rounds.

**Stratified k-fold cross-validation** additionally ensures each fold **maintains the same proportion of classes** as the overall dataset — important whenever classes are imbalanced (see [[Data Preprocessing and Data Quality]]), so that no fold accidentally ends up with too few (or zero) examples of a minority class.

## Intuition: Rotating Exam Groups

Imagine a class of 50 students split into 5 groups of 10. Each week, one group sits a test while the other four groups continue studying together (effectively, "training" on each other's notes). After 5 weeks, **everyone has been tested exactly once**, and **everyone has spent most of their time in the "training" role**. Averaging the 5 groups' test results gives a far more reliable picture of "how well does this class understand the material" than picking just *one* group to test once and assuming their score represents everyone.

This is exactly what k-fold cross-validation does for a model: rather than relying on the luck (or bad luck) of *one* particular train/test split — which might happen to put all the "easy" examples in the test set, or all the tricky edge cases — it averages performance across `k` different splits, giving a more robust estimate of how the model will perform on genuinely new data.

## Why This Matters

A single train/test split gives a **single number** for accuracy (or other metrics) — but that number has variance: a different random split could give a noticeably different number, especially with smaller datasets. Cross-validation:

- Uses **every data point for both training and testing** (across different folds), making efficient use of limited data.
- Produces **k accuracy values**, whose mean and spread (standard deviation) give a much better sense of how *reliable* the performance estimate is — not just a single point estimate.

## In Practice: scikit-learn

```python
from sklearn.model_selection import cross_val_score, StratifiedKFold
from sklearn.tree import DecisionTreeClassifier

model = DecisionTreeClassifier()

# 5-fold stratified cross-validation (stratification is automatic for classifiers)
scores = cross_val_score(model, X, y, cv=5)
print(f"Accuracy: {scores.mean():.3f} +/- {scores.std():.3f}")

# Explicit stratified k-fold, e.g. for manual control
skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
for train_idx, test_idx in skf.split(X, y):
    X_train, X_test = X.iloc[train_idx], X.iloc[test_idx]
    y_train, y_test = y.iloc[train_idx], y.iloc[test_idx]
    # train and evaluate model here
```

`cross_val_score` is also the standard tool for **comparing hyperparameters** (e.g. different values of `k` for [[K-Nearest Neighbors (KNN)|KNN]], or `max_depth` for a decision tree) — fairly, since each candidate setting is evaluated across the same `k` folds.

## Common Pitfalls & Practical Tips

- **`k` is a trade-off**: common choices are `k=5` or `k=10`. Larger `k` → each training set is closer in size to the full dataset (less bias in the estimate) but `k` times more computation, and test folds get smaller (more variance per fold).
- **Always preprocess *inside* each fold**, not before splitting. Fitting a scaler, imputer, or feature selector on the *whole* dataset before cross-validation leaks information from each fold's test portion into its training portion — use a scikit-learn `Pipeline` so preprocessing is refit on each fold's training data only.
- **Standard k-fold assumes data points are independent and identically distributed** — for time-series data, randomly shuffling folds can let the model "see the future" during training. Use a time-aware split (e.g. scikit-learn's `TimeSeriesSplit`) instead.
- **Cross-validation estimates *generalisation* performance** — it doesn't replace a final, untouched **hold-out test set** if you're also using cross-validation results to choose between models/hyperparameters (otherwise you risk overfitting to the cross-validation folds themselves).

## Related Concepts

- [[Knowledge Discovery (KDD) Process]] — cross-validation is the standard technique for the "Validating" step.
- [[Confusion Matrix Metrics]] — the per-fold metric being averaged is often accuracy, precision, recall, or F1.
- [[K-Nearest Neighbors (KNN)]] — cross-validation is how `k` is chosen in practice.
- [[Overfitting and Underfitting]] — cross-validation gives a more trustworthy signal of overfitting than a single train/test split.

**Source:** [Machine Learning Mastery: A Gentle Introduction to k-fold Cross-Validation](https://www.machinelearningmastery.com/k-fold-cross-validation/); [GeeksforGeeks: K-Fold Cross Validation](https://www.geeksforgeeks.org/machine-learning/k-fold-cross-validation-in-machine-learning/)
