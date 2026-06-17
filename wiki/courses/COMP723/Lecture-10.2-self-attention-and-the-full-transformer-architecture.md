---
title: COMP723 Lecture 10.2 - Self-Attention and the Full Transformer Architecture
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture10.pptx]
related: [COMP723, Transformer (Attention Is All You Need), Softmax Function, Recurrent Neural Networks (RNN)]
created: 13-06-2026
last-updated: 13-06-2026
---

# COMP723 Lecture 10.2 - Self-Attention and the Full Transformer Architecture

> [!tip] Going Deeper
> [[Transformer (Attention Is All You Need)]] has been supplemented with this lecture's self-attention mechanics (Query/Key/Value, trainable `M_q`/`M_k`/`M_v` matrices), multi-head attention, normalisation methods, positional encoding, the decoder, and transfer learning — all in full. This note covers slides 27-45, continuing from [[COMP723 Lecture 10.1 - From RNN to Attention|Lecture 10.1]]'s introduction of attention as the solution to RNN limitations.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **List the 3 properties of "raw" self-attention (before it's made trainable).**
- **Define Query, Key, and Value in your own words — what does each represent?**
- **How is self-attention made trainable? What are `M_q`, `M_k`, and `M_v`?**
- **Why does the Transformer use multi-head attention, and how many heads does "Attention Is All You Need" use?**
- **Name the 3 normalisation approaches for attention scores. Which one does the original paper use, and why?**
- **What 2 constraints must any positional encoding scheme satisfy? What functions does the original paper use?**
- **How does the decoder differ from the encoder in terms of what it can attend to, and how does this differ between training and testing?**
- **Give 3 examples of downstream NLP tasks that benefit from transfer learning via a pretrained Transformer.**

---

## Notes

### Self-Attention: The Starting Point

**Self-attention**, as introduced in "Attention Is All You Need", starts with **no trainable weights**:

- **Order has no influence** on the computation.
- **Proximity has no influence** — distant and nearby tokens are treated identically.
- **Shape independent** — works for any sequence length.

### Query, Key, Value

Three roles are introduced (still with nothing trainable at this stage):

- **Key** — a vector representation of (each element of) the sequence.
- **Query** — the word for which context is to be computed.
- **Value** — the Query vector multiplied against the sequence (its Keys), giving **adjusted weights (attention)** for each of the other words.

### Making It Trainable

To make self-attention learnable: if a vector `v` is `1 × k`, multiply it by a **`k × k` matrix**, giving a result that's still `1 × k`. **`M_k`, `M_q`, and `M_v`** are the **trainable matrices** — their weights are **updated as part of the training process**. This turns the Query/Key/Value computation from a fixed geometric operation into something the network can learn.

### Multi-Head Attention

To improve on a single attention computation ("Can we improve this?"), **multi-head attention** uses the **same Q/K/V mechanism but with different initial matrices** for each head. This **projects the input embeddings into different subspaces**, each representing a **different aspect** of the relationships between words (e.g. **co-references, subject, gender**) — expanding the model's ability to focus on different positions/relationships simultaneously. **"Attention Is All You Need" uses 8 heads.**

### Normalisation

Normalisation **scales attention weight numbers down to between 0 and 1**. Similarity can be computed in different ways:

- **Dot product, then softmaxed.**
- **Scaled dot product** — the score is **divided by the dimensionality of the embedding vector**, then softmaxed.
- **Kernel methods** — map Q and K vectors into another space via a **non-linear transformation** (e.g. a layer of neurons).

All of these ultimately rely on the [[Softmax Function]] to turn raw scores into a probability-like distribution over positions.

### Positional Encoding

Token positions must be **included** in the representation, with two constraints:

1. **Positional information can be encoded into the embedding vector.**
2. **The positional vector does not distort the final embedding vector.**

The Transformer paper uses **sine and cosine functions** for **even and odd positions**, with different **wavelengths**. The resulting positional output is **added to the embedding vector** to produce the final, position-aware embedding for each word.

### The Decoder

The **decoder** is the **second part** of the Transformer architecture: it uses the **same mechanism as the encoder**, but operates **one word at a time** (many-to-many). It attends to **all words from the encoder**, but only the **previous words in the decoded sentence so far**:

- **Training**: uses **all of the previous (ground-truth) words** — **teacher forcing**.
- **Testing**: uses the **previously generated word(s)** (the model's own output).

The lecture then shows **"the whole thing"** — the full encoder-decoder Transformer architecture, combining embeddings + positional encoding, multi-head self-attention, normalisation, and the decoder's masked self-attention plus encoder-attention.

### Transfer Learning

Most NLP (and other) tasks require **common knowledge about language** — **sentiment analysis, NER, question answering, machine translation, reasoning, NLG**, etc. This shared foundation is why **pretrained Transformers transfer well** across this whole range of downstream tasks.

### Demo Setup (Slide 45)

The lecture closes with a practical "NN and CNN setup tuning" note — a **multi-data, multi-algorithm tuning setup** using datasets `txt_sentoken`, `SMSSpamCollection.txt`, `imdb_labelled.txt`, `yelp_labelled.txt`, and `amazon_cells_labelled.txt` for the accompanying demo code (not covered further here — applied/lab content).

---

## Summary

This lecture completes the Transformer architecture introduced via attention in [[COMP723 Lecture 10.1 - From RNN to Attention|Lecture 10.1]]. **Self-attention** starts as an untrainable, order/proximity/shape-independent operation defined via **Query, Key, and Value** vectors, then becomes trainable via three **`k×k` matrices (`M_q`, `M_k`, `M_v`)**. **Multi-head attention** (8 heads in the original paper) runs several of these in parallel with different initial matrices, letting the model attend to different relational aspects (coreference, subject, gender) at once. Attention scores are **normalised** (dot product, scaled dot product, or kernel methods, all via [[Softmax Function|softmax]]) into 0-1 weights. **Positional encoding** (sine/cosine at different wavelengths, added to the embedding) restores the order information self-attention discards. The **decoder** mirrors the encoder but processes one word at a time, attending to all encoder outputs but only previously-decoded words (teacher forcing during training, self-generated words during testing). Finally, **transfer learning** explains why one pretrained Transformer can support sentiment analysis, NER, QA, MT, reasoning, and NLG alike. All of this is captured in full in [[Transformer (Attention Is All You Need)]].

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Self-attention properties, QKV, trainable matrices, multi-head attention, normalisation, positional encoding, decoder, transfer learning | [[Transformer (Attention Is All You Need)]] | ✓ Verified |
| Softmax as the normalisation step | [[Softmax Function]] | ✓ Verified |
| Attention as the solution to RNN limitations | [[Recurrent Neural Networks (RNN)]] | ✓ Verified |
