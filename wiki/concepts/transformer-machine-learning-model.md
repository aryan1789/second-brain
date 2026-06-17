---
title: Transformer (Attention Is All You Need)
type: concept
sources: [Vaswani, A. et al. (2017). Attention Is All You Need. NeurIPS. https://arxiv.org/abs/1706.03762, https://en.wikipedia.org/wiki/Attention_Is_All_You_Need, raw/lecture-notes/COMP723/Lecture10.pptx]
related: [Recurrent Neural Networks (RNN), Long Short-Term Memory (LSTM), Vision Transformer (ViT), Convolutional Neural Networks (CNN), Word Embeddings (Word2Vec and GloVe), Softmax Function]
created: 12-06-2026
last-updated: 13-06-2026
---

# Transformer (Attention Is All You Need)

## The Core Idea

The Transformer is a neural network architecture for sequence processing introduced by Vaswani et al. (2017) that relies entirely on an **attention mechanism**, dispensing with the recurrence used by [[Recurrent Neural Networks (RNN)|RNNs]]/[[Long Short-Term Memory (LSTM)|LSTMs]] and the convolutions used by [[Convolutional Neural Networks (CNN)|CNNs]]. Instead of processing a sequence one element at a time, a Transformer looks at the *entire* sequence at once and uses **self-attention** to let every element directly weigh the relevance of every other element, regardless of distance.

## Intuition: Everyone Looks at Everyone, All at Once

An RNN/LSTM reads a sentence word by word, carrying a summary (the hidden state) forward — information from word 1 has to survive being repeatedly compressed through every intermediate timestep before it can influence word 50. A Transformer instead lets word 50 directly "ask" every other word in the sentence: *"how relevant are you to me?"* — and weights its representation by those relevance scores. This is **self-attention**: for each token, the model computes a *query*, and compares it against the *key* of every other token to get attention weights, which are then used to combine the *values* of those tokens into a new representation.

Because every position can attend to every other position in a single step (rather than waiting for information to propagate through a chain of timesteps), Transformers:

- Avoid the vanishing-gradient-over-long-sequences problem that motivated LSTM's gating mechanism.
- Can be computed largely in parallel across the sequence (no step-by-step recurrence), making them far more efficient to train on modern hardware (GPUs/TPUs).

Since order is no longer encoded by the order of processing, Transformers add **positional encodings** to each token's representation so the model knows where in the sequence each token sits.

## Why Transformers Replaced RNNs for Sequence Tasks

Introduced in 2017 by Google Brain for NLP tasks such as machine translation, Transformers are trained on large datasets and can be fine-tuned for specific downstream tasks — this "pretrain then fine-tune" pattern underlies large language models such as GPT. By 2026, Transformers (and their decoder-only descendants) are the dominant architecture for language, and — via the [[Vision Transformer (ViT)|Vision Transformer]] — for many vision tasks as well.

## From Seq2Seq to Encoder-Decoder (COMP723, Lecture 10)

The Transformer's origins lie in **sequence-to-sequence (seq2seq)** tasks like machine translation — a "many to many" problem (variable-length source → variable-length target). Before attention, RNN-based **encoder-decoder** models worked by compressing the entire source sentence into a single **fixed-size hidden vector** (e.g. the final hidden state `h_7` for a 7-word sentence), then using that vector to drive a decoder that predicts the target sentence one word at a time. This makes the decoder a **conditional language model**: each output word is conditioned on **the whole source sentence** (via that compressed vector) *and* the target words generated so far — not just the previous output word.

**Training** uses a **parallel corpus** (e.g. English → French sentence pairs) end-to-end, with two key tricks:

- **Teacher forcing** — at each decoder timestep during training, feed in the **ground-truth previous word** (from the reference translation), rather than the model's own (possibly wrong) prediction. This stabilises training and lets the decoder learn to predict the *next* correct word regardless of earlier mistakes.
- **Masked attention** — masks out ("hides") future words in the target sequence, so the decoder can't "cheat" by looking ahead at words it's supposed to be predicting.

### Decoding at Test Time: Greedy vs. Beam Search

At test time there's no ground truth to feed back in, so the decoder must predict the next word conditioned on **the whole source sentence** and **its own previously predicted words**:

- **Greedy decoding** — at each step, output the single highest-probability word (e.g. building up "le chat…" word by word). Simple, but an early high-probability-but-suboptimal choice can lock the model into a poor overall sentence (e.g. "le chien…" if "chat" vs "chien" was ambiguous at step 1).
- **Beam search** — keep the **n best hypotheses** (partial sequences) at each step instead of just one. Add any hypothesis that produces an `<EOS>` (end-of-sequence) token to a candidate list, stop once enough candidates are found, then **normalise each candidate's score by its length** (otherwise shorter sequences are unfairly favoured, since each additional word multiplies in another probability `<1`).

## Self-Attention Mechanics: Query, Key, and Value (COMP723, Lecture 10)

**Self-attention** (the mechanism underlying the Transformer, introduced in the "Attention Is All You Need" paper) starts from a deceptively simple form with **no trainable weights at all**:

- **Order has no influence** — self-attention is *permutation-invariant* on its own (this is exactly why [[#Positional Encoding (COMP723, Lecture 10)|positional encoding]] is needed).
- **Proximity has no influence** — a token attends to a distant token exactly as easily as an adjacent one.
- **Shape independent** — the mechanism works regardless of sequence length.

This "raw" self-attention is reframed using three roles:

- **Key** — a vector representation of each element of the sequence.
- **Query** — the word for which we want to compute context (i.e. "what is this word looking for?").
- **Value** — the Query vector compared against the Keys of all other words, producing **adjusted weights (attention scores)** for each of those other words — i.e. how much each other word should contribute to this word's new representation.

### Making Self-Attention Trainable

To turn this into something a network can *learn*, each input vector `v` (shape `1×k`) is multiplied by **three separate trainable `k×k` matrices** — `M_q`, `M_k`, and `M_v` — producing the Query, Key, and Value vectors (each still `1×k`). These matrices are the Transformer's actual learned weights for attention: **their values are updated during training**, letting the model learn *what* to attend to, not just *how* attention is computed.

## Multi-Head Attention and Normalisation (COMP723, Lecture 10)

A single Query/Key/Value attention computation can only capture one "kind" of relationship at a time. **Multi-head attention** runs **several attention computations in parallel**, each using the *same* QKV mechanism but **different initial `M_q`/`M_k`/`M_v` matrices** — projecting the input embeddings into **different subspaces**, each potentially representing a different aspect of the relationships between words (e.g. coreference, subject-verb agreement, gender). The original "Attention Is All You Need" paper uses **8 attention heads**.

### Normalisation of Attention Scores

Raw similarity scores between Query and Key vectors need to be scaled down to a `0-1` range before being used as weights. The lecture covers several approaches:

- **Dot product + [[Softmax Function|softmax]]** — compute `Q · K`, then softmax the result.
- **Scaled dot product** — divide the dot product by the (square root of the) dimensionality of the embedding vector before softmax-ing — this is the approach used in "Attention Is All You Need", and prevents the dot product from growing too large (and saturating softmax) as embedding dimensionality increases.
- **Kernel methods** — map both `Q` and `K` vectors into another space via a non-linear transformation (e.g. a layer of neurons), then compute similarity there.

## Positional Encoding (COMP723, Lecture 10)

Since self-attention alone is order-independent, the Transformer must inject positional information separately. Any scheme works as long as it satisfies two constraints:

1. **Positional information can be encoded into the embedding vector.**
2. **The positional vector does not distort the final embedding vector** (i.e. it shouldn't overwhelm the semantic information already in the embedding).

The original Transformer paper uses **sine and cosine functions** — sine for even positions, cosine for odd positions — at different **wavelengths**. The resulting positional vector is **added to** the word's embedding vector, producing a final, position-aware embedding for each word.

## The Decoder (COMP723, Lecture 10)

The decoder is the second half of the Transformer architecture, using the **same self-attention mechanism as the encoder**, but operating **one word at a time** (many-to-many, like the RNN decoder above) with a key restriction: while the decoder can attend to **all** words from the encoder's output, it can only attend to the **previous words in the decoded sentence so far** (not future ones — this is the masked attention from the seq2seq section above).

- **Training**: the decoder sees **all previous (ground-truth) words** at once, via **teacher forcing**.
- **Testing**: the decoder uses its **own previously generated word(s)**, since no ground truth is available.

## Transfer Learning (COMP723, Lecture 10)

Most NLP tasks — **sentiment analysis, Named Entity Recognition, question answering, machine translation, reasoning, Natural Language Generation (NLG)**, etc. — require a shared, underlying "common knowledge about language". This is exactly what makes the **pretrain-then-fine-tune** pattern (mentioned above) so effective for Transformers: a single pretrained model's language understanding **transfers** across this whole range of downstream tasks, each requiring comparatively little task-specific fine-tuning data.

## In Practice: Self-Attention in a Few Lines (PyTorch)

```python
import torch
import torch.nn as nn

# A single multi-head self-attention layer
attn = nn.MultiheadAttention(embed_dim=16, num_heads=2, batch_first=True)

# batch of 4 sequences, 10 tokens each, 16-dim embeddings
x = torch.randn(4, 10, 16)

# self-attention: query, key, and value are all the same tensor
out, attn_weights = attn(x, x, x)
print(out.shape)         # [4, 10, 16]  -- same shape as input
print(attn_weights.shape) # [4, 10, 10] -- how much each token attends to every other token
```

`attn_weights[b, i, j]` is how much token `i` attends to token `j` in sequence `b` — the core quantity that lets the Transformer mix information across the whole sequence in one step.

## Common Pitfalls & Practical Tips

- **Quadratic cost in sequence length.** Self-attention computes an attention score between every pair of tokens, so compute/memory scales as O(n²) with sequence length — this is the main practical limitation for very long sequences.
- **Positional encodings are not optional.** Without them, a Transformer is permutation-invariant — it literally cannot tell "dog bites man" from "man bites dog".
- **Encoder vs decoder vs encoder-decoder.** The original Transformer is an encoder-decoder (translation); BERT-style models use only the encoder, while GPT-style models use only the decoder (with causal/masked attention so a token can't attend to future tokens).

## Related Concepts

- [[Recurrent Neural Networks (RNN)]] / [[Long Short-Term Memory (LSTM)]] — the architectures Transformers largely superseded for sequence modelling, by replacing step-by-step recurrence with parallel self-attention.
- [[Vision Transformer (ViT)]] — applies this same self-attention mechanism to images by treating image patches as a sequence of "tokens".
- [[Convolutional Neural Networks (CNN)]] — the dominant prior architecture for vision, which ViT competes with/complements.

**Source:** [Vaswani, A. et al. (2017). Attention Is All You Need. NeurIPS.](https://arxiv.org/abs/1706.03762); [Attention Is All You Need (Wikipedia)](https://en.wikipedia.org/wiki/Attention_Is_All_You_Need)
