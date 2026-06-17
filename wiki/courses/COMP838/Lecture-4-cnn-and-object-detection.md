---
title: COMP838 Lecture 4 - CNNs and Object Detection (R-CNN, SSD, YOLO)
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture4.pdf]
related: [COMP838, Convolutional Neural Networks (CNN), Receptive Field, Stride, and Padding, Softmax Function, Intersection over Union (IoU), Anchor Boxes, One-Stage vs Two-Stage Object Detection, R-CNN Family, YOLO (You Only Look Once), SSD (Single Shot MultiBox Detector)]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 4 - CNNs and Object Detection (R-CNN, SSD, YOLO)

> [!tip] Going Deeper
> Every concept page linked below has been expanded with intuition, runnable Python code (PyTorch / torchvision), and practical pitfalls — well beyond the lecture slides. This note is a Cornell-style summary; the concept pages are where the depth lives.

This lecture moves from CNN internals to the major **object detection** architecture families — directly relevant to the kiwifruit YOLOv4 work in [[Deep Learning Assignment]].

## Cues & Questions

> Cover the Notes section and try to answer each cue from memory.

- **What are the three core operations inside a CNN, and what does each do?**
- **What does "receptive field" mean, and why does it grow as you go deeper into a network?**
- **What's the formula for computing a convolution's output size from input size, kernel size, stride, and padding?**
- **What does softmax do, and why is it used in the final classification layer?**
- **What is IoU, and name two different places it's used in object detection.**
- **What problem do anchor boxes solve, and how are they matched to ground truth during training?**
- **What's the core difference between one-stage and two-stage detectors?**
- **Trace the R-CNN → Fast R-CNN → Faster R-CNN evolution: what specific bottleneck did each version fix?**
- **What are the three components of YOLOv4's architecture (backbone/neck/head), and what does each do?**

---

## Notes

### CNN Operations Recap

[[Convolutional Neural Networks (CNN)|CNNs]] consist of three core operations: **convolution** (a set of learned filters slide over the input), **pooling** (nonlinear downsampling — simplifies the output), and **[[Activation Functions|ReLU]]** (maps negative values to zero, enabling fast/effective training). The final **fully-connected layer** outputs a `k`-dimensional vector (one per class), which **[[Softmax Function|softmax]]** converts into a probability distribution.

### Receptive Fields, Stride, and Padding

> [!check] Verified
> See [[Receptive Field, Stride, and Padding]] for the full output-size formula, worked examples, and PyTorch shape-checking code.

[[Receptive Field, Stride, and Padding|Receptive field]] is the region of the *original image* that influences a given output value — it grows with network depth, which is *why* deep CNNs can progress from detecting edges to detecting whole objects. Stride and padding directly control output spatial dimensions via `output_size = floor((input_size - kernel_size + 2*padding) / stride) + 1`.

### CNNs Are Inspired by the Visual Cortex

ConvNets are inspired by the biological visual cortex's arrangement of simple and complex cells, activated based on subregions of the visual field (receptive fields). A ConvNet reduces parameter count via local connections, shared weights, and downsampling — directly echoing the [[Convolutional Neural Networks (CNN)|ConvNets = Local Connections + Shared Weights + Pooling + Multilayers]] formula from Lecture 1.

### Training Terminology: Epoch, Iteration, Learning Rate

> [!check] Verified
> See [[Neural Network Training Workflow]] for the full epoch/batch/iteration breakdown and learning rate scheduling.

A full pass through the dataset = one **epoch**; the number of batches needed for one epoch = the number of **iterations**. Learning rates are often gradually reduced during training (smaller steps as the model approaches a good solution). Regular validation during training is how [[Overfitting and Underfitting|overfitting]] is detected — compare training loss/accuracy to validation metrics.

### Object Detection: One-Stage vs Two-Stage

> [!check] Verified
> See [[One-Stage vs Two-Stage Object Detection]] for the full comparison table and torchvision usage examples.

**Two-stage** detectors ([[R-CNN Family|R-CNN, Fast R-CNN, Faster R-CNN]]) first propose candidate regions, then classify/refine each one. **One-stage** detectors ([[YOLO (You Only Look Once)|YOLO]], [[SSD (Single Shot MultiBox Detector)|SSD]]) predict boxes and classes directly in a single pass.

