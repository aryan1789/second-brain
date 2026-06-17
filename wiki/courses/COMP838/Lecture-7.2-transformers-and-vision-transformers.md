---
title: COMP838 Lecture 7.2 - Transformers and Vision Transformers (ViT)
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture7.pdf]
related: [COMP838, Transformer (Attention Is All You Need), Vision Transformer (ViT), Recurrent Neural Networks (RNN), Convolutional Neural Networks (CNN)]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 7.2 - Transformers and Vision Transformers (ViT)

> [!tip] Going Deeper
> [[Transformer (Attention Is All You Need)]] and [[Vision Transformer (ViT)]] have full concept pages with intuition, runnable PyTorch examples, and pitfalls. This note summarises the lecture's brief introduction to both.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **When were Transformers introduced, and what did they replace?**
- **What's the key difference between how RNNs and Transformers process a sequence?**
- **What is the attention mechanism providing, in plain terms?**
- **Vision Transformer (ViT)** — what does it treat as the "tokens" of an image?
- **Can Transformers be fine-tuned for specific tasks after pretraining?**

---

## Notes

### Transformers

[[Transformer (Attention Is All You Need)|Transformers]] are introduced as the state-of-the-art architecture for sequence tasks such as text processing and machine translation. The lecture's key points:

- Transformers were introduced in 2017 by Google Brain for NLP problems, **replacing RNN models (LSTM)**.
- Transformer models are trained on large datasets and can be **fine-tuned for specific tasks** — the pretrain-then-fine-tune pattern.
- Like RNNs, Transformers handle sequential input (natural language, etc.) for tasks such as translation and summarisation.
- Unlike RNNs, Transformers **do not necessarily process data in order** — the attention mechanism provides context for any position in the input sequence, regardless of distance.

> [!check] Verified
> All of the above matches [Attention Is All You Need (Vaswani et al., 2017)](https://arxiv.org/abs/1706.03762) and its reception in the field — Transformers' defining departure from RNNs is processing the whole sequence in parallel via self-attention rather than step-by-step recurrence. See [[Transformer (Attention Is All You Need)]] for how self-attention works mechanically.

This lecture's introduction is intentionally brief — it sits at the end of the RNN section as a preview of "what comes after RNNs," immediately followed by the lecture's coverage of the Vision Transformer.

### ViT: Vision Transformer

The lecture's ViT content is a sequence of MATLAB Deep Learning Toolbox screenshots demonstrating how to train a [[Vision Transformer (ViT)|Vision Transformer]] for image classification, without restating ViT's underlying architecture in the slide text itself.

> [!tip] Supplemented
> The source didn't define ViT beyond the MATLAB walkthrough. Based on [Dosovitskiy et al. (2021)](https://arxiv.org/abs/2010.11929) and the [Vision Transformer Wikipedia entry](https://en.wikipedia.org/wiki/Vision_transformer): ViT applies the Transformer architecture to images by splitting an image into fixed-size patches, treating each patch as a "token" (analogous to a word), and feeding the resulting sequence of patch embeddings through a standard Transformer encoder. See [[Vision Transformer (ViT)]] for the full breakdown, including why this is described as "an image is worth 16x16 words."

The MATLAB tutorial referenced (training a ViT for image classification) follows the same general workflow as the pretrained-CNN examples from [[GoogLeNet and the Inception Architecture|Lecture 5.2]]: load/prepare a labelled image dataset, configure the network (here, a ViT rather than a CNN), train, and evaluate classification accuracy — with the key architectural difference being patches + self-attention instead of convolutional filters.

---

## Summary

This part of Lecture 7 briefly bridges from RNNs/LSTM to the architecture that has largely superseded them for sequence modelling: the Transformer, introduced in 2017, which replaces step-by-step recurrence with parallel self-attention so that any position in a sequence can directly attend to any other. The lecture then previews the Vision Transformer (ViT), which applies this same Transformer architecture to images by treating fixed-size image patches as a sequence of tokens, via a MATLAB training walkthrough. Both architectures point toward the same broader trend as Lecture 6's AI roadmap: attention-based models increasingly displacing both RNNs (for sequences) and, potentially, CNNs (for vision).

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Transformers introduced 2017 by Google Brain, replacing RNNs/LSTM | [Attention Is All You Need (Wikipedia)](https://en.wikipedia.org/wiki/Attention_Is_All_You_Need) | ✓ Verified |
| Transformers process sequences in parallel via attention, not in order | [Attention Is All You Need (arXiv)](https://arxiv.org/abs/1706.03762) | ✓ Verified |
| ViT architecture (patches as tokens) | [Vision Transformer (Wikipedia)](https://en.wikipedia.org/wiki/Vision_transformer) | ➕ Supplemented |
