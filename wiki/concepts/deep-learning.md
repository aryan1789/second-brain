---
title: Deep Learning
type: concept
sources: [LeCun, Y., Bengio, Y., Hinton, G. (2015). Deep Learning. Nature, 521, 436-444. https://doi.org/10.1038/nature14539]
related: [Convolutional Neural Networks (CNN), Recurrent Neural Networks (RNN), Deep Neural Networks (DNN), Machine Learning vs Deep Learning, Artificial Neural Networks (ANN)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Deep Learning

## The Core Idea

A deep-learning architecture is a multilayer stack of simple modules, many of which compute nonlinear input-output mappings. Each module transforms its input to increase both the **selectivity** and **invariance** of the representation. With enough nonlinear layers stacked together, the resulting system can implement extremely intricate functions — sensitive to minute, task-relevant details while remaining insensitive to large, irrelevant variations (e.g., recognising a face regardless of lighting, angle, or background).

## Intuition: Why Stacking Layers Works

Think about how *you* recognise a face in a photo. You don't consciously reason about individual pixel brightness values — your visual system builds up understanding in stages:

1. **Low-level features**: edges, corners, colour gradients
2. **Mid-level features**: combinations of edges form shapes — curves, circles, lines
3. **High-level features**: shapes combine into parts — eyes, a nose, a mouth
4. **Object-level**: parts combine into "this is a face", and further, "this is *your friend's* face"

A deep network learns exactly this kind of hierarchy — **automatically**, from data. Nobody tells layer 1 "look for edges." The network discovers that edge-detectors are useful because they help reduce the [[Loss Functions|loss]] downstream, via [[Backpropagation]] and [[Stochastic Gradient Descent (SGD)|SGD]]. This is called **representation learning**: the network learns *what features to look for*, not just how to combine pre-specified features.

**Selectivity** means: by the final layers, the representation only responds to things that matter for the task (e.g., "is there a face here?").
**Invariance** means: that response doesn't change when irrelevant things change (lighting, rotation, background clutter).

## Why This Matters vs. Traditional / Classical Approaches

Traditional programming: a human writes explicit rules ("if pixel pattern looks like X, then Y"). This breaks down fast for anything visual or perceptual — there's no clean rule for "what a cat looks like."

Classical machine learning: a human still designs the **features** (e.g., "compute the average brightness in this region," "count edges at this angle"), and a simpler model (e.g., logistic regression, SVM) learns to combine those hand-crafted features. See [[Machine Learning vs Deep Learning]] for the full comparison.

Deep learning: the network learns **both** the features *and* how to combine them, directly from raw data (pixels, audio waveforms, raw sensor readings). This is why deep learning dominates in domains where good features are hard to hand-design — vision, speech, language — but is often *overkill* (and harder to interpret) for problems where a handful of well-understood features already work well.

## In Practice: A Minimal Deep Network (PyTorch)

```python
import torch
import torch.nn as nn

# A small "deep" network: input -> hidden -> hidden -> output
# Each (Linear + ReLU) pair is one "nonlinear module" in the
# LeCun/Bengio/Hinton sense.
model = nn.Sequential(
    nn.Linear(784, 128),  # e.g. a flattened 28x28 image -> 128 features
    nn.ReLU(),
    nn.Linear(128, 64),
    nn.ReLU(),
    nn.Linear(64, 10),    # 10 output classes (e.g. digits 0-9)
)

x = torch.randn(1, 784)   # one "image", flattened
logits = model(x)         # raw scores per class, shape [1, 10]
```

Notice the pattern: `Linear -> ReLU -> Linear -> ReLU -> Linear`. Each `Linear` layer is a learned linear transformation (the "weight function" from [[Artificial Neural Networks (ANN)]]); each `ReLU` is the nonlinearity that gives the network its expressive power. Remove the `ReLU`s and the whole stack collapses mathematically into a single linear transformation — no amount of "depth" would help.

## Common Pitfalls & Practical Tips

- **"More layers = always better" is false.** Depth helps when the problem has hierarchical structure to exploit (images, language, audio). For tabular data with a handful of meaningful columns, a shallow network or even a classical model ([[Machine Learning vs Deep Learning|gradient boosting, logistic regression]]) often matches or beats a deep network with far less tuning.
- **Data hunger.** Deep networks have many parameters and need correspondingly large labelled datasets to avoid [[Overfitting and Underfitting|overfitting]]. If you have a few hundred examples, deep learning is rarely the right first tool.
- **It's a "black box."** The hierarchy of learned features isn't directly inspectable the way hand-crafted features are. If interpretability matters (e.g., explaining a medical decision), this is a real cost — techniques like Grad-CAM exist but add complexity.
- **Start simple.** A common, productive workflow: get a classical baseline (e.g., scikit-learn) working first, *then* try deep learning and see if it actually improves things enough to justify the added complexity.

## Related Architectures

Deep learning is the umbrella term for a family of architectures, including:
- **[[Convolutional Neural Networks (CNN)|Convolutional Neural Networks (CNNs)]]** — local connections + shared weights + pooling, for grid-like data (images, and 1D signals like sensor/audio data)
- **[[Recurrent Neural Networks (RNN)|Recurrent Neural Networks (RNNs)]]** — sequence processing with shared weights across time steps
- **[[Deep Neural Networks (DNN)]]** — the general "many hidden layers" feedforward case
- Generative Adversarial Networks (GANs), Autoencoders, Transformer models, and others

**Source:** [LeCun, Y., Bengio, Y., Hinton, G. (2015). Deep Learning. Nature, 521, 436-444.](https://doi.org/10.1038/nature14539)
