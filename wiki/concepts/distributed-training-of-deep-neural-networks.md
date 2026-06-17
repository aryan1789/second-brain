---
title: Distributed Training of Deep Neural Networks (Data Parallelism)
type: concept
sources: [https://d2l.ai/chapter_computational-performance/multiple-gpus.html, https://www.jeremyjordan.me/distributed-training/, Goyal, P. et al. (2017). Accurate, Large Minibatch SGD: Training ImageNet in 1 Hour. arXiv:1706.02677]
related: [Stochastic Gradient Descent (SGD), Neural Network Training Workflow, Backpropagation]
created: 12-06-2026
last-updated: 12-06-2026
---

# Distributed Training of Deep Neural Networks (Data Parallelism)

## The Core Idea

Training deep networks is computationally intensive, but neural network training is *inherently parallel*: the same forward/backward pass computation is repeated independently for every example in a [[Stochastic Gradient Descent (SGD)|mini-batch]]. **Data parallelism** exploits this by splitting each mini-batch across multiple GPUs (or machines), having each device compute gradients on its slice of the batch independently, then averaging (synchronising) those gradients before updating a shared copy of the model's weights. This is the dominant way deep CNNs are accelerated using multiple GPUs, multi-GPU servers, or clusters.

## Intuition: Many Workers, One Recipe, Shared Notes

Imagine a kitchen with one recipe (the model) and a huge pile of ingredients to prep (a mini-batch of training examples). Instead of one chef prepping everything sequentially, you give each of several chefs (GPUs) an equal slice of the ingredients and have them all follow the *same* recipe in parallel. Afterward, everyone compares notes on what they learned (gradients), averages those notes together, and every chef updates their copy of the recipe (model weights) identically — so they all stay in sync for the next batch. The more chefs you have, the more ingredients (effective batch size) you can prep per round.

## Why Batch Size and Learning Rate Are Linked

Splitting a mini-batch across `N` GPUs means each GPU effectively processes `batch_size / N` examples, but to keep each GPU fully utilised, the *total* (effective) batch size is usually scaled *up* by `N` instead. The lecture's framing — "to speed up training using multiple GPUs, MATLAB increases the mini-batch size and learning rate" — reflects the **linear scaling rule**: when the effective batch size increases by a factor `k`, multiply the learning rate by `k` too, so that the *expected* size of each weight update stays roughly the same (Goyal et al., 2017, *Accurate, Large Minibatch SGD*). Without this adjustment, a much larger batch size means fewer, "blunter" gradient updates per epoch, which can slow convergence or hurt final accuracy.

The lecture correctly notes the optimal batch size is dataset/network/hardware-dependent — there's no universal "best" value, only trade-offs between GPU memory, throughput, and convergence behaviour.

## In Practice: Data Parallelism (PyTorch)

```python
import torch
import torch.nn as nn

model = nn.Sequential(nn.Linear(784, 256), nn.ReLU(), nn.Linear(256, 10))

# Wrap the model so the same weights are replicated across all visible GPUs
model = nn.DataParallel(model)
model = model.cuda()

# A mini-batch is automatically split across GPUs, gradients are averaged
# after the backward pass, and the optimizer updates one shared set of weights.
optimizer = torch.optim.SGD(model.parameters(), lr=0.1 * torch.cuda.device_count())
```

`nn.DataParallel` is the simplest (though not the most efficient) way to do data-parallel training in PyTorch; `torch.nn.parallel.DistributedDataParallel` (DDP) is the production-grade equivalent used for multi-machine clusters, mirroring the "train in parallel across multicore CPUs, GPUs, and clusters" framing from the lecture.

## Common Pitfalls & Practical Tips

- **Communication overhead** can dominate at high GPU counts — if gradient synchronisation takes longer than the forward/backward pass itself, adding more GPUs can make training *slower*, not faster (a real issue reported by practitioners using `DataParallel`/`DistributedDataParallel`).
- **Don't forget to scale the learning rate** when scaling the batch size — this is the single most common mistake when moving from single-GPU to multi-GPU training.
- **Federated learning** is a related but distinct setting: instead of splitting one centralised dataset across GPUs you control, each participant trains on their own *local, private* data and only shares model updates (not raw data) — used when data can't be centralised for privacy or regulatory reasons. MATLAB's "Train Network Using Federated Learning" example (referenced in the lecture) applies this pattern.

## Related Concepts

- [[Stochastic Gradient Descent (SGD)]] — data parallelism distributes the per-batch gradient computation that SGD performs every iteration.
- [[Neural Network Training Workflow]] — distributed training changes *how fast* training runs, not the overall train/val/test workflow.
- [[Backpropagation]] — the per-GPU computation being parallelised is exactly a forward + backward pass.

**Source:** [Training on Multiple GPUs (Dive into Deep Learning)](https://d2l.ai/chapter_computational-performance/multiple-gpus.html); [Goyal, P. et al. (2017). Accurate, Large Minibatch SGD. arXiv:1706.02677](https://arxiv.org/abs/1706.02677)
