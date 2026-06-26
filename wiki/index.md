# Wiki Index

Master catalog of all wiki pages. Updated as new pages are created.

## Categories

### Concepts
Pages on timeless topics, patterns, and ideas.

- [[git-command-reference|Git Command Reference]] — Everyday git workflow cheat sheet: setup, commit loop, remotes, branching, undoing, stashing
- [[ml-dl-reading-order|ML/DL Concept Reading Order]] — Suggested reading path through all 58 concept pages, phase by phase
- [[claude-prompting-guide|Claude Prompting Guide]] — Effective communication strategies with Claude
- [[recurring-prompting-patterns|Recurring Prompting Patterns from Your Chats]] — Analysis of common mistakes and improvements
- [[transfer-learning-for-classification|Transfer Learning and YOLO for Classification]] — Deep learning architecture patterns
- [[emg-signal-processing|EMG Signal Processing and Visualization]] — Biometric signal analysis techniques
- [[multi-agent-systems|Multi-Agent AI Systems Architecture]] — Orchestrating specialist agents
- [[deep-learning|Deep Learning]] — Multilayer stacks of nonlinear modules (LeCun/Bengio/Hinton)
- [[convolutional-neural-networks|Convolutional Neural Networks (CNN)]] — Local connections + shared weights + pooling + multilayers
- [[recurrent-neural-networks|Recurrent Neural Networks (RNN)]] — Sequence processing with shared weights across time
- [[deep-neural-networks|Deep Neural Networks (DNN)]] — Input/hidden/output layer architecture
- [[machine-learning-vs-deep-learning|Machine Learning vs Deep Learning]] — Hand-crafted vs. learned features
- [[data-augmentation|Data Augmentation]] — Resize, rotate, flip, shear, translate, recolour
- [[neural-network-training-workflow|Neural Network Training Workflow]] — 7-step workflow + train/val/test split
- [[self-organizing-map|Self-Organizing Map (SOM)]] — Unsupervised clustering via competitive learning
- [[narx-network|NARX Network]] — Nonlinear autoregressive time-series forecasting
- [[artificial-neural-networks|Artificial Neural Networks (ANN)]] — Neuron model: weight, input, transfer functions
- [[multilayer-perceptron|Multilayer Perceptron (MLP)]] — Feedforward ANN with nonlinear hidden layers
- [[Backpropagation]] — Gradient computation via the chain rule
- [[stochastic-gradient-descent|Stochastic Gradient Descent (SGD)]] — Mini-batch weight update procedure
- [[activation-functions|Activation Functions]] — ReLU, Tanh, Sigmoid
- [[loss-functions|Loss Functions]] — 0-1, square, absolute, log, average loss
- [[overfitting-and-underfitting|Overfitting and Underfitting]] — Model capacity vs. generalisation
- [[confusion-matrix-metrics|Confusion Matrix Metrics]] — TPR, FPR, PPV, Accuracy, F1
- [[universal-approximation-theorem|Universal Approximation Theorem]] — Theoretical basis for MLPs as function approximators
- [[receptive-field-stride-padding|Receptive Field, Stride, and Padding]] — CNN spatial dimensions and output-size formula
- [[softmax-function|Softmax Function]] — Converts logits to a probability distribution
- [[intersection-over-union|Intersection over Union (IoU)]] — Bounding box overlap metric
- [[anchor-boxes|Anchor Boxes]] — Predefined box templates for object detection
- [[one-stage-vs-two-stage-detection|One-Stage vs Two-Stage Object Detection]] — R-CNN family vs. YOLO/SSD
- [[r-cnn-family|R-CNN Family]] — R-CNN, Fast R-CNN, Faster R-CNN evolution
- [[yolo-you-only-look-once|YOLO (You Only Look Once)]] — One-stage detector, v1-v4 evolution
- [[ssd-single-shot-multibox-detector|SSD (Single Shot MultiBox Detector)]] — Multi-scale one-stage detector
- [[densenet|Densely Connected Convolutional Network (DenseNet)]] — Concatenated feature maps across layers for reuse and gradient flow
- [[resnet|Residual Networks (ResNet)]] — Identity shortcuts and residual learning to fix the degradation problem
- [[AlexNet]] — 8-layer CNN that won ILSVRC 2012, kickstarted deep learning
- [[vgg|VGG (VGG-16 / VGG-19)]] — Depth via stacked 3x3 convolutions
- [[googlenet-inception|GoogLeNet and the Inception Architecture]] — Parallel multi-scale Inception modules (GoogLeNet, Inception-v3)
- [[long-short-term-memory|Long Short-Term Memory (LSTM)]] — Gated memory cell that fixes the RNN vanishing gradient problem
- [[transformer-machine-learning-model|Transformer (Attention Is All You Need)]] — Self-attention replaces recurrence for sequence modelling
- [[vision-transformer|Vision Transformer (ViT)]] — Images as sequences of patch tokens through a Transformer encoder
- [[generative-adversarial-network|Generative Adversarial Network (GAN)]] — Generator vs. discriminator minimax game
- [[reinforcement-learning|Reinforcement Learning (RL)]] — Agent learns via reward from environment interaction
- [[transfer-learning|Transfer Learning]] — Reuse a model trained on one task as the starting point for another
- [[ensemble-learning|Ensemble Learning]] — Combine diverse base learners for better accuracy
- [[distributed-training-of-deep-neural-networks|Distributed Training of Deep Neural Networks (Data Parallelism)]] — Multi-GPU training and the batch size/learning rate scaling rule
- [[classification-supervised-learning|Classification (Supervised Learning)]] — Training/test sets, structural descriptions, supervised vs. unsupervised
- [[linear-regression-numeric-prediction|Linear Regression and Numeric Prediction]] — Predicting numeric values via a weighted linear formula
- [[bias-in-machine-learning|Bias in Machine Learning (Algorithm Bias vs. Data Bias)]] — Inductive bias vs. unrepresentative training data
- [[knowledge-discovery-kdd-process|Knowledge Discovery (KDD) Process]] — 6-step loop from data collection to monitoring
- [[data-preprocessing-and-data-quality|Data Preprocessing and Data Quality]] — Noise, missing values, normalization, balancing, feature selection
- [[naive-bayes-classifier|Naive Bayes Classifier]] — Bayes theorem + conditional independence assumption
- [[decision-trees-and-information-gain|Decision Trees and Information Gain]] — Top-down recursive construction via entropy/information gain
- [[k-nearest-neighbors-knn|K-Nearest Neighbors (KNN)]] — Lazy, instance-based classification by majority vote among neighbours
- [[bias-variance-tradeoff|Bias-Variance Tradeoff]] — Learner's ability to fit patterns vs. sensitivity to training data
- [[Cross-Validation]] — k-fold and stratified k-fold model evaluation
- [[k-means-clustering|K-Means Clustering]] — Unsupervised partitioning via iterative centroid updates
- [[nlp-text-preprocessing-pipeline|NLP Text Preprocessing Pipeline]] — Tokenization, stop words, normalization, lemmatization vs. stemming
- [[tf-idf-and-feature-selection-for-text|TF-IDF and Feature Selection for Text]] — Bag-of-words, feature selection/construction, Mutual Information, TF-IDF
- [[word-embeddings-word2vec-and-glove|Word Embeddings (Word2Vec and GloVe)]] — Dense semantic vectors via CBOW, Skip-gram, and GloVe
- [[named-entity-recognition-and-relation-extraction|Named Entity Recognition and Relation Extraction]] — Triples, Hearst patterns, supervised and bootstrapped relation extraction
- [[model-context-protocol-mcp|Model Context Protocol (MCP)]] — USB-C for agent harnesses; reduces N×M tool-integration complexity to O(N+M)
- [[agent-to-agent-protocol-a2a|Agent-to-Agent Protocol (A2A)]] — Collaborative agent delegation across networks; agent cards, registries, AaaS, L402 microtransactions
- [[agent-skills|Agent Skills]] — Portable on-demand runbooks giving agents procedural memory; SKILL.md + progressive disclosure, EDD, Read/Draft/Act safety ladder

