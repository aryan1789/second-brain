---
title: Stochastic Gradient Descent (SGD)
type: concept
sources: [Goodfellow, I., Bengio, Y., Courville, A. (2016). Deep Learning. MIT Press.]
related: [Backpropagation, Loss Functions, Multilayer Perceptron (MLP), Overfitting and Underfitting]
created: 12-06-2026
last-updated: 12-06-2026
---

# Stochastic Gradient Descent (SGD)

## The Core Idea

Stochastic Gradient Descent (SGD) is the standard procedure for training multilayer neural networks. "Stochastic" refers to using small, randomly-sampled batches of training data for each update, rather than the entire dataset at once.

## Intuition: Descending a Foggy Mountain

Imagine you're standing on a hilly landscape (the [[Loss Functions|loss]] surface — height = how wrong the model currently is, position = current weight values) in thick fog, trying to reach the lowest point. You can't see the whole landscape, but you can feel the slope right under your feet (the **gradient**, computed via [[Backpropagation]]). Gradient descent says: "take a step in the downhill direction." Repeat, and you gradually descend toward a low point.

**Why "stochastic"?** Computing the *exact* slope using your entire dataset (every training example) is expensive — for large datasets, it might take minutes per step. Instead, SGD estimates the slope using just a small random sample ("mini-batch") of data. This estimate is noisy (it's not the *exact* slope of the full landscape), but it's good enough on average, and you can take *many more steps* in the same amount of time. The noise can even help — it can "jiggle" you out of small dips (local minima/saddle points) that aren't the true lowest point.

## The Procedure

Repeat until the [[Loss Functions|loss function]] stops decreasing (on average):

1. Take an **input vector** for a few samples (a "mini-batch")
2. Compute the network's **outputs and errors** for those samples
3. Compute the **average gradient** of the loss over those samples (via [[Backpropagation]])
4. **Adjust the weights** in the direction that reduces the loss (using the gradient and a learning rate)

## In Practice: Comparing Optimizers (PyTorch)

```python
import torch.optim as optim

model = ...  # your nn.Module

# Plain SGD -- exactly the formula x(k+1) = x(k) - eta * g(k)
optimizer = optim.SGD(model.parameters(), lr=0.01)

# SGD with momentum -- accumulates a "velocity" to smooth out noisy gradients,
# like a ball rolling downhill that keeps some of its previous direction
optimizer = optim.SGD(model.parameters(), lr=0.01, momentum=0.9)

# Adam -- adapts the learning rate per-parameter based on gradient history.
# Usually the best default starting point for new projects.
optimizer = optim.Adam(model.parameters(), lr=0.001)
```

```python
# The training step -- this IS the 4-step SGD procedure:
optimizer.zero_grad()           # reset gradients
preds = model(x_batch)          # forward pass
loss = loss_fn(preds, y_batch)  # step 2: compute error
loss.backward()                 # step 3: compute gradient (backprop)
optimizer.step()                # step 4: adjust weights
```

## Why "Stochastic"? — The Batch Size Trade-off

| Batch size | Gradient estimate | Speed per step | Steps to converge | Memory |
|---|---|---|---|---|
| 1 (true "online" SGD) | Very noisy | Fastest | Many | Lowest |
| Full dataset ("batch" gradient descent) | Exact | Slowest | Fewest | Highest |
| Mini-batch (e.g., 32-256) | Reasonable estimate | Good | Reasonable | Manageable |

In practice, **mini-batches (typically 16-256 examples)** are the standard — small enough to fit in GPU memory and take frequent steps, large enough that the gradient estimate isn't too noisy.

## Learning Rate: The Most Important Hyperparameter

The learning rate `η` controls step size:
- **Too large** → steps overshoot the minimum, loss oscillates or diverges (increases instead of decreases)
- **Too small** → training is extremely slow, may get stuck in a shallow local minimum

A common diagnostic: plot the training loss over time. If it's erratic/increasing, lower the learning rate. If it's decreasing extremely slowly, try increasing it (or switch to Adam, which adapts this automatically per-parameter).

## Common Pitfalls & Practical Tips

- **Adam is a reasonable default** for most projects — it adapts learning rates per-parameter and is less sensitive to the initial learning rate choice than plain SGD.
- **Shuffle your data each epoch** (`DataLoader(..., shuffle=True)`) — without shuffling, the model sees data in the same order every epoch, which can bias the gradient estimates (e.g., if your dataset is sorted by class).
- **Learning rate schedules** — many training setups *decrease* the learning rate over time (e.g., `torch.optim.lr_scheduler`), taking larger steps early (fast progress) and smaller steps later (fine-tuning near the minimum).

**Source:** Goodfellow, I., Bengio, Y., Courville, A. (2016). *Deep Learning*. MIT Press.
