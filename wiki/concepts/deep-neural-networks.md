---
title: Deep Neural Networks (DNN)
type: concept
sources: [Beale, M., Hagan, M., Demuth, H. (2019). MATLAB R2019b Deep Learning Toolbox User's Guide. MathWorks.]
related: [Deep Learning, Convolutional Neural Networks (CNN), Recurrent Neural Networks (RNN), Neural Network Training Workflow, Artificial Neural Networks (ANN), Multilayer Perceptron (MLP)]
created: 12-06-2026
last-updated: 12-06-2026
---

# Deep Neural Networks (DNN)

## The Core Idea

A Deep Neural Network (DNN) combines multiple nonlinear processing layers, made of simple computational elements operating in parallel, loosely inspired by biological nervous systems.

## Structure

- **Input layer** — receives the raw data (e.g., pixel values, sensor readings, tokens)
- **Hidden layers** — one or more intermediate layers that progressively transform the representation
- **Output layer** — produces the final prediction (a class label, a number, a sequence, etc.)

Layers are interconnected via **nodes (neurons)**. Each hidden layer takes the output of the previous layer as its input — this is the "deep" in deep learning: the depth refers to the number of these stacked layers.

## Intuition: "DNN" vs "ANN" vs "MLP" — Why So Many Names?

These terms overlap heavily and the distinctions are more historical/contextual than strict:

- **[[Artificial Neural Networks (ANN)|ANN]]** is the oldest, most general term — any network of artificial neurons, going back to the 1950s perceptron. Could have 0, 1, or many hidden layers.
- **[[Multilayer Perceptron (MLP)|MLP]]** specifically means a *feedforward* ANN with ≥1 hidden layer, trained via backpropagation. The classic "fully-connected" network.
- **DNN** is an informal term emphasizing that the network has *many* layers — used loosely to mean "a neural network deep enough that 'deep learning' techniques and considerations apply" (vanishing gradients, representation learning, need for GPUs, etc.).
- **[[Deep Learning]]** is the broader field/paradigm built around training DNNs.

In practice: if someone says "DNN," picture a feedforward [[Multilayer Perceptron (MLP)|MLP]] with several hidden layers — the same architecture, just emphasizing depth. CNNs and RNNs are also technically "deep neural networks," but get their own names because their connectivity pattern (convolutional / recurrent) is the more important distinguishing feature.

## In Practice: Seeing the Layer Structure Explicitly (PyTorch)

```python
import torch.nn as nn

class DNN(nn.Module):
    def __init__(self, input_size, hidden_sizes, num_classes):
        super().__init__()
        layers = []
        prev_size = input_size
        for h in hidden_sizes:
            layers += [nn.Linear(prev_size, h), nn.ReLU()]
            prev_size = h
        layers.append(nn.Linear(prev_size, num_classes))  # output layer
        self.net = nn.Sequential(*layers)

    def forward(self, x):
        return self.net(x)

# input_size=20 features, three hidden layers of decreasing width, 3 output classes
model = DNN(input_size=20, hidden_sizes=[64, 32, 16], num_classes=3)
print(model)
```

This prints out the explicit input → hidden → hidden → hidden → output structure. Notice how "depth" here is just a parameter (`len(hidden_sizes)`) — there's no architectural magic, just more layers, each adding capacity (and risk of [[Overfitting and Underfitting|overfitting]]) to the model.

## Common Pitfalls & Practical Tips

- **Width vs. depth trade-off.** A network can be made "bigger" by adding more layers (depth) or more units per layer (width). Depth tends to be more parameter-efficient for hierarchical data (images, language); width alone can still underfit if the function being learned genuinely needs compositional structure.
- **Vanishing/exploding gradients get worse with depth.** This is one reason `ReLU` (see [[Activation Functions]]) and techniques like batch normalisation and residual connections (used in ResNet) became important — they let gradients flow through very deep networks during [[Backpropagation]].
- **Don't conflate "DNN" with "any neural network you build."** A single hidden layer with 8 units is technically an [[Artificial Neural Networks (ANN)|ANN]]/[[Multilayer Perceptron (MLP)|MLP]] but wouldn't typically be called "deep" — the term implies enough layers that depth-specific considerations (training difficulty, representation hierarchies) start to matter.

**Source:** Beale, M., Hagan, M., Demuth, H. (2019). *MATLAB R2019b Deep Learning Toolbox User's Guide*. MathWorks.
