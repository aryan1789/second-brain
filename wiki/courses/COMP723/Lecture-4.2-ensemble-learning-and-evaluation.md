---
title: COMP723 Lecture 4.2 - Bias-Variance, Ensemble Learning, and Evaluation
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture4.pptx]
related: [COMP723, Bias-Variance Tradeoff, Ensemble Learning, Cross-Validation, Confusion Matrix Metrics]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP723 Lecture 4.2 - Bias-Variance, Ensemble Learning, and Evaluation

> [!tip] Going Deeper
> [[Bias-Variance Tradeoff]] and [[Cross-Validation]] are new concept pages from this lecture. [[Ensemble Learning]] (from COMP838) has been supplemented with a "Bagging and Boosting in Detail" section covering the algorithms and AdaBoost. [[Confusion Matrix Metrics]] (from COMP838) already covers ROC/AUC in full. This note summarises the lecture's framing and connects them.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **Define bias and variance as the lecture does. Why can't both be minimised simultaneously?**
- **Give one example each of a high-bias learner and a high-bias tree structure.**
- **How does ensemble learning improve the bias-variance trade-off?**
- **Describe the bagging algorithm in 3 steps. What does "sampling with replacement" mean?**
- **How does boosting differ from bagging in (a) how models are built and (b) how they're combined?**
- **What is AdaBoost, and what's its default base classifier in scikit-learn?**
- **What is k-fold cross-validation, and what does "stratified" add?**
- **What does an ROC curve plot, and what do AUC values of 0.5 and 1.0 mean?**

---

## Notes

### Bias vs. Variance Trade-off

The lecture defines **bias** as a learner's ability to learn the patterns in a training dataset (low bias = patterns well captured) and **variance** as the learner's sensitivity to small changes in the training data (high variance = random noise gets captured as if it were signal). It gives two concrete examples of **high bias**: [[Naive Bayes Classifier|Naive Bayes]] on data with high inter-dependencies (its independence assumption can't represent those dependencies), and a **decision stump** compared to a deeper [[Decision Trees and Information Gain|decision tree]]. The lecture states plainly that **both being small at once is often not possible** — reducing one tends to increase the other. See [[Bias-Variance Tradeoff]] for the full "dartboard" intuition and how this connects back to the Lecture 1 framing of [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)|algorithm bias]].

### Ensemble Learning: Motivation

**Ensemble learning's** major motivation, per the lecture, is to **optimize the bias-variance trade-off** — specifically by **lowering variance while not disproportionately raising bias**, achieved by **combining different models** to reduce variability. The lecture frames this with the **general ensemble recipe**: construct a set of classifiers from the training data, then predict by **aggregating** their individual predictions. Two motivations are given explicitly: **reduce variance** (results less dependent on one training set's peculiarities) and **reduce bias** (a combination may learn a more expressive concept class than any single classifier).

A "why does it work?" example: with **25 independent base classifiers**, each with error rate `ε = 0.35`, the **ensemble** (majority vote) makes a wrong prediction only if **more than half** of the 25 classifiers are wrong — which, for independent classifiers with error 0.35, is substantially less likely than 0.35 itself (a binomial-tail calculation).

### Bagging and Boosting

Both are ways to **generate an ensemble of classifiers**:

- **Bagging** ("Bootstrap Aggregating") — randomly draw several **equal-size training sets with replacement** from the training pool (so some instances appear multiple times in a sample, some not at all — each instance has probability `1-(1-1/n)^n` of being in any given sample); train the **same algorithm** on each sample to get `N` models; classify by **majority vote** (each model gets one vote).
- **Boosting** — also combines voting models, but **(1)** each new model is built to focus on instances the **previous models got wrong**, and **(2)** each model's vote is **weighted by its training performance**. Mechanically, all records start with equal weights; **misclassified records get higher weights** (more likely to be emphasised next round), correctly-classified records get **lower weights** — unlike bagging, these weights evolve across rounds.
- **AdaBoost** is given as the worked boosting example: base classifiers `C1...CN`, each with an error rate that determines its **"importance"** (weight) in the final combined vote. scikit-learn's `AdaBoostClassifier` defaults to **decision stumps** as the base estimator.

