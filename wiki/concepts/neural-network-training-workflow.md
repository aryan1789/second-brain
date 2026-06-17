---
title: Neural Network Training Workflow
type: concept
sources: [Beale, M., Hagan, M., Demuth, H. (2019). MATLAB R2019b Deep Learning Toolbox User's Guide. MathWorks., raw/lecture-notes/COMP723/Lecture5.pptx]
related: [Deep Neural Networks (DNN), Data Augmentation, Machine Learning vs Deep Learning, Backpropagation, Stochastic Gradient Descent (SGD), Overfitting and Underfitting]
created: 12-06-2026
last-updated: 12-06-2026
---

# Neural Network Training Workflow

## The Core Idea

A general-purpose workflow for developing a neural network model, applicable across task types (regression/function fitting, classification/pattern recognition, clustering, time-series prediction):

1. **Collect data** — gather a representative dataset for the task
2. **Create a network** — choose an architecture appropriate to the task (e.g., a feedforward network for function fitting, a pattern-recognition network for classification)
3. **Configure the network** — set architecture parameters (e.g., number of hidden units)
4. **Initialize weights and biases** — set starting parameter values (often random)
5. **Train the network** — adjust weights and biases to minimise error on the training data
6. **Validate the network** — check performance on held-out data, watching for overfitting
7. **Use the network** — apply the trained model to new, unseen data

## Train / Validation / Test Split

A standard data split for training is approximately:

- **Training set (~70%)** — used to fit the model's weights
- **Validation set (~15%)** — used during training to tune hyperparameters and detect overfitting (the model never directly learns from this)
- **Test set (~15%)** — held out entirely until final evaluation, to estimate how the model performs on genuinely unseen data

Monitoring training vs. validation performance over time reveals [[Overfitting and Underfitting|overfitting]]: if training error keeps decreasing while validation error starts increasing, the model is memorising the training data rather than learning generalisable patterns.

**Why three sets and not two?** If you tune hyperparameters (learning rate, architecture, etc.) based on test-set performance, you've effectively "used" the test set during development — its performance estimate becomes optimistic. The validation set absorbs all that tuning, leaving the test set as a genuinely unseen final check.

## Terminology: Epoch vs. Batch vs. Iteration

These three terms are frequently confused:

- **Batch (or mini-batch)** — a small subset of the training data processed together in one forward+backward pass (see [[Stochastic Gradient Descent (SGD)]])
- **Iteration** — one update step, i.e., processing **one batch** (one pass through steps 5's inner loop)
- **Epoch** — one full pass through the **entire training dataset** — i.e., enough iterations to have seen every training example once

**Worked example:** 1,000 training examples, batch size 32 → `1000 / 32 ≈ 32` iterations per epoch (the last batch may be smaller). Training for 50 epochs means `50 × 32 = 1,600` total iterations/weight updates.

This is also why the **learning rate** is often **decreased over the course of training** ("learning rate scheduling" or "decay"): early on, large steps make fast progress across the loss landscape; later, smaller steps allow fine-tuning near a good solution without overshooting. PyTorch's `torch.optim.lr_scheduler` module provides several decay strategies (step decay, cosine annealing, etc.).

## In Practice: A Complete PyTorch Training Loop

This is steps 4-7 of the workflow made concrete — the part that's often glossed over in lecture slides but is exactly what you'll write in code for almost every project:

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, random_split

# --- Step 1-3: data + network already prepared ---
# dataset: a torch Dataset object
train_size = int(0.7 * len(dataset))
val_size = int(0.15 * len(dataset))
test_size = len(dataset) - train_size - val_size
train_ds, val_ds, test_ds = random_split(dataset, [train_size, val_size, test_size])

train_loader = DataLoader(train_ds, batch_size=32, shuffle=True)
val_loader = DataLoader(val_ds, batch_size=32)

model = nn.Sequential(nn.Linear(20, 64), nn.ReLU(), nn.Linear(64, 1))

# --- Step 4: initialize ---
# (PyTorch initializes weights automatically when layers are created)

loss_fn = nn.MSELoss()
optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)

# --- Step 5 & 6: train + validate ---
for epoch in range(50):
    model.train()
    train_loss = 0.0
    for x_batch, y_batch in train_loader:
        optimizer.zero_grad()
        preds = model(x_batch)
        loss = loss_fn(preds, y_batch)
        loss.backward()        # backpropagation: compute gradients
        optimizer.step()       # SGD/Adam: update weights using gradients
        train_loss += loss.item()

    model.eval()
    val_loss = 0.0
    with torch.no_grad():       # no gradients needed for validation
        for x_batch, y_batch in val_loader:
            preds = model(x_batch)
            val_loss += loss_fn(preds, y_batch).item()

    print(f"Epoch {epoch}: train_loss={train_loss/len(train_loader):.4f}, "
          f"val_loss={val_loss/len(val_loader):.4f}")

# --- Step 7: use the network ---
model.eval()
with torch.no_grad():
    prediction = model(new_input)
```

Every line maps back to the 7-step workflow: `random_split` is the train/val/test split; `model = nn.Sequential(...)` creates and configures the network; `loss.backward()` + `optimizer.step()` is training; the validation loop inside the epoch is step 6; and `model(new_input)` at the end is step 7.

## Choosing MLP Hyperparameters: Practical Heuristics (COMP723, Lecture 5)

A second lecture lists the "major parameters" for a [[Multilayer Perceptron (MLP)]] and gives rough rules of thumb for setting each:

- **Learning rate** — determines the size of the steps taken during weight adjustment. Larger steps mean training proceeds faster, but accuracy may suffer (the update can overshoot a good solution). See [[Backpropagation]]'s weight update rule, where this is `η`.
- **Number of epochs** — the number of times the training dataset is scanned. Generally, larger values give more accurate models — the lecture suggests **100 or more** epochs as a starting point.
- **Batch size** — the number of datapoints that propagate through the network before a weight update (see "Terminology" above).
- **Number of hidden neurons** — a commonly-cited rule of thumb is:

  ```
  hidden_neurons ≈ (n_attributes + n_classes) / 2
  ```

  e.g., for a dataset with 8 input attributes and 2 output classes, this suggests starting around `(8 + 2) / 2 = 5` hidden neurons. This is a *starting point* for experimentation, not a guarantee of optimal performance — see the overfitting example in [[Overfitting and Underfitting]] for what happens when hidden-neuron count is set too high.
- **Momentum** — some implementations add a **momentum** term to the current weight update: a small fraction of the *previous* iteration's update value is added to the current one. This makes the learning process smoother — analogous to a ball rolling downhill carrying some of its previous velocity, helping it roll through small bumps (local irregularities) in the loss landscape rather than getting stuck or oscillating.

## Common Task Types This Workflow Applies To

- **Function fitting / regression** — predicting a continuous output
- **Pattern recognition / classification** — predicting a discrete category
- **Clustering** — grouping unlabeled data by similarity (e.g., [[Self-Organizing Map (SOM)|Self-Organizing Maps]])
- **Time-series prediction** — forecasting future values from sequential data (e.g., [[NARX Network|NARX networks]])

## Common Pitfalls & Practical Tips

- **`model.train()` vs `model.eval()`** — these switch certain layers' behaviour (dropout, batch norm). Forgetting `model.eval()` during validation/inference is a very common bug that silently produces worse/inconsistent results.
- **`torch.no_grad()` during validation/inference** — without it, PyTorch tracks gradients unnecessarily, wasting memory and compute.
- **Watch the val_loss trend, not just the final number.** If val_loss starts increasing while train_loss keeps decreasing, that's [[Overfitting and Underfitting|overfitting]] — consider early stopping (save the model with the best val_loss seen so far, not necessarily the last epoch).
- **The split should usually be random but reproducible** — set a random seed (`torch.manual_seed(...)`) so results are comparable across runs.

**Source:** Beale, M., Hagan, M., Demuth, H. (2019). *MATLAB R2019b Deep Learning Toolbox User's Guide*. MathWorks.
