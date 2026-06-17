---
title: Long Short-Term Memory (LSTM)
type: concept
sources: [Hochreiter, S. & Schmidhuber, J. (1997). Long Short-Term Memory. Neural Computation, 9(8), 1735-1780., https://colah.github.io/posts/2015-08-Understanding-LSTMs/, https://www.ibm.com/think/topics/lstm]
related: [Recurrent Neural Networks (RNN), Backpropagation, Activation Functions, Transformer (Attention Is All You Need)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Long Short-Term Memory (LSTM)

## The Core Idea

An LSTM is a [[Recurrent Neural Networks (RNN)|RNN]] variant designed to learn long-range dependencies in sequential data by maintaining a separate **cell state** — a kind of conveyor belt of memory that runs through the whole sequence — alongside the usual hidden state. Three **gates** (input, forget, and output), each a small neural layer with a sigmoid activation, control what information is written into, erased from, and read out of the cell state at every timestep. This gating mechanism was specifically designed to fix the vanishing/exploding gradient problem that plain RNNs suffer over long sequences (Hochreiter & Schmidhuber, 1997).

## Intuition: A Conveyor Belt with Gated Doors

Picture the cell state as a conveyor belt running along the top of the network, carrying information forward through time largely unchanged unless something deliberately modifies it. At each timestep, three gated "doors" decide what happens to the belt:

- **Forget gate** — looks at the previous hidden state and current input, and decides what fraction of the old cell state to *erase* (output close to 0 = forget, close to 1 = keep).
- **Input gate** — decides what new information from the current input is worth *writing* onto the belt, producing a candidate update (via `tanh`) scaled by how relevant it is (via `sigmoid`).
- **Output gate** — decides what part of the (updated) cell state to *expose* as the hidden state/output for this timestep.

Because the cell state is updated by addition (forget-gated old state + input-gated new candidate) rather than repeated multiplication by a weight matrix, gradients can flow backward through many timesteps without shrinking or exploding as fast as in a plain RNN — this is the core trick that lets LSTMs learn dependencies spanning hundreds of steps ([colah's blog](https://colah.github.io/posts/2015-08-Understanding-LSTMs/)).

## Why This Matters for Time Series

Time series forecasting (predicting a future value from a history of past observations, sometimes called autoregressive modelling) is a classic use case for LSTMs: the network reads a window of past observations step by step, and its hidden/cell state acts as a learned summary of "everything relevant about the recent past" that it uses to predict the next value. MATLAB's Deep Learning Toolbox provides a worked LSTM time-series forecasting example that follows this pattern (referenced in the lecture).

## In Practice: An LSTM Forecaster (PyTorch)

```python
import torch
import torch.nn as nn

# 4 sequences, 20 past timesteps, 1 feature (e.g. a single sensor reading)
x = torch.randn(4, 20, 1)

lstm = nn.LSTM(input_size=1, hidden_size=32, batch_first=True)
output, (h_n, c_n) = lstm(x)

# Predict the next value from the final hidden state
forecaster = nn.Linear(32, 1)
next_value = forecaster(h_n.squeeze(0))  # shape: [4, 1]
```

`c_n` is the final **cell state** — the "conveyor belt" contents at the last timestep — while `h_n` is the final hidden state used for the prediction. Training typically minimises mean squared error between `next_value` and the true next observation.

## Common Pitfalls & Practical Tips

- **Don't confuse cell state and hidden state.** The cell state (`c_n`) is the long-term memory; the hidden state (`h_n`) is what's exposed to the next layer/output at each step. A lecture slide describing LSTM as having "four gates: input, cell, forget, output" is slightly imprecise — the cell state itself is not a gate, it's the memory the three gates operate on.
- **Normalise your inputs.** Time series with very different scales (e.g. raw sensor voltages vs. normalised 0-1 values) can make the `tanh`/`sigmoid` gates saturate, stalling learning.
- **Stacking and bidirectionality** apply to LSTMs the same way as plain RNNs — see [[Recurrent Neural Networks (RNN)]] for `batch_first`, padding, and gradient clipping tips, which all carry over.
- **GRU as a lighter alternative** — a Gated Recurrent Unit merges the forget and input gates into a single "update gate" and has no separate cell state, giving similar performance with fewer parameters.

## Related Concepts

- [[Recurrent Neural Networks (RNN)]] — LSTM is the RNN variant that solves the vanishing gradient problem described there.
- [[Backpropagation]] — gradients through an LSTM's gates are computed via backpropagation through time.
- [[Activation Functions]] — LSTM gates rely on `sigmoid` (0-1 gating) and `tanh` (-1 to 1 candidate values).
- [[Transformer (Attention Is All You Need)]] — the architecture that has largely superseded LSTMs for sequence modelling since 2017.

**Source:** [Hochreiter, S. & Schmidhuber, J. (1997). Long Short-Term Memory. Neural Computation, 9(8), 1735-1780.](https://www.bioinf.jku.at/publications/older/2604.pdf); [Understanding LSTM Networks (colah's blog)](https://colah.github.io/posts/2015-08-Understanding-LSTMs/); [What is LSTM? (IBM)](https://www.ibm.com/think/topics/lstm)
