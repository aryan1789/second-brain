---
title: Data Augmentation
type: concept
sources: [https://d2l.ai/chapter_computer-vision/image-augmentation.html, https://arxiv.org/abs/2301.02830]
related: [Deep Learning, Convolutional Neural Networks (CNN), Neural Network Training Workflow, Overfitting and Underfitting]
created: 12-06-2026
last-updated: 12-06-2026
---

# Data Augmentation

> [!check] Verified
> Confirmed via [Dive into Deep Learning, Ch. 14.1](https://d2l.ai/chapter_computer-vision/image-augmentation.html) and [arXiv:2301.02830](https://arxiv.org/abs/2301.02830).

## The Core Idea

Data augmentation is the practice of artificially expanding a training dataset by applying transformations to existing data, producing new (but realistic) variations. This helps deep learning models generalise better and reduces [[Overfitting and Underfitting|overfitting]], since the model sees more variety without needing to collect more real data.

## Intuition: Teaching Robustness by Example

Suppose all your training photos of "cats" happen to be taken in bright daylight, facing forward, centred in the frame. A model trained on this data might (incorrectly) learn "lighting = bright AND object centred" as part of what makes something a cat — a **spurious correlation** that has nothing to do with what a cat actually *is*.

Data augmentation directly attacks this: by randomly flipping, rotating, cropping, and recolouring the *same* images during training, the model is forced to find features that are **invariant** to these changes — i.e., features that genuinely characterise "cat-ness" regardless of orientation or lighting. This connects directly to the "invariance" property from [[Deep Learning]] — augmentation is one concrete *training-time* technique for encouraging the invariance that deep networks are supposed to learn.

## Common Image Augmentation Techniques

- **Resizing** — scaling image dimensions by a factor (e.g., rescaling, cropping a subregion while preserving pixel spatial extent)
- **Rotation** — rotating the image by an angle
- **Reflection (flipping)** — mirroring the image horizontally or vertically
- **Shearing** — skewing the image along an axis
- **Translation** — shifting the image position
- **Colour transformations** — adjusting brightness, contrast, saturation, and hue

These transformations are typically applied in **random combinations**, and the corresponding labels (e.g., bounding boxes, class labels) must be transformed consistently with the image — if you flip an image horizontally for an object-detection task, you must also flip the bounding box coordinates.

## In Practice: torchvision Transforms (PyTorch)

```python
import torchvision.transforms as T

train_transforms = T.Compose([
    T.RandomResizedCrop(224, scale=(0.8, 1.0)),  # random crop + resize
    T.RandomHorizontalFlip(p=0.5),               # 50% chance of horizontal flip
    T.RandomRotation(degrees=15),                # rotate up to +/-15 degrees
    T.ColorJitter(brightness=0.2, contrast=0.2,
                   saturation=0.2, hue=0.1),      # colour transformations
    T.ToTensor(),
    T.Normalize(mean=[0.485, 0.456, 0.406],      # ImageNet stats, common default
                 std=[0.229, 0.224, 0.225]),
])

# Important: validation/test data does NOT get random augmentation —
# only deterministic resizing/normalisation, so evaluation is consistent.
eval_transforms = T.Compose([
    T.Resize(256),
    T.CenterCrop(224),
    T.ToTensor(),
    T.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])
```

Each call to `train_transforms(image)` during training produces a *slightly different* version of the same image — a new random crop, flip, rotation, and colour shift each epoch. Over many epochs, the model effectively sees a much larger, more varied dataset than the raw image count suggests.

## Why It Matters

Without augmentation, a model trained on a limited dataset can learn spurious correlations specific to that dataset. Augmentation exposes the model to more variation in lighting, orientation, and framing, helping it learn the underlying pattern rather than dataset-specific artifacts — directly combating the [[Overfitting and Underfitting|overfitting]] that's especially likely when training data is limited relative to model size.

## Common Pitfalls & Practical Tips

- **Augmentation must make sense for the task.** Flipping digit images horizontally turns "6" into something that looks like a backwards "9" — for digit recognition, horizontal flips would *hurt*, not help. Always ask: "does this transformation preserve the label's meaning?"
- **Never augment validation/test data with randomness.** Evaluation should be deterministic and consistent across runs — only the training set gets random augmentation.
- **Augmentation doesn't fix fundamentally insufficient or biased data.** If your dataset has zero examples of a category, no amount of flipping/rotating existing images will create that category from nothing.
- **Beyond images:** augmentation concepts apply to other data types too — e.g., for audio/sensor signals, adding noise, time-shifting, or changing pitch/speed serve a similar role to image flips/rotations.

## Related Concepts

- [[Deep Learning]]
- [[Convolutional Neural Networks (CNN)]]
- [[Neural Network Training Workflow]]
- [[Overfitting and Underfitting]]
