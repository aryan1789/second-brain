# Activity Log

Append-only record of all changes to the wiki. Entries are added chronologically.

## Format

Each entry includes:
- Date
- Type (new page, update, link added, etc.)
- Page affected
- Brief summary of change

---

## Entries

### 12-06-2026

- **System Setup** — Initial wiki structure created
  - index.md (master catalog)
  - log.md (this file)
  - concepts/, projects/, people/ directories created
  - README files added to all directories

---

### 12-06-2026

**Ingestion from Claude.ai Exports**

*Source:* raw/claude-exports/ (170 total files: 163 conversations, 1 design chat, 6 projects)

**New Project Pages:**
- [[Radar Emulator Frontend]] — Work project for visualizing radar packet data with WebGL and interactive features
- [[Deep Learning Assignment]] — COMP838 final-year course on CNN and YOLO architectures
- [[SkillSwap Platform]] — Full-stack student networking application (React, ASP.NET, Supabase)

**New Concept Pages:**
- [[Claude Prompting Guide]] — Comprehensive techniques for effective communication with Claude (from How-to-use-Claude project)
- [[Transfer Learning and YOLO for Classification]] — Two-stage pipeline for object detection and attribute classification
- [[EMG Signal Processing and Visualization]] — Biometric signal analysis using OpenBCI hardware
- [[Multi-Agent AI Systems Architecture]] — Orchestrating specialist agents for complex tasks (Sequential, Parallel, Merger patterns)

**Pages Updated:**
- index.md — Added new pages to Concepts and Projects sections

**Files Deferred:** 163 conversations remain in raw/ as source material. Extracted 3 key conversations for concept synthesis; others available for future selective processing.

**Rationale:** Prioritized substantive materials (projects, design chats) and technical conversations with learning value. Individual conversation extraction deferred to avoid 170 separate pages; instead synthesized key insights into reusable concept pages.

---

### 12-06-2026 (Follow-up)

**Chat Pattern Analysis**

*Source:* raw/claude-exports/conversations.json (sample analysis from 15+ conversations)

**New Page:**
- [[Recurring Prompting Patterns from Your Chats]] — Analysis of 8 recurring patterns across conversations, with anti-patterns vs. good patterns and actionable improvements

**Patterns Identified:**

1. **Vague initial asks** — "can u pls explain this", "do the rest of things" (most common)
2. **Missing code context** — Partial code, missing error messages, missing file types
3. **Iterative refinement** — Your follow-ups are better than first asks; opportunity to frontload
4. **Scope creep** — Undefined "rest of things", multiple tasks without priority
5. **Assignment help needs context** — Role, time constraints, document attachment improve outcomes
6. **Incomplete error messages** — Partial stack traces instead of full output
7. **What you do well** — Full code upfront, clear problem statements, specific function names
8. **Vague success criteria** — "Help me understand" vs. explicit success measures

**Key Insight:** Your second messages are consistently better than your first. You're already providing (in follow-ups) the context needed upfront. Opportunity: frontload this context to eliminate clarification turns.

**Pages Updated:**
- index.md — Added recurring patterns page to Concepts section

---

### 12-06-2026 (Follow-up #2)

**Wiki Lint Cleanup**

*Task:* Remove references to 31 non-existent wiki pages

**Pages Updated:** 8
- concepts/claude-prompting-guide.md
- concepts/emg-signal-processing.md
- concepts/multi-agent-systems.md
- concepts/transfer-learning-for-classification.md
- concepts/recurring-prompting-patterns.md
- projects/deep-learning-assignment.md
- projects/radar-emulator.md
- projects/skillswap-platform.md

**Changes Made:**
- Removed 31 broken wiki-link references from `related:` fields
- Removed inline wiki-link references from body text
- Added placeholder "(To be expanded as more pages are created)" to Related Concepts/Pages sections
- Converted wiki-links to plain text where appropriate (e.g., "[[YOLOv4]]" → "YOLOv4")

**Result:** Wiki now contains only references to existing pages. All 8 content pages remain intact with updated cross-references.

---

### 12-06-2026 (Follow-up #3)

**Skill Setup: lecture-notes-to-cornell**

*Task:* Adapt and install the `lecture-notes-to-cornell` skill (originally built 06-05-2026, see [[Building a custom skill together]]) to match this vault's conventions.

**Changes Made:**
- Installed adapted skill to `~/.claude/skills/lecture-notes-to-cornell/SKILL.md` (user-level)
- Remapped `resources/concepts/` → `wiki/concepts/` and `areas/learning/{COURSE_CODE}/notes/` → `wiki/courses/{COURSE_CODE}/`
- Updated frontmatter templates to conform to CLAUDE.md spec (title/type/sources/related/created/last-updated); concept notes use `type: concept`, Cornell notes use `type: source-summary`
- Wikilinks updated to bare `[[Page Title]]` convention (no folder prefixes)

**Pages/Files Created:**
- `wiki/courses/README.md` — new category documentation
- `wiki/courses/` directory (empty, ready for first course)

**Pages Updated:**
- `CLAUDE.md` — documented new `courses/` category (4th wiki category)
- `wiki/index.md` — added Courses section and quick link

**Status:** Skill is ready to use. Next run of "process my lecture notes for {COURSE_CODE}" will create the first course folder under `wiki/courses/`.

---

### 12-06-2026 (Follow-up #4)

**Lecture Processing: COMP838 Lecture 1**

*Source:* raw/lecture-notes/COMP838/Lecture1.pdf ("Introduction to Deep Learning", Wei Qi Yan, AUT)

**New Concept Pages (wiki/concepts/):**
- [[Deep Learning]] — Multilayer stack of nonlinear modules; selectivity vs. invariance (LeCun/Bengio/Hinton 2015)
- [[Convolutional Neural Networks (CNN)]] — Local Connections + Shared Weights + Pooling + Multilayers
- [[Recurrent Neural Networks (RNN)]] — Sequence processing with shared hidden state across timesteps

