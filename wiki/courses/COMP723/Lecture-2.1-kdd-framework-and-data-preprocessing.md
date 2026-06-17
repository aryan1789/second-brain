---
title: COMP723 Lecture 2.1 - KDD Framework and Data Preprocessing
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture2.pptx]
related: [COMP723, Knowledge Discovery (KDD) Process, Data Preprocessing and Data Quality]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP723 Lecture 2.1 - KDD Framework and Data Preprocessing

> [!tip] Going Deeper
> [[Knowledge Discovery (KDD) Process]] and [[Data Preprocessing and Data Quality]] have full concept pages with intuition, pandas/scikit-learn code, and pitfalls. This note summarises the lecture's framing.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **List the six steps of the Knowledge Discovery process, in order.**
- **Name three examples of data quality problems.**
- **What are the four ways of handling missing values?**
- **Why might "Standard Deviation of Average Yearly Precipitation" be lower than "Standard Deviation of Average Monthly Precipitation"? Which preprocessing technique does this illustrate?**
- **What problem does data normalization solve, and name two normalization techniques besides min-max.**
- **What is data balancing, and why does it matter for fraud detection?**
- **What's the difference between forward selection and backward elimination for feature selection?**

---

## Notes

### A Framework for Knowledge Discovery

The lecture positions **Data Mining as part of a larger, iterative Knowledge Discovery (KD) process** with six steps: **Defining** the problem (identify project goals) → **Data Collection** (including cleaning/preprocessing) → **Data Mining** (the model-building step) → **Validating** the model (typically statistical analysis) → **Deploying** the model → **Monitoring** the model (periodic re-evaluation on new data — possibly triggering retraining). See [[Knowledge Discovery (KDD) Process]] for the full breakdown and how this maps onto a modern ML workflow.

### Data Quality

The lecture poses three framing questions: what *types* of data quality problems exist, how do we *detect* them, and what can we *do* about them? Examples given: **noise and outliers, missing values, duplicate data**.

**Noise** is described as *modification of original values* — analogous to distortion of a person's voice on a poor phone line, or "snow" on a TV screen (a clean signal plus random variation), illustrated with a "two sine waves" vs. "two sine waves + noise" comparison.

### Data Preprocessing: The Full Toolkit

The lecture lists eight preprocessing techniques: **aggregation, missing values, data errors, outliers, discretization, data normalization, data balancing, feature selection**. See [[Data Preprocessing and Data Quality]] for the full concept page covering each. Highlights from the lecture's specific examples:

- **Aggregation** — illustrated with precipitation data: the standard deviation of *average yearly* precipitation in Australia is lower than the standard deviation of *average monthly* precipitation, demonstrating that "aggregated data tends to have less variability."
- **Missing values** — worked example on a car dataset (`mpg, cylinders, cubic inches, hp`): several rows have missing `mpg`/`cylinders`/`hp` values, which are then **replaced with the column mean** (e.g. missing `cubic inches` values become `275.86`, the mean of the present values).
- **Data Errors** — a customer dataset with deliberately broken values is shown: a `Zip Code` of `10,000,000`, an `Age` of `C` (not numeric), an `Age` of `0`, and a negative `Salary` of `-40,000` — all examples of values that are *technically present* but invalid.
- **Data Normalization** — using the same car dataset, **min-max normalization** rescales each column to `[0,1]` (e.g. `mpg` of 14 → `0`, the dataset minimum; `mpg` of 51.7 → `1`, the dataset maximum). The lecture also names **decimal scaling** and **Z-score normalization** as alternatives.
- **Data Balancing** — the canonical example: in a credit card transaction stream, ~99% of transactions are genuine and ~1% are fraud. Any algorithm trained directly on this will struggle to learn the "fraud" pattern; performance improves by **scaling down the majority class** or **creating new data for the minority class**.
- **Feature Selection** — motivated by three benefits: a smaller/more understandable model, faster model-building, and *improved* classification accuracy (redundant attributes can actively hurt accuracy, not just efficiency). The lecture illustrates the search space for the classic weather dataset's 4 attributes (`outlook, temp, humidity, windy`) as all 16 possible subsets, then contrasts:
  - **Forward selection** — start from the empty set, greedily add the attribute giving the best performance each round, until no addition helps. (Note: a previously-discarded attribute can be re-added later, since `A`'s composition has changed.)
  - **Backward elimination** — start from the full set, greedily remove the attribute whose removal causes the **least loss in information gain / accuracy**, until every remaining removal would cause an unacceptable loss.

---

## Summary

This lecture establishes the **Knowledge Discovery (KDD) process** as the umbrella within which "data mining" is just the model-building step — bookended by problem definition, data collection/preprocessing, validation, deployment, and ongoing monitoring. It then works through the **data preprocessing toolkit** in detail using a consistent car-dataset example: handling **missing values** (mean replacement), fixing **data errors** (invalid zip codes, non-numeric ages, negative salaries), **normalizing** scales (min-max, decimal scaling, Z-score), **balancing** imbalanced classes (e.g. fraud detection), and **selecting features** via forward selection or backward elimination. The recurring theme is that mining algorithms are only as good as the data fed into them — most of the "work" in a data mining project happens before any model is trained.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Six-step KDD process | [[Knowledge Discovery (KDD) Process]] | ✓ Verified |
| Missing value handling, normalization, balancing, feature selection | [[Data Preprocessing and Data Quality]] | ✓ Verified |
| Aggregation reduces variability (precipitation example) | Lecture-specific example; consistent with general aggregation theory in [[Data Preprocessing and Data Quality]] | ➕ Supplemented |
