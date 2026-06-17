---
title: AlexNet
type: concept
sources: [https://en.wikipedia.org/wiki/AlexNet, https://www.geeksforgeeks.org/machine-learning/ml-getting-started-with-alexnet/, https://au.mathworks.com/help/deeplearning/ref/alexnet.html]
related: [Convolutional Neural Networks (CNN), Activation Functions, Overfitting and Underfitting, VGG (VGG-16 / VGG-19), GoogLeNet and the Inception Architecture]
created: 12-06-2026
last-updated: 12-06-2026
---

# AlexNet

## The Core Idea

AlexNet (Krizhevsky, Sutskever & Hinton, 2012) is the CNN that won the 2012 ImageNet Large Scale Visual Recognition Challenge (ILSVRC) by a huge margin (top-5 error 15.3% vs. 26.2% for the runner-up), and is widely credited with kicking off the modern deep learning boom. It is **eight layers deep** (five convolutional layers, three fully-connected layers), trained on over a million ImageNet images to classify into 1,000 object categories, with a standard input size of **227×227** pixels (MATLAB's pretrained AlexNet documents this as the required input size).

## Intuition

Before AlexNet, the best image classifiers used hand-crafted features (edge detectors, SIFT, etc.) feeding into shallow classifiers — exactly the "Machine Learning" side of the [[Machine Learning vs Deep Learning]] divide. AlexNet's bet was that a sufficiently large CNN, trained end-to-end on enough data with enough compute (GPUs), could *learn* better features than humans could design by hand. The margin of its win proved the bet correct, and the field pivoted toward learned features almost overnight.

Three specific choices made AlexNet *trainable* at this scale, each addressing a problem that had stalled earlier deep networks:

- **[[Activation Functions|ReLU]]** instead of tanh/sigmoid — avoids the vanishing-gradient problem that saturating activations cause in deep stacks, and is much cheaper to compute.
- **Dropout** in the fully-connected layers — randomly zeroes out neurons during training, forcing the network to not rely on any single neuron and reducing [[Overfitting and Underfitting|overfitting]] in a network with ~60 million parameters.
- **Overlapping max pooling** (3×3 window, stride 2) — slightly improved accuracy over non-overlapping pooling by retaining more spatial information between pooling regions.

## In Practice: Loading and Running AlexNet (Python / PyTorch)

```python
import torch
from torchvision import models, transforms
from PIL import Image

# Load a pretrained AlexNet
model = models.alexnet(weights="IMAGENET1K_V1")
model.eval()

# Standard preprocessing: resize/crop to AlexNet's expected input
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(227),  # AlexNet's documented input size
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

img = Image.open("bell_peppers.jpg").convert("RGB")
batch = preprocess(img).unsqueeze(0)

with torch.no_grad():
    logits = model(batch)
    probs = torch.softmax(logits, dim=1)
    top5 = torch.topk(probs, 5)

print(top5)
```

This mirrors the five-step workflow from the lecture: load a pretrained model → read a test image → resize to the network's input size → classify → inspect the result.

## Common Pitfalls & Practical Tips

- **Input size confusion (224 vs 227)**: AlexNet's original paper describes a 224×224 input, but the convolution arithmetic only works out with 227×227 (or 224 with extra padding) — different implementations handle this differently. MATLAB's `alexnet` explicitly documents 227×227; always check `model.input_size` or the framework docs rather than assuming.
- **AlexNet is a useful baseline, not a production choice today** — [[VGG (VGG-16 / VGG-19)|VGG]], [[GoogLeNet and the Inception Architecture|GoogLeNet/Inception]], and [[Residual Networks (ResNet)|ResNet]] all surpass it in accuracy with comparable or fewer parameters. Use it mainly for quick experiments or historical/educational comparison.
- For transfer learning, freeze the convolutional base and replace `model.classifier[6]` (the final `Linear` layer) with a new layer matching your number of classes.

## Related Concepts

- [[Convolutional Neural Networks (CNN)]] — AlexNet is a (relatively shallow, by modern standards) instance of the conv/pool/ReLU/FC pattern.
- [[Activation Functions]] — AlexNet's use of ReLU over tanh was a key enabler of its depth and training speed.
- [[Overfitting and Underfitting]] — dropout in AlexNet's FC layers directly targets overfitting in a large-parameter model.
- [[VGG (VGG-16 / VGG-19)|VGG]] and [[GoogLeNet and the Inception Architecture|GoogLeNet]] — the next generation of ImageNet-winning architectures that built on AlexNet's success.

**Source:** Krizhevsky, A., Sutskever, I., Hinton, G. (2012). *ImageNet Classification with Deep Convolutional Neural Networks*. NeurIPS; [AlexNet, Wikipedia](https://en.wikipedia.org/wiki/AlexNet); [MathWorks AlexNet docs](https://au.mathworks.com/help/deeplearning/ref/alexnet.html)
