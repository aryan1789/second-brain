---
title: Receptive Field, Stride, and Padding
type: concept
sources: [https://d2l.ai/chapter_convolutional-neural-networks/padding-and-strides.html, https://distill.pub/2019/computing-receptive-fields]
related: [Convolutional Neural Networks (CNN), Deep Neural Networks (DNN)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Receptive Field, Stride, and Padding

> [!check] Verified
> Confirmed via [Dive into Deep Learning: Padding and Strides](https://d2l.ai/chapter_convolutional-neural-networks/padding-and-strides.html) and [Distill: Computing Receptive Fields](https://distill.pub/2019/computing-receptive-fields).

## The Core Idea

Four terms control how a convolution transforms spatial dimensions, and how much of the original input each output value "sees":

- **Feature map**: the output of a convolution operation — a grid of values, one per spatial location, for each filter
- **Stride**: the step length the convolution kernel moves between applications (stride 1 = move one pixel at a time; stride 2 = skip every other position, halving output size)
- **Padding**: extra (usually zero-valued) pixels added around the input's border before convolving, controlling output size and ensuring border pixels get adequate coverage
- **Receptive field**: the region of the *original input image* that a given output value (in some layer) is influenced by

## Intuition: Why Receptive Field Grows with Depth

A single 3×3 convolution kernel directly "sees" only a 3×3 patch of its input — its receptive field at that layer is 3×3. But the *input* to layer 2 is the *output* of layer 1 — so a 3×3 patch of layer 2's input corresponds to a larger patch of the *original image*, because each of those 9 values already aggregated information from a 3×3 region in the original.

This is why **stacking convolutional layers** (the "multilayers" part of [[Convolutional Neural Networks (CNN)|ConvNets = Local Connections + Shared Weights + Pooling + Multilayers]]) lets a network build up from "sees a few pixels" (early layers — edges, textures) to "sees a large fraction of the image" (late layers — whole objects, spatial relationships between objects). Pooling layers (which downsample) accelerate this growth — after a 2×2 max pool, each subsequent layer's kernel effectively covers *twice* as much of the original image per step.

## The Output Size Formula

For a 1D convolution (the same logic extends to each spatial dimension independently):

```
output_size = floor((input_size - kernel_size + 2*padding) / stride) + 1
```

**Worked example:** input 32×32, kernel 3×3, padding 1, stride 1:
```
output_size = floor((32 - 3 + 2*1) / 1) + 1 = floor(31/1) + 1 = 32
```
This is the common "padding=1 with a 3×3 kernel keeps the size unchanged" trick — `2*padding = kernel_size - 1` exactly cancels out the kernel's size reduction.

**Worked example with stride:** input 32×32, kernel 3×3, padding 1, stride 2:
```
output_size = floor((32 - 3 + 2) / 2) + 1 = floor(31/2) + 1 = 15 + 1 = 16
```
Stride 2 roughly halves the spatial dimensions — commonly used as an alternative to (or alongside) pooling for downsampling.

## In Practice: Verifying Shapes (PyTorch)

```python
import torch
import torch.nn as nn

conv = nn.Conv2d(in_channels=3, out_channels=16, kernel_size=3, padding=1, stride=1)
x = torch.randn(1, 3, 32, 32)
print(conv(x).shape)  # torch.Size([1, 16, 32, 32]) -- spatial size unchanged

conv_stride2 = nn.Conv2d(3, 16, kernel_size=3, padding=1, stride=2)
print(conv_stride2(x).shape)  # torch.Size([1, 16, 16, 16]) -- halved, matches formula
```

Always run a quick shape check like this when designing a new CNN — manually tracking sizes through many layers is error-prone, and shape mismatches are among the most common PyTorch errors when building [[Convolutional Neural Networks (CNN)|CNNs]].

## Common Pitfalls & Practical Tips

- **`floor()` matters** — if `(input_size - kernel_size + 2*padding) / stride` isn't a whole number, PyTorch floors it, silently "losing" a fraction of a pixel at the edge. This can cause subtle off-by-one mismatches when concatenating feature maps from different paths (e.g., in U-Net-style architectures).
- **"Same" padding** (output size = input size) requires `padding = (kernel_size - 1) / 2` for odd kernel sizes and stride 1 — this is why 3×3 (padding=1) and 5×5 (padding=2) kernels are so common; even kernel sizes don't divide evenly.
- **Receptive field, not "field of view," determines what a neuron can possibly learn.** If your task requires recognising relationships between distant parts of an image (e.g., "is the steering wheel positioned correctly relative to the seat?") but your network's final receptive field is smaller than that distance, no amount of training will help — you need more layers, larger strides/kernels, or dilated convolutions to grow the receptive field.

## Related Concepts

- [[Convolutional Neural Networks (CNN)]]

**Source:** [Dive into Deep Learning: Padding and Strides](https://d2l.ai/chapter_convolutional-neural-networks/padding-and-strides.html); [Distill: Computing Receptive Fields](https://distill.pub/2019/computing-receptive-fields)
