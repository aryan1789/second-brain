---
title: R-CNN Family
type: concept
sources: [Ross, G. (2014). Rich feature hierarchies for accurate object detection and semantic segmentation. IEEE CVPR, pp. 580-587., Girshick, R. (2015). Fast R-CNN. IEEE ICCV, pp.1440-1448., https://proceedings.neurips.cc/paper/5638-faster-r-cnn-towards-real-time-object-detection-with-region-proposal-networks.pdf]
related: [One-Stage vs Two-Stage Object Detection, Anchor Boxes, Convolutional Neural Networks (CNN), Intersection over Union (IoU)]
created: 12-06-2026
last-updated: 17-06-2026
---

# R-CNN Family (R-CNN, Fast R-CNN, Faster R-CNN)

## The Core Idea

The R-CNN family is a lineage of **two-stage** object detectors (see [[One-Stage vs Two-Stage Object Detection]]), each version fixing the previous version's main bottleneck:

1. **R-CNN (2014)**: region proposals + CNN feature extraction + SVM classification — but each proposal is processed through the CNN *separately* (slow)
2. **Fast R-CNN (2015)**: run the CNN *once* on the whole image, then extract per-region features from the shared feature map (much faster)
3. **Faster R-CNN (2016)**: replace the external region-proposal algorithm with a learned Region Proposal Network (RPN) using [[Anchor Boxes]] (end-to-end trainable, faster still)

## R-CNN: The Original (2014)

R-CNN combines region proposals with CNN features in three steps:

1. **Generate region proposals** using an external algorithm (e.g., Selective Search or Edge Boxes) — typically ~2000 candidate regions per image, found *without* any learning, just classical image-processing heuristics (colour/texture similarity grouping)
2. **Crop and resize** each proposed region to a fixed size, then run it through a CNN to extract a feature vector
3. **Classify** each region's features using a separate SVM, and refine the bounding box with a separate regression model

**The bottleneck**: step 2 runs the CNN ~2000 times *per image* — once per proposal. This is extremely slow (R-CNN took ~47 seconds per image on a GPU).

## Fast R-CNN: Sharing Computation (2015)

Fast R-CNN's key insight: **most of those 2000 proposals overlap heavily** — they're all crops of the *same image*. Instead of running the CNN 2000 times, run it **once** on the whole image to get a single feature map, then for each region proposal, extract the corresponding *patch* of that shared feature map (via "RoI Pooling" — Region of Interest Pooling, which resizes variable-sized patches to a fixed size for the classifier).

This single change took inference from ~47s to ~2s per image — roughly **25x faster** — while still relying on external region proposals (Selective Search) for step 1.

## Faster R-CNN: Learning to Propose Regions (2016)

Faster R-CNN's key insight: **the external region-proposal algorithm (Selective Search) is itself a bottleneck and isn't learned** — it can't improve with training data, and it's a separate CPU-based step that doesn't benefit from GPU parallelism.

Faster R-CNN replaces it with a **Region Proposal Network (RPN)**: a small additional CNN head that slides over the *same* shared feature map (from Fast R-CNN's step 1) and, using [[Anchor Boxes]] at each location, directly predicts "is there an object here?" and rough box coordinates. These RPN-generated proposals then go through the same RoI-Pooling + classification as Fast R-CNN.

The result: the *entire* pipeline — feature extraction, region proposal, classification, box refinement — runs through a single network, trainable end-to-end with [[Backpropagation]], and runs at ~5-17 fps (real-time-ish), a further significant speedup over Fast R-CNN.

## Evolution Summary

| | Region Proposals | Feature Extraction | Speed (approx.) |
|---|---|---|---|
| **R-CNN** | External (Selective Search), ~2000/image | CNN run separately per proposal | ~47s/image |
| **Fast R-CNN** | External (Selective Search) | CNN run once, RoI Pooling extracts per-region features | ~2s/image |
| **Faster R-CNN** | Learned (RPN, using [[Anchor Boxes|anchors]]), on shared feature map | CNN run once, shared with RPN | ~0.2s/image (5 fps) |

## Common Pitfalls & Practical Tips

- **"R-CNN" without a qualifier usually means the *family*, not specifically the 2014 original** — in casual conversation, check context. The original R-CNN is rarely used directly today; Faster R-CNN (or Mask R-CNN, which adds segmentation) is the practical baseline from this family.
- **Two-stage detectors need careful tuning of the RPN's [[Anchor Boxes|anchor]] scales/ratios** for your dataset — if your objects' shapes don't match the anchor priors well, the RPN will struggle to propose good regions regardless of how well the second stage is trained.
- **`torchvision.models.detection.fasterrcnn_resnet50_fpn`** provides a pretrained Faster R-CNN — a strong starting point for transfer learning on custom object detection tasks (see [[Transfer Learning and YOLO for Classification]]).

## Related Concepts

- [[One-Stage vs Two-Stage Object Detection]]
- [[Anchor Boxes]] — introduced by Faster R-CNN's RPN
- [[Intersection over Union (IoU)]] — used to evaluate and train region proposals

**Source:** Ross, G. (2014). *Rich feature hierarchies for accurate object detection and semantic segmentation*. IEEE CVPR; Girshick, R. (2015). *Fast R-CNN*. IEEE ICCV; [Faster R-CNN (NeurIPS 2015)](https://proceedings.neurips.cc/paper/5638-faster-r-cnn-towards-real-time-object-detection-with-region-proposal-networks.pdf)
