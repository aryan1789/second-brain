---
title: Data Preprocessing and Data Quality
type: concept
sources: [raw/lecture-notes/COMP723/Lecture2.pptx, https://scikit-learn.org/stable/modules/preprocessing.html, https://encord.com/blog/data-cleaning-data-preprocessing/]
related: [Knowledge Discovery (KDD) Process, Linear Regression and Numeric Prediction, Overfitting and Underfitting, Classification (Supervised Learning)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Data Preprocessing and Data Quality

> [!check] Verified
> Confirmed via [scikit-learn: Preprocessing data](https://scikit-learn.org/stable/modules/preprocessing.html) and [Encord: Mastering Data Cleaning & Data Preprocessing](https://encord.com/blog/data-cleaning-data-preprocessing/)

## The Core Idea

Raw data is almost never ready to feed directly into a data mining algorithm. **Data quality problems** — noise, missing values, duplicates, outliers, and errors — need to be detected and addressed, and the data often needs to be **transformed** (aggregated, discretized, normalized, balanced) and **reduced** (via feature selection) before mining algorithms can perform well. This is the "Data Collection" step of the [[Knowledge Discovery (KDD) Process]].

## Data Quality Problems

- **Noise** — modification of original values (e.g. distortion of a person's voice on a poor phone connection, or "snow" on a TV screen — a clean signal plus random variation).
- **Missing values** — arise because information wasn't collected (e.g. someone declines to give their age) or an attribute doesn't apply to all cases (e.g. "annual income" doesn't apply to children). Handling options:
  - **Eliminate** the data objects (rows) with missing values
  - **Estimate** the missing value (e.g. replace with the column mean)
  - **Ignore** the missing value during analysis (only for algorithms that support it)
  - **Replace with possible values**, weighted by their probabilities
- **Duplicate data** — the same (or near-identical) record appears more than once, a major issue when merging data from heterogeneous sources (e.g. the same person with multiple email addresses). **Data cleaning** is the process of resolving this.
- **Outliers** — extreme values near the limits of the data range, or values that don't follow the trend of the rest of the data. May represent acquisition errors and can negatively impact mining algorithms.
- **Data errors** — invalid/inconsistent values, e.g. a "Marital Status" column containing `C` (not a valid category), a negative salary, or an age of `0` for an adult.

## Data Preprocessing Techniques

- **Aggregation** — combining two or more attributes/objects into one. Purposes: **data reduction** (fewer attributes/objects to process), **change of scale** (e.g. cities → regions → countries), and **more stable data** (aggregated data tends to have less variability — e.g. yearly precipitation is more stable than monthly precipitation).
- **Discretization** — converting continuous attributes into discrete categories/bins.
- **Normalization** — rescaling variables so their ranges are comparable, since variables with larger ranges can dominate a mining technique's results. Common techniques:
  - **Min-Max normalization** — rescale each value to `[0, 1]`: `x' = (x - min) / (max - min)`
  - **Decimal scaling** — divide by a power of 10 chosen so the maximum absolute value falls below 1
  - **Z-score normalization** — `x' = (x - mean) / std_dev`, giving each attribute mean 0 and standard deviation 1
- **Data Balancing** — real-world data is often **imbalanced** (e.g. 99% genuine vs. 1% fraudulent credit card transactions). With imbalanced data, algorithms struggle to learn the minority class's patterns. Fixes: scale down the majority class (undersampling) or create new data for the minority class (oversampling, e.g. SMOTE).
- **Feature Selection** — removing redundant attributes to get a smaller, more understandable model, faster training, and often *better* accuracy. Two general approaches:
  - **Forward selection** — start with an empty attribute set `A`; at each step, try adding each remaining attribute to `A` and keep whichever addition gives the best performance (e.g. classification accuracy). Repeat until no addition improves performance. (An attribute discarded in one round can be reconsidered later, since the *context* of `A` has changed.)
  - **Backward elimination** — start with `A` containing *all* attributes; at each step, remove whichever attribute's removal causes the least loss in performance (e.g. smallest drop in information gain/accuracy). Repeat until every remaining removal would cause an unacceptable loss.

## Intuition: Prepping Ingredients Before Cooking

A mining algorithm is like a recipe that assumes its ingredients are already washed, peeled, and chopped to a consistent size. If you hand it raw, unwashed, oddly-shaped ingredients (noisy, missing, inconsistently-scaled, redundant data), the result is unpredictable — "garbage in, garbage out." Preprocessing is the prep work: washing (cleaning duplicates/errors), peeling (removing outliers/irrelevant attributes), and chopping to consistent sizes (normalization) — so the recipe (algorithm) can focus on what it's actually good at.

## In Practice: pandas + scikit-learn

```python
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from sklearn.feature_selection import SequentialFeatureSelector
from sklearn.tree import DecisionTreeClassifier

# Handling missing values: replace with column mean
df['hp'] = df['hp'].fillna(df['hp'].mean())

# Removing duplicates
df = df.drop_duplicates()

# Min-Max normalization
scaler = MinMaxScaler()
df[['mpg', 'cylinders', 'cubic_inches', 'hp']] = scaler.fit_transform(
    df[['mpg', 'cylinders', 'cubic_inches', 'hp']]
)

# Forward selection (sklearn's "sequential feature selection")
sfs = SequentialFeatureSelector(DecisionTreeClassifier(), direction='forward', n_features_to_select=3)
sfs.fit(X, y)
print(X.columns[sfs.get_support()])
```

## Common Pitfalls & Practical Tips

- **Fit scalers/imputers on the training set only.** Calling `MinMaxScaler().fit(X)` on the *whole* dataset before splitting leaks test-set statistics (min/max/mean) into training — fit on `X_train`, then `.transform()` both `X_train` and `X_test`.
- **Mean-imputation can distort distributions.** Replacing every missing value with the column mean reduces variance and can weaken real relationships — for skewed data, median imputation or model-based imputation may be better.
- **Aggregation trades resolution for stability** — useful for reducing noise/dimensionality, but you permanently lose the finer-grained information (e.g. you can no longer ask "what was precipitation in March specifically" after aggregating to yearly totals).
- **Feature selection vs. overfitting** — too many irrelevant/redundant attributes increase the risk of a model fitting noise rather than signal; see [[Overfitting and Underfitting]].

## Related Concepts

- [[Knowledge Discovery (KDD) Process]] — preprocessing is the substance of the "Data Collection" step.
- [[Linear Regression and Numeric Prediction]] — normalization affects how regression coefficients should be interpreted.
- [[Overfitting and Underfitting]] — redundant features and noisy/imbalanced data both increase overfitting risk.
- [[Classification (Supervised Learning)]] — the downstream task that preprocessing prepares data for.

**Source:** [scikit-learn: Preprocessing data](https://scikit-learn.org/stable/modules/preprocessing.html); [Encord: Mastering Data Cleaning & Data Preprocessing](https://encord.com/blog/data-cleaning-data-preprocessing/)