### Projects
Pages on specific projects, goals, and initiatives.

- [[radar-emulator|Radar Emulator Frontend]] — Visualizing radar capture data with WebGL
- [[deep-learning-assignment|Deep Learning Assignment]] — COMP838 final-year course project
- [[skillswap-platform|SkillSwap Platform]] — Student skill-exchange network application
- [[emg-fatigue-monitoring-fyp|EMG-Based Muscle Fatigue Monitoring (Final Year Project)]] — AI analysis of EMG biosignals for athlete fatigue monitoring (group FYP)

### Courses
Cornell Method lecture notes, organized by course code. See [courses/](courses/).

- [[index|COMP838 - Introduction to Deep Learning]] — AUT, Wei Qi Yan (completed). Lectures 1-5, 7-10 processed — concept-focused notes
- [[index|COMP723 - Data Mining and Machine Learning]] — AUT, Parma Nand (notes complete). Lectures 1-6, 8-11 processed — data mining, classification, ANNs, clustering, NLP/text mining, word embeddings, Transformers, and relation extraction
- [[index|5-Day AI Agents - Intensive Vibe Coding Course With Google (Kaggle)]] — Kaggle x Google, June 2026 (in progress). Days 1-3 done — vibe coding/agentic engineering, context engineering, factory model; MCP/A2A/A2UI/UCP/AP2 interoperability stack; Agent Skills procedural memory. Days 4-5 pending

---

## Recent Activity

See [log.md](log.md) for a complete append-only record of changes.

---

## Quick Links

- [Log](log.md) — Activity history
- [Concepts/](concepts/) — Concept pages
- [Projects/](projects/) — Project pages
- [Courses/](courses/) — Cornell-method lecture notes by course

---

**Last Updated:** 26-06-2026

---

## Ingestion Summary (12-06-2026)

**Source:** Claude.ai exports (conversations.json, design_chats, projects)

**Files processed:** 170 total
- Conversations: 163
- Design chats: 1
- Projects: 6

**Pages created:** 7 wiki pages
- 3 project pages
- 4 concept pages

See [log.md](log.md) for detailed entry.
