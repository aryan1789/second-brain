---
title: COMP838 Lecture 9.1 - Transfer Learning
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture9.pdf]
related: [COMP838, Transfer Learning, AlexNet, VGG (VGG-16 / VGG-19), GoogLeNet and the Inception Architecture]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 9.1 - Transfer Learning

> [!tip] Going Deeper
> [[Transfer Learning]] has a full concept page with intuition, the categories/approaches table from Pan & Yang's survey, a PyTorch fine-tuning example, and pitfalls (freeze vs. fine-tune, domain gap). This note summarises the lecture's framing.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **Transfer learning** — one-sentence definition.
- **What can differ between the source and target in transfer learning?** (domains, tasks, distributions)
- **Name the three categories of transfer learning and what distinguishes them.**
- **Name the four "what to transfer" approaches and what each one does.**
- **Which pretrained networks does the lecture name, and how many layers does each have?**
- **Why is transfer learning "faster and easier" than training from scratch?**

---

## Notes

### What Is Transfer Learning

[[Transfer Learning|Transfer learning]] is a machine learning method where a model developed for one task is reused as the starting point for a model on a second task (Shao et al., 2015). Pan & Yang (2010) generalise this: transfer learning allows the domains `D`, tasks `T`, and the distributions used in training and test to differ between source and target — the goal is to extract knowledge from one or more **source tasks `T_S`** and apply it to a **target task `T_T`**.

> [!check] Verified
> Both framings match current usage — see [What is transfer learning? (IBM)](https://www.ibm.com/think/topics/transfer-learning), which similarly defines transfer learning as reusing knowledge gained on one task/dataset to improve performance on another.

### Categories and Approaches

Pan & Yang (2010) categorise transfer learning along *what*, *how*, and *when* to transfer:

- **Inductive transfer learning** — source and target tasks differ (`T_S ≠ T_T`).
- **Transductive transfer learning** — source and target tasks are the same but domains differ (`T_S = T_T`, `D_S ≠ D_T`).
- **Unsupervised transfer learning** — tasks differ and neither domain has labelled data; targets unsupervised problems like clustering.

For "what to transfer," four approaches are listed:

| Approach | Description |
|---|---|
| Instance-transfer | Re-weight labelled source-domain data for use in the target domain |
| Feature-representation-transfer | Find a feature representation that reduces the source/target domain gap and the target model's error |
| Parameter-transfer | Discover shared parameters or priors between source and target models |
| Relational-knowledge-transfer | Map relational knowledge between source and target (relational) domains |

> [!check] Verified
> This taxonomy matches Pan & Yang's widely-cited survey directly — see [A Survey on Transfer Learning](https://www.cse.ust.hk/~qyang/Docs/2009/tkde_transfer_learning.pdf). [[Transfer Learning]] explains why deep CNN transfer learning is primarily *parameter-transfer*.

### MATLAB Transfer Learning Workflow

The lecture frames practical (MATLAB) transfer learning as:

1. Choose a pretrained network and import it.
2. Replace the final layer with a new layer matching the target dataset's number of classes.
3. Set higher learning rates on the new layer(s) than on the transferred layers (so the new layer adapts quickly while the transferred layers change little).
4. Export the resulting network.

Benefits cited: faster and easier than training from scratch, reduces training time and data size, and avoids having to design a whole new network architecture — fine-tuning with transfer learning is "usually much faster and easier" than training with randomly initialised weights.

The lecture names four pretrained networks (recapping [[AlexNet]], [[VGG (VGG-16 / VGG-19)]], and [[GoogLeNet and the Inception Architecture]] from Lecture 5.2):

- **AlexNet** — 8 learnable layers (5 convolutional + 3 fully connected), trained on 1M images, 1,000 classes (ILSVRC 2012).
- **VGG-16** — 16 learnable layers (13 convolutional + 3 fully connected).
- **VGG-19** — 19 learnable layers (16 convolutional + 3 fully connected).
- **GoogLeNet** — 22 layers deep, won ILSVRC 2014.

> [!check] Verified
> These layer counts match the figures given in Lecture 5.2's concept pages for [[AlexNet]], [[VGG (VGG-16 / VGG-19)]], and [[GoogLeNet and the Inception Architecture]].

---

## Summary

Transfer learning reuses a model trained on one task as the starting point for a related task, rather than training from scratch. Pan & Yang's survey formalises this as transferring knowledge from a source task/domain to a target task/domain, categorised as inductive, transductive, or unsupervised depending on whether tasks and/or domains match, with four "what to transfer" approaches (instance, feature-representation, parameter, and relational-knowledge transfer). In deep learning practice, this typically means importing a pretrained ImageNet classifier (AlexNet, VGG-16/19, or GoogLeNet), swapping its final layer for one sized to the new task's classes, and fine-tuning — much faster than training a new network from randomly initialised weights.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Transfer learning definition (reuse model for second task) | [What is transfer learning? (IBM)](https://www.ibm.com/think/topics/transfer-learning) | ✓ Verified |
| Inductive/transductive/unsupervised categories and 4 approaches | [A Survey on Transfer Learning (Pan & Yang, 2010)](https://www.cse.ust.hk/~qyang/Docs/2009/tkde_transfer_learning.pdf) | ✓ Verified |
| AlexNet/VGG-16/VGG-19/GoogLeNet layer counts | [[AlexNet]], [[VGG (VGG-16 / VGG-19)]], [[GoogLeNet and the Inception Architecture]] (Lecture 5.2) | ✓ Verified |
