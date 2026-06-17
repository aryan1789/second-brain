---
title: Ensemble Learning
type: concept
sources: [Alpaydin, E. (2009). Introduction to Machine Learning. MIT Press., https://www.geeksforgeeks.org/machine-learning/a-comprehensive-guide-to-ensemble-learning/, https://www.ibm.com/think/topics/bagging, raw/lecture-notes/COMP723/Lecture4.pptx, https://en.wikipedia.org/wiki/AdaBoost]
related: [Deep Learning, Transfer Learning, Overfitting and Underfitting, Confusion Matrix Metrics, Bias-Variance Tradeoff, Decision Trees and Information Gain]
created: 12-06-2026
last-updated: 12-06-2026
---

# Ensemble Learning

## The Core Idea

Ensemble learning combines multiple **base learners** into a single predictor whose accuracy exceeds that of any individual learner. Every learning algorithm comes with its own set of assumptions (its "inductive bias"), and any single model trained on finite data will make some errors; by generating multiple *diverse* learners and combining their outputs, the errors of individual learners tend to cancel out, improving overall accuracy (Alpaydin, 2009).

## Intuition: "Wisdom of the Crowd"

A single expert can be wrong, but if you ask many *differently-skilled* experts the same question and combine their answers (e.g. by majority vote or weighted averaging), the combined answer is often more reliable than any one expert's — *provided* the experts' mistakes aren't all the same mistake. This is the crux of ensemble learning: diversity matters as much as individual accuracy. If every base learner makes the *same* errors, combining them gives you nothing; if their errors are uncorrelated, combining them averages those errors away.

Alpaydin (2009) frames this as two open questions any ensemble method must answer:

1. **How do we generate base learners that complement each other** (rather than all making the same mistakes)?
2. **How do we combine their outputs** for maximum accuracy?

## Generating Diverse Learners

The lecture lists several standard ways to create diversity among base learners:

- **Different algorithms** — train several different model types (e.g. a decision tree, an SVM, and a neural network) on the same data; each has different inductive biases and will err differently.
- **Different hyperparameters** — train multiple instances of the same algorithm with different hyperparameters, then average over this factor to reduce variance and error.
- **Different input representations** — the "random subspace method": train each learner on a different random subset of input features.
- **Different training sets** — randomly draw different training sets from the available samples (this is the basis of **bagging**/bootstrap aggregating) and train one base learner per set; a "mixture of experts" approach can also partition the input space so different learners specialise on different regions.

## Combining the Outputs

Once trained, base learners' outputs `d_1, ..., d_L` are combined via a combining function `f`:

```
y = f(d_1, d_2, ..., d_L | Φ)
c = argmax_i y_i      (for classification, i = 1..K classes)
```

where `Φ` are the combining function's parameters and `c` is the predicted class. Common combination strategies include:

- **Simple voting** — equal weights `w_j ∈ {1, 0}` (a learner either "votes" or doesn't); the class with the most votes wins.
- **Weighted/linear opinion pools** — `y_i = Σ_j w_j · d_ji`, with `Σ_j w_j = 1` and `w_j ≥ 0` — each learner's output is weighted by how much it's trusted.
- **Classifier combination rules** — e.g. sum, max, min, product/median of base learner outputs.

The lecture also distinguishes:

- **Global vs. local combination** — *learner fusion* (global: all learners contribute to every prediction) vs. *learner selection* (local: pick the most relevant learner(s) for a given input region).
- **Multi-stage combination** — *serial* (learners applied one after another) vs. *cascading* (each stage handles only the cases the previous stage was uncertain about).

## In Practice: A Simple Voting Ensemble (scikit-learn)

```python
from sklearn.ensemble import VotingClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC

# Three diverse base learners (different algorithms)
ensemble = VotingClassifier(estimators=[
    ("tree", DecisionTreeClassifier()),
    ("logreg", LogisticRegression()),
    ("svm", SVC(probability=True)),
], voting="soft")  # "soft" = average predicted probabilities (weighted opinion pool)

ensemble.fit(X_train, y_train)
predictions = ensemble.predict(X_test)
```

`voting="soft"` implements the weighted linear opinion pool above (averaging class probabilities); `voting="hard"` implements simple majority voting.

## Bagging and Boosting in Detail (COMP723, Lecture 4)

A second lecture frames bagging and boosting directly through the [[Bias-Variance Tradeoff]]: ensembles help because they **reduce variance** ("results are less dependent on peculiarities of a single training set") and **reduce bias** ("a combination of multiple classifiers may learn a more expressive concept class than a single classifier").

### Bagging (Bootstrap Aggregating) — Algorithm

1. **Randomly select several training datasets of equal size**, sampling **with replacement** from the original training pool ("bootstrap samples"). Because sampling is with replacement, some examples appear multiple times in a given sample, and some don't appear at all — each original instance has probability `1 - (1 - 1/n)^n` of being selected into any given bootstrap sample (for large `n`, this converges to `1 - 1/e ≈ 63.2%`).
2. **Apply the same mining algorithm** (e.g. C4.5/decision tree) to build one model per bootstrap sample — `N` samples → `N` models.
3. **To classify a new instance**, present it to *every* model; each model gets **one vote**; the instance is assigned to the class with the **most votes**.

```python
from sklearn.ensemble import BaggingClassifier
from sklearn.neighbors import KNeighborsClassifier

bagging = BaggingClassifier(KNeighborsClassifier(), max_samples=0.5, max_features=0.5)
```

### Boosting — Algorithm

Boosting also combines multiple models that vote, but differs from bagging in two key ways:

1. **Each new model is built on the results of the previous ones** — it concentrates on correctly classifying the instances the previous models got **wrong**.
2. **Models are weighted by performance** — once all models are built, each gets a weight based on its training-data performance, so better-performing models contribute more to the final vote.

Mechanically: all `N` records start with **equal weights**. After each round, records that were **wrongly classified have their weights increased** (making them more likely to be selected/emphasised next round) and correctly-classified records have their weights **decreased**. Unlike bagging, these weights **change throughout the boosting process**.

### Example: AdaBoost

**AdaBoost** ("Adaptive Boosting") is the canonical boosting algorithm: it trains a sequence of base classifiers `C1, C2, ..., CN` (commonly **decision stumps** — one-split decision trees, a deliberately *high-bias* base learner, see [[Bias-Variance Tradeoff]]), where each classifier's **importance** in the final weighted vote is derived from its **error rate** on the (re-weighted) training data — lower-error classifiers get higher importance weights.

```python
from sklearn.model_selection import cross_val_score
from sklearn.datasets import load_iris
from sklearn.ensemble import AdaBoostClassifier

X, y = load_iris(return_X_y=True)
clf = AdaBoostClassifier(n_estimators=100)
```

By default, scikit-learn's `AdaBoostClassifier` uses **decision stumps** as its base estimator; this can be changed via the `estimator` parameter (formerly `base_estimator`).

## Common Pitfalls & Practical Tips

- **Diversity beats raw accuracy.** A slightly weaker but differently-erring learner can improve an ensemble more than a slightly stronger learner that makes the same mistakes as the others.
- **Bagging vs. boosting** — bagging (training learners independently on resampled data, then averaging) primarily reduces *variance*; boosting (training learners sequentially, each focusing on the previous learner's errors) primarily reduces *bias*. Random Forests are a well-known bagging ensemble of decision trees.
- **Boosting can overfit if run too long** — because it keeps focusing on hard/misclassified examples (which may include mislabeled noise), too many boosting rounds can start fitting noise. Bagging is generally more robust to this.
- **Validation set selection.** The lecture notes the "usual approach" is to pick whichever combination/learner performs best on a held-out validation set — be careful this validation set is representative, or the ensemble may be tuned to validation-set quirks. See [[Overfitting and Underfitting]].

## Related Concepts

- [[Transfer Learning]] — a complementary technique; ensembles are often built from several independently fine-tuned pretrained models.
- [[Overfitting and Underfitting]] — ensembles (especially bagging) are a standard technique for reducing variance/overfitting relative to a single high-capacity model.
- [[Confusion Matrix Metrics]] — the metrics used to evaluate and compare individual base learners vs. the combined ensemble on a validation set.
- [[Bias-Variance Tradeoff]] — bagging primarily reduces variance, boosting primarily reduces bias; this is the lens COMP723 uses to motivate ensembles.
- [[Decision Trees and Information Gain]] — decision trees (and decision stumps) are the most common base learner for both bagging (Random Forests) and boosting (AdaBoost).

**Source:** [Alpaydin, E. (2009). Introduction to Machine Learning. MIT Press.](https://www.geeksforgeeks.org/machine-learning/a-comprehensive-guide-to-ensemble-learning/); [What Is Bagging? (IBM)](https://www.ibm.com/think/topics/bagging); [Wikipedia: AdaBoost](https://en.wikipedia.org/wiki/AdaBoost)
