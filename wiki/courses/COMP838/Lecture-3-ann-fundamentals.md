---
title: COMP838 Lecture 3 - ANNs, MLPs, and Training Fundamentals
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture3.pdf]
related: [COMP838, Artificial Neural Networks (ANN), Multilayer Perceptron (MLP), Backpropagation, Stochastic Gradient Descent (SGD), Activation Functions, Loss Functions, Overfitting and Underfitting, Confusion Matrix Metrics, Universal Approximation Theorem]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 3 - ANNs, MLPs, and Training Fundamentals

> [!tip] Going Deeper
> Every concept page linked below has been expanded with intuition/analogies, runnable Python (PyTorch/scikit-learn) examples — including a hands-on XOR demo for MLPs and a live function-approximation demo for the Universal Approximation Theorem — and practical pitfalls. This note is a Cornell-style summary; the concept pages are where the depth lives.

This is the most theoretically dense lecture so far — the core mathematical machinery behind how neural networks are structured, trained, and evaluated.

## Cues & Questions

> Cover the Notes section and try to answer each cue from memory.

- **What are the three functional operations a neuron performs?**
- **What three layer types does an MLP have at minimum, and why must hidden-layer activations be nonlinear?**
- **Write out the backpropagation weight update rule. What does each symbol mean?**
- **What's the difference between what backpropagation computes and what SGD does with it?**
- **Why does ReLU largely avoid the vanishing gradient problem that affects sigmoid/tanh?**
- **Give the formulas for 0-1 loss, square loss, and log loss. When would you use each?**
- **What causes underfitting vs. overfitting, and what's the visual signature of each?**
- **Given TP, TN, FP, FN — derive TPR, FPR, PPV, ACC, and F1.**
- **What does the Universal Approximation Theorem actually guarantee, and what does it NOT guarantee?**

---

## Notes

### The Neuron Model

[[Artificial Neural Networks (ANN)|ANNs]] are built from neurons performing three operations: a **weight function** (`W·p`), an **input function** adding bias (`n = W·p + b`), and a **transfer/activation function** (`a = f(n)`). Stacking neurons into layers, and layers into networks, is the foundation for everything else in this lecture.

### Multilayer Perceptrons and Backpropagation

A [[Multilayer Perceptron (MLP)|Multilayer Perceptron]] is a feedforward ANN with input, hidden, and output layers, where hidden units use nonlinear [[Activation Functions|activation functions]]. This nonlinearity is what lets MLPs separate data that isn't linearly separable, and underlies the [[Universal Approximation Theorem]] — MLPs can approximate a very broad class of functions (though the theorem doesn't tell you *how many* units you need or *how* to find the weights).

[[Backpropagation]] is how the weights are actually found: it computes the gradient of the [[Loss Functions|loss]] with respect to every weight via the chain rule, working backward through the layers. [[Stochastic Gradient Descent (SGD)|SGD]] then uses that gradient — computed on small mini-batches — to iteratively update the weights until the loss stops decreasing.

### Activation and Loss Functions

> [!check] Verified
> See [[Activation Functions]] and [[Loss Functions]] for full formulas and verification sources.

Three activation functions matter most: **ReLU** (`max(0,x)`, default for hidden layers in deep nets), **Tanh** (zero-centred, `(-1,1)`), and **Sigmoid** (`(0,1)`, useful for probability-like outputs). The choice affects how well gradients flow during backpropagation — ReLU's constant positive-region gradient is why it dominates modern deep networks.

Loss functions quantify prediction error: **0-1 loss** (counts mistakes, not differentiable), **square loss** (penalises large errors more), **absolute loss** (robust to outliers), and **log loss** (penalises confident wrong predictions, basis of cross-entropy). Training minimises the **average loss** over the training set.

### Overfitting, Underfitting, and Evaluation

> [!check] Verified
> See [[Overfitting and Underfitting]] and [[Confusion Matrix Metrics]] for full details.

Model capacity must match the problem: too few neurons → **underfitting** (model too simple to capture the pattern); too many → **overfitting** (model memorises training data, fits noise, generalises poorly — visible as a wildly oscillating fit curve between training points).

For classification, the **confusion matrix** (TP/TN/FP/FN) underlies a family of evaluation metrics: **TPR/Recall**, **FPR**, **PPV/Precision**, **Accuracy**, and **F1 score**. F1 in particular matters for imbalanced datasets where accuracy alone is misleading.

---

## Summary

This lecture covers the core mechanics of training neural networks: the neuron model (weight, input, and activation functions) composes into MLPs; backpropagation computes gradients via the chain rule, and SGD uses them to update weights iteratively; activation function choice (especially ReLU vs. sigmoid/tanh) affects gradient flow during training; loss functions define what "error" means and what's being minimised; model capacity must be balanced to avoid underfitting or overfitting; and classification performance is measured via confusion-matrix-derived metrics (precision, recall, F1) rather than accuracy alone. The Universal Approximation Theorem provides the theoretical grounding for why MLPs work as general function approximators — but doesn't replace the empirical workflow ([[Neural Network Training Workflow]]) for actually finding good weights.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| ANN neuron model, layers | Kasabov (1996), Foundations of Neural Networks | ➕ Cited in lecture, standard reference |
| MLP definition, structure | [Wikipedia: Multilayer perceptron](https://en.wikipedia.org/wiki/Multilayer_perceptron) | ✓ Verified |
| Backpropagation, SGD | LeCun, Bengio & Hinton (2015); Goodfellow, Bengio & Courville (2016) | ➕ Cited in lecture, standard references |
| Activation functions (ReLU/Tanh/Sigmoid) | [GeeksforGeeks](https://www.geeksforgeeks.org/machine-learning/activation-functions-neural-networks/) | ✓ Verified |
| Overfitting/underfitting | [Cross Validated](https://stats.stackexchange.com/questions/306574/which-elements-of-a-neural-network-can-lead-to-overfitting) | ✓ Verified |
| Confusion matrix metrics | [Google ML Crash Course](https://developers.google.com/machine-learning/crash-course/classification/accuracy-precision-recall) | ✓ Verified |
| Universal Approximation Theorem (corrected from lecture's "Kolmogorov Theorem") | [Wikipedia](https://en.wikipedia.org/wiki/Universal_approximation_theorem) | ⚠️ Corrected — see [[Universal Approximation Theorem]] |
