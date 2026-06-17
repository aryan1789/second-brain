---
title: COMP723 Lecture 10.1 - From RNN to Attention
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture10.pptx]
related: [COMP723, Recurrent Neural Networks (RNN), Transformer (Attention Is All You Need), Word Embeddings (Word2Vec and GloVe)]
created: 13-06-2026
last-updated: 13-06-2026
---

# COMP723 Lecture 10.1 - From RNN to Attention

> [!tip] Going Deeper
> [[Recurrent Neural Networks (RNN)]] has been supplemented with this lecture's RNN language model framing and the truncated-backpropagation fix for vanishing gradients. [[Transformer (Attention Is All You Need)]] has been supplemented with the seq2seq/encoder-decoder framing, teacher forcing, and greedy vs. beam search decoding. This note covers slides 1-26 — the motivation for moving from RNNs to attention.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **Why does a one-hot word representation fail to capture semantics, and what does a word embedding add?**
- **What makes an RNN suited to sequence data? What is a "typical task" for an RNN language model?**
- **Explain "shared weight matrix" and "hidden state" in an RNN — how does information flow from one timestep to the next?**
- **Why does adding more layers to an RNN give it "more expressive power"?**
- **Describe the vanishing gradient problem in RNNs in your own words. What practical fix does the lecture propose, and what's the trade-off?**
- **What is a "conditional language model", and why does machine translation need one?**
- **Explain teacher forcing and masked attention during encoder-decoder training.**
- **Contrast greedy decoding and beam search at test time. What does "normalise the score by length" fix?**
- **List the three reasons RNNs struggle with long sequence-to-sequence tasks like translation.**

---

## Notes

### Representing Words: One-Hot vs. Embeddings

A **one-hot representation** has **no semantic representation** — every word is an equally "different" dimension. A **word embedding** enables **semantics**: it lets us compute **distance between words** (similarity) via e.g. **Euclidean distance** or **cosine distance (dot product)**. See [[Word Embeddings (Word2Vec and GloVe)]] for the full treatment (this lecture briefly recaps "extracting the embedded vector from a one-hot representation" as the starting point for everything that follows).

### RNN Language Models

A **Recurrent Neural Network (RNN)** has a **connection from the previous state to the next state** — the current output **depends on the previous one(s)**. This makes it a good model for **sequences** (e.g. time series). The **typical task**: predict the **next word given a partial sequence**.

Mechanically, at each step: a **one-hot vector** is converted to an **embedding vector**, combined with the **hidden state from the previous timestep**, via a **shared weight matrix** (the same weights are reused at every timestep, with the previous hidden state passed forward to the next). Stacking **multiple layers** turns this into a **deep NN** with **more expressive power**.

### Backpropagation and the Vanishing Gradient (Practical Fix)

[[Backpropagation]] in an RNN occurs **at a single timestep**, and **also at all subsequent timesteps** (governed by the loss function) — so the network's effective **depth is as long as the sequence**, even though **weights are shared**. This causes the classic **vanishing gradient** problem: **no slope in the error function over "very long distances"**.

**Lecture's proposed solution**: instead of backpropagating through *all* layers, backpropagate through only **~3 layers at a time**, then **feed the hidden state from those last 3 layers forward** — reducing the effective backpropagation distance to **3**. See [[Recurrent Neural Networks (RNN)]] for this framed alongside LSTM/GRU gating as alternative fixes.

### RNN Applications and Language Translation

The lecture transitions from generic RNN applications to **language translation** specifically, introducing the **Encoder/Decoder** architecture — from **"Attention Is All You Need" (Vaswani et al., 2017)** — as the architecture that will replace the plain RNN approach.

### Encoder-Decoder: A Conditional Language Model

Translation is a **"many to many"** problem, but neural networks need **fixed-size vectors** to compare/process. The encoder represents the **English sentence as a final hidden vector** (e.g. `h_7` for a 7-word sentence), used as input to the decoder. Crucially, this makes the decoder a **conditional language model**: each output word is conditioned on the **input** (the whole source sentence, via that vector) — **not just the previous word in the output**, as a plain language model would be.

**Training** uses a **parallel corpus** (e.g. English → French), predicting **one word at a time**, **end-to-end**:

- **Teacher forcing** — uses the **ground truth** at each timestep (rather than the model's own prediction) as the input to the next decoder step.
- **Masked head** — masks the **forward words** (prevents the decoder from "seeing" words it hasn't generated yet).

### Decoding at Test Time: Greedy vs. Beam Search

At test time, the goal is to predict the next word **conditioned on**: (1) the **whole source sentence**, and (2) the **predicted words so far** in the target sentence.

- **Greedy** decoding builds up one best-guess word at a time (e.g. "le chat…" vs. "le chien…") — a locally-best choice that may not be globally optimal.
- **Beam search**: keep the **n best hypotheses**; add all hypotheses ending in `<EOS>` to the candidate list; stop when enough hypotheses are found; **normalise the score by its length** (so beam search doesn't unfairly favour shorter outputs, since each word multiplies in another probability `< 1`).

### The Limits of Encoder-Decoder RNNs

In the encoder-decoder model so far, **the decoder depends on the same single encoder hidden state for predicting every target word**. But this isn't how humans translate — **we focus on a few specific source words at a time** when translating each part of a sentence. More generally, **RNNs**:

- Suffer from **long-range dependencies** — not good for long sequences.
- Suffer from **vanishing/exploding gradients** due to network depth.
- Compute **sequentially**, so **cannot exploit GPU parallelisation**.

### Solution: Attention

**Attention** is a mechanism to **focus on only some words in the source sentence at a time step** — the **degree of focus on each word is a scalar, summing to 1 across all words**. Attention is **highly parallelisable** (can exploit GPUs) and lets the model express focus on **all words in a sequence at once**, rather than sequentially. This sets up [[COMP723 Lecture 10.2 - Self-Attention and the Full Transformer Architecture|Lecture 10.2]]'s detailed treatment of **self-attention** and the full Transformer architecture.

---

## Summary

This lecture motivates the shift from **RNNs to attention-based models**. RNN language models predict the next word from a sequence, using a **shared weight matrix** to pass a **hidden state** forward — but **backpropagation through time** over long sequences causes **vanishing gradients**, partially mitigated by **truncated backpropagation** (~3 layers at a time). For **translation**, the **encoder-decoder** architecture (from "Attention Is All You Need") turns the decoder into a **conditional language model**, trained with **teacher forcing** and **masked attention**, and decoded at test time via **greedy** or **beam search**. But encoder-decoder RNNs still rely on a **single fixed hidden vector** for the whole source sentence, and inherit RNNs' three core weaknesses: **long-range dependency loss**, **vanishing/exploding gradients**, and **no GPU parallelism**. **Attention** — focusing on a weighted subset of source words at each step, computable in parallel — is the solution, fully developed in [[Transformer (Attention Is All You Need)]] and [[COMP723 Lecture 10.2 - Self-Attention and the Full Transformer Architecture|Lecture 10.2]].

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| RNN language models, shared weights, hidden state, multi-layer RNNs, truncated backpropagation | [[Recurrent Neural Networks (RNN)]] | ✓ Verified |
| Encoder-decoder, conditional language model, teacher forcing, greedy/beam search decoding | [[Transformer (Attention Is All You Need)]] | ✓ Verified |
| One-hot vs. embedding representations | [[Word Embeddings (Word2Vec and GloVe)]] | ✓ Verified |
