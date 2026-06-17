---
title: Universal Approximation Theorem
type: concept
sources: [https://en.wikipedia.org/wiki/Universal_approximation_theorem, https://neuron.eng.wayne.edu/tarek/MITbook/chap2/2_3.html]
related: [Multilayer Perceptron (MLP), Activation Functions]
created: 12-06-2026
last-updated: 12-06-2026
---

# Universal Approximation Theorem

> [!warning] Flagged
> The source lecture attributes this result to a "Kolmogorov Theorem" (citing Duda, Hart & Stork, 2000) with a nested-sum formula. That formula matches **Kolmogorov's superposition theorem (1957)** — a result about representing continuous multivariate functions as sums/compositions of continuous univariate functions. The result specifically about **neural networks** (MLPs with one hidden layer) is the **Universal Approximation Theorem**, proven by Cybenko (1989) and generalised by Hornik (1991). Kolmogorov's theorem is considered a precursor/inspiration for the neural-network-specific theorems. Both are verified via [Wikipedia](https://en.wikipedia.org/wiki/Universal_approximation_theorem) and a [neural networks textbook reference](https://neuron.eng.wayne.edu/tarek/MITbook/chap2/2_3.html).

## What It Says

A feedforward network with a single hidden layer, using a non-polynomial activation function (e.g., sigmoid or ReLU — see [[Activation Functions]]), and enough hidden units, can approximate any continuous function on a compact input domain to arbitrary accuracy.

In other words: [[Multilayer Perceptron (MLP)|MLPs]] are not limited to a narrow class of functions — given enough hidden units and the right weights, they can represent essentially any reasonable continuous function.

## Intuition: Building Any Shape from Simple "Bumps"

A loose but useful intuition: each hidden neuron with a sigmoid (or ReLU) activation produces a smooth "step" or "ramp" shape as its output, positioned and scaled by its weights and bias. The output layer combines these shapes by weighted summation.

Think of it like building an arbitrary curve out of LEGO bricks of different sizes — each hidden neuron contributes one "brick" (a step/ramp at some position with some height/steepness), and with *enough* bricks, you can approximate *any* smooth curve, no matter how wiggly. The theorem formalises this: it guarantees that for any target function and any desired accuracy, *some* number of "bricks" (hidden units) suffices.

## In Practice: Watching an MLP Approximate a Function

```python
import torch
import torch.nn as nn
import numpy as np
import matplotlib.pyplot as plt

# Target function: something an MLP has no "built-in" knowledge of
x = torch.linspace(-2 * np.pi, 2 * np.pi, 200).unsqueeze(1)
y = torch.sin(x) + 0.3 * x  # an arbitrary nonlinear function

# A small MLP -- ONE hidden layer, per the theorem's classic statement
model = nn.Sequential(
    nn.Linear(1, 50),  # 50 "bricks" (hidden units)
    nn.Tanh(),
    nn.Linear(50, 1),
)

optimizer = torch.optim.Adam(model.parameters(), lr=0.01)
loss_fn = nn.MSELoss()

for epoch in range(2000):
    optimizer.zero_grad()
    pred = model(x)
    loss = loss_fn(pred, y)
    loss.backward()
    optimizer.step()

# Plot target vs. learned approximation
plt.plot(x.numpy(), y.numpy(), label="True function")
plt.plot(x.numpy(), model(x).detach().numpy(), label="MLP approximation")
plt.legend()
plt.show()
```

With enough hidden units (try changing `50` to `5` vs `500`) and enough training, the MLP's output curve converges toward the true function — a direct, visual demonstration of the theorem. **Try `5` hidden units** — you'll see the approximation is much rougher; the theorem guarantees *some* number of units suffices, but doesn't tell you it's a *small* number.

## Why It Matters (and Its Limits)

- **It's an existence proof, not a recipe.** The theorem says a network *capable* of approximating the function exists — it doesn't say how many hidden units are needed in practice, or how to find the right weights via training. (As the experiment above shows, "enough units" can mean very different things depending on the function's complexity.)
- **It motivates depth in practice.** While a single sufficiently-wide hidden layer is theoretically enough, in practice deep networks (many narrower layers) tend to learn useful representations more efficiently than very wide shallow ones — depth lets the network compose simple features into complex ones hierarchically (see [[Deep Learning]]'s "selectivity and invariance" framing).
- **It's the theoretical justification** for why neural networks are used as general-purpose function approximators across so many domains — but "can approximate" doesn't mean "will learn to, easily, from finite data." Training dynamics, [[Overfitting and Underfitting|overfitting]], and optimisation difficulty are separate, very real practical concerns the theorem says nothing about.

## Related Concepts

- [[Multilayer Perceptron (MLP)]]
- [[Activation Functions]]

**Source:** [Wikipedia: Universal approximation theorem](https://en.wikipedia.org/wiki/Universal_approximation_theorem)