Both are demonstrated with scikit-learn one-liners (`BaggingClassifier(KNeighborsClassifier(), max_samples=0.5, max_features=0.5)` and `AdaBoostClassifier(n_estimators=100)`). See [[Ensemble Learning]] for the full algorithmic detail and code.

### Recap: Training, Testing, and Validation Data

The lecture recaps the three data roles: **Training Data** (used to learn patterns), **Testing Data** (used to evaluate learning effectiveness), and **Validation Data** (used to fine-tune algorithms between batches — only applicable to some algorithms, sometimes called the **"Holdout set"**). It notes a terminology caveat: *"some people might also refer to the Test data/results as Validation data/results"* — i.e. these terms are used inconsistently across sources, so context matters.

### Cross-Validation

**K-fold cross-validation** is introduced as sampling parts of the data for training and testing without a single fixed split: the whole dataset is divided into `k` "folds," each consisting of a training and testing portion, such that **a given datapoint might be in the training set for one fold and the test set for another**. `k` = the number of folds. **Stratified k-fold validation** additionally **maintains the proportion of classes** across folds. See [[Cross-Validation]] for the "rotating exam groups" intuition and scikit-learn code.

### ROC Curve and AUC

An **ROC curve** (Receiver Operating Characteristic curve) plots a classification model's performance **across all classification thresholds**, using two parameters: **True Positive Rate (TPR)** and **False Positive Rate (FPR)**. TPR is a synonym for **recall**/**sensitivity**; **specificity** is the recall for the *other* (negative) class; FPR is the false-positive analogue of recall (false positives as a proportion of "true negatives + false positives"). Rather than evaluating a classifier at many individual threshold points (described as "inefficient"), the ROC curve plots TPR vs. FPR continuously across thresholds.

**AUC** (Area Under the ROC Curve) summarises this into one number: **AUC = 0.5** is completely random, **AUC = 0.0** is a classifier that's "completely opposite" (systematically wrong), **AUC = 1.0** means the classifier gets both classes correct 100% of the time, and e.g. **AUC = 0.7** corresponds to a 70% chance of correctly distinguishing the classes. This is covered in full, with a worked scikit-learn example, in [[Confusion Matrix Metrics]] (from COMP838) — this lecture's framing is consistent with that page.

---

## Summary

This lecture connects several evaluation-focused threads. **Bias and variance** are defined as two properties of a learner — its ability to capture patterns (bias) vs. its sensitivity to the specific training sample (variance) — that typically trade off against each other. **Ensemble learning** (bagging and boosting) directly targets this trade-off: bagging trains the same algorithm on different bootstrap samples and votes (mainly reducing variance), while boosting trains a sequence of models that focus on each other's mistakes and combines them with performance-based weights (mainly reducing bias), with **AdaBoost** as the canonical example. The lecture then recaps the training/test/validation data roles and introduces **k-fold (and stratified k-fold) cross-validation** as a more robust alternative to a single fixed split. Finally, **ROC curves and AUC** are introduced as threshold-independent ways to evaluate a classifier's ability to distinguish classes — already covered in depth in [[Confusion Matrix Metrics]] from COMP838.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Bias-variance definitions and trade-off | [[Bias-Variance Tradeoff]] | ✓ Verified |
| Bagging algorithm, sampling with replacement | [[Ensemble Learning]] | ✓ Verified |
| Boosting algorithm, AdaBoost | [[Ensemble Learning]]; [Wikipedia: AdaBoost](https://en.wikipedia.org/wiki/AdaBoost) | ✓ Verified |
| K-fold and stratified k-fold cross-validation | [[Cross-Validation]] | ✓ Verified |
| ROC curve, AUC interpretation | [[Confusion Matrix Metrics]] | ✓ Verified |
