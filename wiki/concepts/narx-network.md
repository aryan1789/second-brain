---
title: NARX Network
type: concept
sources: [https://www.mathworks.com/help/deeplearning/ug/create-narx-network-for-time-series-forecasting.html]
related: [Recurrent Neural Networks (RNN), Neural Network Training Workflow]
created: 12-06-2026
last-updated: 12-06-2026
---

# NARX Network (Nonlinear AutoRegressive with eXogenous input)

> [!check] Verified
> Confirmed via [MathWorks: Create and Train NARX Network for Time Series Forecasting](https://www.mathworks.com/help/deeplearning/ug/create-narx-network-for-time-series-forecasting.html).

## The Core Idea

A NARX network is a recurrent neural network architecture designed for **time-series forecasting**. It predicts the next value in a series based on:

- **Autoregressive (AR)** — previous values of the series being predicted (feedback)
- **Exogenous (X)** — previous values of one or more *other* (external/input) time series that influence the target
- **Nonlinear (N)** — the relationship between past values and the prediction is modelled by a nonlinear neural network, rather than a linear equation

## Intuition: Forecasting with Both "Memory" and "Context"

Imagine forecasting tomorrow's electricity demand. Two kinds of information help:

1. **The demand series itself** — yesterday's demand, the demand two days ago, etc. (the "autoregressive" part — the series predicting itself from its own past)
2. **External factors** — tomorrow's forecast temperature, whether it's a weekday or holiday (the "exogenous" part — other series that *influence* but aren't *part of* what you're predicting)

A NARX network takes a fixed window of past values from *both* of these — e.g., the last 4 days of demand AND the last 4 days of temperature — and feeds them into a neural network (typically an [[Multilayer Perceptron (MLP)|MLP]]) that learns the nonlinear relationship to predict the next value.

## Relationship to RNNs

NARX networks are a specific recurrent architecture — they share the core [[Recurrent Neural Networks (RNN)|RNN]] idea of feeding past information back into the network, but structure that feedback explicitly around **fixed time-delay windows** of both the target series and external inputs, rather than an evolving hidden state. This makes NARX conceptually closer to "regression with lagged features" than to a standard RNN's continuously-updated memory — but the *nonlinear, learned* combination of those lagged features is what makes it a neural network rather than classical linear autoregression.

## In Practice: NARX-Style Forecasting (Python)

The core NARX idea — fixed lag windows fed into a model — can be implemented simply with lagged features and any regressor, including a small neural network:

```python
import numpy as np
from sklearn.neural_network import MLPRegressor

def make_narx_features(target_series, exog_series, n_lags=4):
    """Build NARX-style input rows: [target lags..., exog lags...] -> next target value"""
    X, y = [], []
    for t in range(n_lags, len(target_series)):
        target_lags = target_series[t - n_lags:t]
        exog_lags = exog_series[t - n_lags:t]
        X.append(np.concatenate([target_lags, exog_lags]))
        y.append(target_series[t])
    return np.array(X), np.array(y)

# demand: past electricity demand readings; temperature: corresponding temperatures
X, y = make_narx_features(demand, temperature, n_lags=4)

model = MLPRegressor(hidden_layer_sizes=(16,), max_iter=1000)
model.fit(X[:-10], y[:-10])  # train on all but last 10 points

predictions = model.predict(X[-10:])  # forecast the last 10 points
```

`make_narx_features` builds exactly the "fixed window of past target + exogenous values" structure the lecture describes. `MLPRegressor` is the "nonlinear" part — a small feedforward network learning the mapping from lagged values to the next prediction.

## Typical Use Case

Forecasting a quantity that depends on its own history plus external factors — e.g., predicting energy demand (autoregressive: past demand; exogenous: temperature, time of day).

## Common Pitfalls & Practical Tips

- **Choosing `n_lags` matters.** Too few lags and the model can't see far enough back to capture relevant patterns (e.g., weekly seasonality needs ~7+ daily lags); too many lags and you risk [[Overfitting and Underfitting|overfitting]] with too many input features relative to data size.
- **Modern alternatives:** for genuinely complex time series, LSTM/GRU-based [[Recurrent Neural Networks (RNN)|RNNs]] or Transformer-based forecasting models often outperform fixed-lag approaches like NARX, because they can learn variable-length dependencies rather than a fixed window — but NARX-style lagged features remain a strong, simple, *fast-to-train* baseline worth trying first.
- **Always compare against a naive baseline** — e.g., "predict tomorrow = today's value" (a "persistence" forecast). If your NARX model can't beat this trivial baseline, something's likely wrong with the setup.

**Source:** [MathWorks: Create and Train NARX Network for Time Series Forecasting](https://www.mathworks.com/help/deeplearning/ug/create-narx-network-for-time-series-forecasting.html)
