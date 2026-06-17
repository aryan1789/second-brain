# Wiki Index

Master catalog of all wiki pages. Updated as new pages are created.

## Categories

### Concepts
Pages on timeless topics, patterns, and ideas.

- [[ML/DL Concept Reading Order]] — Suggested reading path through all 58 concept pages, phase by phase
- [[Claude Prompting Guide]] — Effective communication strategies with Claude
- [[Recurring Prompting Patterns from Your Chats]] — Analysis of common mistakes and improvements
- [[Transfer Learning and YOLO for Classification]] — Deep learning architecture patterns
- [[EMG Signal Processing and Visualization]] — Biometric signal analysis techniques
- [[Multi-Agent AI Systems Architecture]] — Orchestrating specialist agents
- [[Deep Learning]] — Multilayer stacks of nonlinear modules (LeCun/Bengio/Hinton)
- [[Convolutional Neural Networks (CNN)]] — Local connections + shared weights + pooling + multilayers
- [[Recurrent Neural Networks (RNN)]] — Sequence processing with shared weights across time
- [[Deep Neural Networks (DNN)]] — Input/hidden/output layer architecture
- [[Machine Learning vs Deep Learning]] — Hand-crafted vs. learned features
- [[Data Augmentation]] — Resize, rotate, flip, shear, translate, recolour
- [[Neural Network Training Workflow]] — 7-step workflow + train/val/test split
- [[Self-Organizing Map (SOM)]] — Unsupervised clustering via competitive learning
- [[NARX Network]] — Nonlinear autoregressive time-series forecasting
- [[Artificial Neural Networks (ANN)]] — Neuron model: weight, input, transfer functions
- [[Multilayer Perceptron (MLP)]] — Feedforward ANN with nonlinear hidden layers
- [[Backpropagation]] — Gradient computation via the chain rule
- [[Stochastic Gradient Descent (SGD)]] — Mini-batch weight update procedure
- [[Activation Functions]] — ReLU, Tanh, Sigmoid
- [[Loss Functions]] — 0-1, square, absolute, log, average loss
- [[Overfitting and Underfitting]] — Model capacity vs. generalisation
- [[Confusion Matrix Metrics]] — TPR, FPR, PPV, Accuracy, F1
- [[Universal Approximation Theorem]] — Theoretical basis for MLPs as function approximators
- [[Receptive Field, Stride, and Padding]] — CNN spatial dimensions and output-size formula
- [[Softmax Function]] — Converts logits to a probability distribution
- [[Intersection over Union (IoU)]] — Bounding box overlap metric
- [[Anchor Boxes]] — Predefined box templates for object detection
- [[One-Stage vs Two-Stage Object Detection]] — R-CNN family vs. YOLO/SSD
- [[R-CNN Family]] — R-CNN, Fast R-CNN, Faster R-CNN evolution
- [[YOLO (You Only Look Once)]] — One-stage detector, v1-v4 evolution
- [[SSD (Single Shot MultiBox Detector)]] — Multi-scale one-stage detector
- [[Densely Connected Convolutional Network (DenseNet)]] — Concatenated feature maps across layers for reuse and gradient flow
- [[Residual Networks (ResNet)]] — Identity shortcuts and residual learning to fix the degradation problem
- [[AlexNet]] — 8-layer CNN that won ILSVRC 2012, kickstarted deep learning
- [[VGG (VGG-16 / VGG-19)]] — Depth via stacked 3x3 convolutions
- [[GoogLeNet and the Inception Architecture]] — Parallel multi-scale Inception modules (GoogLeNet, Inception-v3)
- [[Long Short-Term Memory (LSTM)]] — Gated memory cell that fixes the RNN vanishing gradient problem
- [[Transformer (Attention Is All You Need)]] — Self-attention replaces recurrence for sequence modelling
- [[Vision Transformer (ViT)]] — Images as sequences of patch tokens through a Transformer encoder
- [[Generative Adversarial Network (GAN)]] — Generator vs. discriminator minimax game
- [[Reinforcement Learning (RL)]] — Agent learns via reward from environment interaction
- [[Transfer Learning]] — Reuse a model trained on one task as the starting point for another
- [[Ensemble Learning]] — Combine diverse base learners for better accuracy
- [[Distributed Training of Deep Neural Networks (Data Parallelism)]] — Multi-GPU training and the batch size/learning rate scaling rule
- [[Classification (Supervised Learning)]] — Training/test sets, structural descriptions, supervised vs. unsupervised
- [[Linear Regression and Numeric Prediction]] — Predicting numeric values via a weighted linear formula
- [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)]] — Inductive bias vs. unrepresentative training data
- [[Knowledge Discovery (KDD) Process]] — 6-step loop from data collection to monitoring
- [[Data Preprocessing and Data Quality]] — Noise, missing values, normalization, balancing, feature selection
- [[Naive Bayes Classifier]] — Bayes theorem + conditional independence assumption
- [[Decision Trees and Information Gain]] — Top-down recursive construction via entropy/information gain
- [[K-Nearest Neighbors (KNN)]] — Lazy, instance-based classification by majority vote among neighbours
- [[Bias-Variance Tradeoff]] — Learner's ability to fit patterns vs. sensitivity to training data
- [[Cross-Validation]] — k-fold and stratified k-fold model evaluation
- [[K-Means Clustering]] — Unsupervised partitioning via iterative centroid updates
- [[NLP Text Preprocessing Pipeline]] — Tokenization, stop words, normalization, lemmatization vs. stemming
- [[TF-IDF and Feature Selection for Text]] — Bag-of-words, feature selection/construction, Mutual Information, TF-IDF
- [[Word Embeddings (Word2Vec and GloVe)]] — Dense semantic vectors via CBOW, Skip-gram, and GloVe
- [[Named Entity Recognition and Relation Extraction]] — Triples, Hearst patterns, supervised and bootstrapped relation extraction
- [[Model Context Protocol (MCP)]] — USB-C for agent harnesses; reduces N×M tool-integration complexity to O(N+M)
- [[Agent-to-Agent Protocol (A2A)]] — Collaborative agent delegation across networks; agent cards, registries, AaaS, L402 microtransactions

### Projects
Pages on specific projects, goals, and initiatives.

- [[Radar Emulator Frontend]] — Visualizing radar capture data with WebGL
- [[Deep Learning Assignment]] — COMP838 final-year course project
- [[SkillSwap Platform]] — Student skill-exchange network application
- [[EMG-Based Muscle Fatigue Monitoring (Final Year Project)]] — AI analysis of EMG biosignals for athlete fatigue monitoring (group FYP)

### Courses
Cornell Method lecture notes, organized by course code. See [courses/](courses/).

- [[COMP838 - Introduction to Deep Learning]] — AUT, Wei Qi Yan (completed). Lectures 1-5, 7-10 processed — concept-focused notes
- [[COMP723 - Data Mining and Machine Learning]] — AUT, Parma Nand (notes complete). Lectures 1-6, 8-11 processed — data mining, classification, ANNs, clustering, NLP/text mining, word embeddings, Transformers, and relation extraction
- [[5-Day AI Agents - Intensive Vibe Coding Course With Google (Kaggle)]] — Kaggle x Google, June 2026 (in progress). Days 1-2 done — vibe coding/agentic engineering, context engineering, factory model; MCP/A2A/A2UI/UCP/AP2 interoperability stack. Days 3-5 pending

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

**Last Updated:** 17-06-2026

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
