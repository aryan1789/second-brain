---
title: YOLO (You Only Look Once)
type: concept
sources: [Redmon, J. et al. (2016). You Only Look Once: Unified, real-time object detection. IEEE CVPR., https://www.kaggle.com/code/vikramsandu/yolo-1-through-5-a-complete-and-detailed-overview]
related: [One-Stage vs Two-Stage Object Detection, Anchor Boxes, SSD (Single Shot MultiBox Detector), Transfer Learning and YOLO for Classification]
created: 12-06-2026
last-updated: 12-06-2026
---

# YOLO (You Only Look Once)

> [!check] Verified
> Version evolution confirmed via [Kaggle: YOLO 1 through 5, a complete overview](https://www.kaggle.com/code/vikramsandu/yolo-1-through-5-a-complete-and-detailed-overview).

## The Core Idea

YOLO is a **one-stage** object detector (see [[One-Stage vs Two-Stage Object Detection]]): a single neural network predicts bounding boxes AND class probabilities directly from a full image, in one forward pass. The name reflects this — unlike [[R-CNN Family|R-CNN]]'s "propose regions, then look at each one," YOLO looks at the entire image *once*.

Three properties make YOLO distinctive:
- **Sees the whole image at once** — encodes contextual information about all objects and their relationships, which helps reduce false positives from "background" patches that *locally* resemble an object
- **Trained directly on full images** to optimise detection performance end-to-end
- **Highly generalisable** — less likely to break down on new domains or unusual inputs, compared to detectors reliant on hand-tuned region-proposal heuristics

## Intuition: The Grid-Cell Idea (YOLOv1)

YOLOv1 divides the image into an `S×S` grid (e.g., 7×7). Each grid cell is responsible for detecting any object whose **centre** falls within that cell. Each cell predicts:
- A fixed number of bounding boxes (position + size, relative to the cell)
- A confidence score for each box ("how sure am I there's an object here, and how good is this box?")
- Class probabilities for the cell (shared across the boxes that cell predicts)

This turns object detection into a single regression problem: input image → fixed-size output tensor of `(box coordinates, confidences, class probabilities)` per cell — solvable by a single CNN with no separate proposal stage.

## Version Evolution

- **YOLOv1 (2016)**: the original grid-cell approach above. Fast, but struggled with small objects and unusual aspect ratios (each cell predicts a fixed number of boxes with no shape priors).

- **YOLOv2 / YOLO9000 (2017)**: adopted [[Anchor Boxes|anchor boxes]] (borrowed from Faster R-CNN) — instead of predicting raw box coordinates, predicts offsets from predefined anchor shapes, improving handling of varied object shapes. Key prediction components per anchor:
  - **[[Intersection over Union (IoU)|IoU]]** — objectness score for the anchor
  - **Anchor box offset** — refines the anchor's position/size
  - **Class probability** — predicted class for that anchor

- **YOLOv3 (2018)**: adds **multi-scale predictions** — detects objects at three different feature-map resolutions simultaneously, substantially improving small-object detection (a known weakness of v1/v2). Also splits the loss function: mean-squared-error for box regression, binary cross-entropy for classification (rather than one combined loss).

- **YOLOv4 (2020)**: restructures the network into three explicit parts:
  - **Backbone** (CSPDarknet-53) — extracts feature maps from the input image, the same role as the "feature extraction" CNN in earlier architectures
  - **Neck** (SPP + PANet — Spatial Pyramid Pooling + Path Aggregation Network) — aggregates features across the multiple scales introduced in v3, combining fine and coarse spatial information
  - **Head** — YOLOv3-style anchor-based predictions (boxes, objectness, class scores) from the aggregated features

This **backbone/neck/head** decomposition became the standard way to describe (and mix-and-match components of) modern one-stage detectors.

## In Practice: Running a Pretrained YOLO Model (Python)

```python
# Using the Ultralytics YOLO package (covers YOLOv5/v8/v11+)
# pip install ultralytics
from ultralytics import YOLO

model = YOLO("yolov8n.pt")  # pretrained on COCO (80 classes)
results = model("path/to/image.jpg")

for r in results:
    print(r.boxes.xyxy)   # bounding box coordinates
    print(r.boxes.conf)   # confidence scores
    print(r.boxes.cls)    # predicted class indices
```

For your own object detection task (e.g., the kiwifruit ripeness detection from [[Deep Learning Assignment]]), the typical workflow is **transfer learning**: start from a pretrained YOLO (trained on COCO's 80 general object classes), then fine-tune on your own labelled dataset of kiwifruit images — the backbone's learned features (edges, textures, shapes) transfer well even though "kiwifruit" wasn't in the original training classes. See [[Transfer Learning and YOLO for Classification]].

## Common Pitfalls & Practical Tips

- **"YOLO" version numbers don't map 1:1 to a single research lineage** — after YOLOv4, development split across multiple groups/companies (Ultralytics YOLOv5/v8+, original authors' v7, etc.), with naming conventions that aren't strictly sequential improvements from a single source. Always check *which* YOLO implementation/version a tutorial or paper refers to.
- **Class imbalance in training data matters a lot** — since each grid cell/anchor predicts "is there an object here," and most locations in most images are background, YOLO's loss function explicitly weights these terms differently (this is part of why the loss is "separated" in v3 — different terms need different handling).
- **Non-Maximum Suppression (NMS) is a post-processing step**, not part of the network itself — after the network predicts many overlapping boxes, NMS (using [[Intersection over Union (IoU)|IoU]]) removes duplicates, keeping only the highest-confidence box per object.

## Related Concepts

- [[One-Stage vs Two-Stage Object Detection]]
- [[Anchor Boxes]] — adopted from YOLOv2 onward
- [[SSD (Single Shot MultiBox Detector)]] — a contemporaneous one-stage alternative
- [[Transfer Learning and YOLO for Classification]] — practical application to a custom dataset

**Source:** Redmon, J. et al. (2016). *You Only Look Once: Unified, real-time object detection*. IEEE CVPR; [Kaggle: YOLO 1 through 5 overview](https://www.kaggle.com/code/vikramsandu/yolo-1-through-5-a-complete-and-detailed-overview)
