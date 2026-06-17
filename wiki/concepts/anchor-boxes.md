---
title: Anchor Boxes
type: concept
sources: [https://proceedings.neurips.cc/paper/5638-faster-r-cnn-towards-real-time-object-detection-with-region-proposal-networks.pdf]
related: [Intersection over Union (IoU), R-CNN Family, YOLO (You Only Look Once), SSD (Single Shot MultiBox Detector)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Anchor Boxes

> [!check] Verified
> Confirmed via [Faster R-CNN paper (NeurIPS 2015)](https://proceedings.neurips.cc/paper/5638-faster-r-cnn-towards-real-time-object-detection-with-region-proposal-networks.pdf), which introduced anchor boxes for region proposals.

## The Core Idea

Anchor boxes are a set of **predefined bounding boxes** of various sizes and aspect ratios, placed at every spatial location of a feature map. Instead of predicting bounding box coordinates from scratch, the network predicts **offsets/adjustments relative to these anchors**, plus an "objectness" score and class probabilities for each anchor.

## Intuition: Multiple Choice Instead of Free Response

Predicting "where exactly is the object?" from scratch is a hard, unconstrained regression problem — the box could be any size, anywhere. Anchor boxes turn this into something closer to multiple choice: at each location, the network has, say, 9 pre-defined "template" boxes (e.g., 3 sizes × 3 aspect ratios — tall/narrow, wide/short, square), and for each one it predicts:

1. **Objectness score** — "does *something* overlap with this template here?"
2. **Box offsets** — "if yes, how should I nudge this template's position/size to better fit the actual object?" (small adjustments — `Δx, Δy, Δw, Δh` — rather than absolute coordinates)
3. **Class probabilities** — "if yes, what class is it?" (often via [[Softmax Function|softmax]])

This is much easier to learn than predicting `(x, y, width, height)` directly from nothing, because the network only needs to learn *small corrections* to a reasonable starting guess, and different anchors naturally specialise — e.g., "tall narrow" anchors end up detecting pedestrians, "wide short" anchors end up detecting cars.

## How Anchors Get Matched to Ground Truth During Training

For each anchor box, compute [[Intersection over Union (IoU)|IoU]] against all ground-truth boxes in the image:
- **High IoU** (e.g., > 0.7) → this anchor is a "positive" example; train it to predict that object's class and refine its box toward the ground truth
- **Low IoU** (e.g., < 0.3) → "negative" example; train it to predict "no object here" (background)
- **In between** → often ignored during training (ambiguous)

This is why most anchors at most locations are "background" — only a handful of anchors near actual objects become positive examples, which is also why object detection training often needs to handle severe **class imbalance** between background and object anchors.

## Where Anchor Boxes Are Used

- **Faster R-CNN**: the Region Proposal Network (RPN) slides over the feature map, predicting objectness + box refinements for anchors at each location — replacing the external region-proposal algorithms (e.g., Selective Search/Edge Boxes) used by R-CNN/Fast R-CNN
- **SSD**: uses "default boxes" (anchors) of different aspect ratios at multiple feature-map scales simultaneously
- **YOLOv2 and later**: adopted anchor boxes (borrowed from Faster R-CNN) — a key improvement over YOLOv1, which predicted boxes with no anchor priors and struggled with objects of unusual shapes

## In Practice: Generating a Simple Anchor Grid (Python)

```python
import torch

def generate_anchors(feature_map_size, scales, aspect_ratios):
    """Generate anchor boxes (cx, cy, w, h) for each cell in a feature map grid."""
    anchors = []
    for y in range(feature_map_size):
        for x in range(feature_map_size):
            cx, cy = (x + 0.5) / feature_map_size, (y + 0.5) / feature_map_size  # cell centre
            for scale in scales:
                for ratio in aspect_ratios:
                    w = scale * (ratio ** 0.5)
                    h = scale / (ratio ** 0.5)
                    anchors.append([cx, cy, w, h])
    return torch.tensor(anchors)

# 4x4 feature map, 2 scales, 3 aspect ratios -> 4*4*2*3 = 96 anchors
anchors = generate_anchors(feature_map_size=4, scales=[0.1, 0.2], aspect_ratios=[0.5, 1.0, 2.0])
print(anchors.shape)  # torch.Size([96, 4])
```

Each row is one anchor: `(centre_x, centre_y, width, height)`, all normalised to [0,1]. A real detector would, for each of these 96 anchors, predict an objectness score, 4 box-offset values, and class probabilities — `torchvision.models.detection` implementations (e.g., `FasterRCNN`, `RetinaNet`) handle this generation and matching internally via `AnchorGenerator`.

## Common Pitfalls & Practical Tips

- **Anchor scale/aspect-ratio choices should match your dataset.** If your objects are mostly small and square, but your anchors are large and wide, very few anchors will have high IoU with any ground truth — training will be slow/poor. Tools exist to *cluster* ground-truth box dimensions (e.g., k-means, as YOLOv2 did) to choose good anchor shapes for a specific dataset.
- **Anchor-based vs. anchor-free detectors.** More recent architectures (e.g., FCOS, CenterNet, and YOLO versions from v8 onward) move away from anchor boxes entirely, predicting object centres/keypoints directly — simplifying the pipeline (no anchor hyperparameters to tune) at some cost in complexity elsewhere. Anchors remain important to understand because so much of the foundational literature (Faster R-CNN, SSD, YOLOv2-v4) relies on them.

## Related Concepts

- [[Intersection over Union (IoU)]] — the metric used to match anchors to ground truth
- [[R-CNN Family]] — Faster R-CNN's RPN introduced anchor boxes
- [[YOLO (You Only Look Once)]] — adopted anchors from YOLOv2 onward
- [[SSD (Single Shot MultiBox Detector)]] — uses anchors ("default boxes") at multiple scales

**Source:** [Faster R-CNN (NeurIPS 2015)](https://proceedings.neurips.cc/paper/5638-faster-r-cnn-towards-real-time-object-detection-with-region-proposal-networks.pdf)
