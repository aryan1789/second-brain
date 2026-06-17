---
title: COMP838 Lecture 2 - Data Augmentation, ML vs DL, and Training Workflow
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture2.pdf]
related: [COMP838, Deep Neural Networks (DNN), Machine Learning vs Deep Learning, Data Augmentation, Neural Network Training Workflow, Self-Organizing Map (SOM), NARX Network]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 2 - Data Augmentation, ML vs DL, and Training Workflow

> [!tip] Scope note
> This lecture was largely a MATLAB toolbox walkthrough (MATLAB Online, Image Labeler app, specific toolbox function names like `nftool`/`patternnet`/`selforgmap`). Tool-specific tutorial steps have been omitted — only the underlying ML/DL concepts are captured below.

> [!tip] Going Deeper
> Each concept page linked below has been expanded with intuition/analogies, working Python (PyTorch/scikit-learn) code, and practical pitfalls — well beyond the lecture slides. This note is a Cornell-style summary; the concept pages are where the depth lives.

## Cues & Questions

> Cover the Notes section and try to answer each cue from memory.

- **What's the key structural difference between a "deep" neural network and a shallow one?**
- **What is the core distinction between classical ML and deep learning, in terms of feature engineering?**
- **Name five common image data augmentation techniques.**
- **Why does data augmentation help reduce overfitting?**
- **What's the typical train/validation/test split, and what is each portion used for?**
- **What does "NARX" stand for, and what kind of problem is it used for?**
- **What makes a Self-Organizing Map "unsupervised"?**

---

## Notes

### Deep Neural Networks (DNN)

A [[Deep Neural Networks (DNN)|DNN]] combines multiple nonlinear processing layers — an input layer, one or more hidden layers, and an output layer — connected via neurons, where each hidden layer uses the previous layer's output as its input. This is the concrete architecture behind the general "[[Deep Learning]]" framework introduced in Lecture 1.

### Machine Learning vs Deep Learning

> [!check] Verified
> See [[Machine Learning vs Deep Learning]] for the full comparison table.

The core distinction: classical machine learning relies on **human-crafted features**, while deep learning **learns features automatically** from raw data through its layered structure. Deep learning particularly excels at computer vision tasks (face recognition, motion detection, driver-assistance systems) where hand-engineering features would be impractical.

### Data Augmentation

> [!check] Verified
> See [[Data Augmentation]] for the full technique list and rationale.

[[Data Augmentation]] expands a training dataset by applying realistic transformations — resizing, rotation, reflection, shearing, translation, and colour adjustments — to existing data. This reduces overfitting by exposing the model to more variation without collecting new data.

### Neural Network Training Workflow

> [!check] Verified
> See [[Neural Network Training Workflow]] for the full 7-step workflow and train/val/test split details.

A general workflow applies across task types: collect data → create a network → configure → initialize weights → train → validate → use. The standard data split (~70% train / ~15% validation / ~15% test) lets you fit the model, tune it without leaking test information, and finally get an unbiased performance estimate.

### Task Types Covered

The lecture's MATLAB toolbox examples mapped onto four standard ML task categories — useful as a mental map of "what kind of problem is this?":

- **Function fitting (regression)** — predicting a continuous value
- **Pattern recognition (classification)** — predicting a discrete category
- **Clustering** — grouping unlabeled data, e.g. via [[Self-Organizing Map (SOM)|Self-Organizing Maps]]
- **Time-series prediction** — forecasting sequential data, e.g. via [[NARX Network|NARX networks]]

---

## Summary

This lecture's durable content boils down to four ideas: (1) a DNN is a multilayer network of input → hidden → output layers, the concrete realisation of "deep learning"; (2) the ML vs DL distinction is fundamentally about whether features are hand-crafted or learned automatically; (3) data augmentation (resize, rotate, flip, shear, translate, recolour) combats overfitting by synthetically expanding training data; and (4) a standard train/validate/use workflow with a ~70/15/15 data split applies across the four classic ML task types — regression, classification, clustering, and time-series prediction — with SOMs and NARX networks as named examples of clustering and time-series architectures respectively.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| DNN definition, training workflow, train/val/test split | Beale, Hagan, Demuth (2019), MATLAB R2019b Deep Learning Toolbox User's Guide | ➕ Cited in lecture, standard reference |
| ML vs DL distinction | [Databricks](https://www.databricks.com/blog/machine-learning-vs-deep-learning), [Google Cloud](https://cloud.google.com/discover/deep-learning-vs-machine-learning) | ✓ Verified |
| Data augmentation techniques | [Dive into Deep Learning](https://d2l.ai/chapter_computer-vision/image-augmentation.html), [arXiv:2301.02830](https://arxiv.org/abs/2301.02830) | ✓ Verified |
| Self-Organizing Map | [Wikipedia](https://en.wikipedia.org/wiki/Self-organizing_map) | ✓ Verified |
| NARX network | [MathWorks](https://www.mathworks.com/help/deeplearning/ug/create-narx-network-for-time-series-forecasting.html) | ✓ Verified |
