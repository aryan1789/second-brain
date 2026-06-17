---
title: COMP838 Lecture 5.1 - DenseNets and ResNets
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture5.pdf]
related: [COMP838, Densely Connected Convolutional Network (DenseNet), Residual Networks (ResNet), Convolutional Neural Networks (CNN), Backpropagation, R-CNN Family]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 5.1 - DenseNets and ResNets

> [!tip] Going Deeper
> [[Densely Connected Convolutional Network (DenseNet)|DenseNet]] and [[Residual Networks (ResNet)|ResNet]] each have a full concept page with intuition, a runnable PyTorch block implementation, and practical pitfalls. This note is a Cornell-style summary — the depth lives in those pages.

This lecture covers two landmark CNN architectures that both directly address the same underlying problem — training *very deep* networks without accuracy collapsing — using two different connectivity strategies.

## Cues & Questions

> Cover the Notes section and try to answer each cue from memory.

- **What is the "degradation problem", and how is it different from simple overfitting?**
- **Write out the residual learning equation. What does the identity shortcut actually compute, and why does it help?**
- **How does DenseNet's connectivity pattern differ from ResNet's — concatenation vs. addition? What's the practical consequence of that difference?**
- **Why are "transition layers" needed in a DenseNet?**
- **What happens to a residual block's shortcut when the input and output dimensions don't match?**
- **Name two CVPR Best Paper-winning architectures covered in this lecture, and one award-winning paper that extends an architecture from a previous lecture.**

---

## Notes

### Award-Winning Deep Learning Research

The lecture opens with a survey of CVPR Best Paper and IEEE Marr Prize winners — a snapshot of the field's major milestones rather than content to memorise in detail. Two entries are directly relevant to this lecture: **He et al. (2016), "Deep Residual Learning for Image Recognition"** (CVPR Best Paper) introduced [[Residual Networks (ResNet)|ResNet]], and **Huang et al. (2017), "Densely Connected Convolutional Networks"** (CVPR Best Paper) introduced [[Densely Connected Convolutional Network (DenseNet)|DenseNet]] — both covered below. Also notable: **He et al. (2017), "Mask R-CNN"** (Marr Prize) extends the [[R-CNN Family]] from Lecture 4 with pixel-level segmentation masks, and more recent winners (Swin Transformer 2021, SinGAN 2019, diffusion-model control 2023) point toward transformer- and diffusion-based architectures that build on the CNN foundations covered across this course.

### DenseNets: Connect Every Layer to Every Later Layer

> [!check] Verified
> See [[Densely Connected Convolutional Network (DenseNet)]] for the dense block implementation, growth rate, and transition layers.

[[Densely Connected Convolutional Network (DenseNet)|DenseNets]] preserve the feedforward nature of a CNN while adding **direct connections from any layer to all subsequent layers** within a "dense block" — each layer's input is the *concatenation* of every preceding layer's output. This alleviates the vanishing gradient problem, strengthens feature propagation, encourages feature reuse, and substantially reduces parameter count relative to a plain CNN of similar depth and accuracy. DenseNets scale to hundreds of layers without the optimisation difficulties that plain deep CNNs run into, and accuracy can be tuned further via hyperparameters and learning rate schedules — but the dense connectivity comes from architecture, not tuning.

### ResNets: The Degradation Problem and Residual Learning

> [!check] Verified
> See [[Residual Networks (ResNet)]] for the residual block implementation, the `F(x) + x` equation, and how dimension mismatches are handled.

The lecture frames ResNet around the **degradation problem**: as plain network depth increases, accuracy doesn't just plateau — it gets *worse*, on both training and test error (the 56-layer vs. 20-layer comparison shows the 56-layer plain network with *higher* training error than the 20-layer one). [[Residual Networks (ResNet)|ResNets]] are "easy to optimise" and "can easily enjoy accuracy gains from greatly increased depth" because residual blocks learn `F(x)` and add it to an **identity shortcut** `x`, giving `F(x) + x`. Identity shortcuts can be used directly when input/output dimensions match; when they don't (e.g., between stages with different channel counts), a 1×1 convolution projects the shortcut to the right shape. The lecture's architecture diagrams compare VGG-19, a 34-layer plain network, and a 34-layer residual network — the residual version inserts shortcut connections every two conv layers, converting the plain network into a ResNet without otherwise changing its structure. Training curves on ImageNet show ResNet-34 outperforming ResNet-18 (deeper = better), the *opposite* of the plain-network result, which is the degradation problem in reverse.

---

## Summary

This lecture presents two CVPR Best Paper-winning answers to the same question: how do you make CNNs deeper *without* hurting accuracy? [[Residual Networks (ResNet)|ResNet]] (He et al., 2016) identifies the **degradation problem** — plain deep networks get worse, not just plateau — and fixes it with **residual blocks**: each block learns a residual `F(x)` added to an identity shortcut `x`, so extra layers can never make the network strictly worse, only potentially better. [[Densely Connected Convolutional Network (DenseNet)|DenseNet]] (Huang et al., 2017) takes a different approach to the same problem: instead of adding a residual to the input, each layer **concatenates** the outputs of *all* preceding layers, giving every layer direct access to earlier features and gradients flowing directly back to early layers. Both architectures scale to far greater depths than plain CNNs (or even VGG) while using fewer parameters, and both remain common backbones for transfer learning — including for object detectors in the [[R-CNN Family]].

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| DenseNet connectivity, vanishing gradient, feature reuse, parameter reduction | Huang, G., et al. (2017), [arXiv:1608.06993](https://arxiv.org/abs/1608.06993); [DenseNet Explained, GeeksforGeeks](https://www.geeksforgeeks.org/computer-vision/densenet-explained/) | ✓ Verified |
| ResNet degradation problem, residual learning equation, identity/projection shortcuts | He, K., et al. (2016), IEEE CVPR; [Residual Networks (ResNet), GeeksforGeeks](https://www.geeksforgeeks.org/deep-learning/residual-networks-resnet-deep-learning/) | ✓ Verified |
| CVPR Best Paper / Marr Prize award list (DenseNet, ResNet, Mask R-CNN, Swin Transformer, etc.) | As listed on lecture slides; cross-checked against publication years | ✓ Verified |
