---
title: Artificial Neural Networks (ANN)
type: concept
sources: [Kasabov, N. (1996). Foundations of Neural Networks, Fuzzy Systems, and Knowledge Engineering. MIT Press., MATLAB Deep Learning Toolbox User's Guide, raw/lecture-notes/COMP723/Lecture5.pptx]
related: [Deep Neural Networks (DNN), Multilayer Perceptron (MLP), Activation Functions, Backpropagation, Stochastic Gradient Descent (SGD)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Artificial Neural Networks (ANN)

## The Core Idea

An Artificial Neural Network (ANN) is composed of simple computational elements (neurons) operating in parallel. ANNs are trained — i.e., their parameters are adjusted — so that a given input produces a desired target output. ANNs have been applied across pattern recognition, identification, classification, speech, vision, and control systems.

## The Neuron Model

A single neuron performs three operations:

1. **Weight function** — forms the product of input `p` and weight `w`: `wp` (scalar) or `W·p` (vector, for multiple inputs)
2. **Input function (net input)** — adds a bias `b`: `n = wp + b` (scalar) or `n = W·p + b` (vector)
3. **Transfer/activation function** — produces the output: `a = f(n)`, where `f` is a (typically nonlinear) [[Activation Functions|activation function]]

**The central idea:** the parameters `w` (weights) and `b` (biases) can be adjusted so the network exhibits desired behaviour — this adjustment process is *training* (see [[Backpropagation]]).

## Intuition: A Neuron Is a Tiny Decision-Maker

Think of a single neuron as answering a weighted yes/no question. Each input `p_i` is multiplied by a weight `w_i` that represents "how important is this input for my decision" — a large positive weight means "this input strongly pushes me toward 'yes'", a large negative weight means "this input strongly pushes me toward 'no'", and a near-zero weight means "I mostly ignore this input."

The bias `b` shifts the threshold — it's like saying "even with no inputs, I'm somewhat inclined toward yes/no by default."

The net input `n = W·p + b` sums up all this weighted evidence into a single number. The activation function `f` then converts that raw evidence score into the neuron's actual output — e.g., [[Activation Functions|ReLU]] says "if the evidence is negative, output zero (ignore this entirely); if positive, pass it through proportionally."

**A single neuron can only draw a straight-line (linear) decision boundary.** This is why one neuron alone is very limited — the power of neural networks comes from combining *many* neurons across *layers* (see [[Multilayer Perceptron (MLP)]]), where each layer's neurons can build on the previous layer's decisions to represent increasingly complex, nonlinear boundaries.

## In Practice: A Single Neuron, by Hand and in PyTorch

```python
import numpy as np
import torch.nn as nn
import torch

# --- By hand (numpy), to see exactly what's happening ---
p = np.array([0.5, -1.2, 0.3])   # 3 inputs
w = np.array([0.8, 0.4, -0.6])   # 3 weights (learned during training)
b = 0.1                           # bias

n = np.dot(w, p) + b              # net input: n = W.p + b
a = max(0, n)                     # ReLU activation: a = f(n)
print(f"net input n = {n:.3f}, output a = {a:.3f}")

# --- The same neuron in PyTorch ---
neuron = nn.Linear(in_features=3, out_features=1)  # the "weight function" + "input function"
activation = nn.ReLU()                              # the "transfer function"

p_tensor = torch.tensor([[0.5, -1.2, 0.3]])
a_tensor = activation(neuron(p_tensor))
```

`nn.Linear(3, 1)` IS the weight function + input function (`W·p + b`) — PyTorch initializes `W` and `b` randomly, and [[Backpropagation]] adjusts them during training. `nn.ReLU()` is the transfer function.

## From One Neuron to Layers

- **One layer of neurons** — a vector of neurons sharing the same inputs, each with its own weights/bias, producing a vector output `a = f(W·p + b)` (here `W` is a matrix — one row of weights per neuron)
- **Multiple layers** — layers are stacked so each layer's output feeds the next layer's input. This is the basis of [[Multilayer Perceptron (MLP)|multilayer]] architectures and, more generally, [[Deep Neural Networks (DNN)|DNNs]].

## Networks of McCulloch-Pitts Neurons, Weight Matrices, and the Perceptron (COMP723, Lecture 5)

A second lecture frames the same neuron model historically as the **McCulloch-Pitts neuron**: artificial neurons "have the same basic components as biological neurons" — a set of synapses bringing in activations from other neurons, a processing unit summing those inputs and applying a nonlinear [[Activation Functions|activation function]], and an output line transmitting the result onward. Networks of these neurons are labelled by indices `k`, `i`, `j`, with activation flowing between them via synapses of strength `w_ki`, `w_ij`.

### Worked Example: A 2-Layer Network

Given a hidden unit with net input `0.5(3) + -0.5(1)`:

```
f(0.5(3) + -0.5(1)) = f(1.5 - 0.5) = f(1) = 0.731
```

That hidden unit's activation (`0.731`) then feeds the output unit with weight `0.75`:

```
f(0.731 × 0.75) = f(0.548) = 0.634
```

(Here `f` is the [[Activation Functions|sigmoid]] function.) This is the neuron model from earlier in this page applied twice in sequence — exactly **"from one neuron to layers"**.

### Weight Matrices

When building a multi-neuron layer, a **row vector** provides the weights for a *single* unit in the "right" layer, and a **weight matrix `W`** (size `n × r`) provides *all* the weights connecting an `r`-unit "left" layer to an `n`-unit "right" layer — row `i` of `W` holds the weights connecting unit `i` on the right layer to every unit on the left layer. A network with **2 input units, 5 hidden units, and 3 output units, fully connected and feedforward** would therefore have a `5 × 2` weight matrix (input→hidden) and a `3 × 5` weight matrix (hidden→output). This is the same `W·p + b` computation described above, generalised from one neuron to an entire layer at once.

### The Perceptron and the Perceptron Learning Rule

An arrangement of **one input layer of activations feeding forward to one output layer of McCulloch-Pitts neurons** is known as a simple **Perceptron**. The **Perceptron Learning Rule** iteratively shifts the weights `w_ij` — and hence the decision boundaries — to produce the target outputs for each input. This is the historical precursor to the general weight-update rule in [[Backpropagation]].

### Learning by Gradient Descent Error Minimisation

Learning is framed as minimising the difference between actual and target outputs, quantified by the **Sum Squared Error (SSE)** function, summed over all output units `j` and all training patterns `p`:

```
E = (1/2) Σ_p Σ_j (target_pj - actual_pj)²
```

(The `½` is included purely so it cancels neatly when the equation is differentiated.) The general aim of network learning is to minimise `E` by adjusting the weights — by looking at the **gradients** (partial derivatives) of `E` with respect to each weight, and applying the **gradient descent update equation** with a positive learning rate `η` repeatedly until the error is "small enough." This is the same `x(k+1) = x(k) - η·g(k)` update rule given in [[Backpropagation]], applied here at the level of a simple perceptron rather than a deep multilayer network.

### Limitations of Simple Perceptrons

Simple perceptrons can only classify problems that are **linearly separable** — where a single straight line can separate the classes with zero (or near-zero) error. They **cannot** solve non-linear problems such as **XOR** — these require adding a **hidden layer** of neurons, which is precisely the motivation for the [[Multilayer Perceptron (MLP)]] (see that page's XOR walkthrough for the full argument).

## Relationship to Other Concepts

ANN is the general/classical term for this family of models. A [[Multilayer Perceptron (MLP)|Multilayer Perceptron]] is a specific feedforward ANN architecture; a [[Deep Neural Networks (DNN)|Deep Neural Network]] is informally an ANN with many hidden layers.

## Common Pitfalls & Practical Tips

- **Don't skip the bias term.** Without `b`, every neuron's decision boundary is forced to pass through the origin — a surprisingly limiting constraint. `nn.Linear` includes a bias by default (`bias=True`).
- **Weight initialization matters.** Starting all weights at zero means every neuron in a layer computes the *same* output and gets the *same* gradient update — they'd stay identical forever ("symmetry"). PyTorch's default initializers avoid this by using small random values.
- **A neuron's "meaning" only emerges from training.** Before training, weights are random and the neuron's output is meaningless — it's the gradual adjustment via [[Backpropagation]] that makes weights encode anything useful.

**Source:** Kasabov, N. (1996). *Foundations of Neural Networks, Fuzzy Systems, and Knowledge Engineering*. MIT Press; COMP723 Lecture 5 (McCulloch-Pitts neurons, weight matrices, the Perceptron, and gradient descent error minimisation).
