---
title: SSD (Single Shot MultiBox Detector)
type: concept
sources: [Liu, W. et al. (2016). SSD: Single shot multibox detector. ECCV, pp.21-27.]
related: [One-Stage vs Two-Stage Object Detection, Anchor Boxes, YOLO (You Only Look Once), Receptive Field, Stride, and Padding]
created: 12-06-2026
last-updated: 12-06-2026
---

# SSD (Single Shot MultiBox Detector)

## The Core Idea

SSD is a **one-stage** object detector (see [[One-Stage vs Two-Stage Object Detection]]), conceptually similar to [[YOLO (You Only Look Once)|YOLO]] but with a distinctive design: it makes predictions from **multiple feature maps at different scales** within the same network, each using [[Anchor Boxes|default boxes]] ("anchors") of various aspect ratios.

The name breaks down:
- **Single shot**: object detection and classification happen in a single forward pass of the network (like YOLO)
- **Multibox**: the architecture is designed for bounding-box regression — predicting offsets from default boxes
- **Detector**: a neural network that classifies the target visual objects

## Intuition: Different Feature Map Scales "See" Different Object Sizes

Recall from [[Receptive Field, Stride, and Padding]]: deeper layers in a CNN have *larger* receptive fields (each value summarises a bigger region of the original image) but *smaller* spatial resolution (fewer total positions).

SSD exploits this directly: it attaches detection heads to **several feature maps at different depths** of the backbone network simultaneously:
- **Earlier, higher-resolution feature maps** (small receptive field) → better for detecting **small objects** (more spatial positions to "look" for small things)
- **Later, lower-resolution feature maps** (large receptive field) → better for detecting **large objects** (each position already summarises a big chunk of the image)

At each feature map, SSD places [[Anchor Boxes|default boxes]] of multiple aspect ratios at each spatial location, and predicts (per default box): a confidence score for each class, and 4 offset values to refine the box position/size.

## How SSD Differs from Faster R-CNN's RPN

SSD is similar to Faster R-CNN's Region Proposal Network in that both use anchor/default boxes and predict offsets + scores per anchor. The key difference: **SSD skips the separate "proposal" stage entirely** — there's no second stage that takes proposed regions and re-classifies them. The multi-scale anchor predictions in SSD's single pass *are* the final detections (after [[Intersection over Union (IoU)|NMS]] post-processing), making it a one-stage detector like YOLO, whereas Faster R-CNN's RPN output feeds into a second classification stage.

## In Practice: SSD via torchvision

```python
import torchvision
import torch

model = torchvision.models.detection.ssd300_vgg16(weights="DEFAULT")
model.eval()

images = [torch.rand(3, 300, 300)]  # SSD300: fixed 300x300 input
with torch.no_grad():
    predictions = model(images)

print(predictions[0]['boxes'])   # [N, 4] -- predicted bounding boxes
print(predictions[0]['labels'])  # [N]    -- predicted class indices
print(predictions[0]['scores'])  # [N]    -- confidence scores
```

The "300" in `ssd300_vgg16` refers to the fixed input resolution (300×300) — unlike some YOLO variants which support variable input sizes, classic SSD architectures are typically tied to a specific input resolution because the multi-scale feature map sizes are precomputed for that resolution.

## Common Pitfalls & Practical Tips

- **Fixed input size matters for SSD** — resizing/padding your images to match the expected input resolution (e.g., 300×300 or 512×512 for SSD512) is part of the preprocessing pipeline, not optional.
- **Default box aspect ratios should reflect your data**, same caveat as [[Anchor Boxes]] generally — SSD's original aspect ratios (1, 2, 3, 1/2, 1/3) were chosen for general object datasets (COCO/PASCAL VOC) and may not suit very elongated or unusual object shapes without adjustment.
- **SSD vs. YOLO in practice**: both are one-stage, anchor-based (post-v2), real-time-capable detectors with broadly similar performance characteristics. The choice often comes down to ecosystem/tooling support — YOLO (especially via Ultralytics) has a larger community and more frequent updates as of 2026, making it the more common default choice for new projects.

## Related Concepts

- [[One-Stage vs Two-Stage Object Detection]]
- [[Anchor Boxes]] — SSD's "default boxes" are anchor boxes at multiple scales
- [[YOLO (You Only Look Once)]] — the other major one-stage family
- [[Receptive Field, Stride, and Padding]] — explains why different-depth feature maps suit different object sizes

**Source:** Liu, W. et al. (2016). *SSD: Single shot multibox detector*. ECCV, pp.21-27.
