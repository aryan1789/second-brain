---
title: Activation Functions
type: concept
sources: [Kasabov, N. (1996). Foundations of Neural Networks, Fuzzy Systems, and Knowledge Engineering. MIT Press., https://www.geeksforgeeks.org/machine-learning/activation-functions-neural-networks/]
related: [Artificial Neural Networks (ANN), Multilayer Perceptron (MLP), Backpropagation]
created: 12-06-2026
last-updated: 12-06-2026
---

# Activation Functions

> [!check] Verified
> Confirmed via [GeeksforGeeks: Activation Functions in Neural Networks](https://www.geeksforgeeks.org/machine-learning/activation-functions-neural-networks/).

## The Core Idea

An activation function `f` is applied to a neuron's net input `n` to produce its output: `a = f(n)`. Activation functions introduce **nonlinearity** — without them, a multilayer network would collapse into an equivalent single linear transformation, regardless of depth (see the XOR example in [[Multilayer Perceptron (MLP)]] for a hands-on demonstration of why this matters).

## Common Activation Functions

- **ReLU (Rectified Linear Unit):** `f(x) = max(0, x)`
  Outputs zero for negative inputs and the input itself for positive inputs. Widely used in deep networks because it avoids the vanishing gradient problem and is computationally cheap.

- **Tanh (Hyperbolic Tangent):** `f(x) = (e^x - e^-x) / (e^x + e^-x)`
  Outputs values in `(-1, 1)`. Zero-centred, which helps gradients flow better than sigmoid in some cases, but can still suffer from vanishing gradients in deep networks.

- **Sigmoid (Logistic function):** `f(x) = 1 / (1 + e^-x)`
  Outputs values in `(0, 1)`, often used for binary classification output layers (interpretable as a probability). Prone to vanishing gradients in deep networks.

## Intuition: Visualising the Shapes and Their Gradients

```python
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(-5, 5, 200)

relu = np.maximum(0, x)
tanh = np.tanh(x)
sigmoid = 1 / (1 + np.exp(-x))

fig, axes = plt.subplots(1, 3, figsize=(12, 3))
for ax, (name, y) in zip(axes, [("ReLU", relu), ("Tanh", tanh), ("Sigmoid", sigmoid)]):
    ax.plot(x, y)
    ax.set_title(name)
    ax.axhline(0, color='gray', linewidth=0.5)
plt.tight_layout()
plt.show()
```

Run this and look at the **slopes**:
- **ReLU**: slope is exactly 0 for `x < 0`, exactly 1 for `x > 0`. A neuron with a positive net input always passes gradient through *unchanged* during [[Backpropagation]] — no shrinking.
- **Tanh / Sigmoid**: both are S-shaped curves that **flatten out** at the extremes (very negative or very positive `x`). Where the curve is flat, its slope (gradient) is close to **zero**. If many neurons in a deep network operate in these flat regions, the gradient gets multiplied by near-zero values repeatedly during backpropagation — this is the **vanishing gradient problem**, and it's the single biggest practical reason ReLU became the default for hidden layers.

## Why the Choice Matters

[[Backpropagation]] relies on gradients flowing back through every layer. Sigmoid and tanh **saturate** (their gradients approach zero) for large positive or negative inputs, which can cause gradients to vanish in deep networks — slowing or stalling training. ReLU's constant gradient for positive inputs largely avoids this, which is a major reason it became the default choice for hidden layers in modern deep networks.

## In Practice: Where Each Function Typically Goes (PyTorch)

```python
import torch.nn as nn

model = nn.Sequential(
    nn.Linear(20, 64),
    nn.ReLU(),              # hidden layers: ReLU is the default choice
    nn.Linear(64, 32),
    nn.ReLU(),
    nn.Linear(32, 1),
    nn.Sigmoid(),           # OUTPUT layer for binary classification:
                            # squashes to (0,1), interpretable as a probability
)

# For MULTI-class classification, the output layer typically has NO activation
# here -- nn.CrossEntropyLoss applies softmax internally for numerical stability.
multiclass_model = nn.Sequential(
    nn.Linear(20, 64), nn.ReLU(),
    nn.Linear(64, 10),   # 10 classes -- raw "logits", softmax applied by the loss
)
```

## Common Pitfalls & Practical Tips

- **"Dying ReLU" problem.** If a neuron's net input is *always* negative across the whole dataset, its ReLU output is always 0, its gradient is always 0, and it never updates again — effectively a "dead" neuron. Variants like **Leaky ReLU** (`f(x) = max(0.01x, x)`) give a small negative slope to avoid this.
- **Don't apply sigmoid/softmax AND use a loss function that expects raw logits.** `nn.CrossEntropyLoss` and `nn.BCEWithLogitsLoss` apply softmax/sigmoid internally for numerical stability — applying it twice (once in the model, once in the loss) is a common bug that subtly hurts training.
- **Sigmoid for binary output, softmax (via CrossEntropyLoss) for multi-class, nothing for regression output** — a quick rule of thumb for output-layer activation choice (see [[Loss Functions]] for the matching loss function in each case).

**Source:** Kasabov, N. (1996). *Foundations of Neural Networks, Fuzzy Systems, and Knowledge Engineering*. MIT Press; [GeeksforGeeks](https://www.geeksforgeeks.org/machine-learning/activation-functions-neural-networks/)