### R-CNN → Fast R-CNN → Faster R-CNN

> [!check] Verified
> See [[R-CNN Family]] for the full evolution table, speed comparisons, and what specifically changed at each step.

Each version fixes the prior bottleneck: R-CNN runs a CNN separately on ~2000 region proposals per image (slow); Fast R-CNN runs the CNN once and pools per-region features from a shared feature map; Faster R-CNN replaces the external region-proposal algorithm with a learned Region Proposal Network using [[Anchor Boxes]].

### SSD and YOLO

> [!check] Verified
> See [[SSD (Single Shot MultiBox Detector)]] and [[YOLO (You Only Look Once)]] for full details, version evolution (YOLOv1-v4), and code examples.

**SSD** predicts from multiple feature maps at different scales, each with default ([[Anchor Boxes|anchor]]) boxes of different aspect ratios — exploiting the receptive-field-vs-resolution trade-off (early layers for small objects, late layers for large objects). **YOLO** evolved from grid-cell predictions (v1) → anchor boxes (v2) → multi-scale predictions + split loss (v3) → explicit backbone/neck/head architecture (v4, CSPDarknet-53 + SPP/PANet + YOLOv3-style head).

### Intersection over Union (IoU) and Anchor Boxes

> [!check] Verified
> See [[Intersection over Union (IoU)]] and [[Anchor Boxes]] for formulas, code, and how they connect.

[[Intersection over Union (IoU)|IoU]] measures bounding box overlap (`intersection area / union area`) — used for evaluation (is a prediction "correct"?), Non-Maximum Suppression (removing duplicate detections), and matching [[Anchor Boxes|anchor boxes]] to ground truth during training. Anchor boxes are predefined box templates at each feature-map location; the network predicts small offsets from these templates rather than raw coordinates — used by Faster R-CNN's RPN, SSD, and YOLOv2+.

---

## Summary

This lecture connects CNN internals (convolution, pooling, ReLU, receptive fields, softmax) to the major object detection architectures. The two-stage R-CNN lineage (R-CNN → Fast R-CNN → Faster R-CNN) progressively moves more of the pipeline into a single learned, end-to-end network — culminating in the Region Proposal Network and anchor boxes. The one-stage lineage (SSD, YOLO) skips the proposal stage entirely, predicting boxes and classes directly; YOLO's evolution (v1→v4) progressively adds anchor boxes, multi-scale predictions, and an explicit backbone/neck/head structure. IoU and anchor boxes are cross-cutting concepts used throughout both lineages — for training (matching anchors to ground truth), and evaluation/post-processing (NMS, mAP). This lecture's content directly underlies the YOLOv4 + transfer learning approach used in [[Deep Learning Assignment]].

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Receptive field, output size formula | [Dive into Deep Learning](https://d2l.ai/chapter_convolutional-neural-networks/padding-and-strides.html), [Distill](https://distill.pub/2019/computing-receptive-fields) | ✓ Verified |
| Softmax / categorical cross-entropy | [GeeksforGeeks](https://www.geeksforgeeks.org/deep-learning/categorical-cross-entropy-in-multi-class-classification/) | ✓ Verified |
| IoU formula and uses | [SuperAnnotate](https://www.superannotate.com/blog/intersection-over-union-for-object-detection), [Generalized IoU](https://giou.stanford.edu/) | ✓ Verified |
| R-CNN, Fast R-CNN, Faster R-CNN evolution | [Faster R-CNN paper](https://proceedings.neurips.cc/paper/5638-faster-r-cnn-towards-real-time-object-detection-with-region-proposal-networks.pdf), [overview](https://medium.com/towardsdev/r-cnn-fast-r-cnn-faster-r-cnn-and-mask-r-cnn-e7cd2e6f0a82) | ✓ Verified |
| YOLO v1-v4 evolution, backbone/neck/head | [Kaggle: YOLO 1-5 overview](https://www.kaggle.com/code/vikramsandu/yolo-1-through-5-a-complete-and-detailed-overview) | ✓ Verified |
| SSD architecture | Liu, W. et al. (2016), SSD: Single shot multibox detector, ECCV | ➕ Cited in lecture, standard reference |