**New Course (wiki/courses/COMP838/):**
- index.md — Course overview, syllabus table, lecture index
- Lecture-1.1-the-chronicle-of-deep-learning.md — Reorganized 1946-2026 DL history timeline into 4 eras, with verification
- Lecture-1.2-deep-learning-architectures-overview.md — Deep Learning/CNN/RNN definitions + architecture roadmap mapped to future lectures

**Research Performed:**
- Verified LeCun/Bengio/Hinton (2015) Nature 521:436-444 citation (core source for all 3 concept definitions)
- Verified 2024 ACM Turing Award (Barto & Sutton, RL foundations)
- Verified 2024 Nobel Prizes — Physics (Hopfield & Hinton) and Chemistry (Hassabis & Jumper, AlphaFold)
- Verified DeepSeek-R1 (Jan 2025)
- Flagged as unverified: YOLOv12 (2025), Seedance/ByteDance (2026) — could not confirm via search

**Scope Decisions (per user input):**
- Skipped "Course Structure and Assessment" admin content (not exam-relevant)
- Did not link to existing [[Deep Learning Assignment]] project page (kept separate)
- Did not create concept notes for architectures only name-dropped in the Chronicle (AlexNet, ResNet, GoogLeNet, GANs, Transformers, etc.) — deferred to when their dedicated lectures (4, 8, 9, Individual Reports) are processed, where there's enough material for a proper definition

**Pages Updated:**
- wiki/index.md — added 3 concept pages, added Courses entry for COMP838
- raw/lecture-notes/COMP838/Lecture1.pdf — source PDF saved

---

### 12-06-2026 (Follow-up #5)

**Lecture Processing: COMP838 Lecture 2 + Redo Lecture 1 (Completed-Course Mode)**

*Trigger:* COMP838 is finished — Aryan asked that wiki notes for completed courses focus only on durable ML/DL knowledge, excluding detailed timelines, course admin/assignment refs, and lecturer's own research projects.

**Redone — Lecture 1:**
- Deleted `Lecture-1.1-the-chronicle-of-deep-learning.md` (detailed 1946-2026 timeline — excluded per new guidance)
- Replaced `Lecture-1.2-deep-learning-architectures-overview.md` with `Lecture-1-deep-learning-fundamentals.md` — removed "Architecture Roadmap for COMP838" table (assignment/lecture-number refs) and consolidated into a single lecture note
- Trimmed [[Deep Learning]], [[Convolutional Neural Networks (CNN)]], [[Recurrent Neural Networks (RNN)]] — removed "Course Context (COMP838)" sections referencing lecture numbers/individual reports; CNN/RNN now fold the durable content (origins, LSTM) into the main body

**New — Lecture 2 (raw/lecture-notes/COMP838/Lecture2.pdf, "Data Labelling, Augmentation and Visualization"):**

New concept pages (wiki/concepts/):
- [[Deep Neural Networks (DNN)]] — input/hidden/output layer architecture
- [[Machine Learning vs Deep Learning]] (type: comparison) — hand-crafted vs. learned features, trade-off table
- [[Data Augmentation]] — resize/rotate/flip/shear/translate/recolour, why it reduces overfitting
- [[Neural Network Training Workflow]] — 7-step workflow, train/val/test split, maps to 4 task types
- [[Self-Organizing Map (SOM)]] — unsupervised competitive-learning clustering
- [[NARX Network]] — nonlinear autoregressive exogenous time-series architecture, linked to RNN

New course note:
- `wiki/courses/COMP838/Lecture-2-data-and-ml-fundamentals.md`

**Explicitly excluded from Lecture 2** (per completed-course filter): MATLAB Online/Image Labeler GUI walkthroughs, MATLAB toolbox function syntax (nftool/patternnet/selforgmap/narxnet code snippets), Excel/Matplotlib tool links, "Questions?" slides.

**Research Performed (via firecrawl):**
- ML vs DL distinction (Databricks, Google Cloud) — ✓ verified
- Data augmentation techniques (Dive into Deep Learning, arXiv:2301.02830) — ✓ verified
- Self-Organizing Map (Wikipedia) — ✓ verified
- NARX network (MathWorks) — ✓ verified

**Pages Updated:**
- `wiki/index.md` — added 6 new concept pages, updated Courses entry
- `wiki/courses/COMP838/index.md` — rewrote: removed syllabus/assessment table, added topic-area summary and links to both lecture notes

**Skill Updated:**
- `~/.claude/skills/lecture-notes-to-cornell/SKILL.md` — added "Completed Course Mode" section defining what to include/exclude when processing a finished course (applies to future courses from this semester too)

---

### 12-06-2026 (Follow-up #6)

**Lecture Processing: COMP838 Lecture 3 + raw/lecture-notes README**

*Source:* raw/lecture-notes/COMP838/Lecture3.pdf ("Artificial Neural Networks") — Aryan also dropped Lectures 4-10 + Revision PDF into the same folder for future processing.

**New — Documentation:**
- Rewrote `raw/lecture-notes/README.md` to document the lecture-processing conventions in-repo: file naming, what gets created where, the "Completed Course Mode" include/exclude checklist, frontmatter spec, and suggested one-lecture-per-run pacing. This applies to all old semester papers being dropped in, not just COMP838.

**New — Lecture 3 concept pages (wiki/concepts/), the densest lecture so far:**
- [[Artificial Neural Networks (ANN)]] — neuron model (weight/input/transfer functions), single vs. multi-layer
- [[Multilayer Perceptron (MLP)]] — feedforward ANN, ≥3 layers, nonlinear hidden activations, trained via backprop
- [[Backpropagation]] — chain-rule gradient computation, weight update formula
- [[Stochastic Gradient Descent (SGD)]] — mini-batch training procedure
- [[Activation Functions]] — ReLU, Tanh, Sigmoid with formulas
- [[Loss Functions]] — 0-1, square, absolute, log, average/empirical risk
- [[Overfitting and Underfitting]] — model capacity vs. generalisation, links to train/val split
- [[Confusion Matrix Metrics]] — TP/TN/FP/FN → TPR/FPR/PPV/ACC/F1
- [[Universal Approximation Theorem]] — corrected from lecture's "Kolmogorov Theorem" framing; distinguished from Kolmogorov's 1957 superposition theorem

