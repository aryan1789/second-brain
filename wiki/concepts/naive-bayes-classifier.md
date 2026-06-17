---
title: Naive Bayes Classifier
type: concept
sources: [raw/lecture-notes/COMP723/Lecture3.pptx, https://en.wikipedia.org/wiki/Naive_Bayes_classifier, https://www.cs.cmu.edu/~tom/mlbook/NBayesLogReg.pdf]
related: [Classification (Supervised Learning), Decision Trees and Information Gain, Bias in Machine Learning (Algorithm Bias vs. Data Bias)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Naive Bayes Classifier

> [!check] Verified
> Confirmed via [Wikipedia: Naive Bayes classifier](https://en.wikipedia.org/wiki/Naive_Bayes_classifier) and [CMU: Naive Bayes and Logistic Regression](https://www.cs.cmu.edu/~tom/mlbook/NBayesLogReg.pdf)

## The Core Idea

Naive Bayes is a probabilistic classifier built on **Bayes' theorem**. To classify an instance, it estimates `Pr(H|E)` — the probability of each possible class (hypothesis `H`, e.g. `Good Risk` vs `Poor Risk`) given the observed evidence `E` (the instance's attribute values) — and picks the class with the highest probability. The "naive" part is the assumption that **all attributes are statistically independent of each other given the class**:

```
Pr(E1, E2, E3 | H) = Pr(E1|H) · Pr(E2|H) · Pr(E3|H)
```

This assumption is "not always true" (the lecture says so explicitly), but it dramatically simplifies the computation — each attribute's contribution can be estimated independently from training data, and the class probability becomes a simple product.

## Worked Example: Credit Scoring

The lecture's running example classifies an applicant ("Joe") as `Good Risk (GR)` or `Poor Risk (PR)` based on three pieces of evidence: `E1` = Debt level, `E2` = Income level, `E3` = Marital Status. The model computes:

```
Pr(GR|E1,E2,E3) ∝ Pr(E1|GR)·Pr(E2|GR)·Pr(E3|GR)·Pr(GR)
Pr(PR|E1,E2,E3) ∝ Pr(E1|PR)·Pr(E2|PR)·Pr(E3|PR)·Pr(PR)
```

Since `Pr(GR|Joe) > Pr(PR|Joe)`, Joe is classified as **Good Risk**. The lecture notes that, just like decision trees, Naive Bayes models have **good explanatory power** here: Income and Marital Status essentially determine the risk factor, and the "typical profile" of a good-risk applicant is someone married with high income.

## Intuition: A Jury Weighing Independent Testimonies

Imagine a jury deciding "guilty" vs "not guilty" by calling several witnesses, where **each witness testifies independently** and has no idea what the others said. Each witness's testimony shifts the jury's belief up or down by some factor. The jury's final verdict is (roughly) the *product* of all these independent shifts, starting from a baseline ("prior") belief about guilt. Naive Bayes works the same way: each attribute is a "witness" contributing evidence toward each class, and the final probability for each class is the product of all the individual contributions — assuming (naively) that no two witnesses are colluding or influencing each other.

## The Zero-Frequency Problem and Laplace Correction

If **no training samples** exist for a particular class + feature-value combination, `Pr(Ei|H) = 0` for that combination — and because the formula *multiplies* probabilities together, a single zero wipes out the entire product for that class, regardless of how strong the other evidence is. **Laplace correction** fixes this by adding a small count (typically 1) to every observed frequency before computing probabilities, ensuring no probability is ever exactly zero.

## Handling Missing Values

Naive Bayes is described as a **robust technique for missing/unknown values**, with two distinct scenarios:

- **Missing values in the training data** — simply don't include those instances when estimating the probability for that particular attribute/value combination.
- **Missing values in the instance being classified** — requires more care: if an attribute value is missing, set its conditional probability to `1` for **all** class outcomes. Since it then doesn't change the product for any class, the missing attribute simply doesn't bias the result either way.

## Naive Bayes for Continuous Data

For continuous (numeric) attributes, rather than counting discrete frequencies, Naive Bayes typically assumes each attribute follows a distribution (commonly Gaussian/normal) within each class, and computes the probability density at the observed value — this is the basis of scikit-learn's `GaussianNB`.

## General Characteristics

- **Highly efficient** — makes only **one pass** through the training data to estimate all the probabilities needed.
- **Works well in practice even when the independence assumption is violated** — a frequently-cited empirical finding.
- **Degrades when many features are strongly dependent on each other** — accuracy can drop substantially; a more advanced model that explicitly captures dependencies between variables, a **Bayesian Network**, should be used instead in that case.

## In Practice: scikit-learn

```python
from sklearn.naive_bayes import GaussianNB, MultinomialNB

# Continuous features (e.g. income, debt level as numbers)
model = GaussianNB()
model.fit(X_train, y_train)
predictions = model.predict(X_test)

# Discrete/count features (e.g. word counts in text classification)
# alpha=1.0 applies Laplace (additive) smoothing -- avoids the zero-frequency problem
text_model = MultinomialNB(alpha=1.0)
```

## Common Pitfalls & Practical Tips

- **Always use smoothing (`alpha` in scikit-learn)** — without it, any unseen feature/class combination in production data can zero out a class's probability entirely, regardless of how well everything else matches.
- **The independence assumption is the model's main [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)|algorithmic bias]]** — it's a feature, not just a limitation: it's *why* Naive Bayes needs so little data and is so fast, but it's also exactly where it breaks down (strongly correlated features).
- **Check feature correlations before trusting Naive Bayes on a new dataset** — if several features are highly correlated, consider a Bayesian Network, or a model like [[Decision Trees and Information Gain|Decision Trees]] that doesn't assume independence.

## Related Concepts

- [[Classification (Supervised Learning)]] — the general task Naive Bayes solves.
- [[Decision Trees and Information Gain]] — an alternative classifier with comparable explanatory power but different inductive bias.
- [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)|Bias in Machine Learning]] — the independence assumption is a textbook example of algorithmic/inductive bias.

**Source:** [Wikipedia: Naive Bayes classifier](https://en.wikipedia.org/wiki/Naive_Bayes_classifier); [CMU: Naive Bayes and Logistic Regression](https://www.cs.cmu.edu/~tom/mlbook/NBayesLogReg.pdf)
