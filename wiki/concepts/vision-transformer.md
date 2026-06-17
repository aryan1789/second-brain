---
title: Vision Transformer (ViT)
type: concept
sources: [Dosovitskiy, A. et al. (2021). An Image is Worth 16x16 Words: Transformers for Image Recognition at Scale. ICLR. https://arxiv.org/abs/2010.11929, https://en.wikipedia.org/wiki/Vision_transformer, https://d2l.ai/chapter_attention-mechanisms-and-transformers/vision-transformer.html]
related: [Transformer (Attention Is All You Need), Convolutional Neural Networks (CNN), AlexNet, VGG (VGG-16 / VGG-19)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Vision Transformer (ViT)

## The Core Idea

The Vision Transformer (ViT), introduced by Dosovitskiy et al. (2021), applies the [[Transformer (Attention Is All You Need)|Transformer]] architecture — originally designed for text — directly to images, with minimal modification. An input image is split into fixed-size, non-overlapping **patches** (e.g. 16x16 pixels), each patch is flattened and linearly projected into an embedding vector, and the resulting sequence of patch embeddings is fed into a standard Transformer encoder, exactly as if they were word tokens in a sentence.

## Intuition: An Image Is a Sentence Made of Patches

A [[Convolutional Neural Networks (CNN)|CNN]] builds up an understanding of an image gradually, layer by layer, using small local filters that slide across the image — locality and translation-invariance are *built into* the architecture. ViT takes a different approach: it chops the image into a grid of patches (e.g. a 224x224 image into 14x14 = 196 patches of 16x16 pixels), treats each patch as a "word", and lets self-attention figure out which patches are relevant to which other patches — including patches far apart in the image. Where a CNN learns spatial structure mostly implicitly through its architecture, ViT must instead learn it largely from data, aided by added **positional embeddings** that tell the model where each patch sits in the original image.

A learnable **class token** is typically prepended to the sequence of patch embeddings; after passing through the Transformer encoder, this token's final representation is used for classification — analogous to how a `[CLS]` token works in BERT-style NLP models.

## Why It Matters

ViT showed that, given enough training data, a model with *no* convolutional structure at all can match or exceed CNNs on image classification (e.g. on ImageNet) — challenging the long-held assumption that the inductive biases of convolutions (locality, weight sharing across space) are necessary for vision. With less data, ViT tends to underperform CNNs (it has to learn spatial structure from scratch), but with large-scale pretraining it generalises very well — a similar "scale wins" story to what Transformers showed for language.

## In Practice: Patchifying an Image (PyTorch)

```python
import torch
import torch.nn as nn

# A 32x32 image with 3 colour channels, batch of 4
images = torch.randn(4, 3, 32, 32)

patch_size = 8  # -> (32/8)^2 = 16 patches per image
patch_embed = nn.Conv2d(in_channels=3, out_channels=64,
                         kernel_size=patch_size, stride=patch_size)

patches = patch_embed(images)            # [4, 64, 4, 4]
patches = patches.flatten(2).transpose(1, 2)  # [4, 16, 64]  -- 16 patch tokens, 64-dim each

# Feed `patches` into a Transformer encoder (e.g. nn.TransformerEncoder) just like word tokens
```

A strided `Conv2d` is a common trick to implement "split into patches + linearly project" in one step: each output spatial position corresponds to one non-overlapping patch.

## Common Pitfalls & Practical Tips

- **ViT is data-hungry.** Without large-scale pretraining (or strong data augmentation/regularisation), ViT typically underperforms a comparably-sized CNN on small datasets — the convolutional inductive bias acts as a useful prior when data is limited.
- **Input size must match patch size cleanly.** Image dimensions need to be divisible by the patch size; resizing/cropping inputs to a compatible resolution is a common preprocessing step (MathWorks' MATLAB ViT tutorial, referenced in the lecture, follows this same pattern).
- **Positional embeddings matter.** Since patches are processed as an unordered set by self-attention, positional embeddings are what let the model know patch (0,0) is top-left and patch (13,13) is bottom-right.

## Related Concepts

- [[Transformer (Attention Is All You Need)]] — ViT is the direct application of this architecture to images via patch tokens.
- [[Convolutional Neural Networks (CNN)]] — the architecture ViT is most often compared against for image classification.
- [[AlexNet]] / [[VGG (VGG-16 / VGG-19)]] — earlier ImageNet-era CNN classifiers that ViT-based models are benchmarked against.

**Source:** [Dosovitskiy, A. et al. (2021). An Image is Worth 16x16 Words. ICLR.](https://arxiv.org/abs/2010.11929); [Vision Transformer (Wikipedia)](https://en.wikipedia.org/wiki/Vision_transformer); [Transformers for Vision (Dive into Deep Learning)](https://d2l.ai/chapter_attention-mechanisms-and-transformers/vision-transformer.html)
