---
title: COMP838 Lecture 8.1 - Generative Adversarial Networks (GAN)
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture8.pdf]
related: [COMP838, Generative Adversarial Network (GAN), Multilayer Perceptron (MLP), Backpropagation]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 8.1 - Generative Adversarial Networks (GAN)

> [!tip] Going Deeper
> [[Generative Adversarial Network (GAN)]] has a full concept page with intuition, the minimax loss functions, a PyTorch training-step example, and pitfalls (training instability, mode collapse). This note summarises the lecture's framing.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **GAN** — what are the two networks called, and what does each one do?
- **The "minimax two-player game"** — what is each player trying to maximise/minimise?
- **Counterfeiter/police analogy** — map it onto generator/discriminator.
- **What does the generator take as input, and what does it produce?**
- **Write out (in words) the discriminator loss and generator loss.**
- **What two algorithms train both networks?**

---

## Notes

### A Two-Player Game

A [[Generative Adversarial Network (GAN)|GAN]] simultaneously trains two models — a **generative model G** and a **discriminative model D** — via an adversarial process (Goodfellow et al., 2014). `G` captures the underlying data distribution and produces samples from it; `D` estimates the probability that a given sample came from the real training data rather than from `G`. `G` is trained to *maximise* the probability that `D` makes a mistake, while `D` is trained to correctly tell real from fake — Goodfellow et al. frame this as a **minimax two-player game**.

> [!check] Verified
> This framing matches the original GAN paper exactly — see [Generative Adversarial Network (Wikipedia)](https://en.wikipedia.org/wiki/Generative_adversarial_network), which describes GAN training as "indirect," with the discriminator providing the training signal for the generator.

The lecture's own analogy: the generator is like a team of **counterfeiters** producing fake currency without detection, and the discriminator is like the **police** trying to detect the counterfeits. Competition between the two drives both to improve until the fakes become indistinguishable from genuine currency — at which point `G` has learned to approximate the real data distribution.

### A Simple Model and Training

In the simplest GAN, both `G` and `D` can be [[Multilayer Perceptron (MLP)|multilayer perceptrons]]. Samples are generated from `G` using only forward propagation; both networks are trained using [[Backpropagation]], and a large network may randomly drop out nodes during training (dropout) to reduce overfitting and improve generalisation. The lecture references MNIST and CIFAR-10 as the datasets used in early GAN experiments.

### MATLAB GAN Architecture and Loss Functions

Following MATLAB's Deep Learning Toolbox GAN example:

- The **generator** takes a random vector as input and produces data with the same structure as the training data.
- The **discriminator** takes batches containing both real training data and generated data, and classifies each observation as "real" or "generated."

The loss functions given are:

- **Generator loss**: `L_G = -E[log(D(G(z)))]` — the lecture writes this with `Y^G` denoting the discriminator's output on generated data.
- **Discriminator loss**: `L_D = -E[log(D(x))] - E[log(1 - D(G(z)))]` — `Y^D` denotes the discriminator's output on real data.

Training alternates: train `D` to distinguish real from generated data, and train `G` to produce data that "fools" `D" — i.e. maximise `D`'s loss on generated data while minimising `D`'s overall loss on the real/generated mix.

> [!check] Verified
> These loss formulas match MATLAB's documented GAN training example — see [Train Generative Adversarial Network (GAN) - MathWorks](https://www.mathworks.com/help/deeplearning/examples/train-generative-adversarial-network.html). See [[Generative Adversarial Network (GAN)]] for a worked PyTorch version of this training step.

---

## Summary

A GAN trains a generator and a discriminator against each other in a minimax game: the generator tries to produce data realistic enough to fool the discriminator, while the discriminator tries to correctly separate real training data from the generator's output. Both networks can be simple MLPs trained with standard backpropagation (and dropout for regularisation). MATLAB's GAN example formalises this with explicit loss functions for `G` and `D` based on the discriminator's sigmoid output on real vs. generated samples, and the lecture references MNIST/CIFAR-10 as standard small-scale benchmarks.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| GAN as a minimax two-player game between G and D | [Generative Adversarial Network (Wikipedia)](https://en.wikipedia.org/wiki/Generative_adversarial_network) | ✓ Verified |
| MATLAB GAN generator/discriminator roles and loss functions | [Train GAN - MathWorks](https://www.mathworks.com/help/deeplearning/examples/train-generative-adversarial-network.html) | ✓ Verified |
