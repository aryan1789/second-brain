---
title: COMP838 Lecture 10.1 - Parallel and Cloud Computing for Deep Learning
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture10.pdf]
related: [COMP838, Distributed Training of Deep Neural Networks (Data Parallelism), Stochastic Gradient Descent (SGD)]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 10.1 - Parallel and Cloud Computing for Deep Learning

> [!tip] Going Deeper
> [[Distributed Training of Deep Neural Networks (Data Parallelism)]] has a full concept page with intuition, the batch-size/learning-rate scaling relationship, a PyTorch `DataParallel` example, and pitfalls (communication overhead, federated learning). This note summarises the lecture's framing of parallel and cloud computing for deep learning.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **What property of neural network training makes it "inherently parallel"?**
- **What does MATLAB do to the mini-batch size and learning rate when training on multiple GPUs, and why?**
- **What determines the "optimal" batch size?**
- **What does Google Colab provide, and why is it useful for deep learning?**
- **What is federated learning, in one sentence?**

---

## Notes

### Parallel Computing for Deep Learning

Training deep networks is computationally intensive, but the lecture notes that **neural networks are inherently parallel algorithms** — the same computation is repeated across every example in a batch. In practice, training [[Convolutional Neural Networks (CNN)|CNNs]] is accelerated by **distributing it across multicore CPUs, GPUs, and clusters with multiple CPUs/GPUs** (MATLAB requires its Parallel Computing Toolbox for GPU/parallel options, and supports training a single network across multiple GPUs).

A **GPU (Graphics Processing Unit)** is described as a specialised electronic circuit originally designed to accelerate image/frame-buffer rendering for a display; modern GPUs are also highly efficient at the kind of bulk parallel arithmetic that deep learning training requires, which is why they've become the standard hardware for it.

To speed up training with multiple GPUs, the lecture states that MATLAB **increases the mini-batch size and learning rate together** — a larger batch size and learning rate can speed up training without an accuracy decrease, *if* scaled appropriately.

> [!check] Verified
> This is the **linear scaling rule**: when the (effective) batch size is multiplied by `k`, the learning rate should also be multiplied by roughly `k` to keep the expected weight-update magnitude consistent — see Goyal et al. (2017), *Accurate, Large Minibatch SGD: Training ImageNet in 1 Hour*, and [[Distributed Training of Deep Neural Networks (Data Parallelism)]] for the full explanation and a PyTorch example.

The lecture notes that CNNs are typically trained iteratively using a batch size, and that the **optimal batch size depends on the specific network, dataset, and GPU hardware** — i.e. there's no universal best value.

The referenced MATLAB workflow for training a network in parallel with a custom training loop follows the same overall shape as the standard [[Neural Network Training Workflow]] from Lecture 2, with parallelism-specific steps added: load the dataset into an image datastore, split into train/test datastores, define the network as a layer graph, check GPU availability, train with specified options, then evaluate accuracy on the test set.

### Cloud Computing for Deep Learning

The lecture frames cloud computing as a way to scale up the same parallel training further: using the cloud, training can be accelerated with **multiple GPUs on a single machine or across a cluster of machines with multiple GPUs**, either to train one network faster or to **train multiple models at once on the same data**. The practical steps given are: set up cloud accounts, copy data to the cloud, and create a compute cluster.

**Google Colab** ("Colaboratory") is introduced as a free, browser-based environment for writing and running Python code, requiring zero configuration, with free access to GPUs/TPUs/NPUs (code executes on Google's cloud servers) and easy sharing — giving access to the standard Python data science/ML library ecosystem from any browser. The lecture lists its common uses in the ML community: getting started with TensorFlow, developing/training neural networks, experimenting with GPUs/TPUs, disseminating AI research, and creating tutorials.

> [!tip] Supplemented
> The lecture's bullet list also mentions "Train Network Using **Federated Learning**" as one of MATLAB's parallel/cloud deep learning examples, without further explanation. Federated learning trains a shared model across many participants' *local, private* datasets — only model updates (not raw data) are shared and aggregated centrally — used when data cannot be centralised for privacy, regulatory, or bandwidth reasons. See [[Distributed Training of Deep Neural Networks (Data Parallelism)]] for how this contrasts with standard data-parallel training.

---

## Summary

This lecture covers the infrastructure side of deep learning: because neural network training is inherently parallel (the same computation repeats across every batch element), it's commonly accelerated using GPUs, multi-GPU machines, and clusters. When scaling to multiple GPUs, both batch size and learning rate are typically increased together (the linear scaling rule) to maintain training speed without sacrificing accuracy, though the optimal batch size remains dataset/network/hardware-dependent. Cloud computing extends this further — letting you train one model faster across a GPU cluster, or train multiple models in parallel on the same data — with Google Colab highlighted as a free, zero-configuration way to access cloud GPUs/TPUs for ML experimentation. Federated learning is mentioned in passing as a privacy-preserving alternative to centralised distributed training.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Neural network training is inherently parallel; accelerated via GPUs/clusters | [Training on Multiple GPUs (Dive into Deep Learning)](https://d2l.ai/chapter_computational-performance/multiple-gpus.html) | ✓ Verified |
| Scaling batch size and learning rate together for multi-GPU training | Goyal, P. et al. (2017). *Accurate, Large Minibatch SGD*. arXiv:1706.02677 | ✓ Verified |
| Google Colab: free browser-based Python with GPU/TPU access | [Google Colab](https://colab.research.google.com/) (product description, lecture-referenced) | ✓ Verified |
| Federated learning definition | [[Distributed Training of Deep Neural Networks (Data Parallelism)]] | ➕ Supplemented |
