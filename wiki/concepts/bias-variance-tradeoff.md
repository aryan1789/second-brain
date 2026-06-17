---
title: Bias-Variance Tradeoff
type: concept
sources: [raw/lecture-notes/COMP723/Lecture4.pptx, https://www.ibm.com/think/topics/bias-variance-tradeoff, https://www.geeksforgeeks.org/machine-learning/ml-bias-variance-trade-off/]
related: [Bias in Machine Learning (Algorithm Bias vs. Data Bias), Overfitting and Underfitting, Ensemble Learning, K-Nearest Neighbors (KNN), Naive Bayes Classifier, Decision Trees and Information Gain]
created: 12-06-2026
last-updated: 12-06-2026
---

# Bias-Variance Tradeoff

> [!check] Verified
> Confirmed via [IBM: What is Bias-Variance Tradeoff?](https://www.ibm.com/think/topics/bias-variance-tradeoff) and [GeeksforGeeks: Bias-Variance Trade Off](https://www.geeksforgeeks.org/machine-learning/ml-bias-variance-trade-off/)

## The Core Idea

Two properties characterise how a learner behaves across different training sets:

- **Bias** — a learner's ability to **learn the patterns in a training dataset**. Low bias means patterns are captured well.
- **Variance** — the learner's **sensitivity to small changes in the training data**. High variance means the model captures random noise as if it were signal — train it on a slightly different sample and you'd get a meaningfully different model.

**Ideally both would be small simultaneously**, but in practice this is usually impossible: reducing bias (making a model more flexible, so it can fit more patterns) tends to *increase* variance (the extra flexibility also lets it fit noise), and vice versa.

## Worked Examples from the Lecture

- **[[Naive Bayes Classifier]] on data with strong inter-dependencies** displays **high bias** — its independence assumption means it structurally *cannot* represent the dependency patterns in the data, no matter how much training data it sees.
- **A decision stump** (a [[Decision Trees and Information Gain|decision tree]] with just one split) has **high bias** compared to a deeper tree — it can only represent very simple decision boundaries, so it will systematically underfit more complex patterns.

## Intuition: Throwing Darts at a Target

Imagine repeating an experiment many times: each time, train a model on a *different* random sample of training data, then have it make a prediction for the same fixed input. Plot all these predictions as dart throws at a target, where the bullseye is the true value.

- **High bias** = your throws cluster together, but **far from the bullseye** — consistently wrong in the same way, regardless of which training sample you used. (A decision stump always draws roughly the same simple boundary, which is consistently "not quite right.")
- **High variance** = your throws are **scattered all over** the board — sometimes near the bullseye, sometimes far, depending heavily on which training sample you happened to get. (A very deep, unpruned tree fits each training sample's noise differently, so its predictions swing wildly between samples.)
- **The goal**: throws tightly clustered *and* centred on the bullseye — low bias *and* low variance — which is hard because the "darts" (model flexibility) that help you aim more precisely (low bias) also make your hand shakier (high variance), and vice versa.

## How Ensemble Learning Helps

A major motivation for [[Ensemble Learning]] is to improve this trade-off directly: it **lowers variance while not disproportionately raising bias**. By combining the predictions of several different models — each trained on a slightly different sample/subset of the data — the models' individual errors (scattered "dart throws") tend to **average out**, reducing the overall variance without making any individual model less expressive (so bias doesn't rise much, if at all). This is precisely *why* the lecture introduces Bagging and Boosting immediately after this concept.

## Relationship to Overfitting/Underfitting and Algorithm Bias

- **High bias ≈ underfitting** — the model is too simple/constrained to capture the true pattern, regardless of training data (see [[Overfitting and Underfitting]]).
- **High variance ≈ overfitting** — the model fits the specific training sample's noise too closely and won't generalise.
- This is the **same underlying idea** as [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)|algorithm bias from Lecture 1]], made more precise: a learner's *inductive bias* (its built-in assumptions) directly determines where it sits on the bias-variance spectrum. A learner with strong assumptions (Naive Bayes, decision stumps) has high bias/low variance; a learner with few assumptions (deep decision trees, k-NN with small `k`) has low bias/high variance.

## Common Pitfalls & Practical Tips

- **You cannot measure bias and variance directly from a single trained model on a single dataset** — they describe behaviour *across* hypothetical resamples of the training data. In practice, [[Cross-Validation]] and learning curves (training vs. validation error as model complexity changes) are used as proxies.
- **"More complex model" doesn't always mean "better."** A more flexible model only helps if its *reduction in bias* outweighs its *increase in variance* for your specific amount of data — with little data, a simpler (higher-bias, lower-variance) model often generalises better.
- **More training data primarily reduces variance**, not bias — a high-bias model (e.g. linear regression on a fundamentally nonlinear relationship) will not improve much with more data; you need a different (lower-bias) model.

## Related Concepts

- [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)]] — the Lecture 1 framing this concept formalises.
- [[Overfitting and Underfitting]] — variance ≈ overfitting, bias ≈ underfitting.
- [[Ensemble Learning]] — combines models specifically to reduce variance without raising bias much.
- [[K-Nearest Neighbors (KNN)]] — the choice of `k` is a direct bias-variance dial.
- [[Naive Bayes Classifier]] and [[Decision Trees and Information Gain]] — concrete high-bias examples (independence assumption; decision stump).

**Source:** [IBM: What is Bias-Variance Tradeoff?](https://www.ibm.com/think/topics/bias-variance-tradeoff); [GeeksforGeeks: Bias-Variance Trade Off](https://www.geeksforgeeks.org/machine-learning/ml-bias-variance-trade-off/)
