---
title: VGG (VGG-16 / VGG-19)
type: concept
sources: [https://arxiv.org/abs/1409.1556, https://www.geeksforgeeks.org/computer-vision/vgg-16-cnn-model/, https://au.mathworks.com/help/deeplearning/ref/vgg19.html]
related: [AlexNet, Receptive Field, Stride, and Padding, Convolutional Neural Networks (CNN), Residual Networks (ResNet)]
created: 12-06-2026
last-updated: 12-06-2026
---

# VGG (VGG-16 / VGG-19)

## The Core Idea

VGG (Simonyan & Zisserman, 2014) is a family of CNNs built almost entirely from **stacks of small 3×3 convolution filters** (stride 1, padding 1) followed by 2×2 max pooling, repeated in blocks of increasing depth and channel count. VGG-19 has 19 weight layers (16 convolutional + 3 fully-connected), takes a **224×224** input, and is trained on ImageNet to classify 1,000 object categories. VGG-16 (13 conv + 3 FC = 16 weight layers) achieved 92.7% top-5 accuracy and a 7.32% top-5 error on ILSVRC 2014 — runner-up in classification to [[GoogLeNet and the Inception Architecture|GoogLeNet]], but winner of the localization task.

## Intuition

VGG's central finding was almost an experiment in minimalism: instead of trying different filter sizes (11×11, 5×5, etc. as in [[AlexNet]]), use **only 3×3 filters everywhere**, and get depth/receptive field by *stacking* them.

This connects directly to [[Receptive Field, Stride, and Padding]]: two stacked 3×3 convolutions have the same receptive field as a single 5×5 convolution (5×5 = 25 weights per channel vs. 2×(3×3) = 18), but with **fewer parameters** *and* an extra ReLU nonlinearity in between — meaning the network can learn a more complex, non-linear function over that same receptive field for less cost. Three stacked 3×3 convs ≈ one 7×7 conv, with even more savings. VGG essentially asks: "what if depth, not filter size, is the main lever for representational power?" — and the answer (at the time) was that it worked very well.

The tradeoff: almost all of VGG's ~138 million parameters (for VGG-16) live in the **fully-connected layers** at the end, making it large and slow compared to later architectures that replace FC layers with global average pooling (see [[GoogLeNet and the Inception Architecture|GoogLeNet]] and [[Residual Networks (ResNet)|ResNet]]).

## In Practice: VGG-19 as a Feature Extractor (PyTorch)

```python
import torch
from torchvision import models, transforms
from PIL import Image

model = models.vgg19(weights="IMAGENET1K_V1")
model.eval()

preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),  # VGG-19's documented input size
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

img = Image.open("bell_peppers.jpg").convert("RGB")
batch = preprocess(img).unsqueeze(0)

with torch.no_grad():
    probs = torch.softmax(model(batch), dim=1)
    top5 = torch.topk(probs, 5)

print(top5)

# VGG's convolutional "features" block is a popular frozen feature extractor
# for transfer learning, style transfer, and perceptual loss functions.
feature_extractor = model.features
```

## Common Pitfalls & Practical Tips

- **VGG is large and slow** — VGG-16/19 have far more parameters than [[Residual Networks (ResNet)|ResNet-50]] or [[GoogLeNet and the Inception Architecture|GoogLeNet]] for similar or worse accuracy. It's still popular for **perceptual losses** (e.g., in style transfer / GANs) because its learned features correlate well with human perceptual similarity, even when it's not the best choice as a classification backbone.
- **3×3 stacking ≠ free lunch** — stacking small filters increases depth, which (without [[Residual Networks (ResNet)|residual connections]]) can reintroduce vanishing-gradient/degradation issues at extreme depths. VGG-19 is close to the practical depth limit for a "plain" CNN of this style.
- For transfer learning, VGG's `model.classifier` (the FC stack) is the part you typically replace; `model.features` (the conv stack) is usually frozen or fine-tuned with a low learning rate.

## Related Concepts

- [[Receptive Field, Stride, and Padding]] — directly explains why stacking 3×3 convolutions can replace larger filters.
- [[AlexNet]] — VGG is the architectural successor that replaced AlexNet's varied filter sizes with uniform small filters and much greater depth.
- [[Convolutional Neural Networks (CNN)]] — VGG is a "pure" instance of the conv/pool/FC pattern, with almost no architectural tricks beyond depth.
- [[Residual Networks (ResNet)|ResNet]] and [[GoogLeNet and the Inception Architecture|GoogLeNet]] — both directly address VGG's parameter/compute cost while going even deeper.

**Source:** Simonyan, K., Zisserman, A. (2014). *Very Deep Convolutional Networks for Large-Scale Image Recognition*. [arXiv:1409.1556](https://arxiv.org/abs/1409.1556); [VGG-16 | CNN Model, GeeksforGeeks](https://www.geeksforgeeks.org/computer-vision/vgg-16-cnn-model/); [MathWorks VGG-19 docs](https://au.mathworks.com/help/deeplearning/ref/vgg19.html)
