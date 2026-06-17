---
title: Confusion Matrix Metrics
type: concept
sources: [https://developers.google.com/machine-learning/crash-course/classification/accuracy-precision-recall, raw/lecture-notes/COMP723/Lecture8.pptx, https://en.wikipedia.org/wiki/Precision_and_recall]
related: [Neural Network Training Workflow, Loss Functions]
created: 12-06-2026
last-updated: 13-06-2026
---

# Confusion Matrix Metrics

> [!check] Verified
> Confirmed via [Google ML Crash Course: Accuracy, precision, and recall](https://developers.google.com/machine-learning/crash-course/classification/accuracy-precision-recall)

## The Core Idea

For a binary classifier, every prediction falls into one of four outcomes — the **confusion matrix**:

| | Predicted Positive | Predicted Negative |
|---|---|---|
| **Actual Positive** | True Positive (TP) — hit | False Negative (FN) — miss |
| **Actual Negative** | False Positive (FP) — false alarm | True Negative (TN) — correct rejection |

## Derived Metrics

- **TPR (True Positive Rate / Recall):** `TPR = TP / (TP + FN)`
  Of all actual positives, how many did the model correctly identify?

- **FPR (False Positive Rate):** `FPR = FP / (FP + TN)`
  Of all actual negatives, how many did the model incorrectly flag as positive?

- **PPV (Positive Predictive Value / Precision):** `PPV = TP / (TP + FP)`
  Of everything the model flagged as positive, how many actually were?

- **ACC (Accuracy):** `ACC = (TP + TN) / (P + N)`
  Overall fraction of correct predictions (P = total actual positives, N = total actual negatives).

- **F1 Score:** `F1 = 2·TP / (2·TP + FP + FN)`
  The harmonic mean of precision and recall — useful when classes are imbalanced and accuracy alone would be misleading.

## Intuition: Precision vs. Recall Is a Trade-off, Not Independent Choices

Imagine a spam filter:
- **High precision, low recall**: very cautious — only flags emails it's *very* confident are spam. Few false alarms (good emails marked as spam are rare), but lots of actual spam slips through to your inbox (low recall — many spam emails are missed/FN).
- **High recall, low precision**: very aggressive — flags almost anything suspicious as spam. Catches nearly all spam (high recall), but also flags many legitimate emails as spam (low precision — many FP).

You can usually shift this trade-off by changing the **classification threshold** (e.g., "flag as spam if predicted probability > 0.5" vs. "> 0.9"). Raising the threshold → fewer things flagged → higher precision, lower recall. Lowering it → opposite. **There is no single "correct" threshold** — it depends on the relative cost of false positives vs. false negatives in your specific application (e.g., for cancer screening, missing a real case (FN) is usually far worse than a false alarm (FP), so you'd tolerate lower precision for higher recall).

## Why Not Just Use Accuracy?

Accuracy can be wildly misleading on imbalanced datasets. Consider a dataset where 99% of examples are "negative" (e.g., "no fraud"). A model that *always* predicts "negative", regardless of input, achieves **99% accuracy** — yet it has 0% recall (catches zero actual fraud cases) and is completely useless. This is exactly why [[Loss Functions|loss function]] and *evaluation metric* choice both matter, and why F1/precision/recall exist as alternatives to accuracy.

## In Practice: scikit-learn (Python)

```python
from sklearn.metrics import confusion_matrix, classification_report, roc_curve, auc
import numpy as np

y_true = [0, 1, 1, 0, 1, 0, 1, 1, 0, 0]
y_pred = [0, 1, 0, 0, 1, 1, 1, 1, 0, 0]

# Confusion matrix: rows = actual, cols = predicted
cm = confusion_matrix(y_true, y_pred)
print(cm)
# [[TN, FP],
#  [FN, TP]]

# All the derived metrics at once
print(classification_report(y_true, y_pred, target_names=["negative", "positive"]))

# ROC curve: TPR vs FPR across all thresholds
y_scores = [0.1, 0.9, 0.4, 0.2, 0.8, 0.6, 0.95, 0.7, 0.05, 0.3]  # predicted probabilities
fpr, tpr, thresholds = roc_curve(y_true, y_scores)
print(f"AUC = {auc(fpr, tpr):.3f}")
```

`classification_report` prints precision, recall, F1, and support (number of examples) for each class — usually the fastest way to get a full picture of classifier performance beyond a single accuracy number.

## The ROC Curve

The **ROC curve** (Receiver Operating Characteristic) plots TPR against FPR across different classification thresholds, visualising the trade-off between catching positives and triggering false alarms. The **AUC** (Area Under the Curve) summarises this into a single number: AUC = 1.0 is a perfect classifier, AUC = 0.5 is no better than random guessing.

## Sensitivity, Specificity, and the General F-measure (Fβ) (COMP723, Lecture 8)

Medical/diagnostic literature (and the COMP723 text mining evaluation lecture) uses slightly different names for two of the metrics above:

- **Sensitivity** = **TPR** = **Recall** = `TP / (TP + FN)`.
- **Specificity** = **TNR (True Negative Rate)** = `TN / (TN + FP)` = `1 - FPR`.

A plot of **sensitivity vs. specificity** (or equivalently TPR vs. FPR) across thresholds is exactly the [[Confusion Matrix Metrics|ROC curve]] above — it measures how well a classifier can pick out a (usually smaller) class, such as "sick" individuals, from a population of "well" individuals.

**F1** is a special case of the more general **Fβ measure**, which weights recall `β` times as important as precision:

```
F_β = (1 + β²) · (Precision · Recall) / (β² · Precision + Recall)
```

- `β = 1` → **F1**, the harmonic mean (recall and precision weighted equally).
- `β > 1` (e.g. F2) → recall matters more than precision.
- `β < 1` (e.g. F0.5) → precision matters more than recall.

**Worked exercise (Lecture 8)**: a classifier sorts 250 relevant and 750 non-relevant documents. It correctly classifies 150 relevant documents (TP=150, FN=100) and 720 non-relevant documents (TN=720, FP=30). From this confusion matrix: `Precision = 150/180 ≈ 0.83`, `Recall (Sensitivity) = 150/250 = 0.6`, `Specificity = 720/750 = 0.96`, `Accuracy = (150+720)/1000 = 0.87`.

## Common Pitfalls & Practical Tips

- **Always check class balance first.** `y.value_counts()` (pandas) or `np.bincount(y)` — if one class dominates, accuracy alone will be misleading and F1/precision/recall become essential.
- **Macro vs. weighted averages for multi-class.** `classification_report` and similar functions offer `average='macro'` (treats all classes equally, regardless of size) vs `average='weighted'` (accounts for class imbalance) — pick based on whether rare classes matter as much as common ones for your application.
- **Confusion matrix rows/columns convention varies** — some libraries put "actual" on rows and "predicted" on columns, others the reverse. Always check the documentation/labels rather than assuming.

## Related Concepts

- [[Neural Network Training Workflow]]
- [[Loss Functions]]

**Source:** [Google ML Crash Course: Accuracy, precision, and recall](https://developers.google.com/machine-learning/crash-course/classification/accuracy-precision-recall)
