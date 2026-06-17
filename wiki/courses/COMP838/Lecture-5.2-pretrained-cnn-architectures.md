---
title: COMP838 Lecture 5.2 - Pretrained CNN Architectures (AlexNet, VGG-19, GoogLeNet, Inception-v3)
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture5.pdf]
related: [COMP838, AlexNet, VGG (VGG-16 / VGG-19), GoogLeNet and the Inception Architecture, Convolutional Neural Networks (CNN), Transfer Learning and YOLO for Classification]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 5.2 - Pretrained CNN Architectures (AlexNet, VGG-19, GoogLeNet, Inception-v3)

> [!tip] Going Deeper
> Each architecture below has a full concept page with intuition, a runnable PyTorch loading/inference example, and pitfalls (especially around input sizes). This note summarises the lecture's MATLAB-based survey in framework-agnostic terms — the depth lives in the linked concept pages.

The lecture demonstrates four classic ImageNet-pretrained CNNs available as ready-to-use models (the lecture uses MATLAB's Deep Learning Toolbox; the same architectures are equally available via `torchvision.models` in Python, which the concept pages use).

## Cues & Questions

> Cover the Notes section and try to answer each cue from memory.

- **List the four pretrained networks covered, their depth (number of layers), and their required input image size.**
- **What are the five generic steps in the "load → classify → display" workflow for using a pretrained image classifier?**
- **Which network reported the highest confidence on the bell pepper image in the lecture demo — what architectural feature might explain that?**
- **Why does Inception-v3 need a different input size than the other three networks?**

---

## Notes

### AlexNet: 8 Layers, the ImageNet Pioneer

> [!check] Verified
> See [[AlexNet]] for the full architecture breakdown (ReLU, dropout, overlapping pooling) and a PyTorch loading example.

[[AlexNet]] is a CNN trained on more than a million ImageNet images, **eight layers deep**, classifying images into 1,000 object categories (e.g. keyboard, mouse, pencil, and many animal classes). It takes a **227×227** input image. As the first deep CNN to dramatically outperform hand-crafted-feature approaches on ImageNet (2012), it remains a useful baseline and historical reference point, though it has been surpassed in accuracy by every architecture below.

### VGG-19: Depth via Uniform 3×3 Convolutions

> [!check] Verified
> See [[VGG (VGG-16 / VGG-19)]] for why stacking 3×3 filters approximates larger receptive fields with fewer parameters.

[[VGG (VGG-16 / VGG-19)|VGG-19]] is **19 layers deep**, also trained on over a million ImageNet images for 1,000-class classification, with a **224×224** input. Its defining trait — not mentioned on the slide but central to the architecture — is that nearly all of its convolutional layers use small 3×3 filters, with depth (rather than filter size) doing the work of building larger receptive fields.

### GoogLeNet: 22 Layers, Multi-Scale Inception Modules

> [!check] Verified
> See [[GoogLeNet and the Inception Architecture]] for how Inception modules combine multiple filter sizes in parallel, and how 1×1 convolutions cut computation.

[[GoogLeNet and the Inception Architecture|GoogLeNet]] is a **22-layer** pretrained CNN, trained on ImageNet for the same 1,000-class task, but also offered as a variant classifying into **365 scene categories** (field, park, runway, lobby, etc. — the Places365 dataset). Its input size is **224×224**, matching VGG-19. The lecture doesn't explain *why* GoogLeNet performs well, but the underlying reason is its Inception module: running 1×1, 3×3, and 5×5 convolutions in parallel and concatenating the results, with 1×1 convolutions used as computational bottlenecks.

### Inception-v3: 48 Layers, Factorized Convolutions

> [!check] Verified
> See [[GoogLeNet and the Inception Architecture]] for Inception-v3's factorized convolutions and why its input size differs from the other three networks.

[[GoogLeNet and the Inception Architecture|Inception-v3]] is a deeper evolution of the GoogLeNet/Inception family: **48 layers**, trained on over a million ImageNet images for 1,000-class classification, with a notably larger **299×299** input — the largest of the four networks covered. This larger input, combined with factorizing large convolutions (e.g. a 7×7 conv into three 3×3 convs), is part of how Inception-v3 pushes accuracy further while controlling parameter growth.

### The Generic Pretrained-Network Classification Workflow

The lecture's MATLAB-specific steps for AlexNet generalise to any pretrained image classifier, regardless of toolkit:

1. **Load a pretrained model** (e.g. `models.alexnet(weights=...)` in PyTorch, or `alexnet` in MATLAB).
2. **Read a test image.**
3. **Resize/crop the image** to the network's expected input size — this is where the size differences above (227×227, 224×224, 299×299) matter in practice.
4. **Run the image through the network** to get class probabilities.
5. **Display the image alongside the predicted class** (and, often, the top-5 predictions with their probabilities).

### Comparing the Four Networks on the Same Image

The lecture demonstrates all four networks classifying the same image — a tray of bell peppers, garlic, and other vegetables — and compares their top-5 prediction confidences:

- **AlexNet**: correctly predicts "bell pepper" as the top class, but with noticeably lower confidence than GoogLeNet, and includes less plausible classes (e.g. "candle") in its top 5.
- **GoogLeNet**: predicts "bell pepper" with **95.5% confidence** — visibly higher and more decisive than AlexNet's result on the same image.
- **Inception-v3 and VGG-19**: both also predict "bell pepper" as the top class with high confidence (similar to GoogLeNet), with VGG-19's top-5 list including more plausible related classes (cucumber, butternut squash, Granny Smith) than Inception-v3's (which includes "grocery store" and "zucchini").

The general pattern — newer/deeper architectures (GoogLeNet, Inception-v3, VGG-19) producing higher-confidence, more semantically coherent top-5 predictions than the oldest network (AlexNet) — is consistent with their lower ImageNet error rates and is the practical reason transfer learning pipelines default to these newer backbones (see [[Transfer Learning and YOLO for Classification]]).

---

## Summary

This lecture surveys four ImageNet-pretrained CNNs as ready-to-use building blocks: [[AlexNet]] (8 layers, 227×227, the 2012 pioneer), [[VGG (VGG-16 / VGG-19)|VGG-19]] (19 layers, 224×224, uniform 3×3 convolutions), [[GoogLeNet and the Inception Architecture|GoogLeNet]] (22 layers, 224×224, Inception modules, also available for 365-class scene classification), and Inception-v3 (48 layers, 299×299, factorized convolutions). All four follow the same load → preprocess → classify → display workflow, differing mainly in depth, input resolution, and accuracy. A live comparison on a single bell-pepper image shows the newer architectures (GoogLeNet, Inception-v3, VGG-19) producing higher-confidence and more semantically sensible top-5 predictions than AlexNet — the practical payoff of the architectural advances (Inception modules, depth via small filters) covered across this and the previous lecture's [[Densely Connected Convolutional Network (DenseNet)|DenseNet]]/[[Residual Networks (ResNet)|ResNet]] material.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| AlexNet: 8 layers, 227×227 input, 1000 classes | [MathWorks AlexNet docs](https://au.mathworks.com/help/deeplearning/ref/alexnet.html); [AlexNet, Wikipedia](https://en.wikipedia.org/wiki/AlexNet) | ✓ Verified |
| VGG-19: 19 layers, 224×224 input, 1000 classes | [MathWorks VGG-19 docs](https://au.mathworks.com/help/deeplearning/ref/vgg19.html); [arXiv:1409.1556](https://arxiv.org/abs/1409.1556) | ✓ Verified |
| GoogLeNet: 22 layers, 224×224 input, 1000/365 classes | [MathWorks GoogLeNet docs](https://au.mathworks.com/help/deeplearning/ref/googlenet.html); [Understanding GoogLeNet, GeeksforGeeks](https://www.geeksforgeeks.org/machine-learning/understanding-googlenet-model-cnn-architecture/) | ✓ Verified |
| Inception-v3: 48 layers, 299×299 input, 1000 classes, factorized convolutions | [MathWorks Inception-v3 docs](https://au.mathworks.com/help/deeplearning/ref/inceptionv3.html); [Inception V3, ScienceDirect Topics](https://www.sciencedirect.com/topics/computer-science/inception-v3) | ✓ Verified |
| 3×3 stacking vs larger filters (VGG rationale, not on slide) | [VGG-16, GeeksforGeeks](https://www.geeksforgeeks.org/computer-vision/vgg-16-cnn-model/) | ➕ Supplemented |
