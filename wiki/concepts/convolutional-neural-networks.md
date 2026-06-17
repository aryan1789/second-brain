---
title: Convolutional Neural Networks (CNN)
type: concept
sources: [LeCun, Y., Bengio, Y., Hinton, G. (2015). Deep Learning. Nature, 521, 436-444. https://doi.org/10.1038/nature14539, LeCun & Bengio (1995) Convolutional networks for images, speech, and time series, LeCun & Bengio (1990) Handwritten digit recognition with a back-propagation network]
related: [Deep Learning, Deep Neural Networks (DNN), Data Augmentation, Transfer Learning and YOLO for Classification, EMG Signal Processing and Visualization]
created: 12-06-2026
last-updated: 12-06-2026
---

# Convolutional Neural Networks (CNN / ConvNets)

## The Core Idea

A Convolutional Neural Network (CNN, also called a ConvNet) can be summarised as:

> **ConvNets = Local Connections + Shared Weights + Pooling + Multilayers**

- **Local connections** — each neuron connects only to a small, local region of the input (a "receptive field"), rather than the entire input. This mirrors how visual processing works on local patches of an image.
- **Shared weights** — the same filter (set of weights) is applied across different spatial locations, dramatically reducing the number of parameters and letting the network detect a pattern (e.g., an edge) anywhere in the input.
- **Pooling** — downsampling layers (e.g., max pooling) reduce spatial resolution, making the representation more compact and robust to small translations.
- **Multilayers** — stacking many convolution + pooling layers builds up a hierarchy from low-level features (edges, textures) to high-level features (object parts, whole objects).

## Intuition: What a "Convolution" Actually Does

Imagine a small grid of numbers — say 3×3 — called a **kernel** or **filter**. You slide this grid across every position of your input image, and at each position you multiply the overlapping numbers together and sum them up. That sum becomes one pixel of the output.

A kernel like:
```
-1 -1 -1
-1  8 -1
-1 -1 -1
```
acts as an **edge detector** — it produces a large value where the centre pixel differs sharply from its neighbours (an edge), and near-zero where the region is flat (uniform colour).

**The "shared weights" insight**: instead of hand-picking this kernel, the network *learns* the kernel's numbers via [[Backpropagation]] — and crucially, the *same* learned kernel slides across the *entire* image. If the network learns "this pattern of weights detects a vertical edge," it can detect a vertical edge **anywhere** in the image, not just in one fixed location. This is why CNNs generalise well across spatial position — a cat in the top-left of an image and a cat in the bottom-right activate the same learned filters.

**Pooling** then asks: "within this small region, what's the strongest activation?" (max pooling) and keeps only that — discarding exact position information while keeping "this feature was present somewhere around here." This is what gives CNNs robustness to small shifts/translations.

## Why Local Connections + Shared Weights Matters for Parameter Count

A fully-connected layer processing a 224×224 RGB image (224×224×3 ≈ 150,000 inputs) connecting to even a modest 1,000 hidden units would need ~150 million weights for *that one layer*. A convolutional layer with, say, 64 filters of size 3×3×3 needs only `64 × (3×3×3) = 1,728` weights — **regardless of image size** — because the same filter is reused everywhere. This is the practical reason CNNs were necessary before CNNs could even be trained at all on images.

## Origins

CNNs originated with LeCun and Bengio's work on handwritten digit recognition using back-propagation (1990) and were further developed for images, speech, and time series (1995) — predating the 2012 "deep learning boom" by over two decades. They underpin most modern object detection/classification architectures (R-CNN, YOLO family, ResNet, GoogLeNet, AlexNet).

## In Practice: A Small CNN (PyTorch)

```python
import torch
import torch.nn as nn

class SimpleCNN(nn.Module):
    def __init__(self, num_classes=10):
        super().__init__()
        self.features = nn.Sequential(
            # in_channels=3 (RGB), out_channels=16 filters, kernel 3x3
            nn.Conv2d(3, 16, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),  # halves spatial dimensions

            nn.Conv2d(16, 32, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),  # halves again
        )
        self.classifier = nn.Linear(32 * 8 * 8, num_classes)  # for 32x32 input

    def forward(self, x):
        x = self.features(x)
        x = x.flatten(1)          # flatten everything except batch dimension
        return self.classifier(x)

model = SimpleCNN()
x = torch.randn(1, 3, 32, 32)  # batch of 1, 3-channel, 32x32 image
out = model(x)                  # shape [1, 10]
```

Each `Conv2d` layer is "local connections + shared weights" (the kernel slides across the image, sharing its weights). Each `MaxPool2d(2)` is the pooling step — it halves the height and width by taking the max over each 2×2 block. Stacking `Conv2d -> ReLU -> MaxPool2d` blocks is the "multilayers" part of the formula.

## Beyond Images: 1D CNNs for Sensor Data

CNNs aren't only for images — `nn.Conv1d` applies the same "sliding filter" idea along a single time axis, useful for sensor/signal data such as EMG recordings (see [[EMG Signal Processing and Visualization]]). A 1D convolution can learn to detect characteristic waveform shapes (e.g., a muscle activation spike) regardless of *when* in the recording they occur — the same "shared weights = position-independent detection" logic as 2D CNNs on images.

## Common Pitfalls & Practical Tips

- **Padding controls output size.** `padding=1` with a 3×3 kernel keeps the spatial size unchanged; `padding=0` shrinks it. Forgetting this is a common source of shape-mismatch errors.
- **Don't forget pooling/stride reduces spatial size** — when you flatten before the final linear layer, the flattened size depends on how many pooling layers you have and the input size. Compute this carefully (or use `nn.AdaptiveAvgPool2d((1,1))` to sidestep it entirely).
- **Transfer learning is usually better than training from scratch** for image tasks with limited data — pretrained CNNs (ResNet, etc.) already encode general visual features (edges, textures, shapes) from millions of images. See [[Transfer Learning and YOLO for Classification]].
- **Receptive field grows with depth.** A single 3×3 kernel only "sees" a 3×3 patch, but after several layers, each output unit's receptive field covers a much larger region of the original input — this is how CNNs build up from edges to whole-object detectors.

## Related Concepts

- [[Deep Learning]]
- [[Deep Neural Networks (DNN)]]
- [[Data Augmentation]]
- [[Transfer Learning and YOLO for Classification]]

**Source:** [LeCun, Y., Bengio, Y., Hinton, G. (2015). Deep Learning. Nature, 521, 436-444.](https://doi.org/10.1038/nature14539)
