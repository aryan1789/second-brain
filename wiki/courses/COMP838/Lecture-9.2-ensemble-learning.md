---
title: COMP838 Lecture 9.2 - Ensemble Learning
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture9.pdf]
related: [COMP838, Ensemble Learning, Overfitting and Underfitting]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 9.2 - Ensemble Learning

> [!tip] Going Deeper
> [[Ensemble Learning]] has a full concept page with intuition, the combining-function notation, a scikit-learn voting ensemble example, and pitfalls (diversity vs. accuracy, bagging vs. boosting). This note summarises the lecture's framing.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **What two questions does ensemble learning need to answer?**
- **List the four ways to generate diverse base learners.**
- **What's the difference between global and local multi-expert combination?**
- **What's the difference between serial and cascading multi-stage combination?**
- **Write out the combining function `y = f(...)` and the decision rule `c = argmax...` in your own words.**
- **What's the difference between simple voting and a weighted/linear opinion pool?**

---

## Notes

### Why Ensembles

[[Ensemble Learning|Ensemble learning]] starts from the observation that every learning algorithm comes with a set of assumptions, so by suitably generating and combining multiple **base learners**, overall accuracy can be improved beyond any single learner's (Alpaydin, 2009). The lecture frames this as two open questions: **how do we generate base learners that complement each other**, and **how do we combine their outputs for maximum accuracy**?

> [!check] Verified
> This "diversity + combination" framing is the standard motivation for ensemble methods — see [Ensemble Learning (GeeksforGeeks)](https://www.geeksforgeeks.org/machine-learning/a-comprehensive-guide-to-ensemble-learning/).

### Generating Diverse Learners

Four ways to generate base learners that differ in their decisions (and so complement each other):

- **Different algorithms** — combine multiple distinct learning algorithms.
- **Different hyperparameters** — train multiple instances of the same algorithm with varied hyperparameters, then average to reduce variance and error.
- **Different input representations** — the random subspace method: each learner sees a different random subset of features.
- **Different training sets** — randomly draw different training sets from the available samples and train one learner per set (a "mixture of experts" approach).

### Combination Strategies

The lecture distinguishes two dimensions of combination strategy:

- **Multi-expert combination**: *global* approach (learner fusion — all learners contribute to every prediction) vs. *local* approach (learner selection — pick the most relevant learner(s) per input).
- **Multi-stage combination**: *serial* (learners applied one after another) vs. *cascading* (later stages only handle cases earlier stages were unsure about).

Formally, base learner outputs `d_1, ..., d_L` are combined via `y = f(d_1, d_2, ..., d_L | Φ)`, and for classification the predicted class is `c = argmax_i y_i` over classes `i = 1...K`, where `f(·)` is the combining function parameterised by `Φ`.

Specific combining rules given:

- **Simple voting** — weights `w_j ∈ {1, 0}` (binary "votes").
- **Weighted/linear opinion pools** — `y_i = Σ_j w_j · d_ji`, subject to `Σ_j w_j = 1` and `w_j ≥ 0`.
- **Classifier combination rules** — sum, max, min, etc. of base learner outputs.

> [!check] Verified
> The `y = f(d_1,...,d_L|Φ)`, `c = argmax y_i` formulation and the voting/linear-opinion-pool combination rules match the standard treatment in Alpaydin's *Introduction to Machine Learning* (MIT Press), as summarised in [[Ensemble Learning]].

### MATLAB Ensemble Learning Workflow

The lecture's MATLAB workflow for ensemble learning: prepare the predictor data, prepare the response data, choose an ensemble aggregation method, set the number of ensemble members, prepare the weak learners, and call an ensemble function — i.e. "meld results from many weak learners into one high-quality ensemble predictor."

---

## Summary

Ensemble learning improves on any single model by training multiple diverse base learners and combining their predictions. Diversity can come from using different algorithms, hyperparameters, input feature subsets, or training sets. Combination can be global (fusion) or local (selection), and single-stage or multi-stage (serial/cascading); concretely, base learner outputs are combined via a function `f` and a classification decision is made via `argmax`, using strategies like simple voting or weighted linear opinion pools. MATLAB's ensemble workflow operationalises this as: prepare data, choose an aggregation method, set the number of weak learners, and call an ensemble function.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Ensemble learning rationale (diversity + combination) | [Ensemble Learning (GeeksforGeeks)](https://www.geeksforgeeks.org/machine-learning/a-comprehensive-guide-to-ensemble-learning/) | ✓ Verified |
| Combining function notation and voting/opinion-pool rules | Alpaydin, E. (2009) *Introduction to Machine Learning*, MIT Press | ✓ Verified |
