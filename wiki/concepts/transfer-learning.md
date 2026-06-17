---
title: Transfer Learning
type: concept
sources: [Pan, S. & Yang, Q. (2010). A Survey on Transfer Learning. IEEE Transactions on Knowledge and Data Engineering, 22(10), 1345-1359., Shao, L. et al. (2015). Transfer Learning for Visual Categorization: A Survey. IEEE Transactions on Neural Networks and Learning Systems, 26(5)., https://www.ibm.com/think/topics/transfer-learning]
related: [Deep Learning, AlexNet, VGG (VGG-16 / VGG-19), GoogLeNet and the Inception Architecture, Transfer Learning and YOLO for Classification, Ensemble Learning]
created: 12-06-2026
last-updated: 12-06-2026
---

# Transfer Learning

## The Core Idea

Transfer learning is a machine learning method where a model developed for one task is reused as the starting point for a model on a second, related task (Shao et al., 2015). More formally, Pan & Yang (2010) frame it as extracting knowledge from one or more **source tasks** `T_S` (learned over a source domain `D_S`) and applying that knowledge to a **target task** `T_T` over a target domain `D_T` — where the domains and/or tasks are allowed to differ between source and target.

## Intuition: Don't Learn to See from Scratch

Imagine teaching someone to recognise birds after they've already spent years learning to recognise animals in general. They don't need to relearn what edges, textures, colours, and shapes look like — they already have those visual building blocks, and only need to learn what's *specific* to distinguishing bird species. Deep CNNs work the same way: early layers learn generic features (edges, textures, simple shapes) that transfer well across almost any image task, while later layers specialise toward the original task's specific classes. Transfer learning **reuses the generic early/middle layers** of a network trained on a large dataset (e.g. ImageNet) and only retrains (or lightly fine-tunes) the later layers for the new task.

## Categories of Transfer Learning

Pan & Yang's survey (2010) categorises transfer learning along two questions — *what* to transfer, and *when/how* — based on whether the source and target tasks (`T_S`/`T_T`) and domains (`D_S`/`D_T`) match:

- **Inductive transfer learning** — `T_S ≠ T_T` (different tasks), regardless of whether `D_S = D_T`. Labelled data is available in the target domain.
- **Transductive transfer learning** — `T_S = T_T` (same task) but `D_S ≠ D_T` (different domains). No labelled target data is typically available.
- **Unsupervised transfer learning** — `T_S ≠ T_T` and both source and target domains lack labelled data; focuses on unsupervised tasks like clustering or dimensionality reduction.

### Approaches: What to Transfer

| Approach | Description |
|---|---|
| **Instance-transfer** | Re-weight some labelled data in the source domain for use in the target domain |
| **Feature-representation-transfer** | Find a feature representation that reduces the difference between source and target domains and the error of the target model |
| **Parameter-transfer** | Discover shared parameters or priors between the source and target domain models |
| **Relational-knowledge-transfer** | Build a mapping of relational knowledge between source and target domains (both must be relational domains) |

Deep CNN transfer learning (the focus of the lecture's MATLAB examples) is primarily **parameter-transfer**: the pretrained weights of early/middle layers are reused directly as a prior, and only the final layer(s) are retrained.

## In Practice: Fine-Tuning a Pretrained CNN (PyTorch)

```python
import torch
import torchvision.models as models
import torch.nn as nn

# Load a CNN pretrained on ImageNet (parameter-transfer source)
model = models.resnet50(weights="IMAGENET1K_V2")

# Freeze all the pretrained ("transferred") layers
for param in model.parameters():
    param.requires_grad = False

# Replace the final classification layer for the new task (e.g. 5 classes)
num_classes = 5
model.fc = nn.Linear(model.fc.in_features, num_classes)
# Only model.fc's parameters now have requires_grad=True, and will be trained
```

This mirrors the MATLAB transfer-learning workflow referenced in the lecture: import a pretrained network (AlexNet, VGG-16/19, GoogLeNet, etc.), replace the final layer with one sized for the new dataset's number of classes, and set a higher learning rate on the new layer(s) than on the transferred layers.

## Common Pitfalls & Practical Tips

- **Freeze vs. fine-tune.** Fully freezing pretrained layers is fastest and works well with very little target data; *fine-tuning* (unfreezing some/all pretrained layers with a small learning rate) can improve accuracy further once you have enough target data, but risks "catastrophic forgetting" of the useful pretrained features if the learning rate is too high.
- **Input preprocessing must match.** Pretrained networks (AlexNet, VGG, GoogLeNet, etc.) expect specific input sizes and normalisation statistics from their original training data (e.g. ImageNet mean/std) — mismatches here silently degrade accuracy.
- **Domain gap.** Transfer learning works best when the source and target domains share low-level structure (e.g. both are natural images). Transferring from natural images to, say, medical X-rays or spectrograms gives a smaller benefit, though early-layer features (edges, textures) often still help.

## Related Concepts

- [[AlexNet]], [[VGG (VGG-16 / VGG-19)]], [[GoogLeNet and the Inception Architecture]] — the specific pretrained ImageNet classifiers the lecture's MATLAB transfer-learning examples use as source models.
- [[Transfer Learning and YOLO for Classification]] — a concrete two-stage application of transfer learning (detection + classification) from Aryan's kiwifruit ripeness project.
- [[Ensemble Learning]] — a complementary technique for combining multiple models, often used alongside transfer learning (e.g. fine-tuning several pretrained backbones and ensembling their predictions).

**Source:** [Pan, S. & Yang, Q. (2010). A Survey on Transfer Learning. IEEE TKDE, 22(10).](https://www.cse.ust.hk/~qyang/Docs/2009/tkde_transfer_learning.pdf); [What is transfer learning? (IBM)](https://www.ibm.com/think/topics/transfer-learning)
