---
title: COMP723 Lecture 3 - Naive Bayes and Decision Trees
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture3.pptx]
related: [COMP723, Naive Bayes Classifier, Decision Trees and Information Gain, Overfitting and Underfitting]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP723 Lecture 3 - Naive Bayes and Decision Trees

> [!tip] Going Deeper
> [[Naive Bayes Classifier]] and [[Decision Trees and Information Gain]] have full concept pages with intuition, worked examples, Python code, and pitfalls. [[Overfitting and Underfitting]] already has a full concept page from COMP838. This note summarises how the lecture introduces these ideas and connects them.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **Walk through how Naive Bayes classifies "Joe" as a Good Risk applicant using the credit-scoring evidence.**
- **What is the zero-frequency problem, and how does Laplace correction fix it?**
- **How does Naive Bayes handle a missing value in the instance being classified, vs. a missing value in the training data?**
- **Describe the recursive, top-down procedure for building a decision tree.**
- **What is entropy, and how is information gain computed from it?**
- **Why doesn't every leaf in a decision tree need to be "pure"?**
- **Define underfitting and overfitting in terms of training vs. test accuracy, specifically for decision trees.**
- **What two causes of overfitting are mentioned, and what is post-pruning?**

---

## Notes

### Naive Bayes

The lecture frames Naive Bayes as using **Bayes' theorem** to build "a portfolio of evidence" where each data feature contributes independently to the classification — under the (not-always-true) assumption that **all attributes are statistically independent of each other**. The worked credit-scoring example classifies "Joe" by computing `Pr(GoodRisk|evidence)` vs `Pr(PoorRisk|evidence)` from three pieces of evidence (Debt level, Income level, Marital Status), and similarly classifies four further individuals.

Two practical issues are then addressed:

- **Zero-frequency problem** — if no training samples exist for a class+feature-value combination, the multiplied probability becomes zero and dominates the result; **Laplace correction** fixes this.
- **Missing values** — handled robustly: missing training instances are simply excluded from the relevant probability estimate; a missing value in the instance *being classified* has its conditional probability set to `1` for **all** classes, so it doesn't bias the result.

The lecture also notes Naive Bayes can be extended to **continuous data** (e.g. via Gaussian distributions), and closes with its **general characteristics**: it's one of the most efficient techniques (one pass through training data), it works well in practice even with some feature dependence, but **accuracy can drop substantially with many dependent features** — in which case a **Bayesian Network** is recommended. See [[Naive Bayes Classifier]] for the full breakdown, intuition ("jury weighing independent testimonies"), and scikit-learn code.

### Decision Trees: Attribute Selection via Information Gain

The lecture describes the **normal procedure** for building a decision tree: top-down, recursive, divide-and-conquer — select a root attribute, branch on its values, split instances into subsets, and recurse on each branch until all instances at a node share the same class.

The key question, **"which attribute to select?"**, is answered via a heuristic: choose the attribute producing the **"purest" subsets**, measured by **information gain** — itself derived from **entropy** (the bits of information needed to predict an outcome from a probability distribution). The worked example computes `gain("Outlook") = info([9,5]) - info([2,3],[4,0],[3,2]) = 0.940 - 0.693 ≈ 0.247` for the weather/play dataset, then shows the **final tree**, noting leaves don't all need to be pure — impure leaves get the **majority class** label, and splitting stops when attributes run out or a node falls below a minimum instance count.

**Advantages** highlighted: inexpensive to construct, fast at classifying, easy to interpret for small trees, and accuracy comparable to other techniques. See [[Decision Trees and Information Gain]] for the full entropy/information-gain formulas, the "20 Questions" intuition, and scikit-learn code (including pre-pruning via `max_depth`).

### Practical Issues of Classification: Underfitting and Overfitting

The lecture introduces three "practical issues": **underfitting/overfitting**, **missing values**, and **costs of classification** — focusing mainly on the first.

- **Underfitting** — the model hasn't fully learned the patterns in the data, giving poor *test* accuracy. For decision trees specifically, this means the tree is **not of sufficient depth/size** to capture the patterns present.
- **Overfitting** — the model learns the *training* data extremely well but **cannot predict new data well** (training accuracy >> test accuracy). For decision trees, this means the tree is **too detailed/large**. Two causes are given: **noise** (errors in class labels distorting the decision boundary) and **insufficient training data** in some regions (forcing the tree to rely on irrelevant nearby records when predicting that region).

The lecture stresses a key consequence: once a tree overfits, **training error is no longer a good estimate of test performance** — new error-estimation methods are needed. **Post-pruning** is given as the standard fix: grow the tree fully, then trim bottom-up, replacing any subtree with a majority-class leaf if doing so **improves generalization error**.

> [!tip] Supplemented
> [[Overfitting and Underfitting]] (from COMP838) covers the same underfitting/overfitting trade-off in the context of neural networks — capacity (neurons/parameters) plays the same role there that tree size/depth plays here. The "memorising vs. understanding" intuition and the train/validation curve diagnostic from that page apply directly to decision trees too.

### Practical Tools: Pandas, NumPy, and Scikit-learn (Lab 3)

The lecture's lab section introduces the **Python data science stack** used for the rest of the course: **pandas** `DataFrame`s (tabular data, `.loc` for label-based indexing vs. `.iloc` for position-based indexing), **NumPy** arrays (homogeneous n-dimensional arrays with `.reshape()`, `.ravel()`, and elementwise arithmetic), and **scikit-learn** (built on NumPy/pandas, providing a consistent interface across regression, clustering, decision trees, neural networks, SVMs, Naive Bayes, ensembles, feature selection, outlier detection, and model selection/validation). The lab task is to study provided code and (optionally) systematically tune algorithm parameters, tracking how classification accuracy changes.

---

## Summary

This lecture covers two of the most fundamental classification algorithms. **Naive Bayes** applies Bayes' theorem under a (often-violated but often-effective) feature-independence assumption, handles the zero-frequency problem via Laplace correction, and degrades gracefully (mostly) except when many features are strongly dependent. **Decision Trees** are built top-down by greedily choosing, at each step, the attribute with the highest **information gain** (i.e. the split that most reduces **entropy**) — producing an interpretable structural description, but one that's prone to **overfitting** if grown too large; **post-pruning** trims the tree bottom-up to restore generalisation. Both algorithms have "good explanatory power" — a recurring theme that contrasts with less-interpretable models covered later in the course (e.g. neural networks in Lecture 5). The lab introduces pandas/NumPy/scikit-learn as the practical toolkit for implementing and comparing these algorithms.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Naive Bayes: Bayes theorem, independence assumption, Laplace correction, missing values | [[Naive Bayes Classifier]] | ✓ Verified |
| Decision trees: recursive splitting, entropy, information gain | [[Decision Trees and Information Gain]] | ✓ Verified |
| Underfitting/overfitting trade-off, post-pruning | [[Overfitting and Underfitting]]; [[Decision Trees and Information Gain]] | ✓ Verified |
| Pandas/NumPy/scikit-learn library roles | [scikit-learn documentation](https://scikit-learn.org/stable/) (general library docs, lecture-cited) | ➕ Supplemented |
