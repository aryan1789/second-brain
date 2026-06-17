---
title: Residual Networks (ResNet)
type: concept
sources: [https://www.geeksforgeeks.org/deep-learning/residual-networks-resnet-deep-learning/, https://arxiv.org/html/2405.01725v1]
related: [Densely Connected Convolutional Network (DenseNet), Convolutional Neural Networks (CNN), Backpropagation, Overfitting and Underfitting, R-CNN Family]
created: 12-06-2026
last-updated: 12-06-2026
---

# Residual Networks (ResNet)

## The Core Idea

ResNet (He et al., 2016, CVPR Best Paper) solves the **degradation problem**: beyond a certain depth, plain (non-residual) networks get *worse* on both training and test data as more layers are added, not just overfit. ResNet's fix is the **residual block**: instead of a stack of layers learning the full mapping `H(x)`, they learn a *residual* `F(x) = H(x) - x`, and the block's output is `F(x) + x`, computed via an **identity shortcut connection** that skips over the weight layers. This makes very deep networks (50, 101, even 1000+ layers) both trainable and more accurate than their shallower counterparts.

## Intuition

Imagine you're editing an essay that's already pretty good. Two ways to ask someone to improve it:

1. "Rewrite this whole essay" (= learning `H(x)` directly) — risky, since a bad rewrite makes things worse than the original.
2. "Suggest edits/additions to this essay, and I'll add them to the original" (= learning `F(x)`, then computing `x + F(x)`) — if the suggested edits are useless (`F(x) ≈ 0`), you're no worse off than the original essay.

That second framing is what a residual block does. The identity shortcut means that, in the worst case, a block can learn to do *nothing* (`F(x) = 0`) and just pass its input through unchanged — so stacking more residual blocks can never make a network strictly worse at representing what a shallower network could already represent. This is the core reason ResNets don't suffer the degradation problem: depth becomes "free" in the sense that extra layers are never forced to hurt accuracy, only potentially help it.

The shortcut also gives gradients a direct path back to early layers during [[Backpropagation]] — instead of multiplying through every weight layer (where gradients can shrink toward zero — the vanishing gradient problem), gradients can flow along the identity connection mostly unchanged.

**Handling dimension mismatches**: when a residual block changes the number of channels or the spatial resolution (e.g., via a stride-2 conv), the identity shortcut can't be added directly — it's replaced with a learned **1×1 convolution projection** that reshapes `x` to match `F(x)`'s output shape before the addition.

## In Practice: A Residual Block (PyTorch)

```python
import torch
import torch.nn as nn

class ResidualBlock(nn.Module):
    def __init__(self, channels):
        super().__init__()
        self.conv1 = nn.Conv2d(channels, channels, kernel_size=3, padding=1)
        self.bn1 = nn.BatchNorm2d(channels)
        self.conv2 = nn.Conv2d(channels, channels, kernel_size=3, padding=1)
        self.bn2 = nn.BatchNorm2d(channels)
        self.relu = nn.ReLU(inplace=True)

    def forward(self, x):
        identity = x                      # the shortcut
        out = self.relu(self.bn1(self.conv1(x)))
        out = self.bn2(self.conv2(out))
        out = out + identity              # F(x) + x
        return self.relu(out)

block = ResidualBlock(channels=16)
x = torch.randn(1, 16, 32, 32)
print(block(x).shape)  # torch.Size([1, 16, 32, 32]) -- shape preserved
```

To see *why* the shortcut matters, try removing the `out = out + identity` line and training a 50+ layer stack of these blocks — the degradation problem (training error increases with depth) becomes visible, matching the 56-layer vs 20-layer comparison from the original paper.

## Common Pitfalls & Practical Tips

- **The shortcut requires matching shapes.** If a block changes channel count or spatial size (common at the start of each "stage" in ResNet-34/50), use a 1×1 conv (with the same stride) on the identity path — don't just `out + x` and expect it to broadcast correctly.
- **ResNet vs DenseNet**: both target the same vanishing-gradient/degradation issues, but ResNet **adds** (`F(x) + x`, same shape required) while [[Densely Connected Convolutional Network (DenseNet)|DenseNet]] **concatenates** (grows the channel dimension). Addition is cheaper; concatenation preserves more distinct information.
- **`torchvision.models.resnet50(weights="IMAGENET1K_V2")`** is the standard transfer-learning backbone — it's also the default backbone for `fasterrcnn_resnet50_fpn` in the [[R-CNN Family]].
- Very deep ResNets (50+) use a **bottleneck block** (1×1 → 3×3 → 1×1 convs) instead of the simple two-3×3-conv block shown above, to keep compute manageable at depth.

## Related Concepts

- [[Densely Connected Convolutional Network (DenseNet)|DenseNet]] — an alternative connectivity pattern (concatenation vs. addition) solving the same depth problem.
- [[Convolutional Neural Networks (CNN)]] — residual blocks are built from standard conv/BN/ReLU layers.
- [[Backpropagation]] — shortcut connections give gradients a more direct path to early layers, reducing vanishing gradients.
- [[R-CNN Family]] — Faster R-CNN commonly uses a ResNet backbone for feature extraction.

**Source:** He, K., et al. (2016). *Deep Residual Learning for Image Recognition*. IEEE CVPR; [Residual Networks (ResNet), GeeksforGeeks](https://www.geeksforgeeks.org/deep-learning/residual-networks-resnet-deep-learning/)
