---
title: Generative Adversarial Network (GAN)
type: concept
sources: [Goodfellow, I. et al. (2014). Generative Adversarial Nets. NeurIPS, pp. 2672-2680., https://en.wikipedia.org/wiki/Generative_adversarial_network, https://www.mathworks.com/help/deeplearning/examples/train-generative-adversarial-network.html]
related: [Deep Learning, Multilayer Perceptron (MLP), Loss Functions, Backpropagation, Activation Functions]
created: 12-06-2026
last-updated: 12-06-2026
---

# Generative Adversarial Network (GAN)

## The Core Idea

A GAN trains two neural networks simultaneously in opposition to each other: a **generator** `G`, which learns to produce fake data resembling the training distribution, and a **discriminator** `D`, which learns to tell real training data apart from `G`'s fakes. `G` is trained to maximise the probability that `D` makes a mistake, while `D` is trained to correctly classify real vs. generated samples — a setup Goodfellow et al. (2014) describe as a **minimax two-player game** (Goodfellow, I. et al. 2014, *Generative Adversarial Nets*, NeurIPS).

## Intuition: Counterfeiters vs. Police

The lecture's own analogy is the clearest one: the generator is like a team of **counterfeiters** producing fake currency, and the discriminator is like the **police** trying to detect the fakes. Competition between the two teams drives both to improve — the counterfeiters get better at making convincing fakes, and the police get better at spotting them — until (ideally) the fakes become indistinguishable from real currency. In ML terms, training converges toward an equilibrium where `D` can no longer reliably distinguish real samples from `G`'s output, at which point `G` has learned to approximate the real data distribution.

In the original formulation, both `G` and `D` can be simple [[Multilayer Perceptron (MLP)|multilayer perceptrons]]: `G` takes a random noise vector as input and outputs a fake sample (e.g. an image); `D` takes a sample (real or fake) and outputs the probability that it's real. `G` is trained using only forward propagation through `D` (to get a training signal) plus [[Backpropagation]]; both networks are trained with standard backprop, and techniques like dropout (randomly disabling nodes during training) help reduce overfitting.

## The Minimax Loss Functions

Following the MATLAB Deep Learning Toolbox's GAN example (which the lecture references directly), training alternates between optimising two loss functions:

- **Discriminator loss**: `L_D = -E[log(D(x))] - E[log(1 - D(G(z)))]` — minimising this trains `D` to output values close to 1 for real data `x` and close to 0 for generated data `G(z)`.
- **Generator loss**: `L_G = -E[log(D(G(z)))]` — minimising this trains `G` to produce samples that `D` scores close to 1 (i.e. "fools" `D` into thinking they're real).

Here `D(·)` denotes the discriminator's sigmoid output (a probability), `G(z)` is the generator's output given random noise `z`, and `E[·]` is the expectation (mean) over a batch.

## In Practice: A Minimal GAN Training Step (PyTorch)

```python
import torch
import torch.nn as nn

generator = nn.Sequential(nn.Linear(10, 64), nn.ReLU(), nn.Linear(64, 784), nn.Tanh())
discriminator = nn.Sequential(nn.Linear(784, 64), nn.ReLU(), nn.Linear(64, 1), nn.Sigmoid())

real_data = torch.randn(32, 784)       # batch of real samples (flattened images)
z = torch.randn(32, 10)                # random noise input to the generator

# --- Discriminator step ---
fake_data = generator(z).detach()      # detach so G isn't updated here
d_loss = -(torch.log(discriminator(real_data)).mean()
           + torch.log(1 - discriminator(fake_data)).mean())

# --- Generator step ---
fake_data = generator(z)
g_loss = -torch.log(discriminator(fake_data)).mean()
```

Each step backpropagates `d_loss` through `D` only, and `g_loss` through `G` only (with `D`'s weights frozen) — alternating these two updates is the core GAN training loop.

## Common Pitfalls & Practical Tips

- **Training instability** is the classic GAN problem: if `D` becomes too good too fast, `G`'s gradient (`-log(D(G(z)))`) vanishes because `D(G(z)) ≈ 0`, so `G` stops learning. Balancing the relative training speed of `G` and `D` is a major practical concern.
- **Mode collapse** — `G` may learn to produce only a narrow range of outputs that reliably fool `D`, rather than capturing the full diversity of the training data.
- **Datasets**: the lecture references MNIST and CIFAR-10 as standard small-scale benchmarks for early GAN experiments — good starting points for a first implementation.

## Related Concepts

- [[Multilayer Perceptron (MLP)]] — the original GAN paper uses simple MLPs for both `G` and `D`.
- [[Loss Functions]] — the minimax `L_G`/`L_D` formulation is a specialised pair of loss functions unique to adversarial training.
- [[Backpropagation]] — both networks are trained via standard backprop, alternating which network's weights are updated.
- [[Activation Functions]] — the discriminator's sigmoid output is what makes `D(x)` interpretable as a probability in the loss formulas above.

**Source:** [Goodfellow, I. et al. (2014). Generative Adversarial Nets. NeurIPS.](https://en.wikipedia.org/wiki/Generative_adversarial_network); [Train Generative Adversarial Network (GAN) - MathWorks](https://www.mathworks.com/help/deeplearning/examples/train-generative-adversarial-network.html)
