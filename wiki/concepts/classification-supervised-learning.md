---
title: Classification (Supervised Learning)
type: concept
sources: [raw/lecture-notes/COMP723/Lecture1.pptx, https://en.wikipedia.org/wiki/Training,_validation,_and_test_data_sets, https://www.ibm.com/think/topics/supervised-learning]
related: [Decision Trees and Information Gain, Naive Bayes Classifier, K-Nearest Neighbors (KNN), Confusion Matrix Metrics, Overfitting and Underfitting, Linear Regression and Numeric Prediction]
created: 12-06-2026
last-updated: 12-06-2026
---

# Classification (Supervised Learning)

> [!check] Verified
> Confirmed via [Wikipedia: Training, validation, and test data sets](https://en.wikipedia.org/wiki/Training,_validation,_and_test_data_sets) and [IBM: What Is Supervised Learning?](https://www.ibm.com/think/topics/supervised-learning)

## The Core Idea

Classification is a **supervised learning** task. Given a collection of records (the **training set**), where each record has a set of **attributes** and one designated attribute is the **class**, the goal is to find a **model** — a mapping from attributes to class — that assigns the correct class to **previously unseen** records as accurately as possible. A separate **test set** (records the model never saw during training) is used to measure how accurate that model actually is.

## Intuition: Learning With an Answer Key, Then Taking a Closed-Book Exam

Think of the training set as a study guide with an answer key attached to every question (each record's class label). The model "studies" this guide, looking for patterns that connect the question (attributes) to the answer (class). The test set is then a closed-book exam: new questions in the same style, but **without the answer key visible to the model** — only used afterwards to grade how well it learned the underlying pattern rather than just memorising the study guide.

This is also the dividing line between **supervised** and **unsupervised** learning: in classification the "answer key" (class label) is provided during training; in [[K-Means Clustering|clustering]]-style tasks it isn't — the model only groups similar records together without being told what the groups *mean*.

## Worked Example: Credit Risk Classification

The lecture's running example: customers are described by attributes such as **income, debt level, employment history**, etc. Historical records of customers and their loan repayment outcomes form the training set, where the class attribute is something like `{Good Risk, Poor Risk}`. A classifier (e.g. [[Naive Bayes Classifier]], [[Decision Trees and Information Gain|Decision Tree]], or [[K-Nearest Neighbors (KNN)|k-NN]]) is trained on this historical data, then used to classify **new** loan applicants who don't yet have a known outcome.

Other classic applications mentioned in the lecture: direct marketing (predict `{buy, don't buy}`), fraud detection (`{fraud, honest}`), customer churn (`{loyal, disloyal}`), and sky-survey object cataloguing (`{star, galaxy}`) — in every case, the pattern is the same: historical labelled data → trained model → predictions on new, unlabelled data.

## In Practice: Train/Test Split and a Classifier (scikit-learn)

```python
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score

# X = attributes (features), y = class labels
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

model = DecisionTreeClassifier()
model.fit(X_train, y_train)            # "study" the training set

predictions = model.predict(X_test)    # "exam": predict on unseen records
print(accuracy_score(y_test, predictions))
```

The same train/predict/evaluate shape applies regardless of which classifier (`DecisionTreeClassifier`, `GaussianNB`, `KNeighborsClassifier`, ...) is plugged in — this is the common interface that makes scikit-learn classifiers interchangeable.

## Two Kinds of "Structural Description"

The lecture distinguishes two ways a classifier's learned model can be expressed:

- **If-then rules** — e.g. *"If tear production rate = reduced then recommendation = none"*. Easy to read individually, but a full rule set can be large.
- **Decision trees** — the same kind of logic arranged as a tree of attribute tests, where each path from root to leaf corresponds to one rule. See [[Decision Trees and Information Gain]] for how these are built.

Both are **interpretable** representations — a human can inspect *why* the model reached a given prediction, unlike some other model types (e.g. neural networks).

## Common Pitfalls & Practical Tips

- **Never evaluate on the training set.** A model can trivially memorise its training data; accuracy on the training set tells you almost nothing about real-world performance. Always hold out a test set (see [[Overfitting and Underfitting]]).
- **Classification vs. numeric prediction** — if the "class" attribute is a continuous number rather than a category, the task becomes *numeric prediction* (e.g. [[Linear Regression and Numeric Prediction]]) rather than classification, and accuracy is no longer the right metric (use error measures instead).
- **Class imbalance matters.** If 99% of training records belong to one class, a model that always predicts that class gets 99% accuracy while being useless — see [[Confusion Matrix Metrics]] for metrics (precision, recall, F1) that handle this better than raw accuracy.

## Related Concepts

- [[Decision Trees and Information Gain]] — one structural description / classifier type.
- [[Naive Bayes Classifier]] — a probabilistic classifier for the same task.
- [[K-Nearest Neighbors (KNN)]] — an instance-based classifier.
- [[Confusion Matrix Metrics]] — how classifier accuracy is actually measured.
- [[Overfitting and Underfitting]] — why train/test separation matters.
- [[Linear Regression and Numeric Prediction]] — the analogous task when the target is numeric, not categorical.

**Source:** [Wikipedia: Training, validation, and test data sets](https://en.wikipedia.org/wiki/Training,_validation,_and_test_data_sets); [IBM: What Is Supervised Learning?](https://www.ibm.com/think/topics/supervised-learning)
