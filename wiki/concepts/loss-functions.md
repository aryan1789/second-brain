---
title: Loss Functions
type: concept
sources: [Goodfellow, I., Bengio, Y., Courville, A. (2016). Deep Learning. MIT Press.]
related: [Backpropagation, Stochastic Gradient Descent (SGD), Confusion Matrix Metrics, Activation Functions]
created: 12-06-2026
last-updated: 12-06-2026
---

# Loss Functions

## The Core Idea

A loss function `L(Y, f(X))` measures how wrong a model's prediction `f(X)` is compared to the true value `Y`. Training (via [[Backpropagation]] and [[Stochastic Gradient Descent (SGD)|SGD]]) adjusts model parameters to minimise this loss.

## Intuition: The Loss Function Defines What "Good" Means

The loss function is arguably the most important design decision in a project — it's the **only thing the model is actually trying to optimise**. Everything else (architecture, training procedure) just determines *how well* the model can minimise this specific number. If the loss doesn't reflect what you actually care about, the model will dutifully optimise the wrong thing.

**Example:** if you train a medical diagnosis model with plain accuracy/0-1 loss on a dataset where 99% of patients are healthy, a model that *always* predicts "healthy" gets 99% accuracy/very low loss — while being clinically useless (it never catches the 1% who are sick). This is why loss function choice connects directly to [[Confusion Matrix Metrics]] — sometimes the *training* loss and the *evaluation* metric you actually care about need to be different things.

## Common Loss Functions

- **0-1 loss:** `L(Y, f(X)) = 0` if `Y = f(X)`, else `1`.
  Directly counts mistakes. Not differentiable (it's a step function — flat everywhere except a jump, so its gradient is zero or undefined), so rarely used to *train* models directly via gradient descent — but it's conceptually what classification **accuracy** measures.

- **Square loss (MSE — Mean Squared Error):** `L(Y, f(X)) = (Y - f(X))²`
  Penalises larger errors disproportionately more (an error of 2 contributes 4x the loss of an error of 1). Common for regression.

- **Absolute loss (MAE — Mean Absolute Error):** `L(Y, f(X)) = |Y - f(X)|`
  Penalises errors linearly. More robust to outliers than square loss — a single huge error doesn't dominate the total loss as much.

- **Logarithm (log) loss / Cross-Entropy:** `L(Y, p(Y|X)) = -log p(Y|X)`
  Used when the model outputs a probability. Heavily penalises confident-but-wrong predictions — e.g., if the true label is "1" and the model predicts probability 0.01 for "1", `-log(0.01) ≈ 4.6` (a large penalty); if it predicts 0.49, `-log(0.49) ≈ 0.7` (a much smaller penalty), even though both predictions are "wrong" under 0-1 loss.

## Average Loss (Empirical Risk)

In practice, a model is trained to minimise the **average loss** over the training set:

```
L = (1/m) · Σ L(x_i, y_i),  for i = 1 to m
```

where `T = {(x_i, y_i)}` for `i = 1, ..., m` is the training set of `m` examples. This average is what [[Stochastic Gradient Descent (SGD)|SGD]] actually minimises (or an estimate of it, from a mini-batch).

## In Practice: PyTorch Loss Functions and When to Use Each

```python
import torch.nn as nn

# REGRESSION -- predicting a continuous number
mse_loss = nn.MSELoss()   # square loss -- default for regression
mae_loss = nn.L1Loss()    # absolute loss -- use if you have outliers
# preds and targets: shape [batch_size, 1] or [batch_size]

# BINARY CLASSIFICATION -- predicting one of two classes
bce_loss = nn.BCEWithLogitsLoss()  # log loss; takes RAW logits (applies sigmoid internally)
# preds: shape [batch_size, 1] (raw logits), targets: shape [batch_size, 1], values 0.0 or 1.0

# MULTI-CLASS CLASSIFICATION -- predicting one of N classes
ce_loss = nn.CrossEntropyLoss()  # log loss; takes RAW logits (applies softmax internally)
# preds: shape [batch_size, num_classes] (raw logits)
# targets: shape [batch_size], values are integer class indices (NOT one-hot!)
```

**A very common bug:** `nn.CrossEntropyLoss` expects integer class *indices* as targets (e.g., `tensor([2, 0, 1])` for a 3-class problem), NOT one-hot vectors (`tensor([[0,0,1],[1,0,0],[0,1,0]])`). Passing one-hot targets either errors or silently produces wrong results depending on PyTorch version.

## Common Pitfalls & Practical Tips

- **Match the loss to the output activation** (see [[Activation Functions]]): `nn.CrossEntropyLoss`/`nn.BCEWithLogitsLoss` expect *raw logits* (no sigmoid/softmax applied in the model) — they apply it internally for numerical stability. Applying softmax yourself AND using these losses double-applies it.
- **MSE vs MAE**: MSE punishes large errors heavily (good if large errors are especially bad in your application; bad if your data has outliers that would dominate training). MAE treats all error sizes proportionally.
- **The loss you train on isn't always the metric you report.** You might train with cross-entropy loss (smooth, differentiable, good for gradient descent) but *evaluate* using [[Confusion Matrix Metrics|F1 score or precision/recall]] (better reflects real-world performance on imbalanced data).

## Related Concepts

- [[Backpropagation]]
- [[Stochastic Gradient Descent (SGD)]]
- [[Confusion Matrix Metrics]]

**Source:** Goodfellow, I., Bengio, Y., Courville, A. (2016). *Deep Learning*. MIT Press.
