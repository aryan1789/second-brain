---
title: COMP723 Lecture 5.2 - Training MLPs, Strengths, and Weaknesses
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture5.pptx]
related: [COMP723, Multilayer Perceptron (MLP), Softmax Function, Backpropagation, Neural Network Training Workflow, Overfitting and Underfitting, Decision Trees and Information Gain, Naive Bayes Classifier]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP723 Lecture 5.2 - Training MLPs, Strengths, and Weaknesses

> [!tip] Going Deeper
> [[Multilayer Perceptron (MLP)]] covers the XOR problem and linear separability in full. [[Softmax Function]] covers multi-class classification in depth. [[Backpropagation]] covers the chain rule and weight-update rule. [[Neural Network Training Workflow]] has been supplemented with this lecture's hidden-neuron and momentum heuristics, and [[Overfitting and Underfitting]] has been supplemented with this lecture's Diabetes-dataset worked example. This note summarises the lecture's framing of slides 23-49.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **What does the Perceptron Model compute, and how does it decide its output (threshold comparison)?**
- **Why can't a single perceptron solve XOR? What's the fix?**
- **Walk through the AND-with-NOT truth table. Why are NOT X1 and NOT X2 included as inputs?**
- **How does the XNOR network decompose XNOR into two simpler sub-problems (a1, a2) computed in parallel?**
- **What does the Softmax layer do, and what is "one-hot representation"?**
- **In the lecture's "General Algorithm for learning ANN," how is `Δw_jk` computed, and what does it mean if the actual output (1.2) is higher than the desired output (1.0)?**
- **List the 5 "Major Parameters for Multi Layer Perceptrons."**
- **Give 3 strengths and 3 weaknesses of Neural Networks compared to Decision Trees / Naive Bayes.**
- **What did the Diabetes dataset experiment show about hidden-neuron count and overfitting?**

---

## Notes

### The Perceptron Model and General ANN Structure

The lecture re-introduces the **Perceptron Model**: an assembly of inter-connected nodes and weighted links, where the **output node sums up each of its input values according to the link weights**, then **compares this sum against some threshold `t`** to decide its output. This is illustrated with a worked example: *"Output Y is 1 if at least two of the three inputs are equal to 1"* — a majority-vote function implementable by a single perceptron with appropriate weights and threshold. **Training an ANN means learning the weights of the neurons** — this is the general framing that the rest of the lecture builds on.

### Limitations of Simple Perceptrons, Revisited

