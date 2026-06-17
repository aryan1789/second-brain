---
title: COMP723 Lecture 2.2 - Evaluation Methods and Data Mining Tasks
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture2.pptx]
related: [COMP723, Confusion Matrix Metrics, Classification (Supervised Learning), Linear Regression and Numeric Prediction, Self-Organizing Map (SOM)]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP723 Lecture 2.2 - Evaluation Methods and Data Mining Tasks

> [!tip] Going Deeper
> [[Confusion Matrix Metrics]] already has a full concept page (from COMP838) covering TP/FP/FN/TN, recall, precision, accuracy, F1, and ROC/AUC — this note summarises how COMP723 introduces the same ideas via a credit-card classification example.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **What's the difference between Recall, Precision, Error Rate, Accuracy, and F1?**
- **In a confusion matrix, which cell represents a False Positive vs. a False Negative?**
- **Why might "Model A" and "Model B" both have 900/1000 correct, yet be meaningfully different?**
- **What is association rule discovery, and give one example rule.**
- **How is clustering different from classification?**
- **What's the difference between classification learning and numeric prediction, in terms of supervision?**

---

## Notes

### Evaluating Classification: Confusion Matrices

The lecture's classification-learning recap emphasises: classification is **supervised** (the scheme is given the actual outcome, called the "class," during training), and success is measured on **fresh test data** for which class labels are known.

To compare classifiers, the lecture introduces the **confusion matrix** via a credit-card application example, comparing two hypothetical models:

- **Model A**: 600 Accept→Accept (TP), 25 Accept→Reject (FN), 75 Reject→Accept (FP), 300 Reject→Reject (TN)
- **Model B**: 600 TP, 75 FN, 25 FP, 300 TN

Both models get the same overall accuracy (900/1000 = 90%), yet they make **different kinds of mistakes** — Model A has more false positives (wrongly approves risky applicants), Model B has more false negatives (wrongly rejects good applicants). Which is "better" depends on the **relative cost** of each error type — the lecture poses this directly: *"Compare fraud detection vs. Cancer detection"* — in cancer detection a false negative (missed cancer) is far worse than a false positive, while in fraud detection the costs may be more balanced or reversed depending on business context.

This motivates the standard derived metrics — **Recall, Precision, Error Rate, Accuracy, F1** — and their **multi-class** generalisation via an `N x N` confusion matrix (the lecture's Exercise 2 uses a 3-class example: Class A/B/C). All of these are covered in depth, with formulas and a worked scikit-learn example, in [[Confusion Matrix Metrics]]. The lecture also names **Sensitivity** (= Recall) and **Specificity** (= recall for the *other*/negative class) as metrics particularly suited to **balanced data**.

### Association Rule Discovery

Given a set of records, each containing some items from a shared collection, **association rule discovery** produces dependency rules predicting the occurrence of one item based on the occurrence of others — e.g. `{Milk} → {Coke}` or `{Diaper, Milk} → {Beer}`. The lecture frames this through **marketing and sales promotion**: if `{Bagels, ...} → {Potato Chips}` is discovered, then:

- **Potato Chips as the consequent** → tells you what to promote to boost potato chip sales (e.g. stock more bagels nearby).
- **Bagels as the antecedent** → tells you what else would be affected if bagels were discontinued.
- **Bagels in the antecedent AND potato chips in the consequent** → tells you what to sell *alongside* bagels to boost potato chip sales specifically.

This is a one-slide introduction in this lecture (no algorithm such as Apriori covered yet) — flagged here as a topic to potentially expand into its own concept page if a later lecture covers the mining algorithm.

### Clustering

**Clustering** is introduced by contrast with classification: it finds groups of *similar* items, but is **unsupervised** — the class of each example is *not known* in advance, and success is measured **subjectively** (there's no ground-truth label to compute accuracy against). The example given is running the classic iris dataset *without* its class labels. For a concrete clustering algorithm, see [[Self-Organizing Map (SOM)]] (covered in COMP838) — an unsupervised, competitive-learning approach to exactly this kind of grouping problem.

### Numeric Prediction (Recap)

The lecture recaps **numeric prediction** as "like classification learning but with a numeric 'class'" — still **supervised** (the scheme is given a target value during training), with success measured on test data, illustrated again via **linear regression** (`Y = aX + b`, finding the best straight line through the data). See [[Linear Regression and Numeric Prediction]] for the full concept page and the mpg worked example from Lecture 1.

---

## Summary

This second half of Lecture 2 surveys the **major data mining task types** and how each is evaluated. **Classification** evaluation centres on the **confusion matrix** and its derived metrics (recall, precision, accuracy, F1) — the credit-card Model A/B example shows that *equal accuracy doesn't mean equal usefulness*, since different error types (false positives vs. false negatives) carry different real-world costs. **Association rule discovery** finds `{antecedent} → {consequent}` dependency rules useful for marketing decisions. **Clustering** is the unsupervised counterpart to classification — grouping similar items with no ground-truth labels, evaluated subjectively. **Numeric prediction** is classification's supervised sibling for continuous targets, exemplified by linear regression.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Confusion matrix, recall/precision/accuracy/F1, sensitivity/specificity | [[Confusion Matrix Metrics]] | ✓ Verified |
| Association rule discovery / market basket analysis | [Market Basket Analysis in Data Mining (GeeksforGeeks)](https://www.geeksforgeeks.org/data-science/market-basket-analysis-in-data-mining/) | ✓ Verified |
| Clustering as unsupervised grouping | [[Self-Organizing Map (SOM)]] | ✓ Verified |
| Numeric prediction as supervised, continuous-target sibling of classification | [[Linear Regression and Numeric Prediction]] | ✓ Verified |
