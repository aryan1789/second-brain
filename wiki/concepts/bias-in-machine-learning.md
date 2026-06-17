---
title: Bias in Machine Learning (Algorithm Bias vs. Data Bias)
type: concept
sources: [raw/lecture-notes/COMP723/Lecture1.pptx, https://www.ibm.com/think/topics/data-bias, Mitchell, T. (1997). Machine Learning. McGraw-Hill]
related: [Bias-Variance Tradeoff, Overfitting and Underfitting, Classification (Supervised Learning)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Bias in Machine Learning (Algorithm Bias vs. Data Bias)

> [!check] Verified
> Confirmed via [IBM: What is Data Bias?](https://www.ibm.com/think/topics/data-bias); the algorithm/inductive bias framing is standard (Mitchell, 1997, *Machine Learning*, Ch. 2).

## The Core Idea

The lecture identifies **two distinct contexts** in which "bias" arises in machine learning, and they're easy to conflate:

1. **Bias introduced by the learning algorithm** (a.k.a. *inductive bias*) — every learning algorithm relies on **heuristics** to search for patterns, because it's computationally impossible to exhaustively search the entire space of possible patterns. These heuristics necessarily favour certain kinds of patterns over others.
2. **Bias introduced by the data** — **imperfect training datasets**: patterns that will occur in future/real-world data may be entirely absent from the training set, and conversely, patterns present in the training set may not actually generalise to future data.

## Intuition: Tinted Glasses vs. a Narrow Window

**Algorithm bias** is like wearing tinted glasses: every learner has a built-in "shape" of pattern it's naturally good at finding. A [[Decision Trees and Information Gain|decision tree]] is biased toward axis-aligned, rectangular splits of the data; [[K-Nearest Neighbors (KNN)|k-NN]] is biased toward "things that are similar are nearby"; [[Naive Bayes Classifier|Naive Bayes]] is biased toward assuming attributes don't interact. None of these biases are "wrong" — they're *necessary* simplifying assumptions that make learning tractable at all — but they mean each algorithm will systematically miss patterns that don't match its "shape," no matter how much data you give it.

**Data bias** is like trying to understand a whole city by only ever looking out of one window. If your training data was collected from a narrow slice of reality (a particular time period, region, demographic, etc.), the model can only learn the patterns visible through that window — patterns elsewhere in the "city" (future data, different populations) are invisible to it, and patterns that *were* visible through your window might not hold true elsewhere.

## Worked Example: Credit Scoring

Revisiting the lecture's credit-risk classifier: **algorithm bias** shows up in *which* model you choose — a decision tree will represent "good risk" as a set of threshold rules on income/debt/marital status, while a [[Naive Bayes Classifier|Naive Bayes]] model will represent it as independent probability contributions from each attribute. Each makes different *assumptions* about how the attributes relate to risk.

**Data bias** shows up if the historical loan data used for training came from a period of economic growth — the model may have never seen examples of how applicants behave during a recession, so its predictions could be unreliable if applied to new applications during one.

## Why This Matters: Bias Is Unavoidable, But Should Be Understood

The lecture frames heuristics (and thus algorithm bias) as a **"must"** — not a flaw to be eliminated, but a necessary trade-off that makes learning from finite data possible at all (without *some* bias toward simpler/more plausible patterns, a learner could "fit" infinitely many functions to the same training data equally well). The practical takeaway is to **choose an algorithm whose inductive bias roughly matches the true structure of your problem**, and to **scrutinise your training data's collection process** for gaps that could become data bias.

## Common Pitfalls & Practical Tips

- **Don't confuse this "bias" with the bias-variance bias.** [[Bias-Variance Tradeoff]] (covered later in this course) uses "bias" in a related but more specific *statistical* sense — how far a model's average prediction is from the true value. High algorithmic/inductive bias (e.g. a very simple model) tends to correspond to high bias in the bias-variance sense too, but the two framings emphasise different things: this page is about *what patterns an algorithm can represent at all*, bias-variance is about *error decomposition for a trained model*.
- **Data bias can't be fixed by a "better" algorithm.** If a pattern simply doesn't exist in the training data, no algorithm — however sophisticated — can learn it. This is why data collection and preprocessing (see [[Data Preprocessing and Data Quality]]) matter as much as model choice.
- **"No free lunch"**: there is no single algorithm with zero inductive bias that performs best on all problems — this is closely related to the *No Free Lunch theorem* in optimisation/ML.

## Related Concepts

- [[Bias-Variance Tradeoff]] — the related, more formal statistical decomposition of prediction error.
- [[Overfitting and Underfitting]] — a model whose bias is too high (too simple) underfits; a model fit too closely to a biased/noisy sample of data can overfit to that sample's quirks.
- [[Classification (Supervised Learning)]] — the task in which both forms of bias play out.

**Source:** [IBM: What is Data Bias?](https://www.ibm.com/think/topics/data-bias); Mitchell, T. (1997). *Machine Learning*. McGraw-Hill (inductive bias).