Simple perceptrons can classify problems that are **linearly separable** — a single line separates the classes with zero (or near-zero) error. They **cannot solve non-linear problems like XOR** — solving these requires adding a **hidden layer** of neurons. See [[Multilayer Perceptron (MLP)]] for the full XOR walkthrough (this lecture's framing is identical).

### Worked Examples: Solving Logical Functions with Weights

The lecture works through several small networks where specific **weight values** are given/derived to compute logical functions — concretely demonstrating "training an ANN means learning the weights":

- **Logical AND** — solved directly with the sigmoid as the activation function `f`.
- **Logical AND with NOT as operands** — extends the truth table to include `NOT X1` and `NOT X2` as additional inputs alongside `X1` and `X2`, then asks for the network's weights to reproduce the desired output `y` for all 4 input combinations. Including the negated inputs as explicit features is itself a form of feature engineering that makes the target function easier for a single layer to represent.
- **Logical OR** — solved similarly.
- **Logical XNOR** — explicitly framed as **harder than AND**, because it **cannot be solved by a single neuron** — it's a **2-stage process**. The decomposition given is:

  ```
  (X1 XNOR X2) = a1 OR a2
  where a1 = (X1 AND X2)  and  a2 = (NOT X1 AND NOT X2)
  ```

  | X1 | X2 | a1 | a2 | a1 OR a2 (= X1 XNOR X2) |
  |---|---|---|---|---|
  | 0 | 0 | 0 | 1 | 1 |
  | 0 | 1 | 0 | 0 | 0 |
  | 1 | 0 | 0 | 0 | 0 |
  | 1 | 1 | 1 | 0 | 1 |

  Because `a1` and `a2` can be **computed in parallel**, **2 neurons are assigned to the hidden (intermediate) layer** to compute them, and a third output neuron computes `a1 OR a2`. The lecture gives concrete weight values for this network (e.g. `-30`, `-30`, `20`, `20`, `-10`) showing exactly how the thresholds and weights combine to reproduce the XNOR truth table — a fully worked instance of "why hidden layers let MLPs solve non-linearly-separable problems" (see [[Multilayer Perceptron (MLP)]]).

### Softmax for Multi-Class Classification

Classification problems involving **more than two classes** are solved through the **Softmax** function, implemented as an additional layer. The lecture's example: given hidden-layer outputs ("logits"), a Softmax layer produces a **one-hot representation** answering yes/no for each of several classes simultaneously (e.g. `apple: yes/no? bear: yes/no? candy: yes/no? dog: yes/no? egg: yes/no?`) — i.e., a probability distribution over mutually-exclusive classes. See [[Softmax Function]] for the full formula, the sigmoid-vs-softmax comparison, and why you rarely call softmax directly when using `nn.CrossEntropyLoss`.

### General Algorithm for Learning ANN (Weight Update)

The lecture gives a general, intuitive algorithm for learning ANN weights:

1. **Initialize the weights** `(w₀, w₁, ..., wₖ)`.
2. **Compute the error** at each output node `k`, and at each hidden node `j` connected to it.
3. **Adjust the weights** `w_jk` such that:

   ```
   w_jk(new) = w_jk(current) + Δw_jk
   where Δw_jk = r · Error(k) · O_j
   ```

   `r` = learning rate (`0 < r < 1`), `Error(k)` = computed error at node `k`, `O_j` = output of node `j`.

**Worked numerical example:** if the desired output at node `k` is `1.0` and the actual output is `1.2`, then `Error(k) = (1 - 1.2) = -0.2` — a **negative error**, meaning the output is **too high**, so the weights of *all* incoming links from nodes feeding `k` (e.g. `j1`, `j2`) need to **decrease**. This adjustment is done **iteratively**, scanning the data many times, until the error is below some threshold.

### Backpropagation Learning

A **rigorous derivation** of the weight-update expression above, using **gradient descent**, is referred to as **backpropagation learning** — gradient descent is "commonly used for minimizing a function." The **loss function** (also called the **cost function**) in backpropagation learning quantifies the error being minimised. See [[Backpropagation]] for the full chain-rule derivation and the `x(k+1) = x(k) - η·g(k)` update rule — the general-algorithm `Δw_jk = r · Error(k) · O_j` above is a simplified, single-layer special case of this.

### Major Parameters for Multi Layer Perceptrons

The lecture lists 5 major parameters — see [[Neural Network Training Workflow]] for the full heuristics added from this lecture:

1. **Learning rate** — size of weight-adjustment steps; larger = faster but may hurt accuracy.
2. **Number of epochs** — number of times the training data is scanned; generally 100+ for accuracy.
3. **Batch size** — number of datapoints propagated through before a weight update.
4. **Number of hidden neurons** — rule of thumb: `(attributes + classes) / 2`.
5. **Momentum** — a fraction of the previous update added to the current one, for smoother learning.

### Neural Networks: Strengths

- Work well with **datasets containing noise**.
- **Consistently good accuracy rates** across several domains.
- Can be used for both **supervised** (classification and numeric prediction) **and unsupervised** learning.

### Worked Example: Overfitting with MLP (Diabetes Dataset)

With the Diabetes dataset:

- **300 hidden neurons** → **79% training accuracy, 71% test accuracy** — a clear sign of **overfitting**: "an accurate model learns the existing data but the model cannot predict very well on new data that is arriving."
- **100 hidden neurons** → **76% accuracy on both training and test** — better generalisation.

See [[Overfitting and Underfitting]] for this example in the context of model capacity more broadly.

### Neural Network Applications

In general, ANNs can be used for **classification** (e.g. recognising printed and handwritten digits) and **numeric prediction** (e.g. forecasting time-series data such as weather — temperature, pressure, wind speed — or stock market prices). The lecture references two illustrative demos: a neural network recognising handwritten digits, and a neural network learning to play Pong.

### Neural Networks: Weaknesses

- **Lack the ability to explain their behaviour** — unlike [[Decision Trees and Information Gain|Decision Trees]] and [[Naive Bayes Classifier|Naive Bayes]].
- **Overtraining can cause overfitting** (see the Diabetes example above).
- **Training time can be very large** with large datasets — much larger than Decision Tree and Naive Bayes methods.
- **Deep learning lacks feature introspection** — with NNs, you can debug the *process* but **cannot map decisions back to individual input features**, whereas with (random forest) decision trees you can.

### Deep Learning and Neural Networks (Brief Intro)

The lecture briefly introduces **deep learning** as not requiring you to label everything, and notes its advantage over classical NNs and other ML algorithms: deep learning **can extrapolate new features from a limited set of features** in the training set, searching for other features that correlate with the existing ones. (This is left as a brief forward-pointer; see [[Deep Learning]] and [[Deep Neural Networks (DNN)]] for the full treatment from COMP838.)

The lecture closes with a lab demo referencing a **Mobile Price Classification** dataset.

---

## Summary

This lecture works through the mechanics of training an MLP via concrete examples: the **Perceptron Model** (weighted sum vs. threshold), why simple perceptrons are limited to **linearly separable** problems, and a sequence of worked logic-gate examples (AND, AND-with-NOT, OR, and especially **XNOR**, which requires a 2-neuron hidden layer to decompose into `a1 OR a2`). **Softmax** extends this to multi-class problems via a one-hot output layer. The **general weight-update algorithm** (`Δw_jk = r · Error(k) · O_j`) is presented as an intuitive precursor to the rigorous **backpropagation** derivation via gradient descent on a loss/cost function. Five **major MLP parameters** (learning rate, epochs, batch size, hidden neurons, momentum) govern training behaviour — with the **Diabetes dataset** example showing concretely how too many hidden neurons (300 vs. 100) causes **overfitting**. Finally, the lecture frames NNs' **strengths** (noise tolerance, consistent accuracy, supervised+unsupervised) against their **weaknesses** (no explainability, overfitting risk, long training times, no feature introspection) relative to Decision Trees and Naive Bayes — directly echoing Lecture 1's "decisions can't be explained" characteristic and the [[Bias-Variance Tradeoff]] theme from Lecture 4.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| XOR/linear separability, hidden layers | [[Multilayer Perceptron (MLP)]] | ✓ Verified |
| Softmax, one-hot multi-class output | [[Softmax Function]] | ✓ Verified |
| Backpropagation, gradient descent, loss/cost function | [[Backpropagation]] | ✓ Verified |
| MLP parameters (learning rate, epochs, batch size, hidden neurons, momentum) | [[Neural Network Training Workflow]] | ✓ Verified |
| Overfitting with hidden-neuron count (Diabetes dataset) | [[Overfitting and Underfitting]] | ✓ Verified |
| NN weaknesses vs. Decision Trees/Naive Bayes (explainability) | [[Decision Trees and Information Gain]], [[Naive Bayes Classifier]] | ✓ Verified |
