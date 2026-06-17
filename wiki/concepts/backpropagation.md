---
title: Backpropagation
type: concept
sources: [LeCun, Y., Bengio, Y., Hinton, G. (2015). Deep Learning. Nature, 521, 436-444. https://doi.org/10.1038/nature14539]
related: [Multilayer Perceptron (MLP), Stochastic Gradient Descent (SGD), Loss Functions, Activation Functions]
created: 12-06-2026
last-updated: 12-06-2026
---

# Backpropagation

## The Core Idea

Backpropagation is the algorithm used to train multilayer neural networks: it computes how much each weight contributed to the network's error, working **backward** through the network from the output to the input.

## Intuition: Assigning Blame for a Mistake

Imagine a network with 3 layers makes a wrong prediction. The final [[Loss Functions|loss]] tells you "you were wrong by this much" — but it doesn't directly tell you which of the hundreds of weights across all 3 layers should change, or by how much.

Backpropagation answers this with a simple but powerful idea: **the chain rule of calculus**. The output of layer 3 depends on layer 2's output, which depends on layer 1's output, which depends on the input and the weights. To find "how much does this weight in layer 1 affect the final loss?", you multiply together: (how layer 1's output affects layer 2's output) × (how layer 2's output affects layer 3's output) × (how layer 3's output affects the loss). This is *literally* the chain rule — backpropagation is just a systematic, efficient way of applying it to every weight in the network at once, reusing intermediate calculations rather than recomputing them from scratch for each weight.

**The "backward" direction**: you compute the loss's sensitivity to the *output* layer first (easy — it's right there), then work backward to find the *hidden* layers' sensitivities (using what you just computed for the layer after them), and so on until you reach the input. Each weight's gradient tells you: "if I increase this weight slightly, the loss will increase/decrease by approximately this much" — and [[Stochastic Gradient Descent (SGD)|SGD]] uses this to decide which direction to nudge each weight.

## The Weight Update Rule

```
x(k+1) = x(k) - η · g(k),   k = 1, 2, ...
```

where `x(k)` is the vector of current weights, `g(k)` is the current gradient (of the [[Loss Functions|loss function]] with respect to the weights), and `η` (eta) is the **learning rate**.

## In Practice: Autograd — PyTorch's Backpropagation Engine

You almost never implement backpropagation by hand — PyTorch's `autograd` system does it automatically. But seeing it explicitly helps demystify `.backward()`:

```python
import torch

# A tiny "network": y = w * x + b, loss = (y - target)^2
x = torch.tensor(2.0)
target = torch.tensor(10.0)

w = torch.tensor(3.0, requires_grad=True)  # requires_grad: track this for backprop
b = torch.tensor(1.0, requires_grad=True)

y = w * x + b              # forward pass: y = 3*2 + 1 = 7
loss = (y - target) ** 2    # loss = (7 - 10)^2 = 9

loss.backward()             # <-- THIS IS BACKPROPAGATION

print(w.grad)  # d(loss)/dw -- how much the loss changes per unit change in w
print(b.grad)  # d(loss)/db -- how much the loss changes per unit change in b
```

`loss.backward()` walks backward through every operation that produced `loss` (`** 2`, then `-`, then `+`, then `*`), applying the chain rule at each step, and stores the result in `w.grad` and `b.grad`. For a real network with millions of parameters across dozens of layers, the exact same mechanism applies — PyTorch automatically builds and traverses the "computation graph" of every operation.

You can verify `w.grad` by hand: `loss = (w*x + b - target)^2`, so `d(loss)/dw = 2*(w*x+b-target)*x = 2*(7-10)*2 = -12`. PyTorch computes exactly this.

## The Chain Rule, Applied Repeatedly

Computing the gradient of the loss with respect to every weight in a multilayer network is done via the **chain rule** for derivatives. Because the network is a composition of functions (one per layer), the chain rule lets the gradient be computed layer-by-layer, propagating backward from the output layer to the input layer — applying the same procedure repeatedly to propagate gradients through all layers.

## Relationship to SGD

Backpropagation computes *what the gradient is*. [[Stochastic Gradient Descent (SGD)|Stochastic Gradient Descent]] is the procedure that *uses* that gradient to actually update the weights, typically using small batches of training examples at a time. In PyTorch terms: `loss.backward()` is backpropagation; `optimizer.step()` is SGD (or a variant like Adam).

## Common Pitfalls & Practical Tips

- **`optimizer.zero_grad()` before `.backward()`** — gradients *accumulate* by default in PyTorch. Forgetting to zero them out means each batch's gradients add to the previous batch's, corrupting training. This is one of the most common PyTorch bugs.
- **`requires_grad=True`** — only tensors with this flag (model parameters, by default) have gradients tracked. Input data typically doesn't need `requires_grad=True`.
- **Vanishing/exploding gradients** — in deep networks, repeated multiplication during the chain rule can make gradients shrink toward zero or grow huge. This is why [[Activation Functions|activation function choice]] (ReLU vs. sigmoid/tanh) and techniques like batch normalization matter.
- **`with torch.no_grad():`** — used during inference/validation to skip building the computation graph entirely, saving memory and compute when you don't need `.backward()`.

**Source:** LeCun, Y., Bengio, Y., Hinton, G. (2015). *Deep Learning*. Nature, 521, 436-444.
