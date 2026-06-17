---
title: Multilayer Perceptron (MLP)
type: concept
sources: [https://en.wikipedia.org/wiki/Multilayer_perceptron]
related: [Artificial Neural Networks (ANN), Backpropagation, Deep Neural Networks (DNN), Universal Approximation Theorem, Activation Functions]
created: 12-06-2026
last-updated: 12-06-2026
---

# Multilayer Perceptron (MLP)

## The Core Idea

A Multilayer Perceptron (MLP) is a class of **feedforward** [[Artificial Neural Networks (ANN)|artificial neural network]].

## Structure

- At least three layers of nodes: an **input layer**, one or more **hidden layers**, and an **output layer**
- Except for input nodes, every node is a neuron using a **nonlinear** [[Activation Functions|activation function]]
- "Feedforward" means information flows in one direction — input → hidden layers → output — with no cycles (contrast with [[Recurrent Neural Networks (RNN)|RNNs]], which feed information back to themselves)

## Intuition: Why a Single Layer Isn't Enough — The XOR Problem

The classic illustration of why MLPs need *hidden* layers is the **XOR (exclusive OR)** function:

| Input A | Input B | XOR Output |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

Plot these four points on a 2D grid with A and B as axes, coloured by output. **No single straight line can separate the "1" outputs from the "0" outputs** — they're arranged diagonally. A single neuron (which can only draw a straight-line boundary, per [[Artificial Neural Networks (ANN)]]) *cannot* learn XOR. This was a famous limitation of early single-layer "perceptrons" in the 1960s.

**A hidden layer fixes this.** With even 2 hidden neurons, each can learn a different linear boundary (e.g., one neuron learns "A OR B", another learns "A AND B"), and the output neuron combines these into "A OR B, but NOT (A AND B)" — exactly XOR. This is the core reason MLPs **can distinguish data that is not linearly separable**, while single-layer perceptrons cannot.

## Training

MLPs use a **supervised learning** technique called [[Backpropagation]] for training — the network is shown labelled examples (inputs with known correct outputs) and adjusts its weights to reduce prediction error.

## In Practice: Solving XOR with an MLP (PyTorch)

```python
import torch
import torch.nn as nn

# The 4 XOR examples
X = torch.tensor([[0.,0.], [0.,1.], [1.,0.], [1.,1.]])
y = torch.tensor([[0.], [1.], [1.], [0.]])

# An MLP with ONE hidden layer of 2 neurons -- just enough for XOR
model = nn.Sequential(
    nn.Linear(2, 2),   # input layer -> hidden layer (2 neurons)
    nn.Tanh(),         # nonlinear activation -- REQUIRED, see below
    nn.Linear(2, 1),   # hidden layer -> output layer
    nn.Sigmoid(),      # output in (0,1), interpretable as probability
)

loss_fn = nn.BCELoss()  # binary cross-entropy
optimizer = torch.optim.Adam(model.parameters(), lr=0.05)

for epoch in range(2000):
    optimizer.zero_grad()
    pred = model(X)
    loss = loss_fn(pred, y)
    loss.backward()
    optimizer.step()

print(model(X).round())  # should approximate [[0],[1],[1],[0]]
```

**Try removing both `nn.Tanh()` calls** (leaving just two stacked `Linear` layers) and re-run — the model will fail to learn XOR, no matter how long you train it. Two stacked linear layers *with no nonlinearity between them* are mathematically equivalent to a single linear layer — depth without nonlinearity adds no expressive power. This is a hands-on demonstration of why [[Activation Functions|nonlinear activations]] are essential, not optional.

## Why MLPs Matter

Because of their nonlinear activation functions, MLPs can **distinguish data that is not linearly separable** — unlike a single-layer perceptron. This nonlinearity, combined with enough hidden units, underlies the [[Universal Approximation Theorem]]: MLPs can approximate a very broad class of functions.

## Common Pitfalls & Practical Tips

- **"At least three layers"** — input, hidden, output. People sometimes say "a 2-layer network" meaning 2 layers *of weights* (input→hidden and hidden→output) — terminology around layer-counting is inconsistent across sources, so pay attention to context.
- **Hidden layer size is a hyperparameter you choose** — too few units and the network underfits (can't represent the needed function, see [[Overfitting and Underfitting]]); too many and it's prone to overfitting and slower to train.
- **MLPs treat input as an unordered flat vector** — they have no built-in notion of spatial structure (unlike [[Convolutional Neural Networks (CNN)|CNNs]]) or sequence order (unlike [[Recurrent Neural Networks (RNN)|RNNs]]). For images/sequences, MLPs are usually a *component* (e.g., the final classification layers) rather than the whole architecture.

## Related Concepts

- [[Artificial Neural Networks (ANN)]]
- [[Backpropagation]]
- [[Deep Neural Networks (DNN)]]
- [[Universal Approximation Theorem]]

**Source:** [Wikipedia: Multilayer perceptron](https://en.wikipedia.org/wiki/Multilayer_perceptron)
