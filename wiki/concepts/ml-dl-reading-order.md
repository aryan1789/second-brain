---
title: ML/DL Concept Reading Order
type: concept
sources: []
related: [Machine Learning vs Deep Learning, Deep Learning, Neural Network Training Workflow]
created: 17-06-2026
last-updated: 17-06-2026
---

# ML/DL Concept Reading Order

A suggested reading path through all concept pages — ordered so each page builds on what came before. Grouped into 12 phases from foundational ML through modern AI architecture.

Skip phases you already know. Each phase is self-contained enough to jump in.

---

## Phase 1 — ML Landscape and Data

Orient yourself to what ML is and how data work happens before any algorithm.

1. [[Machine Learning vs Deep Learning]] — the big-picture distinction between hand-crafted and learned features
2. [[Knowledge Discovery (KDD) Process]] — the 6-step loop from raw data to deployed model
3. [[Data Preprocessing and Data Quality]] — noise, missing values, normalisation, feature selection
4. [[Classification (Supervised Learning)]] — training/test splits, structural descriptions, the core supervised task
5. [[Linear Regression and Numeric Prediction]] — the supervised analogue when the target is continuous
6. [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)]] — inductive bias vs. unrepresentative data; a distinction that recurs everywhere

---

## Phase 2 — Classic ML Algorithms

The workhorses before neural networks. Understanding these makes neural net motivations clearer.

7. [[Naive Bayes Classifier]] — Bayes theorem + conditional independence; a probabilistic baseline
8. [[Decision Trees and Information Gain]] — entropy, information gain, top-down tree construction
9. [[K-Nearest Neighbors (KNN)]] — lazy, instance-based; no training, just distance at inference
10. [[Ensemble Learning]] — bagging, boosting, random forests; combining weak learners into strong ones
11. [[K-Means Clustering]] — unsupervised partitioning; the canonical "no labels" algorithm
12. [[Self-Organizing Map (SOM)]] — unsupervised clustering via competitive learning; a bridge toward neural methods

---

## Phase 3 — Evaluating Models

Evaluation concepts that apply to every algorithm in every phase. Read before any deep-dive.

13. [[Confusion Matrix Metrics]] — TPR, FPR, precision, recall, F1; why accuracy alone lies
14. [[Bias-Variance Tradeoff]] — the fundamental learner tension: fit vs. generalisation
15. [[Cross-Validation]] — k-fold and stratified k-fold; reliable model selection
16. [[Overfitting and Underfitting]] — model capacity vs. data; the symptom of the bias-variance problem

---

## Phase 4 — Neural Network Foundations

The mechanics every neural network is built from.

17. [[Artificial Neural Networks (ANN)]] — neuron model: weights, inputs, transfer functions
18. [[Activation Functions]] — ReLU, Tanh, Sigmoid; why nonlinearity is everything
19. [[Loss Functions]] — 0-1, square, log loss; what the network is actually minimising
20. [[Backpropagation]] — gradient computation via the chain rule; how error flows backward
21. [[Stochastic Gradient Descent (SGD)]] — mini-batch weight update; the engine of learning
22. [[Multilayer Perceptron (MLP)]] — feedforward ANN with nonlinear hidden layers; the basic deep model
23. [[Neural Network Training Workflow]] — 7-step workflow, train/val/test split, epochs vs. batches
24. [[Universal Approximation Theorem]] — theoretical justification for why MLPs can approximate anything
25. [[Data Augmentation]] — resize, rotate, flip, shear; practical regularisation for small datasets

---

## Phase 5 — Going Deep

What makes "deep" learning different from a big MLP.

26. [[Deep Learning]] — stacked nonlinear modules, selectivity vs. invariance, LeCun/Bengio/Hinton
27. [[Deep Neural Networks (DNN)]] — input/hidden/output architecture; depth vs. width tradeoffs

---

## Phase 6 — Convolutional Neural Networks

The dominant vision architecture. Spatial structure → local connections + shared weights.

28. [[Convolutional Neural Networks (CNN)]] — local connections, weight sharing, pooling, multilayers
29. [[Receptive Field, Stride, and Padding]] — output-size formula; how spatial dimensions shrink
30. [[Softmax Function]] — converting logits to a probability distribution over classes

---

## Phase 7 — CNN Architectures (Historical → Modern)

Read in this order — each architecture reacts to the previous one's weakness.

