---
title: Softmax Function
type: concept
sources: [https://www.geeksforgeeks.org/deep-learning/categorical-cross-entropy-in-multi-class-classification/]
related: [Activation Functions, Loss Functions, Confusion Matrix Metrics]
created: 12-06-2026
last-updated: 12-06-2026
---

# Softmax Function

> [!check] Verified
> Confirmed via [GeeksforGeeks: Categorical Cross-Entropy in Multi-Class Classification](https://www.geeksforgeeks.org/deep-learning/categorical-cross-entropy-in-multi-class-classification/).

## The Core Idea

Softmax converts a vector of raw scores ("logits") into a probability distribution — a vector of values between 0 and 1 that **sum to exactly 1**. For class `i` out of `k` classes, given logits `z_1, ..., z_k`:

```
softmax(z_i) = e^(z_i) / Σ_j e^(z_j)    (sum over j = 1 to k)
```

The final layer of a multi-class classification network (e.g., a CNN classifying an image into one of `k` classes) applies softmax to its raw output to produce these per-class probabilities — this is exactly the "fully connected layer outputs a vector of k dimensions... containing the probabilities for each class" described in [[Convolutional Neural Networks (CNN)|CNN]] classification heads.

## Intuition: "Squashing" Scores into a Competition

Think of the raw logits as "votes" for each class — a CNN might output `[2.0, 0.5, -1.0]` for classes `[cat, dog, bird]`. These numbers are hard to interpret directly — what does "2.0" mean? Softmax converts them into something interpretable: `[0.78, 0.17, 0.05]` — "78% confident it's a cat."

**Why exponentiate?** Exponentiation (`e^x`) is always positive (handling negative logits) and *amplifies differences* — a logit of 2.0 vs 0.5 becomes `e^2 ≈ 7.4` vs `e^0.5 ≈ 1.6`, a much bigger relative gap than 2.0 vs 0.5. This makes softmax "confident" outputs genuinely peak around the highest logit, while still assigning *some* probability to every class (never exactly 0, since `e^x > 0` always) — useful because it keeps the function smooth and differentiable everywhere, which [[Backpropagation]] needs.

**Why divide by the sum?** This is the "normalisation" step that ensures the outputs sum to 1, so they can be interpreted as a probability distribution.

## Sigmoid vs. Softmax — When to Use Which

- **[[Activation Functions|Sigmoid]]**: for **binary** classification (2 classes) — one output number, interpreted as P(class=1). P(class=0) is implicitly `1 - sigmoid_output`.
- **Softmax**: for **multi-class** classification (3+ mutually exclusive classes) — `k` output numbers, all summing to 1.

Sigmoid is actually a special case: softmax over 2 classes mathematically reduces to sigmoid applied to the *difference* of the two logits.

## In Practice: Softmax in PyTorch (and Why You Rarely Call It Directly)

```python
import torch
import torch.nn.functional as F

logits = torch.tensor([2.0, 0.5, -1.0])
probs = F.softmax(logits, dim=-1)
print(probs)  # tensor([0.7869, 0.1755, 0.0379]) -- sums to 1.0
```

**However**, when training, you almost never apply `softmax` yourself before computing the loss:

```python
import torch.nn as nn

model = nn.Sequential(
    nn.Linear(64, 32), nn.ReLU(),
    nn.Linear(32, 3),   # 3 classes -- output RAW LOGITS, no softmax here
)

loss_fn = nn.CrossEntropyLoss()  # applies softmax + log + negative-log-likelihood
                                   # internally, in one numerically stable step

logits = model(x)
loss = loss_fn(logits, target)  # target: integer class index, e.g. tensor([0, 2, 1])
```

`nn.CrossEntropyLoss` combines softmax and the [[Loss Functions|log loss]] internally using a numerically stable formula (`log_softmax` avoids computing `e^x` for very large `x`, which can overflow). You only call `F.softmax` explicitly when you need actual *probabilities* for output/interpretation (e.g., displaying "78% confident") — not during training.

## Common Pitfalls & Practical Tips

- **Don't apply `softmax` AND use `nn.CrossEntropyLoss`** — this double-applies softmax, distorting the loss landscape and typically hurting training. This is one of the most common PyTorch classification bugs (see also [[Activation Functions]] and [[Loss Functions]]).
- **`dim=-1`** (or whichever dimension holds the per-class scores) — softmax must be applied across the *class* dimension, not the batch dimension. For a `[batch_size, num_classes]` tensor, that's `dim=-1` (or `dim=1`).
- **Overflow with large logits** — naive softmax computes `e^z` for potentially large `z`, which can overflow to `inf`. PyTorch's `F.softmax` and `nn.CrossEntropyLoss` handle this internally via the "log-sum-exp trick" — another reason to use the built-in functions rather than implementing softmax from the raw formula yourself.

## Related Concepts

- [[Activation Functions]] — softmax is the multi-class generalisation of sigmoid
- [[Loss Functions]] — softmax + log loss = cross-entropy, the standard multi-class classification loss
- [[Confusion Matrix Metrics]] — the probabilities softmax produces are thresholded/argmax'd to get the predicted class for these metrics

**Source:** [GeeksforGeeks: Categorical Cross-Entropy in Multi-Class Classification](https://www.geeksforgeeks.org/deep-learning/categorical-cross-entropy-in-multi-class-classification/)
