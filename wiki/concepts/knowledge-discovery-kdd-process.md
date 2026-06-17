---
title: Knowledge Discovery (KDD) Process
type: concept
sources: [raw/lecture-notes/COMP723/Lecture2.pptx, https://www.geeksforgeeks.org/dbms/kdd-process-in-data-mining/, https://www.datascience-pm.com/kdd-and-data-mining/]
related: [Data Preprocessing and Data Quality, Classification (Supervised Learning), Cross-Validation]
created: 12-06-2026
last-updated: 12-06-2026
---

# Knowledge Discovery (KDD) Process

> [!check] Verified
> Confirmed via [GeeksforGeeks: KDD Process in Data Mining](https://www.geeksforgeeks.org/dbms/kdd-process-in-data-mining/) and [Data Science PM: KDD and Data Mining](https://www.datascience-pm.com/kdd-and-data-mining/)

## The Core Idea

**Data mining is just one step inside a larger, iterative process called Knowledge Discovery in Databases (KDD).** The lecture frames KDD as the umbrella process, with data mining being specifically the "model building" stage. The full KDD process has six steps:

1. **Define** — identify the goals of the project (what question are you trying to answer?)
2. **Data Collection** — gather data; includes cleaning and pre-processing
3. **Data Mining** — the model-building step itself (applying algorithms to find patterns)
4. **Validating** the model — usually some form of statistical analysis
5. **Deploying** the model — putting it into actual use
6. **Monitoring** the model — periodic re-evaluation on new data to check it's still appropriate, possibly **retraining** it

## Intuition: KDD Is a Loop, Not a Pipeline

It's tempting to picture these six steps as a one-way pipeline: define → collect → mine → validate → deploy → done. But the lecture's framing as an **iterative process** is the important part — step 6 (monitoring) feeds back into earlier steps. The world changes after a model is deployed: customer behaviour shifts, new fraud patterns emerge, sensor characteristics drift. A model validated and deployed last year may be quietly getting worse *right now*, and the only way to know is to keep monitoring it against new data — which often means going back to step 2 (collect new data) and step 3 (retrain).

## Mapping KDD to a Modern ML Project

| KDD Step | Modern equivalent |
|---|---|
| Define | Write down the business/research question and success metric |
| Data Collection | Gather raw data; clean with `pandas` (handle missing values, duplicates — see [[Data Preprocessing and Data Quality]]) |
| Data Mining | Train a model (e.g. with scikit-learn) |
| Validating | [[Cross-Validation]], hold-out test set, [[Confusion Matrix Metrics]] |
| Deploying | Wrap the model behind an API / integrate into an application |
| Monitoring | Track live prediction quality, watch for **data drift** (the live data's distribution diverging from training data) |

## Common Pitfalls & Practical Tips

- **"Data mining" is often used loosely to mean the whole KDD process** — but precisely, it's only the model-building step. The other steps (especially preprocessing and monitoring) often take far more time and have a bigger impact on real-world success than the modelling step itself.
- **Monitoring is the step most often skipped** in practice — teams build and deploy a model, then never check whether it's still accurate months later. This is how "silent" model degradation happens.
- **Going back to "Define"**: if validation reveals the model can't reach a useful accuracy, it's often a sign the *original question* needs reframing (different target variable, different data sources) — not just a sign to try a different algorithm.

## Related Concepts

- [[Data Preprocessing and Data Quality]] — the substance of the "Data Collection" step.
- [[Classification (Supervised Learning)]] — a common type of "Data Mining" step.
- [[Cross-Validation]] — one of the standard "Validating" techniques.

**Source:** [GeeksforGeeks: KDD Process in Data Mining](https://www.geeksforgeeks.org/dbms/kdd-process-in-data-mining/); [Data Science PM: KDD and Data Mining](https://www.datascience-pm.com/kdd-and-data-mining/)
