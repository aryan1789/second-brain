---
title: COMP838 Lecture 1 - Deep Learning Fundamentals
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture1.pdf]
related: [COMP838, Deep Learning, Convolutional Neural Networks (CNN), Recurrent Neural Networks (RNN)]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 1 - Deep Learning Fundamentals

> [!tip] Going Deeper
> The concept pages linked below ([[Deep Learning]], [[Convolutional Neural Networks (CNN)]], [[Recurrent Neural Networks (RNN)]]) have been expanded well beyond the lecture slides — each includes intuition/analogies, a working PyTorch code example, and common pitfalls. This lecture note stays as a Cornell-style summary; the concept pages are where the deeper understanding and practical application live.

## Cues & Questions

> Cover the Notes section and try to answer each cue from memory.

- **What is the formal definition of a "deep-learning architecture"?**
- **What two properties does each module in a deep architecture increase as data passes through?**
- **What four components make up "ConvNets = ? + ? + ? + ?"**
- **What does an RNN maintain across timesteps, and what does this let it do?**
- **In what sense can an RNN be viewed as "a very deep feedforward network"?**

---

## Notes

### What Is Deep Learning?

[[Deep Learning]] is defined (LeCun, Bengio & Hinton, 2015) as a **multilayer stack of simple modules**, most of which compute nonlinear input-output mappings. Each module transforms its input to increase both:

1. **Selectivity** — sensitivity to the specific, task-relevant patterns that matter
2. **Invariance** — insensitivity to irrelevant variations (lighting, angle, background, etc.)

The combined effect of stacking many such nonlinear layers is a system that can represent extremely intricate functions — precise where it needs to be, robust where it doesn't.

### Convolutional Neural Networks (CNNs)

> [!check] Verified
> Definition confirmed against LeCun, Bengio & Hinton (2015), Nature 521, 436-444.

The lecture gives a compact formula for [[Convolutional Neural Networks (CNN)|CNNs]]:

> ConvNets = Local Connections + Shared Weights + Pooling + Multilayers

This single line packs in four distinct architectural ideas (see the CNN concept note for the full breakdown of each). CNNs trace back to 1990 (LeCun & Bengio's handwritten digit recognition work) — well before the 2012 "deep learning boom," making them one of the oldest architectures still in widespread modern use.

### Recurrent Neural Networks (RNNs)

[[Recurrent Neural Networks (RNN)|RNNs]] process an input **sequence**, maintaining a hidden state that implicitly summarises everything seen so far. Two framings worth holding onto:

- **RNNs as very deep feedforward networks** — every "layer" is actually a timestep, and all timesteps share the same weights. This is the temporal analogue of CNNs sharing weights across spatial locations.
- **RNNs and symbolic computation** — RNNs connect to Turing machines, finite state machines (FSMs), and memory networks, framing sequence models as a bridge toward tasks that need reasoning and symbol manipulation, not just pattern recognition.

---

## Summary

This lecture establishes the conceptual vocabulary for deep learning: it's framed as stacked nonlinear modules that trade off selectivity and invariance. CNNs are defined by four architectural ingredients (local connections, shared weights, pooling, multilayers) and are among the oldest deep architectures still in use. RNNs extend the "shared weights" idea across time rather than space, with hidden state acting as memory, and connect conceptually to symbolic/sequential reasoning.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Deep Learning definition (multilayer stack, selectivity/invariance) | [LeCun, Bengio & Hinton (2015), Nature 521, 436-444](https://doi.org/10.1038/nature14539) | ✓ Verified |
| ConvNets = Local Connections + Shared Weights + Pooling + Multilayers | [LeCun, Bengio & Hinton (2015), Nature 521, 436-444](https://doi.org/10.1038/nature14539) | ✓ Verified |
| RNN definition (sequence processing, shared weights, hidden state) | [LeCun, Bengio & Hinton (2015), Nature 521, 436-444](https://doi.org/10.1038/nature14539) | ✓ Verified |
| CNN origins (1990, LeCun & Bengio handwritten digit recognition) | Lecture citation: LeCun & Bengio (1990), *Handwritten digit recognition with a back-propagation network*, NIPS, pp. 396-404 | ➕ Cited in lecture, not independently re-verified |