New course note: `wiki/courses/COMP838/Lecture-3-ann-fundamentals.md`

**Excluded from Lecture 3** (per Completed Course Mode): "ANN Playground" demo link, step-by-step backprop blog reference, Horner's algorithm aside (general numerical method, not ML/DL-specific), Wine Classification dataset specifics (kept the underlying confusion-matrix concept, dropped the dataset example).

**Research Performed (via firecrawl):**
- Universal Approximation Theorem attribution (Cybenko/Hornik vs. Kolmogorov) — ✓ verified, correction flagged
- Confusion matrix / precision / recall / F1 (Google ML Crash Course) — ✓ verified
- Activation functions (GeeksforGeeks) — ✓ verified
- Overfitting/underfitting (Cross Validated) — ✓ verified

**Pages Updated:**
- `wiki/index.md` — added 9 new concept pages, updated Courses entry (Lectures 1-3)
- `wiki/courses/COMP838/index.md` — added Lecture 3, expanded topic areas and related concept list

---

### 12-06-2026 (Follow-up #7)

**Major Revision: Enriched All COMP838 Concept Pages (Lectures 1-3)**

*Trigger:* Aryan reviewed the Lecture 1 wiki page and asked for substantially more depth — lecture slides are sparse, and he wants concept pages to build real understanding of DL/data science (he's a final-year SE student with a DS minor, feels his DS fundamentals are elementary) AND practical coding ability. Code examples: Python (PyTorch for DL, scikit-learn for classical ML).

**All 18 concept pages rewritten** with a new standard structure — Core Idea, Intuition (analogies/worked examples), In Practice (Python code), Common Pitfalls & Practical Tips, Related Concepts:

*Lecture 1:* [[Deep Learning]], [[Convolutional Neural Networks (CNN)]], [[Recurrent Neural Networks (RNN)]]
*Lecture 2:* [[Deep Neural Networks (DNN)]], [[Machine Learning vs Deep Learning]], [[Data Augmentation]], [[Neural Network Training Workflow]], [[Self-Organizing Map (SOM)]], [[NARX Network]]
*Lecture 3:* [[Artificial Neural Networks (ANN)]], [[Multilayer Perceptron (MLP)]], [[Backpropagation]], [[Stochastic Gradient Descent (SGD)]], [[Activation Functions]], [[Loss Functions]], [[Overfitting and Underfitting]], [[Confusion Matrix Metrics]], [[Universal Approximation Theorem]]

**Notable additions:**
- XOR worked example in [[Multilayer Perceptron (MLP)]] (with a "remove the activation function and watch it fail" exercise)
- Live function-approximation demo in [[Universal Approximation Theorem]]
- Autograd walkthrough in [[Backpropagation]] showing `.backward()` mechanics on a tiny example
- ReLU/Tanh/Sigmoid gradient-shape visualization code in [[Activation Functions]]
- Decision framework + side-by-side scikit-learn vs. PyTorch code in [[Machine Learning vs Deep Learning]]
- Full PyTorch training loop (DataLoader, train/val split, train/eval modes) in [[Neural Network Training Workflow]]

**Lecture notes updated:** Added "Going Deeper" callouts to all 3 Lecture-N course notes, pointing to the enriched concept pages. Lecture notes remain Cornell-style summaries; depth now lives in concept pages.

**Skill & README Updated for Future Lectures (4-10):**
- `~/.claude/skills/lecture-notes-to-cornell/SKILL.md` — Step 3 now mandates the 5-part enriched structure (Core Idea / Intuition / In Practice-Python / Pitfalls / Related Concepts) for all concept notes; Step 4 requires a "Going Deeper" callout in Cornell notes; removed `{COURSE_CODE}` from concept `related:` fields (concepts now stand alone, not tied to originating course)
- `raw/lecture-notes/README.md` — documents the enrichment standard for all future lecture batches

---

### 12-06-2026 (Follow-up #8)

**Lecture Processing: COMP838 Lecture 4 (CNNs and Object Detection)**

*Source:* raw/lecture-notes/COMP838/Lecture4.pdf ("Convolutional Neural Networks" — CNN internals, R-CNN family, SSD/YOLO)

**New concept pages (wiki/concepts/), all using the enriched 5-part structure:**
- [[Receptive Field, Stride, and Padding]] — output-size formula, worked examples, growth of receptive field with depth
- [[Softmax Function]] — logits → probability distribution, sigmoid vs. softmax, CrossEntropyLoss internals
- [[Intersection over Union (IoU)]] — bounding box overlap metric, NMS, anchor matching, torchvision code
- [[Anchor Boxes]] — predefined box templates, IoU-based matching, anchor generation code
- [[One-Stage vs Two-Stage Object Detection]] (type: comparison) — R-CNN family vs. YOLO/SSD framing
- [[R-CNN Family]] — R-CNN → Fast R-CNN → Faster R-CNN evolution, what each version fixed, speed comparison table
- [[YOLO (You Only Look Once)]] — v1-v4 evolution (grid cells → anchors → multi-scale → backbone/neck/head), Ultralytics code
- [[SSD (Single Shot MultiBox Detector)]] — multi-scale default boxes, torchvision code

**Existing page expanded:**
- [[Neural Network Training Workflow]] — added "Epoch vs. Batch vs. Iteration" terminology section + learning rate scheduling note

New course note: `wiki/courses/COMP838/Lecture-4-cnn-and-object-detection.md`

**Research Performed (via firecrawl):** receptive field/output-size formula (D2L, Distill), softmax/cross-entropy (GeeksforGeeks), IoU (SuperAnnotate, Stanford GIoU), R-CNN family evolution (Faster R-CNN paper, overview), YOLO v1-v4 evolution (Kaggle overview) — all ✓ verified.

**Explicitly excluded from Lecture 4** (per Completed Course Mode): MATLAB-specific YOLOv2/v3/v4 doc links (kept the underlying architecture concepts), "Questions?" slides.

**Pages Updated:**
- `wiki/index.md` — added 8 new concept pages, updated Courses entry (Lectures 1-4)
- `wiki/courses/COMP838/index.md` — added Lecture 4, expanded topic areas and related concept list

**Note:** This lecture's content (R-CNN family, YOLO evolution, anchor boxes, IoU) directly underlies the YOLOv4 + transfer learning approach in [[Deep Learning Assignment]] (kiwifruit ripeness classification).

---

### 12-06-2026 (Follow-up #9)

**Lecture Processing: COMP838 Lecture 5 (Deep Neural Networks — DenseNets, ResNets, Pretrained CNNs)**

*Source:* raw/lecture-notes/COMP838/Lecture5.pdf ("Deep Neural Networks" — CVPR/Marr Prize award survey, DenseNet/ResNet, MATLAB pretrained DNNs)

**New concept pages (wiki/concepts/), all using the enriched 5-part structure:**
- [[Densely Connected Convolutional Network (DenseNet)]] — dense block concatenation, growth rate, transition layers, PyTorch DenseBlock implementation
- [[Residual Networks (ResNet)]] — degradation problem, residual learning `F(x)+x`, identity vs. projection shortcuts, PyTorch ResidualBlock
- [[AlexNet]] — 8-layer ILSVRC 2012 winner, ReLU/dropout/overlapping pooling, 227x227 input
- [[VGG (VGG-16 / VGG-19)]] — depth via stacked 3x3 convolutions, link to receptive field formula
- [[GoogLeNet and the Inception Architecture]] — Inception modules (parallel 1x1/3x3/5x5 + pooling), 1x1 bottlenecks, GoogLeNet vs. Inception-v3 (224 vs 299 input)

New course notes:
- `wiki/courses/COMP838/Lecture-5.1-densenets-and-resnets.md` — DenseNet vs. ResNet, plus condensed context on the CVPR Best Paper / Marr Prize award survey (only architectures relevant to this course's content kept; passing references to Swin Transformer, SinGAN, etc. noted as future-topic pointers, no concept pages created for those)
- `wiki/courses/COMP838/Lecture-5.2-pretrained-cnn-architectures.md` — AlexNet/VGG-19/GoogLeNet/Inception-v3 survey, generalised the MATLAB-specific classification workflow into a framework-agnostic 5-step process, and the bell-pepper demo comparison

**Research Performed (via firecrawl):** DenseNet architecture/advantages (arXiv 1608.06993, GeeksforGeeks), ResNet degradation problem/residual learning (GeeksforGeeks, arXiv 2405.01725), AlexNet architecture (Wikipedia, GeeksforGeeks, MathWorks), VGG-19 (arXiv 1409.1556, GeeksforGeeks, MathWorks), GoogLeNet/Inception-v3 (GeeksforGeeks, ScienceDirect, CVPR 2016 paper, MathWorks) — all ✓ verified.

**Explicitly excluded from Lecture 5** (per Completed Course Mode): MATLAB-specific menu/function walkthroughs for AlexNet classification (generalised into a framework-agnostic workflow instead); most individual entries in the CVPR/Marr Prize award list beyond DenseNet, ResNet, and Mask R-CNN (passing bibliography references, not load-bearing concepts for this course).

**Pages Updated:**
- `wiki/index.md` — added 5 new concept pages, updated Courses entry (Lectures 1-5)
- `wiki/courses/COMP838/index.md` — added Lecture 5.1/5.2, expanded topic areas and related concept list

---

### 12-06-2026 (Follow-up #10)

**Lecture Processing: COMP838 Lecture 7 (RNNs/LSTM Recap, Time Series Forecasting, Transformers, Vision Transformer)**

*Source:* raw/lecture-notes/COMP838/Lecture7.pdf ("RNNs and Time Series Analysis" — time series regression, RNN/LSTM recap, MATLAB LSTM forecasting/classification, intro to Transformers and MATLAB ViT)

*Note:* Lecture 6 ("Robotic Vision: From Deep Learning to Autonomous Systems") skipped per Aryan's instruction — AI roadmap survey and lecturer's own research projects (swimmer recognition, table tennis analysis), no durable concepts.

**New concept pages (wiki/concepts/), using the enriched 5-part structure:**
- [[Long Short-Term Memory (LSTM)]] — gated memory cell (input/forget/output gates + cell state), fixes RNN vanishing/exploding gradients, PyTorch LSTM forecaster example
- [[Transformer (Attention Is All You Need)]] — self-attention replacing recurrence, parallel sequence processing, positional encodings, PyTorch `nn.MultiheadAttention` example
- [[Vision Transformer (ViT)]] — images as sequences of patch tokens through a Transformer encoder, PyTorch patchify example via strided Conv2d

New course notes:
- `wiki/courses/COMP838/Lecture-7.1-rnns-lstm-and-time-series-forecasting.md` — time series regression definition, RNN unfolded notation recap, LSTM gating mechanism and its motivation for time series forecasting
- `wiki/courses/COMP838/Lecture-7.2-transformers-and-vision-transformers.md` — Transformer intro (2017, replacing RNNs/LSTM via attention), ViT intro via MATLAB training walkthrough

**Research Performed (via firecrawl):** LSTM architecture/gates (IBM, colah's blog, d2l.ai, Hochreiter & Schmidhuber 1997), Transformer/self-attention (arXiv 1706.03762, Wikipedia), Vision Transformer (arXiv 2010.11929, Wikipedia, d2l.ai), time series regression/autoregressive models (Wikipedia, MathWorks) — all ✓ verified.

**Flagged & Corrected:** Lecture's description of LSTM as having "four gates: input gate, cell, forget gate, output gate" — corrected to 3 gates (input, forget, output) operating on a separate cell state, per colah's blog and IBM.

**Pages Updated:**
- `wiki/index.md` — added 3 new concept pages, updated Courses entry (Lectures 1-5, 7)
- `wiki/courses/COMP838/index.md` — added Lecture 7.1/7.2, expanded sources/topic areas and related concept list

---

### 12-06-2026 (Follow-up #11)

**Lecture Processing: COMP838 Lecture 8 (Generative Adversarial Networks and Reinforcement Learning)**

*Source:* raw/lecture-notes/COMP838/Lecture8.pdf ("GAN and Reinforcement Learning" — GAN minimax framework + MATLAB GAN architecture/loss functions, MATLAB Reinforcement Learning agent/environment/policy and 7-step workflow)

**New concept pages (wiki/concepts/), using the enriched 5-part structure:**
- [[Generative Adversarial Network (GAN)]] — generator/discriminator minimax game, counterfeiter/police analogy, MATLAB GAN loss functions (L_G, L_D), PyTorch training-step example
- [[Reinforcement Learning (RL)]] — agent-environment loop (policy + learning algorithm), 7-step RL workflow, PyTorch-free minimal agent-environment example

New course notes:
- `wiki/courses/COMP838/Lecture-8.1-generative-adversarial-networks.md` — GAN minimax framing, simple-model training (MLPs + backprop + dropout), MATLAB GAN architecture and loss functions
- `wiki/courses/COMP838/Lecture-8.2-reinforcement-learning.md` — agent/environment/policy/reward definitions, 7-step RL workflow, grid-world (Q-learning) and pendulum (DDPG) examples

**Research Performed (via firecrawl):** GAN minimax game and architecture (Wikipedia, MathWorks GAN example, Goodfellow et al. 2014), reinforcement learning agent/policy/reward (MathWorks RL docs, Wikipedia, OpenAI Spinning Up) — all ✓ verified.

**Pages Updated:**
- `wiki/index.md` — added 2 new concept pages, updated Courses entry (Lectures 1-5, 7-8)
- `wiki/courses/COMP838/index.md` — added Lecture 8.1/8.2, expanded sources/topic areas and related concept list

---

### 12-06-2026 (Follow-up #12)

**Lecture Processing: COMP838 Lecture 9 (Transfer Learning and Ensemble Learning)**

*Source:* raw/lecture-notes/COMP838/Lecture9.pdf ("Transfer Learning & Ensemble Learning" — Pan & Yang transfer learning taxonomy + MATLAB transfer learning workflow, Alpaydin ensemble learning framework + MATLAB ensemble workflow)

**New concept pages (wiki/concepts/), using the enriched 5-part structure:**
- [[Transfer Learning]] — general definition, Pan & Yang's inductive/transductive/unsupervised categories and 4 "what to transfer" approaches, PyTorch fine-tuning example. Cross-linked with the existing project-specific [[Transfer Learning and YOLO for Classification]] page (added "Transfer Learning" to its `related:` field).
- [[Ensemble Learning]] — diversity-generation methods, combining-function notation (`y = f(d1...dL|Φ)`, `argmax`), global/local and serial/cascading combination, scikit-learn `VotingClassifier` example

New course notes:
- `wiki/courses/COMP838/Lecture-9.1-transfer-learning.md` — transfer learning definition, categories/approaches table, MATLAB workflow, recap of AlexNet/VGG-16/VGG-19/GoogLeNet layer counts from Lecture 5.2
- `wiki/courses/COMP838/Lecture-9.2-ensemble-learning.md` — why ensembles work, diversity-generation methods, combination strategies and notation, MATLAB ensemble workflow

**Research Performed (via firecrawl):** Transfer learning definitions and taxonomy (IBM, Pan & Yang 2010 survey), ensemble learning / bagging / boosting (GeeksforGeeks, IBM) — all ✓ verified.

**Pages Updated:**
- `wiki/index.md` — added 2 new concept pages, updated Courses entry (Lectures 1-5, 7-9)
- `wiki/courses/COMP838/index.md` — added Lecture 9.1/9.2, expanded sources/topic areas and related concept list

---

### 12-06-2026 (Follow-up #13)

**Lecture Processing: COMP838 Lecture 10 (Parallel and Cloud Computing for Deep Learning)**

*Source:* raw/lecture-notes/COMP838/Lecture10.pdf ("Deep Learning Computing" — MATLAB parallel/multi-GPU training, GPU basics, batch size/learning rate scaling, MATLAB cloud computing, Google Colab, federated learning passing mention)

**New concept page (wiki/concepts/), using the enriched 5-part structure:**
- [[Distributed Training of Deep Neural Networks (Data Parallelism)]] — data parallelism across GPUs, the linear scaling rule linking batch size and learning rate (Goyal et al. 2017), PyTorch `DataParallel` example, federated learning as a contrasting privacy-preserving pattern

New course note:
- `wiki/courses/COMP838/Lecture-10.1-parallel-and-cloud-computing-for-deep-learning.md` — combined both lecture subtopics (parallel computing, cloud computing) into one note given thin/tool-walkthrough-heavy source content; covers GPU basics, multi-GPU batch size/LR scaling, cloud training workflow, Google Colab, and federated learning (supplemented)

**Research Performed (via firecrawl):** Data parallelism / multi-GPU training and batch size-learning rate scaling (Dive into Deep Learning, Goyal et al. 2017 "Accurate, Large Minibatch SGD") — ✓ verified.

**Explicitly excluded from Lecture 10** (per Completed Course Mode): GPU 101 definition (too basic/general to warrant its own concept page — folded into the distributed training note as context), Google Colab product walkthrough (tool-specific, summarised briefly in the Cornell note only, no dedicated concept page), MATLAB-specific "single experiment vs. multiple experiments in parallel" UI screenshots.

**Pages Updated:**
- `wiki/index.md` — added 1 new concept page, updated Courses entry (Lectures 1-5, 7-10)
- `wiki/courses/COMP838/index.md` — added Lecture 10.1, expanded sources/topic areas and related concept list

---

### 12-06-2026 (Follow-up #14)

**Lecture Processing: COMP723 Lectures 1-5 (Data Mining and Machine Learning)**

*Source:* raw/lecture-notes/COMP723/Lecture1.pptx through Lecture5.pptx ("Data Mining & Machine Learning", Parma Nand, AUT) — extracted via a Unicode-safe Python `zipfile`/XML script (writing to UTF-8 `.txt` files) to work around a `charmap` codec error on Windows.

*Course status:* COMP723 is an **in-progress** semester course (13-week structure visible in Lecture 1, mid-test in week 7, assignment due week 13) — processed with a moderate filter (excluded pure admin: staff contacts, timetables, assessment weightings; kept more contextual framing than COMP838's "Completed Course Mode").

**New course (wiki/courses/COMP723/):**
- index.md — course overview, topic areas, lecture index, related concept notes
- Lecture-1-introduction-to-data-mining-and-classification.md — data vs. knowledge, what is(n't) data mining, origins of data mining, classification (4 worked examples), structural descriptions, numeric prediction, recognising bias
- Lecture-2.1-kdd-framework-and-data-preprocessing.md — KDD 6-step framework, full preprocessing toolkit with lecture examples
- Lecture-2.2-evaluation-and-data-mining-tasks.md — confusion matrix (Model A vs. B), association rule discovery, clustering, numeric prediction recap
- Lecture-3-naive-bayes-and-decision-trees.md — Naive Bayes (zero-frequency/Laplace, missing values, continuous data), decision trees (info gain, Outlook example), under/overfitting in trees, Pandas/NumPy/scikit-learn lab tools (Cornell-only, no concept page)
- Lecture-4.1-k-nearest-neighbours.md — instance-based classifiers, k-NN algorithm, choosing k and scaling, lazy vs. eager learning
- Lecture-4.2-ensemble-learning-and-evaluation.md — bias-variance trade-off, ensemble motivation (25-classifier example), bagging/boosting/AdaBoost, train/val/test recap, cross-validation, ROC/AUC
- Lecture-5.1-ann-fundamentals-and-the-perceptron.md — ANN architectures overview, biological inspiration, mathematical neuron, McCulloch-Pitts neurons, weight matrices, the Perceptron and Perceptron Learning Rule, gradient descent/SSE
- Lecture-5.2-training-mlps-strengths-and-weaknesses.md — Perceptron model, AND/OR/XNOR worked examples with weights, Softmax, general weight-update algorithm, MLP parameters, NN strengths/weaknesses vs. Decision Trees/Naive Bayes, Diabetes overfitting example

**New concept pages (wiki/concepts/), 5-part enriched structure:**
- [[Classification (Supervised Learning)]] — training/test sets, structural descriptions, 4 worked examples (credit risk, fraud, churn, sky survey)
- [[Linear Regression and Numeric Prediction]] — worked mpg formula, RMSE/R², pitfalls
- [[Bias in Machine Learning (Algorithm Bias vs. Data Bias)]] — algorithm/inductive bias vs. data bias, credit scoring example
- [[Knowledge Discovery (KDD) Process]] — 6-step loop (Define → Collect → Mine → Validate → Deploy → Monitor), mapped to modern ML tooling
- [[Data Preprocessing and Data Quality]] — noise/missing values/duplicates/outliers, normalization, balancing, feature selection (forward/backward)
- [[Naive Bayes Classifier]] — Bayes theorem + conditional independence, credit-risk worked example, Laplace correction, missing values, Gaussian NB
- [[Decision Trees and Information Gain]] — entropy/info gain formulas, Outlook worked example, post-pruning, sklearn `DecisionTreeClassifier`
- [[K-Nearest Neighbors (KNN)]] — instance-based lazy learning, choosing k as a bias-variance dial, scaling, nominal distance
- [[Bias-Variance Tradeoff]] — bias/variance definitions, dartboard intuition, link to ensembles and Lecture 1's algorithm bias
- [[Cross-Validation]] — k-fold/stratified k-fold, rotating-exam-groups intuition, sklearn `cross_val_score`

**Existing pages supplemented (overlap with COMP838 — linked rather than duplicated):**
- [[Ensemble Learning]] — added "Bagging and Boosting in Detail" section (bootstrap sampling formula, bagging/boosting algorithms, AdaBoost, sklearn code)
- [[Artificial Neural Networks (ANN)]] — added "Networks of McCulloch-Pitts Neurons, Weight Matrices, and the Perceptron" section (2-layer worked example, weight matrices, Perceptron Learning Rule, gradient descent/SSE, linear separability)
- [[Neural Network Training Workflow]] — added "Choosing MLP Hyperparameters" section (hidden-neuron rule of thumb `(attributes+classes)/2`, momentum)
- [[Overfitting and Underfitting]] — added Diabetes-dataset MLP worked example (300 vs. 100 hidden neurons)

**Deliberately not made into concept pages:** Association Rule Discovery, Clustering (one-slide topics, linked to existing [[Self-Organizing Map (SOM)]] instead), Pandas/NumPy/scikit-learn lab tooling (Lecture 3, kept Cornell-only).

**Research Performed (via firecrawl):** train/test sets and supervised learning (Wikipedia, IBM), linear regression (MLU-Explain, GeeksforGeeks), data bias (IBM, Mitchell 1997), KDD process (GeeksforGeeks, Data Science PM), data preprocessing (scikit-learn docs, Encord), Naive Bayes (Wikipedia, CMU), decision trees (Towards Data Science, CodeX), KNN (GeeksforGeeks, Pinecone), bias-variance trade-off (IBM, GeeksforGeeks), cross-validation (Machine Learning Mastery, GeeksforGeeks), AdaBoost (Wikipedia) — all ✓ verified.

**Pages Updated:**
- `wiki/index.md` — added 10 new concept pages, added COMP723 entry under Courses (in progress)

---

### 13-06-2026 (Follow-up #15)

**Lecture Processing: COMP723 Lectures 6, 8-11 (Unstructured Data Mining — Text/Speech)**

*Source:* raw/lecture-notes/COMP723/Lecture6.pptx, Lecture8.pptx, Lecture9.pptx, Lecture10.pptx, Lecture11.pptx (no Lecture7 — "the second 5 weeks" of the course) — extracted via the same Unicode-safe Python `zipfile`/XML script used for Lectures 1-5 (writes UTF-8 `.txt` files, then deleted). This completes COMP723's lecture-note processing — course marked **"notes complete"**.

**New course notes (wiki/courses/COMP723/):**
- Lecture-6.1-clustering-and-k-means.md — clustering as unsupervised learning, K-means algorithm (Initialize/Alternate/Stop), K=2 convergence walkthrough, distance measure properties
- Lecture-6.2-sound-and-speech-processing.md — audio formats, librosa, spectrograms/MFCC, ASR vocabulary (Cornell-only, survey-level, no new concept page)
- Lecture-8.1-text-mining-fundamentals-and-preprocessing.md — why text mining is hard (ambiguity/subtlety), text mining process flow vs. KDD, tokenization (token/type/term, AUT example), stop words, normalization, lemmatization vs. stemming, Porter's Algorithm
- Lecture-8.2-ner-relation-extraction-preview-and-evaluation.md — coreference/relation/event extraction preview, NLP feature types, classification scheme forms, Sensitivity/Specificity/Fβ recap, Penn Treebank/POS tagging, syntactic ambiguity exercise
- Lecture-9.1-text-classification-and-feature-engineering.md — text classification framings (binary/multi-class/multi-label), genre dependence, bag-of-words, feature subset selection vs. construction, MI(National) and TF-IDF(cat) worked exercises, baseline evaluation
- Lecture-9.2-word-embeddings-word2vec-and-glove.md — one-hot limitations, distributional hypothesis, CBOW vs. Skip-gram, "quick brown fox" worked Skip-gram example, embedding matrix as lookup table, GloVe
- Lecture-10.1-from-rnn-to-attention.md — RNN language models, shared weights/hidden state, truncated backpropagation fix for vanishing gradients, encoder-decoder/conditional language model, teacher forcing, greedy vs. beam search, motivation for attention
- Lecture-10.2-self-attention-and-the-full-transformer-architecture.md — self-attention properties, Query/Key/Value, trainable M_q/M_k/M_v matrices, multi-head attention (8 heads), normalisation methods, sine/cosine positional encoding, decoder, transfer learning
- Lecture-11-relation-extraction.md — relations/triples/RDF/OWL/DBpedia/SPARQL, taxonomic relations (IS-A, instance-of, co-hyponym, meronym), Hearst's IS-A patterns, ACE relation types, hand-written patterns vs. supervised ML (word/NE-type/gazetteer features, P/R/F1) vs. bootstrapping (Hearst 1992, Mark Twain/Elmira example)

**New concept pages (wiki/concepts/), 5-part enriched structure:**
- [[K-Means Clustering]] — K-means algorithm, K=2 walkthrough, distance measure properties, initialization pitfalls, scikit-learn `KMeans` + Elbow Method
- [[NLP Text Preprocessing Pipeline]] — ambiguity types, text mining process flow, tokenization (token/type/term), stop words, normalization, case folding, lemmatization vs. stemming, Porter's Algorithm, NLTK example
- [[TF-IDF and Feature Selection for Text]] — bag-of-words/vector-space classification, feature subset selection vs. construction, Mutual Information formula, TF-IDF formula + worked examples, `TfidfVectorizer`
- [[Word Embeddings (Word2Vec and GloVe)]] — one-hot limitations, distributional hypothesis, CBOW/Skip-gram, "quick brown fox" worked example, embedding matrix as lookup table, GloVe (Stanford dimensions/corpora)
- [[Named Entity Recognition and Relation Extraction]] — relations/triples/RDF/OWL/DBpedia, coreference, taxonomic relations, Hearst's IS-A patterns, hand-written/supervised/bootstrapped relation extraction with all lecture worked examples

**Existing pages supplemented (overlap with prior COMP723/COMP838 work — linked rather than duplicated):**
- [[Confusion Matrix Metrics]] — added "Sensitivity, Specificity, and the General F-measure (Fβ)" section (Sensitivity=Recall, Specificity=TNR=1-FPR, general Fβ formula, 250/750-document worked exercise)
- [[Recurrent Neural Networks (RNN)]] — added "RNN Language Models and Truncated Backpropagation" section (predict-next-word framing, shared weight matrix/hidden state, multi-layer RNNs, truncated BPTT as a practical vanishing-gradient fix, why RNNs struggle with seq2seq)
- [[Transformer (Attention Is All You Need)]] — added 5 new sections: "From Seq2Seq to Encoder-Decoder" (conditional language model, teacher forcing, masked attention, greedy/beam search), "Self-Attention Mechanics: Query, Key, and Value" (M_q/M_k/M_v trainable matrices), "Multi-Head Attention and Normalisation" (8 heads, dot-product/scaled-dot-product/kernel normalisation), "Positional Encoding" (sine/cosine), "The Decoder", and "Transfer Learning"

**Deliberately not made into concept pages:** Lecture 6.2's sound/speech processing (survey-level/applied — audio formats, librosa, MFCC, ASR — kept Cornell-only, consistent with prior "lab tooling stays Cornell-only" precedent); Lecture 9/10/11 demo slides (applied/lab content, noted but not expanded).

**Research Performed (via firecrawl):** K-means clustering (GeeksforGeeks, IBM), text preprocessing and Porter stemming (GeeksforGeeks, Porter's algorithm page), TF-IDF (GeeksforGeeks, Wikipedia), Word2Vec Skip-gram/CBOW (Medium — Ria Kulshrestha) and GloVe (Stanford NLP project page), Precision/Recall for the Sensitivity/Specificity supplement (Wikipedia), Hearst patterns (Medium — Prakhar Mishra) and DBpedia/RDF (DBpedia Technology Tutorial) — all ✓ verified.

**Pages Updated:**
- `wiki/index.md` — added 5 new concept pages under Concepts, updated COMP723 entry under Courses to "notes complete" (Lectures 1-6, 8-11), bumped Last Updated to 13-06-2026
- `wiki/courses/COMP723/index.md` — marked course "notes complete", expanded Topic Areas, added Lectures 6.1/6.2/8.1/8.2/9.1/9.2/10.1/10.2/11 to Notes by Lecture, expanded sources/related concept list

---

### 14-06-2026

**New Project Page: EMG-Based Muscle Fatigue Monitoring (FYP) + EMG Concept Correction**

*Trigger:* Aryan asked why the final-year project (group FYP, EMG muscle-fatigue monitoring) had no presence in the vault — no project page, and an existing concept page still had a factual error from before the team's pivot to a public dataset.

**New Project Page:**
- [[EMG-Based Muscle Fatigue Monitoring (Final Year Project)]] — research question, team/roles (Maalav: data pipeline, Rayyan: ML classification/Product Owner, Aryan: insights layer + LSTM/Scrum Master), methodology evolution (OpenBCI rig → quality failure → Zenodo 14182446 pivot → 250 Hz bridge rule → validated RF/SVM/KNN pipeline), current LOSO results table (classical vs. LSTM), Aryan's LSTM sequence-classifier contribution (`aryan/lstm-sequence-classifier` branch), and open questions/next steps.

**Corrected:**
- [[EMG Signal Processing and Visualization]] — fixed a standing factual error: the Cyton sample rate was listed as "1000 Hz" (the OpenBCI GUI header's default label). Added a "Sample Rate Correction" section explaining the true rate is ~250 Hz, verified via the `Sample Index` wrap-counter (three independent methods agree), with the consequence that trusting the header made earlier MDF/MNF values 4x too high. Cross-linked to the new FYP project page (this correction underlies the project's "250 Hz bridge rule").

**Pages Updated:**
- `wiki/index.md` — added the FYP project page to Projects, bumped Last Updated to 14-06-2026

**Note:** The team's group-chat transcript (pasted earlier in conversation) was not archived to `raw/` — the conversation context containing it was compacted before this task ran. Re-paste it in a future session if you want it saved verbatim; the project page above was built from the repo's existing handover docs, supervisor brief, dataset-selection notes, and prior progress-report conversation in `raw/claude-exports/`.

---

### 14-06-2026 (Follow-up)

**Teams Chat Archived + FYP Project Page Updated**

*Trigger:* Aryan pasted a partial Teams group-chat export (18-05-2026 to 13-06-2026) covering supervisor directives, dataset-approval discussion, and hardware procurement — filling the gap noted above.

**New Raw Source:**
- `raw/teams-chats/final-year-project-teams-chat-may-jun-2026.md` — full chat transcript, frontmatter with date range and participants.

**Updated:**
- [[EMG-Based Muscle Fatigue Monitoring (Final Year Project)]] — added a "Supervisor Directives" section (public-dataset use explicitly approved, "this break = LSTM, next semester = Transformer" roadmap confirmed, new supervisor-assigned task to find/label time windows where all 8 EMG channels move similarly and apply MATLAB-style deep-learning forecasting to those windows, elastic-strap hardware fix in progress). Added the new task and hardware fix to Open Questions/Next Steps, added the new raw file to `sources`, and linked [[Transformer (Attention Is All You Need)]] in `related`.

---

### 16-06-2026

**New Course Added: Kaggle x Google 5-Day AI Agents Course (Day 1)**

*Trigger:* Aryan is doing the Kaggle x Google "5-Day AI Agents: Intensive Vibe Coding Course" and pasted the Day 1 podcast transcript, then asked for the companion whitepaper to be fetched and summarized, then asked for both to be archived in the second brain with a folder per day. Chose light-summary mode (no concept pages, no deep research) over full Cornell processing.

**New Raw Sources:**
- `raw/lecture-notes/KAGGLE-VIBE-CODING/Day-1/podcast-transcript.md` — full Day 1 podcast transcript
- `raw/lecture-notes/KAGGLE-VIBE-CODING/Day-1/whitepaper-the-new-sdlc-with-vibe-coding.pdf` — Day 1 whitepaper, downloaded via gstack browse from the Kaggle page's embedded Google Drive viewer

**New Pages:**
- [[5-Day AI Agents - Intensive Vibe Coding Course With Google (Kaggle)]] — course index, lists Days 1-5 (Day 1 done, 2-5 pending)
- [Day 1 - The New SDLC With Vibe Coding](courses/KAGGLE-VIBE-CODING/Day-1/index.md) — light summary covering vibe coding vs. agentic engineering, the six types of context + static/dynamic split + context rot, how AI reshapes each SDLC phase, the factory model and Agent = Model + Harness, conductor/orchestrator modes, the 80% problem, and the CapEx/OpEx token economy

**Pages Updated:**
- `wiki/index.md` — added the course to the Courses section

**Structure:** Created `Day-1` through `Day-5` folders under both `raw/lecture-notes/KAGGLE-VIBE-CODING/` and `wiki/courses/KAGGLE-VIBE-CODING/` so future days drop in with the same layout.

---

### 17-06-2026

**Course Day Processed: Kaggle x Google 5-Day AI Agents — Day 2 (Agent Tools and Interoperability)**

*Source:* raw/articles/kaggle-google-5day-agents-day2-podcast-transcript.md (podcast transcript for Day 2 whitepaper; whitepaper URL: https://www.kaggle.com/whitepaper-agent-tools-and-interoperability)

**New Pages:**
- [Day 2 - Agent Tools and Interoperability](courses/KAGGLE-VIBE-CODING/Day-2/index.md) — light summary covering the full interoperability stack: MCP (N×M→O(N+M), transports, discovery/config/connection, security, RAG tool loading, debugging mindset), monolithic ceiling and bounded vs. unbounded domain distinction, A2A (agent cards, registries, AaaS), L402 microtransactions, A2UI (generative UI via declarative JSON, sheet music analogy, LLM generates UI vs Tool as Template, canvas), UCP + AP2 (mandate + handshake, cryptographic commerce guarantees)
- [[Model Context Protocol (MCP)]] — concept page; core idea, N×M problem intuition, stdio/SSE transports, discovery/configuration/connection workflow, RAG-based dynamic tool loading, common pitfalls (hardcoded keys, attention dilution, prompt-patching)
- [[Agent-to-Agent Protocol (A2A)]] — concept page; bounded vs. unbounded domain distinction, goto problem, agent cards and registries, AaaS monetization, L402 permissionless microtransactions with macaroon proof-of-payment, bounded vs. unbounded decision table

**Pages Updated:**
- wiki/courses/KAGGLE-VIBE-CODING/index.md — marked Day 2 done
- wiki/index.md — added 2 new concept pages, updated course entry (Days 1-2 done)

**Mode:** Light summary for the day note (matching Day 1 precedent). Created concept pages for MCP and A2A as genuinely new foundational protocols not yet covered in the wiki, which will recur across Days 3-5 and in future project work.

---

**Next Entry:** [Date] — [Change Type] — [Page] — [Summary]
