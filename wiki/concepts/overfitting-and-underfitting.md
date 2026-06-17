---
title: Overfitting and Underfitting
type: concept
sources: [https://stats.stackexchange.com/questions/306574/which-elements-of-a-neural-network-can-lead-to-overfitting, raw/lecture-notes/COMP723/Lecture5.pptx]
related: [Neural Network Training Workflow, Multilayer Perceptron (MLP), Data Augmentation, Loss Functions]
created: 12-06-2026
last-updated: 12-06-2026
---

# Overfitting and Underfitting

> [!check] Verified
> Confirmed via [Cross Validated: Which elements of a Neural Network can lead to overfitting?](https://stats.stackexchange.com/questions/306574/which-elements-of-a-neural-network-can-lead-to-overfitting)

## The Core Idea

A model's capacity — roughly, how complex a function it can represent — needs to be matched to the problem. Too little capacity or too much both cause problems, but in opposite ways.

## Underfitting

When a model has **too few neurons/parameters** (or is trained too little), it cannot capture the underlying pattern in the data. The model performs poorly on both training and new data because it's too simple to represent the true relationship.

## Overfitting

When a model has **too many neurons/parameters** relative to the amount of training data, it can fit the training data extremely well — including its noise — while generalising poorly to new data. A telltale sign is a fitting curve that **oscillates wildly** between training points, fitting every point exactly but behaving erratically in between.

## Intuition: Memorising vs. Understanding

Imagine studying for an exam by memorising the *exact wording* of every practice question and its answer, vs. understanding the *underlying concepts*.

- **Underfitting** is like not studying enough — you can't answer practice questions OR the real exam, because you haven't learned the pattern at all.
- **Overfitting** is like memorising practice questions verbatim — you'd score 100% if the real exam used the *exact same questions*, but if even slightly reworded, you're lost, because you never learned the underlying concept, just the specific examples.
- **Good fit** is like actually understanding the material — you do reasonably well on practice questions AND can generalise to new ones you haven't seen.

In ML terms: training loss is "practice question performance," validation/test loss is "real exam performance" (on data the model hasn't seen during training).

## In Practice: Seeing It in a Training Curve

```python
import matplotlib.pyplot as plt

# After training, you'll typically have lists like:
# train_losses = [...]  -- one value per epoch
# val_losses = [...]    -- one value per epoch

plt.plot(train_losses, label="Train Loss")
plt.plot(val_losses, label="Validation Loss")
plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.legend()
plt.show()
```

**What to look for:**
- **Both curves high and flat** → underfitting. The model hasn't learned much; consider a bigger model, more features, or training longer.
- **Both curves decreasing together, similar values** → good fit (so far).
- **Train loss keeps decreasing, but validation loss starts increasing** → overfitting has begun. This is the point where the model starts memorising training-specific noise rather than learning generalisable patterns. This is exactly the signal the [[Neural Network Training Workflow|train/validation split]] is designed to surface.

## Detecting and Managing It

Common mitigations:

- **Reducing model size** (fewer neurons/layers) — directly reduces capacity
- **[[Data Augmentation]]** — effectively increases the amount/variety of training data
- **Regularisation techniques:**
  - **Dropout** (`nn.Dropout(p=0.5)`) — randomly "turns off" a fraction of neurons during each training step, forcing the network not to rely too heavily on any single neuron
  - **Weight decay** (`optimizer = torch.optim.Adam(model.parameters(), weight_decay=1e-4)`) — adds a penalty for large weights, encouraging simpler solutions
- **Early stopping** — halting training when validation error starts increasing, and keeping the model weights from the epoch with the *best* validation performance (not necessarily the last epoch)

```python
import torch.nn as nn

# Adding dropout to combat overfitting
model = nn.Sequential(
    nn.Linear(20, 64), nn.ReLU(), nn.Dropout(0.3),
    nn.Linear(64, 32), nn.ReLU(), nn.Dropout(0.3),
    nn.Linear(32, 1),
)
```

## Worked Example: Hidden-Layer Size and Overfitting (Diabetes Dataset)

A second lecture gives a concrete before/after comparison using an MLP on the Diabetes dataset:

- **300 hidden neurons** → **79% accuracy on training**, but only **71% on test** — a large train/test gap, indicating overfitting: the model has enough capacity to memorise quirks of the training set that don't generalise.
- **100 hidden neurons** → **76% accuracy on both training and test** — train and test accuracy are much closer together (and test accuracy is actually *higher* than in the 300-neuron case), indicating a better-generalising model.

This is a direct illustration of the "too many neurons/parameters" case above: more hidden neurons isn't automatically better — see [[Neural Network Training Workflow]]'s `(attributes + classes) / 2` heuristic for a starting point, then tune based on the train/test gap rather than training accuracy alone.

## Common Pitfalls & Practical Tips

- **Dropout only applies during training** — `model.train()` enables it, `model.eval()` disables it (PyTorch handles this automatically when you call these methods — but forgetting to call `model.eval()` before validation means dropout is still active, making validation results noisy/pessimistic).
- **More data is usually the best fix for overfitting** — if you can get more labelled data, it often beats every regularisation trick combined. Regularisation helps you do *more* with the data you have, but isn't a substitute for having enough.
- **A small gap between train and validation loss is normal and expected** — the goal isn't to make them identical, just to prevent validation loss from getting *worse* while training loss keeps improving.

## Related Concepts

- [[Neural Network Training Workflow]]
- [[Data Augmentation]]
- [[Loss Functions]]

**Source:** [Cross Validated: Which elements of a Neural Network can lead to overfitting?](https://stats.stackexchange.com/questions/306574/which-elements-of-a-neural-network-can-lead-to-overfitting)
