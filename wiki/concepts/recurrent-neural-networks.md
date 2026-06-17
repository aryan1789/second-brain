---
title: Recurrent Neural Networks (RNN)
type: concept
sources: [LeCun, Y., Bengio, Y., Hinton, G. (2015). Deep Learning. Nature, 521, 436-444. https://doi.org/10.1038/nature14539, raw/lecture-notes/COMP723/Lecture10.pptx]
related: [Deep Learning, NARX Network, Backpropagation, Word Embeddings (Word2Vec and GloVe), Transformer (Attention Is All You Need)]
created: 12-06-2026
last-updated: 13-06-2026
---

# Recurrent Neural Networks (RNN)

## The Core Idea

A Recurrent Neural Network (RNN) processes an input **sequence** one element at a time, maintaining a **hidden state** that implicitly encodes information about the history of all past elements seen so far. This makes RNNs naturally suited to sequential data — text, time series, audio, video frames.

## Intuition: Reading a Sentence Word by Word

Imagine reading the sentence: *"The trophy didn't fit in the suitcase because it was too big."*

To understand what "it" refers to, you need to remember the earlier words ("trophy", "suitcase") and combine that memory with the current word. An RNN works the same way:

- At each timestep, it takes **two inputs**: the current element (e.g., one word, or one sensor reading) AND its own hidden state from the previous timestep.
- It combines these to produce a **new hidden state**, which gets passed to the next timestep.
- The hidden state is a fixed-size vector that acts as a "running summary" of everything seen so far — it can't store everything verbatim, so the network learns *what's worth remembering* for the task.

## Unrolling Through Time

An RNN applies the **same weights** at every timestep — this is the "shared weights" idea, but applied across *time* instead of *space* (compare to how [[Convolutional Neural Networks (CNN)|CNNs]] share weights across spatial positions). If you "unroll" an RNN processing a 5-element sequence, you get something that looks like a 5-layer feedforward network where every layer has identical weights — which is the lecture's framing: **"RNNs can be viewed as very deep feedforward networks in which all the layers share the same weights."**

```
h0 --[RNN cell]--> h1 --[RNN cell]--> h2 --[RNN cell]--> h3 --[RNN cell]--> h4
       ^                  ^                  ^                  ^
       x1                 x2                 x3                 x4
```

Each `[RNN cell]` box is the *same* function with the *same* weights, applied repeatedly.

## The Vanishing Gradient Problem (and LSTM)

Because the same weights are applied repeatedly, [[Backpropagation]] through a long sequence multiplies the same gradient term over and over. If that term is slightly less than 1, repeated multiplication makes the gradient shrink toward zero exponentially — by the time the error signal reaches early timesteps, it's essentially zero, so the network can't learn long-range dependencies ("vanishing gradients"). The reverse (term slightly above 1) causes gradients to explode.

**LSTM (Long Short-Term Memory)**, introduced in 1997, addresses this with a more complex cell that includes "gates" controlling what information to keep, forget, or output at each step — letting gradients flow over much longer sequences without vanishing as quickly. A related, simpler variant is the **GRU (Gated Recurrent Unit)**.

## RNN Language Models and Truncated Backpropagation (COMP723, Lecture 10)

The canonical RNN application is a **language model**: given a partial sequence, predict the next word. At each timestep, the RNN takes a **one-hot** word representation, converts it to an **embedding vector** (see [[Word Embeddings (Word2Vec and GloVe)]]), and combines it with the **hidden state from the previous timestep** via a **shared weight matrix** to produce the next hidden state. Stacking **multiple RNN layers** (a "deep" RNN) gives the model **more expressive power**, at the cost of more computation.

### Backpropagation Through Time, and a Practical Fix for Vanishing Gradients

[[Backpropagation]] in an RNN happens **at each timestep, and also propagates back through all subsequent timesteps** — the network's effective depth is **as long as the sequence**, even though the weights are shared across all of it. This is precisely what causes the **vanishing gradient** problem described above: over very long distances, the error signal's gradient has effectively no slope left.

Beyond LSTM/GRU gating, the lecture describes a simpler, practical workaround: **truncated backpropagation** — instead of backpropagating through the *entire* sequence, only backpropagate through a small fixed window (e.g. **3 layers/timesteps** at a time), then **feed the hidden state from those last 3 layers forward** to continue processing. This reduces the *effective* backpropagation distance to 3, trading off some long-range gradient signal for tractable training.

### Why RNNs Struggle with Sequence-to-Sequence Tasks

For tasks like machine translation (seq2seq), RNN-based encoder-decoder architectures have three compounding problems:

1. **Long-range dependencies** — performance degrades on long sequences, since the entire source sentence must be compressed into a single fixed-size hidden vector.
2. **Vanishing/exploding gradients** — a direct consequence of network depth scaling with sequence length (see above).
3. **No GPU parallelisation** — every timestep's computation depends on the previous timestep's hidden state, so the whole sequence must be processed **sequentially**, unable to exploit GPU parallelism.

These three limitations are the direct motivation for **attention** and the [[Transformer (Attention Is All You Need)|Transformer architecture]], which processes the whole sequence in parallel and lets any position attend directly to any other.

## Connection to Symbolic Computation

RNNs connect to Turing machines, finite state machines (FSMs), and memory networks — used for tasks requiring reasoning and symbol manipulation. The hidden state is analogous to a Turing machine's tape/memory: a fixed mechanism (the RNN cell) reads input and updates memory, step by step, potentially implementing arbitrary sequential computations given the right weights.

## In Practice: A Small RNN (PyTorch)

```python
import torch
import torch.nn as nn

# batch of 4 sequences, each 10 timesteps long, 8 features per timestep
x = torch.randn(4, 10, 8)

rnn = nn.LSTM(input_size=8, hidden_size=16, batch_first=True)
output, (h_n, c_n) = rnn(x)

print(output.shape)  # [4, 10, 16]  -- hidden state at EVERY timestep
print(h_n.shape)     # [1, 4, 16]   -- FINAL hidden state only

# For classification: use the final hidden state
classifier = nn.Linear(16, 2)  # e.g. binary classification
logits = classifier(h_n.squeeze(0))  # [4, 2]
```

`nn.LSTM` handles the "unrolling" for you — feed it the whole sequence, and it internally applies the same cell at every timestep, returning either the output at every step (`output`) or just the final hidden state (`h_n`), depending on what your task needs.

## When NOT to Reach for an RNN (2026 Context)

Since ~2017, **Transformer** architectures (which process the whole sequence in parallel using attention, rather than step-by-step) have largely overtaken RNNs for language tasks, and increasingly for time series too — they train faster (no sequential dependency) and handle long-range dependencies better without the vanishing gradient issue. RNNs/LSTMs remain useful for: smaller-scale sequence tasks, streaming/online settings where you must process one timestep at a time with limited memory, and as a conceptual stepping stone — the "hidden state carries memory forward" intuition still underlies more advanced sequence models.

## Common Pitfalls & Practical Tips

- **`batch_first=True`** — PyTorch's default tensor shape is `(seq_len, batch, features)`; setting `batch_first=True` switches to the more intuitive `(batch, seq_len, features)`. Forgetting this is a very common shape-mismatch bug.
- **Gradient clipping.** Even LSTMs can suffer exploding gradients on long sequences — `torch.nn.utils.clip_grad_norm_` is commonly used during training.
- **Padding and masking.** Real-world sequences have varying lengths; you'll typically pad shorter sequences to a common length and use `pack_padded_sequence` (or attention masks, for Transformers) so the model doesn't learn from padding.
- **Bidirectional RNNs** (`bidirectional=True`) process the sequence both forwards and backwards — useful when the *entire* sequence is available upfront (e.g., classifying a full recording), but not for real-time/streaming use cases where future data isn't available yet.

## Related Concepts

- [[Deep Learning]]
- [[NARX Network]] — a specific recurrent architecture for time-series forecasting with external inputs
- [[Backpropagation]]

**Source:** [LeCun, Y., Bengio, Y., Hinton, G. (2015). Deep Learning. Nature, 521, 436-444.](https://doi.org/10.1038/nature14539)
