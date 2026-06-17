---
title: COMP723 Lecture 1 - Introduction to Data Mining and Classification
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture1.pptx]
related: [COMP723, Classification (Supervised Learning), Linear Regression and Numeric Prediction, Bias in Machine Learning (Algorithm Bias vs. Data Bias), Decision Trees and Information Gain]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP723 Lecture 1 - Introduction to Data Mining and Classification

> [!tip] Going Deeper
> [[Classification (Supervised Learning)]], [[Linear Regression and Numeric Prediction]], and [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)]] have full concept pages with intuition, worked examples, Python code, and pitfalls. This note summarises how the lecture introduces these ideas. Course administration (staff contacts, timetable, assessment weightings) is intentionally omitted.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **What is the difference between "data" and "knowledge"?**
- **What are the two problems with patterns extracted by data mining algorithms?**
- **What is the difference between "what is data mining" and "what is not data mining" — give one example of each.**
- **What three fields does data mining draw on, and why are traditional techniques sometimes unsuitable?**
- **Define classification in terms of training set, attributes, class, and test set.**
- **Name two ways a classifier's learned model can be expressed as a "structural description."**
- **What is numeric prediction, and how does it differ from classification?**
- **What are the two contexts in which "bias" arises in machine learning?**

---

## Notes

### Data vs. Knowledge, and Why Data Mining Exists

The lecture opens by framing the current era as one of **"Big Data"** — the bottleneck is no longer collecting data but **keeping pace with it**: raw data is described as "useless" without techniques to automatically extract knowledge from it. The lecture draws a sharp distinction:

- **Data** — simply a set of recorded facts.
- **Knowledge** — insights into how systems *behave*.

This motivates **Data Mining**: *"extraction of implicit, previously unknown, and potentially useful information from data"*, via algorithms that automatically detect and extract patterns. Two problems are flagged with this:

1. Most patterns are either **trivial** or **already known**.
2. Patterns may be **imprecise or spurious** if the underlying data is corrupted or missing.

### What Is (and Isn't) Data Mining?

The lecture contrasts examples:

- **Is data mining**: noticing that certain surnames are more prevalent in certain NZ locations (Auckland, Wellington, Dunedin); grouping similar documents returned by a search engine by context (e.g. distinguishing "Amazon" the rainforest from "Amazon.com").
- **Is not data mining**: looking someone up in a phone directory; querying a search engine for "Amazon" and reading the results.

The distinguishing factor is whether a **new pattern or relationship is being discovered**, versus simply **retrieving** already-known, explicitly stored information.

### Origins of Data Mining

Data mining draws ideas from three fields: **machine learning / pattern recognition / AI**, **statistics / mathematics**, and **database systems**. Traditional techniques from these fields can be unsuitable on their own due to:

- The **enormity** of data
- The **high dimensionality** of data
- The **heterogeneous, distributed nature** of data

[[Machine Learning vs Deep Learning|Machine learning techniques]] provide the technical basis: algorithms for automatically acquiring patterns from data, which can then be used both to **predict** outcomes for new situations and — arguably just as importantly — to **understand and explain** how a prediction is made.

### Classification: Definition and Examples

See [[Classification (Supervised Learning)]] for the full concept page. The lecture's definition: given a **training set** of records, each with **attributes** including one designated **class** attribute, find a **model** mapping attributes → class such that **previously unseen** records are classified as accurately as possible. A **test set** (disjoint from the training set) is used to measure that accuracy.

Four worked application examples are given, all following the same shape (historical labelled data → model → predict on new data):

- **Direct marketing** — predict `{buy, don't buy}` for a new product based on demographic/lifestyle attributes, using data from a similar past product launch.
- **Fraud detection** — label past credit card transactions as `{fraud, honest}`, learn a model, then flag new transactions.
- **Customer churn** — label past customers as `{loyal, disloyal}` based on transaction history, then predict which current customers are at risk.
- **Sky survey cataloguing** — classify telescope images as `{star, galaxy}` from ~40 image features per object; a real success story found 16 new high-redshift quasars this way.

### Structural Descriptions: Rules and Decision Trees

A classifier's learned model can be expressed in human-readable form as a **structural description**:

- **If-then rules**, e.g. for the "contact lenses" dataset: *"If tear production rate = reduced then recommendation = none"*, or *"Otherwise, if age = young and astigmatic = no then recommendation = soft."* A second example (the classic "weather/play" dataset) shows a small rule set: *"If outlook = sunny and humidity = high then play = no"*, *"If outlook = overcast then play = yes"*, etc.
- **Decision trees** — the lecture introduces these as "another type of structural description," illustrated with a labour-negotiations dataset, without yet covering *how* a tree is built from data. That algorithmic detail (information gain, entropy, pruning) is covered in [[COMP723 Lecture 3 - Naive Bayes and Decision Trees|Lecture 3]], and has its own concept page at [[Decision Trees and Information Gain]].

Both representations are **interpretable**: a person can trace exactly why a given input produced a given output, which is a major advantage over "black box" models.

### Numeric Prediction: Linear Regression

See [[Linear Regression and Numeric Prediction]] for the full concept page. The lecture introduces **numeric prediction** as a sibling task to classification — same supervised setup, but the target is a continuous number rather than a category. The example: predicting `mpg` (fuel efficiency) for 398 cars from `cylinders, engine size, power output, weight, acceleration` using a fitted linear regression equation, where every coefficient is negative (heavier, more powerful, faster-accelerating cars are less fuel-efficient).

### Recognising Bias in Machine Learning

See [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)]] for the full concept page. The lecture closes the conceptual material by introducing **two distinct contexts** for "bias":

- **Algorithm bias** — every learning algorithm relies on heuristics (a "must," since exhaustively searching the full data space is infeasible) that bias it toward certain kinds of patterns.
- **Data bias** — results from **imperfect training datasets**: future patterns absent from training data, or training-data patterns that don't manifest in future data.

---

## Summary

This opening lecture frames data mining as the automated extraction of *previously unknown, useful* patterns from data — distinct from simple information retrieval — drawing on machine learning, statistics, and database systems because traditional techniques struggle with the scale, dimensionality, and heterogeneity of modern data. It introduces **classification** (training set → model → test set, illustrated via credit scoring, marketing, fraud, churn, and astronomy examples) and its two main "structural description" outputs — **rules** and **decision trees** — both prized for interpretability. It also introduces **numeric prediction** via a linear regression example (predicting car fuel efficiency), and closes by distinguishing **algorithm bias** (inherent in any learning heuristic) from **data bias** (a property of the training dataset itself) — a distinction that recurs later in the course as the more formal [[Bias-Variance Tradeoff|bias-variance trade-off]].

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Supervised classification: training set, attributes, class, test set | [[Classification (Supervised Learning)]] | ✓ Verified |
| Linear regression for numeric prediction | [[Linear Regression and Numeric Prediction]] | ✓ Verified |
| Algorithm (inductive) bias vs. data bias | [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)]] | ✓ Verified |
| Decision trees as structural descriptions | Witten, I., Frank, E. (2011). *Data Mining: Practical Machine Learning Tools and Techniques* (3rd ed.), Ch. 1 (lecture-cited textbook) | ➕ Supplemented |
