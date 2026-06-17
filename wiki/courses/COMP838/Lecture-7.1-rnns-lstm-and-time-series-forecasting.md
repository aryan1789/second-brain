---
title: COMP838 Lecture 7.1 - RNNs, LSTM, and Time Series Forecasting
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture7.pdf]
related: [COMP838, Recurrent Neural Networks (RNN), Long Short-Term Memory (LSTM), Backpropagation]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 7.1 - RNNs, LSTM, and Time Series Forecasting

> [!tip] Going Deeper
> The full intuition, PyTorch examples, and pitfalls for the architectures below live in [[Recurrent Neural Networks (RNN)]] and [[Long Short-Term Memory (LSTM)]]. This note summarises how the lecture frames their use for time series forecasting.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **Time series regression** — what is it, and what kinds of systems is it used to model?
- **What does an RNN carry from one timestep to the next?**
- **Unfolded/unrolled RNN** — what do the notations x, h, o, L, y, U, V, W represent?
- **What problem does LSTM solve that plain RNNs struggle with?**
- **LSTM gates** — name the three gates and what each one controls.
- **Why is the lecture's "four gates" description of LSTM slightly imprecise?**

---

## Notes

### Time Series Regression

[[Long Short-Term Memory (LSTM)|Time series regression]] is a statistical method for predicting a future response based on the history of that response (autoregressive dynamics) combined with the influence of other relevant predictor variables over time. It is used to understand and forecast the behaviour of dynamic systems — the lecture gives economic, financial, and biological systems as examples, drawn from MathWorks' time series regression documentation.

> [!check] Verified
> Time series regression as "predicting future values from past observations" matches the standard definition of autoregressive modelling used across statistics and forecasting — see [Autoregressive model (Wikipedia)](https://en.wikipedia.org/wiki/Autoregressive_model).

The lecture connects this statistical framing directly to deep learning: MATLAB's Deep Learning Toolbox provides worked examples of using an LSTM network for time series forecasting, including versions that update their forecast as new observations arrive. The deep-learning angle is that instead of hand-specifying an autoregressive equation, an LSTM *learns* what history is relevant from data — see [[Long Short-Term Memory (LSTM)]] for how this works mechanically.

### RNNs: Recap

The lecture recaps [[Recurrent Neural Networks (RNN)|RNNs]] as "a family of neural networks for processing sequential data, which is a dynamical system," noting that the *same transition function with the same parameters* is applied at every timestep (Goodfellow, 2016) — the "shared weights across time" idea covered in Lecture 3.

Two variants of the unfolded (unrolled) RNN are described:

- A network that produces an **output at every timestep**, with recurrent connections between hidden units.
- A network that reads the **entire sequence first** and produces a **single output** at the end — this is the pattern used for sequence classification (e.g. "is this time series anomalous?").

The standard notation: input `x`, hidden state `h`, output `o`, loss function `L`, training target `y`, and weight matrices `U`, `V`, `W` (input-to-hidden, hidden-to-output, and hidden-to-hidden respectively).

### LSTM: Long Short-Term Memory

[[Long Short-Term Memory (LSTM)|LSTM]] is introduced as "a model for short-term memory which can last for a long period of time" (Hochreiter & Schmidhuber, 1997) — deliberately developed to address the **exploding and vanishing gradient problems** that limit how far back in time a plain RNN can learn dependencies.

> [!warning] Flagged
> The lecture describes an LSTM unit as consisting of "four gates: input gate, cell, forget gate, and output gate." The **cell** (cell state) is not itself a gate — it's the memory that the three gates (input, forget, output) read from and write to. See [[Long Short-Term Memory (LSTM)]] for the corrected breakdown: three sigmoid-activated gates controlling read/write/output access to a single cell state.

The lecture's remaining LSTM points hold up well against authoritative sources:

- An LSTM (memory) cell stores a value/state for either long or short time periods — confirmed by [Understanding LSTM Networks (colah's blog)](https://colah.github.io/posts/2015-08-Understanding-LSTMs/), which describes the cell state as a "conveyor belt" running through the sequence.
- LSTM gates compute an activation, often using the logistic (sigmoid) function — confirmed; sigmoid outputs in [0,1] are exactly what make a gate "gate-like" (0 = block, 1 = pass).
- LSTM is well-suited to classification, processing, and prediction of time series with unknown/variable time lags between important events — this is the core motivation from the original 1997 paper and remains the standard framing today.

MATLAB's Deep Learning Toolbox documentation (referenced in the lecture) demonstrates LSTM networks for sequence classification: a sequence input layer feeds the raw time series in, and the network ends with a fully connected layer, a [[Softmax Function|softmax]] layer, and a classification output layer — the same general pattern used for CNN-based classifiers, just with an LSTM backbone instead of convolutional layers.

---

## Summary

This part of Lecture 7 connects classical time series regression (predicting future values from past observations and related predictors) to its deep-learning counterpart: LSTM networks. RNNs were recapped as sequence models that apply the same transition function at every timestep, either producing an output per timestep or a single output after reading the whole sequence. LSTM was introduced as the RNN variant designed to solve the vanishing/exploding gradient problem via a gated memory cell, making it well-suited to time series with long or variable-length dependencies. The lecture's MATLAB-based examples mirror a standard LSTM classification pipeline: sequence input → LSTM → fully connected → softmax → classification output.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Time series regression definition | [MathWorks: Time Series Regression](https://au.mathworks.com/discovery/time-series-regression.html) | ✓ Verified |
| RNN unfolded notation (x, h, o, L, y, U, V, W) | Goodfellow, I. (2016) *Deep Learning*, MIT Press | ✓ Verified |
| LSTM solves vanishing/exploding gradients | Hochreiter, S. & Schmidhuber, J. (1997) *Neural Computation* 9(8) | ✓ Verified |
| LSTM "four gates: input, cell, forget, output" | [Understanding LSTM Networks (colah's blog)](https://colah.github.io/posts/2015-08-Understanding-LSTMs/) | ⚠️ Corrected — cell state is not a gate; 3 gates (input, forget, output) operate on it |
| LSTM gates use sigmoid activation | [What is LSTM? (IBM)](https://www.ibm.com/think/topics/lstm) | ✓ Verified |
