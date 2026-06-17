---
title: Decision Trees and Information Gain
type: concept
sources: [raw/lecture-notes/COMP723/Lecture1.pptx, raw/lecture-notes/COMP723/Lecture3.pptx, https://towardsdatascience.com/decision-trees-explained-entropy-information-gain-gini-index-ccp-pruning-4d78070db36c/, https://medium.com/codex/decision-tree-for-classification-entropy-and-information-gain-cd9f99a26e0d]
related: [Classification (Supervised Learning), Naive Bayes Classifier, Overfitting and Underfitting, Ensemble Learning]
created: 12-06-2026
last-updated: 12-06-2026
---

# Decision Trees and Information Gain

> [!check] Verified
> Confirmed via [Towards Data Science: Decision Trees Explained — Entropy, Information Gain, Gini Index, CCP Pruning](https://towardsdatascience.com/decision-trees-explained-entropy-information-gain-gini-index-ccp-pruning-4d78070db36c/) and [Decision Tree for Classification: Entropy and Information Gain (CodeX)](https://medium.com/codex/decision-tree-for-classification-entropy-and-information-gain-cd9f99a26e0d)

## The Core Idea

A decision tree is built **top-down, recursively, in a "divide and conquer" fashion**:

1. **Select** an attribute for the root node; create one branch per possible value of that attribute.
2. **Split** the training instances into subsets, one per branch.
3. **Repeat** the procedure recursively for each branch, using only the instances that reach it.
4. **Stop** when all instances at a node have the same class (a "pure" node).

The critical question at every step is: **which attribute should we split on?** The lecture's heuristic: choose the attribute that produces the **"purest" subsets** — measured via **information gain**.

## Entropy and Information Gain

**Entropy** measures the amount of information (in bits) needed to predict the outcome from a probability distribution:

```
entropy(p1, p2, ..., pn) = -p1·log2(p1) - p2·log2(p2) - ... - pn·log2(pn)
```

where `p1...pn` are the probabilities of each class outcome. A node where all instances belong to one class has entropy `0` (no uncertainty, no information needed); a node split 50/50 between two classes has entropy `1` (maximum uncertainty for two classes).

**Information gain** for an attribute = (entropy *before* splitting) − (weighted average entropy *after* splitting on that attribute):

```
gain(attribute) = info(before) - info(after)
```

### Worked Example: The "Outlook" Attribute (Weather Dataset)

The lecture computes, for the classic weather/play dataset:

```
gain("Outlook") = info([9,5]) - info([2,3], [4,0], [3,2]) = 0.940 - 0.693 = 0.247
```

Here `info([9,5])` is the entropy of the *whole* dataset (9 "play=yes", 5 "play=no" → entropy 0.940), and `info([2,3],[4,0],[3,2])` is the weighted entropy *after* splitting on Outlook's three values (Sunny, Overcast, Rainy), each producing its own [yes,no] split. The **strategy**: compute this gain for every candidate attribute, and choose the attribute with the **greatest information gain** as the split.

## Building the Final Tree

Splitting continues recursively, picking the highest-information-gain attribute at each remaining node, using only the instances that reached that node. **Not all leaves need be pure**: if splitting stops before a node is pure (because attributes have run out, or the node has fewer instances than a specified minimum), the leaf is labelled with the **majority class** of the instances that reached it.

## Intuition: Twenty Questions, Played Optimally

Decision tree construction is like playing "20 Questions" where you get to *choose* the best possible question at each step. A bad question (low information gain) might split the remaining possibilities 19-vs-1 — barely narrowing things down. A good question (high information gain) splits them closer to evenly, or — even better — perfectly separates the remaining possibilities into "all yes" and "all no" groups. **Entropy measures how "mixed up" your current group of possibilities is**; **information gain measures how much a question would reduce that mixed-up-ness**. The algorithm always asks the most-clarifying question available at each step — but it never looks ahead to see if a *slightly worse* question now might lead to a *much better* tree overall (this greediness is a known limitation, see Pitfalls below).

## Decision Trees as a "Structural Description"

As introduced in [[Classification (Supervised Learning)|Lecture 1]], a decision tree is one of two common **structural descriptions** of a learned classifier (the other being if-then rules) — every path from root to leaf corresponds to one rule (e.g. *"If Outlook=Sunny and Humidity=High then Play=No"*), making the model's logic directly inspectable.

## Advantages

- **Inexpensive to construct**
- **Extremely fast at classifying** unknown records (just follow a path from root to leaf)
- **Easy to interpret** for small-sized trees
- **Accuracy comparable** to other classification techniques on many datasets

## Addressing Overfitting: Post-Pruning

A fully-grown decision tree tends to be **more complex than necessary** and overfits the training data (see [[Overfitting and Underfitting]]) — its training error stops being a good estimate of performance on unseen data. **Post-pruning** addresses this:

1. Grow the decision tree to its **entirety** (fully split until pure or out of attributes).
2. **Trim nodes bottom-up**: for each subtree, check whether replacing it with a single leaf (labelled with the **majority class** of its instances) **improves generalization error**.
3. If it does, **replace the subtree with the leaf**. Repeat until no further trimming improves generalization error.

## In Practice: scikit-learn

```python
from sklearn.tree import DecisionTreeClassifier, plot_tree
import matplotlib.pyplot as plt

# criterion='entropy' uses information gain (as in this lecture);
# the scikit-learn default, 'gini', is a similar but slightly different impurity measure
model = DecisionTreeClassifier(criterion='entropy', max_depth=4)
model.fit(X_train, y_train)

plt.figure(figsize=(12, 8))
plot_tree(model, feature_names=X.columns, class_names=model.classes_, filled=True)
plt.show()

print(dict(zip(X.columns, model.feature_importances_)))
```

`max_depth`, `min_samples_split`, and `min_samples_leaf` are scikit-learn's main **pre-pruning** controls — limiting tree growth *during* construction, as a simpler alternative to post-pruning a fully-grown tree.

## Common Pitfalls & Practical Tips

- **The algorithm is greedy, not globally optimal.** It picks the locally-best split at each step; a different (locally worse) first split could sometimes lead to a smaller or more accurate overall tree. Finding the globally optimal tree is computationally intractable for realistic datasets.
- **Information gain is biased toward attributes with many distinct values** (e.g. an ID column would appear to have "perfect" information gain, despite being useless for generalisation) — a known issue addressed by the **information gain *ratio*** (not covered in this lecture, but worth knowing if you see it in scikit-learn or other texts).
- **Unpruned trees almost always overfit** — always validate with a held-out set and consider pruning (`max_depth`, post-pruning) before trusting a deep tree.
- **Decision trees are the building block of [[Ensemble Learning|Random Forests]]** — many of the weaknesses of a single tree (instability, overfitting) are substantially mitigated by combining many trees.

## Related Concepts

- [[Classification (Supervised Learning)]] — decision trees are one structural description of a classifier.
- [[Naive Bayes Classifier]] — an alternative classifier with comparable explanatory power but a different inductive bias (independence vs. recursive partitioning).
- [[Overfitting and Underfitting]] — post-pruning is a decision-tree-specific technique for managing overfitting.
- [[Ensemble Learning]] — Random Forests and boosted trees build on individual decision trees.

**Source:** [Towards Data Science: Decision Trees Explained](https://towardsdatascience.com/decision-trees-explained-entropy-information-gain-gini-index-ccp-pruning-4d78070db36c/); [Decision Tree for Classification: Entropy and Information Gain (CodeX)](https://medium.com/codex/decision-tree-for-classification-entropy-and-information-gain-cd9f99a26e0d)