31. [[AlexNet]] — 8-layer CNN, won ILSVRC 2012; kickstarted the deep learning era
32. [[VGG (VGG-16 / VGG-19)]] — depth via uniform 3×3 convolutions; showed depth > receptive field size
33. [[GoogLeNet and the Inception Architecture]] — parallel multi-scale Inception modules; efficiency over raw depth
34. [[Residual Networks (ResNet)]] — identity shortcuts; fixed the degradation problem and enabled 100+ layer networks
35. [[Densely Connected Convolutional Network (DenseNet)]] — every layer connected to all subsequent layers; max feature reuse

---

## Phase 8 — Object Detection

Classification tells you *what*; detection tells you *what and where*. Build on Phase 6–7.

36. [[Intersection over Union (IoU)]] — bounding box overlap metric; the evaluation currency of detection
37. [[Anchor Boxes]] — predefined box templates; how detectors pre-parameterise shape space
38. [[One-Stage vs Two-Stage Object Detection]] — speed vs. accuracy tradeoff; the architectural fork
39. [[R-CNN Family]] — R-CNN → Fast R-CNN → Faster R-CNN; the two-stage lineage
40. [[YOLO (You Only Look Once)]] — one-stage, grid-based, real-time; v1 → v4 evolution
41. [[SSD (Single Shot MultiBox Detector)]] — multi-scale one-stage detection
42. [[Transfer Learning and YOLO for Classification]] — applied example: YOLOv4 + transfer learning on a real dataset

---

## Phase 9 — Sequence Models

Handling data where order matters: time series, text, signals.

43. [[Recurrent Neural Networks (RNN)]] — shared weights across time; the basic sequence model
44. [[Long Short-Term Memory (LSTM)]] — gated memory cell; fixes the vanishing gradient problem in RNNs
45. [[NARX Network]] — nonlinear autoregressive network; RNN variant for time-series forecasting

---

## Phase 10 — Attention and Transformers

The architecture that replaced RNNs for most sequence tasks and then spread everywhere.

46. [[Transformer (Attention Is All You Need)]] — self-attention replaces recurrence; encoder-decoder, positional encoding
47. [[Vision Transformer (ViT)]] — images as sequences of patch tokens through a Transformer encoder

---

## Phase 11 — NLP and Text Mining

Language-specific pipeline on top of the sequence/transformer foundations.

48. [[NLP Text Preprocessing Pipeline]] — tokenisation, stop words, normalisation, stemming vs. lemmatisation
49. [[TF-IDF and Feature Selection for Text]] — bag-of-words, mutual information, TF-IDF weighting
50. [[Word Embeddings (Word2Vec and GloVe)]] — dense semantic vectors via CBOW, Skip-gram, GloVe
51. [[Named Entity Recognition and Relation Extraction]] — triples, Hearst patterns, supervised and bootstrapped extraction

---

## Phase 12 — Advanced and Frontier

Generative models, RL, and scaling — read once you're solid on Phases 4–11.

52. [[Generative Adversarial Network (GAN)]] — generator vs. discriminator minimax game
53. [[Reinforcement Learning (RL)]] — agent learns via reward from environment interaction
54. [[Transfer Learning]] — reusing a model trained on one task as the starting point for another
55. [[Distributed Training of Deep Neural Networks (Data Parallelism)]] — multi-GPU training and the batch size / learning rate scaling rule

---

## Phase 13 — Modern AI Architecture

Agentic systems built on top of the models from every prior phase.

56. [[Model Context Protocol (MCP)]] — USB-C for agent harnesses; reduces N×M tool integration to O(N+M)
57. [[Multi-Agent AI Systems Architecture]] — orchestrator + specialist agents; context, tool-use, coordination patterns
58. [[Agent-to-Agent Protocol (A2A)]] — collaborative agent delegation across networks; agent cards, AaaS, L402

---

## Quick-Reference: Phase by Skill Goal

| Goal | Phases |
|---|---|
| Understand what ML is and how data gets prepared | 1 |
| Know the classic algorithms (interviews, coursework) | 1, 2, 3 |
| Build and train neural networks from scratch | 4, 5 |
| Work on computer vision / image tasks | 6, 7, 8 |
| Work on time-series or sequential data | 9, 10 |
| Work on NLP / text | 10, 11 |
| Understand modern LLMs and generative AI | 10, 12 |
| Build agentic systems with LLMs | 13 |
