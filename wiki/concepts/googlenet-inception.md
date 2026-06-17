---
title: GoogLeNet and the Inception Architecture
type: concept
sources: [https://www.geeksforgeeks.org/machine-learning/understanding-googlenet-model-cnn-architecture/, https://www.sciencedirect.com/topics/computer-science/inception-v3, https://www.cv-foundation.org/openaccess/content_cvpr_2016/papers/Szegedy_Rethinking_the_Inception_CVPR_2016_paper.pdf, https://au.mathworks.com/help/deeplearning/ref/googlenet.html, https://au.mathworks.com/help/deeplearning/ref/inceptionv3.html]
related: [Convolutional Neural Networks (CNN), AlexNet, VGG (VGG-16 / VGG-19), Residual Networks (ResNet)]
created: 12-06-2026
last-updated: 12-06-2026
---

# GoogLeNet and the Inception Architecture

## The Core Idea

GoogLeNet (Szegedy et al., 2014 — also called **Inception-v1**) won ILSVRC 2014 classification (6.67% top-5 error) using a 22-layer network built from **Inception modules**: instead of choosing one filter size per layer, each Inception module runs **1×1, 3×3, and 5×5 convolutions plus 3×3 max pooling in parallel** on the same input and concatenates their outputs. **Inception-v3** (Szegedy et al., 2016) is a later refinement of the same family — it factorizes large convolutions (e.g., a 7×7 conv becomes three 3×3 convs), adds batch normalization to the auxiliary classifiers, uses RMSProp and label smoothing, has 48 layers, and takes a larger **299×299** input (vs. 224×224 for GoogLeNet).

## Intuition

The motivating question behind Inception is: *what's the "right" filter size for a given layer?* Small objects need small receptive fields (3×3), large objects need bigger ones (5×5), and sometimes you just need to mix channels without spatial filtering at all (1×1). Rather than guess, an Inception module **does all of them at once** and lets the network learn, via the weights on each branch, how much to rely on each scale — multi-scale feature extraction "for free."

The other key trick is the **1×1 convolution used as a bottleneck**. A 1×1 conv doesn't look at any spatial neighborhood — it only mixes information *across channels* at each pixel. Used *before* an expensive 5×5 conv, it can shrink the channel count first (e.g., 480 → 16 channels), so the 5×5 conv has far less work to do. The lecture's GeeksforGeeks source gives a concrete example: a 5×5 conv over 480 input channels costs ~112.9M operations directly, but only ~5.3M operations if a 1×1 conv first reduces to 16 channels — roughly a **20x reduction** with negligible accuracy loss.

GoogLeNet also uses **auxiliary classifiers** — extra softmax outputs attached partway through the network during training — to inject additional gradient signal into early layers, mitigating vanishing gradients in a 22-layer network (a similar problem to the one [[Residual Networks (ResNet)|ResNet]] solves differently, with shortcut connections). Inception-v3 keeps this idea but adds batch normalization to the auxiliary branch for more stable training.

Finally, both versions replace VGG/AlexNet-style large fully-connected layers with **global average pooling** before the final classifier — collapsing each feature map to a single number — which drastically cuts parameter count and reduces overfitting.

## In Practice: GoogLeNet vs. Inception-v3 (PyTorch)

```python
import torch
from torchvision import models, transforms
from PIL import Image

googlenet = models.googlenet(weights="IMAGENET1K_V1").eval()
inception_v3 = models.inception_v3(weights="IMAGENET1K_V1").eval()

# Note the DIFFERENT input sizes -- a common transfer-learning bug source
preprocess_224 = transforms.Compose([
    transforms.Resize(256), transforms.CenterCrop(224), transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])
preprocess_299 = transforms.Compose([
    transforms.Resize(342), transforms.CenterCrop(299), transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

img = Image.open("bell_peppers.jpg").convert("RGB")

with torch.no_grad():
    pred_google = torch.softmax(googlenet(preprocess_224(img).unsqueeze(0)), dim=1)
    pred_inception = torch.softmax(inception_v3(preprocess_299(img).unsqueeze(0)), dim=1)

print("GoogLeNet top-5:", torch.topk(pred_google, 5))
print("Inception-v3 top-5:", torch.topk(pred_inception, 5))
```

## Common Pitfalls & Practical Tips

- **Input size mismatch (224 vs 299)** is the single most common bug when swapping Inception-v3 into a pipeline built around other architectures — always check the model's expected input resolution.
- **Auxiliary classifiers are training-only** — in inference mode (`model.eval()`), most implementations automatically disable them and use only the main output head.
- GoogLeNet/Inception-v3 sit in a useful middle ground: noticeably more parameter-efficient than [[VGG (VGG-16 / VGG-19)|VGG]], while being conceptually more complex to implement from scratch than [[Residual Networks (ResNet)|ResNet]]'s simple residual blocks — for most transfer learning today, ResNet variants are the more common default, with Inception used where its specific multi-scale behaviour helps.

## Related Concepts

- [[Convolutional Neural Networks (CNN)]] — Inception modules are built from the same conv/pool/ReLU primitives, just arranged in parallel branches.
- [[AlexNet]] and [[VGG (VGG-16 / VGG-19)|VGG]] — GoogLeNet was ILSVRC 2014's classification winner, beating VGG (runner-up) by combining multi-scale filters with much lower parameter count.
- [[Residual Networks (ResNet)|ResNet]] — addresses the same "how do we train very deep networks" problem as GoogLeNet's auxiliary classifiers, but via shortcut connections instead.

**Source:** Szegedy, C., et al. (2015). *Going Deeper with Convolutions* (GoogLeNet/Inception-v1), CVPR; Szegedy, C., et al. (2016). *Rethinking the Inception Architecture for Computer Vision* (Inception-v3), [CVPR](https://www.cv-foundation.org/openaccess/content_cvpr_2016/papers/Szegedy_Rethinking_the_Inception_CVPR_2016_paper.pdf); [Understanding GoogLeNet, GeeksforGeeks](https://www.geeksforgeeks.org/machine-learning/understanding-googlenet-model-cnn-architecture/); [Inception V3, ScienceDirect Topics](https://www.sciencedirect.com/topics/computer-science/inception-v3)
