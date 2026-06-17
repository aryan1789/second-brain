---
title: COMP723 Lecture 5.1 - ANN Fundamentals and the Perceptron
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture5.pptx]
related: [COMP723, Artificial Neural Networks (ANN), Activation Functions, Multilayer Perceptron (MLP), Backpropagation]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP723 Lecture 5.1 - ANN Fundamentals and the Perceptron

> [!tip] Going Deeper
> [[Artificial Neural Networks (ANN)]] has been supplemented with a "Networks of McCulloch-Pitts Neurons, Weight Matrices, and the Perceptron" section covering this lecture's worked example, weight matrices, the Perceptron Learning Rule, and gradient descent error minimisation in full. [[Activation Functions]] already covers ReLU/tanh/sigmoid in depth. This note summarises the lecture's framing of slides 1-22.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **What three tasks are ANNs used for, and what are 5 common ANN architectures and their typical use?**
- **List 4 characteristics of ANNs from the lecture (one should relate to interpretability).**
- **What are the three components of a "mathematical neuron"?**
- **Why is the sigmoid function used to approximate a step function?**
- **What is a McCulloch-Pitts neuron?**
- **Given a hidden unit with net input `0.5(3) + -0.5(1)`, what is its activation? What is the network's final output if that activation feeds an output unit with weight 0.75?**
- **What is a weight matrix `W`, and what do its dimensions represent for a network with 2 inputs, 5 hidden units, and 3 outputs?**
- **What is a Perceptron, and what does the Perceptron Learning Rule do?**
- **Write out the Sum Squared Error (SSE) formula. Why is there a `½` in it?**

---

## Notes

### Neural Networks: Generic Overview

ANNs are a **biologically-inspired family of algorithms**, inspired by the human brain, used for **classification**, **clustering**, and **numeric prediction** tasks. The lecture lists the most popular architectures and their typical uses:

| Architecture | Typical Use |
|---|---|
| Multi Layer Perceptron (MLP) | Classification |
| Radial Basis Function (RBF) | Classification and numeric prediction |
| Self Organizing Map (SOM) | Clustering |
| Convolutional Neural Network (CNN) | Image/text classification |
| Long Short Term Memory (LSTM) | Modelling time series |

This lecture focuses on the **MLP**, including its operation and the derivation of its weight-update formula via [[Backpropagation]].

### Biological Inspiration

The brain performs **classifications, predictions, and associations**. The lecture emphasises the scale involved: each neuron sends and receives roughly **10⁴ synapses** (connections), and the brain contains roughly **10¹¹ neurons** — "huge connectivity" and "huge complexity." Artificial Neural Networks are **crude approximations** to parts of real brains — they can be physical devices or, more commonly, simulated on conventional computers.

### Characteristics of ANNs

The lecture lists several defining characteristics:

- **Extremely powerful computational devices**
- **Naturally parallel** — making them efficient
- **Learn and generalize from training data** — no need for "enormous feats of programming" (i.e., no need to hand-code rules)
- **Particularly fault tolerant** and **very noise tolerant** — they cope with situations where normal symbolic systems would struggle
- **In principle, can do anything a symbolic/logic system can do, and more**
- **Cannot be mapped back to individual features** — unlike e.g. [[Decision Trees and Information Gain|decision trees]], ANN decisions/classifications **can't be explained** in terms of which input features drove them. This is the classic interpretability trade-off, revisited later in this lecture's Strengths/Weaknesses comparison.

### The Mathematical Neuron and Activation Functions

A mathematical neuron has three parts (same model as [[Artificial Neural Networks (ANN)]]'s "Neuron Model" section):

1. **A set of synapses (connections)** bring in activations from other neurons.
2. **A processing unit sums the inputs**, then applies a **non-linear activation function**.
3. **An output line** transmits the result to other neurons.

`θ` (theta) denotes the **threshold**.

### The Sigmoidal Step Function

Some neural net mathematics requires the activation function to be **continuously differentiable** — a true step function isn't. A **sigmoidal function** is often used to *approximate* a step function while remaining smooth/differentiable everywhere (required for [[Backpropagation]]'s gradient computations — see [[Activation Functions]] for the full sigmoid formula and its vanishing-gradient trade-offs). The lecture also shows how varying the **steepness** of the sigmoid changes how closely it approximates a hard step.

### Networks of McCulloch-Pitts Neurons

The simplest ANNs consist of a set of **McCulloch-Pitts neurons** — labelled by indices `k`, `i`, `j` — with activation flowing between them via synapses of strength `w_ki`, `w_ij`. Each neuron has the same 3-part structure described above (synapses → summation + activation → output).

**Worked 2-layer example:**

```
Activation of hidden unit = f(0.5(3) + -0.5(1)) = f(1.5 - 0.5) = f(1) = 0.731
Output activation         = f(0.731 × 0.75)     = f(0.548)    = 0.634
```

### Weight Matrices

To build up a network from individual neurons: a **row vector** provides the weights for a single unit in the "right" layer; a **weight matrix `W`** (size `n × r`) provides *all* weights connecting an `r`-unit "left" layer to an `n`-unit "right" layer — row `i` of `W` connects unit `i` on the right layer to every unit on the left layer.

**Example network:** 2 input units, 5 units in a single hidden layer, 3 output units, **fully connected, feedforward**.

### The Perceptron and the Perceptron Learning Rule

An arrangement of **one input layer of activations feeding forward to one output layer of McCulloch-Pitts neurons** is called a simple **Perceptron**. The **Perceptron Learning Rule** iteratively shifts the weights `w_ij` — and hence the decision boundaries — to produce the target outputs for each input.

### Learning by Gradient Descent Error Minimisation

Learning = minimising the difference between actual and target outputs, quantified by the **Sum Squared Error**:

```
E = (1/2) Σ_p Σ_j (target_pj - actual_pj)²
```

summed over all output units `j` and all training patterns `p`. The `½` is included so it cancels neatly when `E` is differentiated. Network learning aims to minimise `E` by adjusting weights, using the **gradients (partial derivatives) of `E`** with respect to each weight to determine direction. The **gradient descent update equation** (with positive learning rate `η`) is applied iteratively until the error is "small enough."

---

## Summary

This lecture introduces ANNs as a biologically-inspired family of algorithms used for classification, clustering, and numeric prediction, with the MLP as its focus. ANNs are powerful, parallel, fault- and noise-tolerant, and learn from data without hand-coded rules — but their decisions can't be explained in terms of individual features. The **mathematical neuron** (synapses → weighted sum + nonlinear activation → output) is the building block; the **sigmoid** is the standard differentiable approximation to a step function. **McCulloch-Pitts neurons** formalise this model, and **weight matrices** generalise it from one neuron to entire layers. A **Perceptron** is the simplest such network (one input layer → one output layer), trained via the **Perceptron Learning Rule**, which is itself an instance of **gradient descent error minimisation** on the **Sum Squared Error** — the same family of ideas that [[Backpropagation]] generalises to deep multilayer networks. See [[Artificial Neural Networks (ANN)]] for the full worked example and formulas.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Neuron model, weight matrices, Perceptron, Perceptron Learning Rule, gradient descent/SSE | [[Artificial Neural Networks (ANN)]] | ✓ Verified |
| Sigmoid as a differentiable step-function approximation | [[Activation Functions]] | ✓ Verified |
| ANN architectures (MLP/RBF/SOM/CNN/LSTM) and their uses | [[Multilayer Perceptron (MLP)]], [[Self-Organizing Map (SOM)]], [[Convolutional Neural Networks (CNN)]], [[Long Short-Term Memory (LSTM)]] | ✓ Verified |
