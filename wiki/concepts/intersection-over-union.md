---
title: Intersection over Union (IoU)
type: concept
sources: [https://www.superannotate.com/blog/intersection-over-union-for-object-detection, https://giou.stanford.edu/]
related: [Anchor Boxes, Confusion Matrix Metrics]
created: 12-06-2026
last-updated: 12-06-2026
---

# Intersection over Union (IoU)

> [!check] Verified
> Confirmed via [SuperAnnotate: Intersection over Union for object detection](https://www.superannotate.com/blog/intersection-over-union-for-object-detection) and [Generalized IoU](https://giou.stanford.edu/).

## The Core Idea

IoU measures how well two bounding boxes overlap — used throughout object detection to compare a **predicted** box against a **ground truth** box (or against another predicted box):

```
IoU = Area(Box A ∩ Box B) / Area(Box A ∪ Box B)
```

IoU ranges from 0 (no overlap) to 1 (identical boxes).

## Intuition: A Single Number for "How Good Is This Box?"

Imagine you're grading a student's drawn bounding box against the correct answer. You could check "did they get the exact pixels right?" (too strict — a box shifted by 1 pixel would "fail") or "did they roughly point at the object?" (too lenient — a box covering the whole image would "pass" for any object in it).

IoU is the middle ground: it asks "what fraction of the *combined* area (both boxes together) is *shared* (both boxes agree on)?" A perfect match gives IoU=1 (intersection = union = the box itself). A box that's way off (e.g., predicting a box for "cat" over in the corner where there's no cat) gives IoU≈0 (intersection ≈ 0, union ≈ sum of both areas).

## Where IoU Is Used

1. **Evaluation**: a prediction is typically counted as a "correct detection" (a True Positive — see [[Confusion Matrix Metrics]]) if `IoU(predicted_box, ground_truth_box) > threshold` (commonly 0.5). Below the threshold, it's a False Positive (wrong box) even if the *class* prediction was correct.

2. **Non-Maximum Suppression (NMS)**: object detectors often produce *many* overlapping candidate boxes for the same object. NMS keeps the highest-confidence box and removes other boxes that have IoU > some threshold with it (they're "duplicates" of the same detection).

3. **[[Anchor Boxes|Anchor box]] assignment during training**: when training detectors that use anchor boxes (Faster R-CNN, SSD, YOLOv2+), each anchor box is assigned to a ground-truth object if their IoU exceeds a threshold — this determines which anchors the network is trained to adjust toward that object.

## In Practice: Computing IoU (Python)

```python
def compute_iou(box_a, box_b):
    """Each box is (x1, y1, x2, y2) -- top-left and bottom-right corners."""
    # Intersection rectangle
    x1 = max(box_a[0], box_b[0])
    y1 = max(box_a[1], box_b[1])
    x2 = min(box_a[2], box_b[2])
    y2 = min(box_a[3], box_b[3])

    inter_area = max(0, x2 - x1) * max(0, y2 - y1)  # 0 if no overlap

    area_a = (box_a[2] - box_a[0]) * (box_a[3] - box_a[1])
    area_b = (box_b[2] - box_b[0]) * (box_b[3] - box_b[1])
    union_area = area_a + area_b - inter_area

    return inter_area / union_area if union_area > 0 else 0.0

predicted = (10, 10, 50, 50)
ground_truth = (15, 15, 55, 55)
print(compute_iou(predicted, ground_truth))  # ~0.57
```

```python
# torchvision has a built-in, batched, GPU-friendly version:
from torchvision.ops import box_iou
import torch

boxes_a = torch.tensor([[10., 10., 50., 50.]])
boxes_b = torch.tensor([[15., 15., 55., 55.]])
print(box_iou(boxes_a, boxes_b))  # tensor([[0.5735]])
```

`torchvision.ops.box_iou` computes IoU between *every pair* of boxes from two sets in one call — exactly what's needed for NMS or anchor-matching across hundreds/thousands of anchor boxes.

## Common Pitfalls & Practical Tips

- **IoU threshold choice affects everything downstream.** A "correct detection" at IoU>0.5 might be "incorrect" at IoU>0.75 — when comparing detector performance (e.g., via mAP, mean Average Precision), always check *which* IoU threshold(s) were used.
- **`max(0, ...)` for intersection dimensions** — if boxes don't overlap at all, `x2 - x1` or `y2 - y1` can be negative; clamping to 0 avoids a negative "intersection area."
- **Generalized IoU (GIoU) and variants** exist to address IoU's limitation of providing zero gradient when boxes don't overlap at all (IoU=0 regardless of *how far apart* the boxes are) — useful as a training loss, where you want gradient signal even for very wrong predictions.

## Related Concepts

- [[Anchor Boxes]] — IoU is used to match anchors to ground-truth objects during training
- [[Confusion Matrix Metrics]] — IoU thresholds determine TP/FP/FN classification for detection tasks

**Source:** [SuperAnnotate: Intersection over Union for object detection](https://www.superannotate.com/blog/intersection-over-union-for-object-detection)
