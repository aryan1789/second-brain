---
title: Word Embeddings (Word2Vec and GloVe)
type: concept
sources: [raw/lecture-notes/COMP723/Lecture9.pptx, https://medium.com/data-science/nlp-101-word2vec-skip-gram-and-cbow-93512ee24314, https://nlp.stanford.edu/projects/glove/]
related: [TF-IDF and Feature Selection for Text, Transformer (Attention Is All You Need), Recurrent Neural Networks (RNN)]
created: 13-06-2026
last-updated: 13-06-2026
---

# Word Embeddings (Word2Vec and GloVe)

> [!check] Verified
> Confirmed via [Ria Kulshrestha: NLP 101 — Word2Vec, Skip-gram and CBOW (Medium)](https://medium.com/data-science/nlp-101-word2vec-skip-gram-and-cbow-93512ee24314) and [Stanford NLP: GloVe — Global Vectors for Word Representation](https://nlp.stanford.edu/projects/glove/)

## The Core Idea

[[TF-IDF and Feature Selection for Text|TF-IDF and bag-of-words]] represent words as sparse counts with **no notion of meaning** — "cat" and "dog" are just two unrelated dimensions, exactly as unrelated as "cat" and "car". **Word embeddings** fix this: every word is mapped to a **dense vector in an n-dimensional space** such that **semantically similar words are mapped to nearby points** — we want "cat" and "dog" to be *close*, even though they're different words. This is **distance/similarity in embedding space** (e.g. Euclidean distance, or cosine distance/dot product).

## Why One-Hot Representations Aren't Enough

A **one-hot representation** encodes each word as a vector of all zeros except a single 1 (e.g. with a 10,000-word vocabulary, each word is a 1×10,000 vector). This has three problems:

1. **Vector size scales with vocabulary size** — wasteful, and contributes to the "curse of dimensionality."
2. **Tightly coupled to a fixed vocabulary** — adding/removing words effectively requires retraining.
3. **No semantic structure** — `Similarity(Mango, Strawberry) == Similarity(Mango, City) == 0`, when ideally `Similarity(Mango, Strawberry) >> Similarity(Mango, City)`.

## The Distributional Hypothesis

Word embeddings are built on the **distributional hypothesis**: *words that appear in the same context share semantic meaning*. If "cat" and "dog" both frequently appear near words like "pet", "vet", "bark/meow", "feed", they should end up with similar embedding vectors — without ever being told explicitly that they're both animals.

## Two Models: CBOW and Skip-gram

Both are neural architectures for *learning* word embeddings from raw text, using a sliding **context window**:

- **Continuous Bag of Words (CBOW)** — predicts the **target word** from its **context words**.
- **Skip-gram** — does the inverse: predicts the **context words** from the **target word**.

### Worked Skip-gram Example

For the sentence *"the quick brown fox jumped over the lazy dog"* with **window size 1**:

- **Focus word**: `quick`
- **Context words**: `the` and `brown` (one word to the left, one to the right)
- This generates **(input, output) training pairs**: `(quick, the), (quick, brown), (brown, quick), (brown, fox), ...`

The learning problem becomes: given an input word, **predict its context words** — i.e. predict which words are likely to appear nearby. CBOW applies the same principle in reverse (predict the centre word from its context).

## How Training Produces Embeddings

A neural network is **trained on these (input, output) pairs**, but the goal isn't the network's predictions themselves — it's the **learned weight matrix**. Once trained:

- The **weights become the embedding matrix** — a lookup table mapping each word (by its one-hot index) to its dense embedding vector.
- This is **unsupervised learning** (no human-provided labels — the "labels" are just neighbouring words from raw text), but it **doesn't use the neural network in the conventional sense**: the network's predictions are discarded, and only its internal weight matrix is kept as the embedding.

## GloVe: Global Vectors for Word Representation

**GloVe** (Stanford NLP) takes a different approach: instead of predicting context word-by-word (as Word2Vec's CBOW/Skip-gram do), GloVe is trained on **aggregated global word-word co-occurrence statistics** for a corpus — directly capturing how often words co-occur across the *entire* corpus, not just within local windows.

- Developed by Stanford as an **open-source project**, trained on **Wikipedia** (and other large corpora).
- Stanford provides **pre-trained vectors** at **25, 50, 100, 200, and 300 dimensions**, trained on corpora of **2, 6, 42, and 840 billion tokens** respectively — larger corpora and higher dimensions generally capture finer-grained semantic relationships, at the cost of larger model size.

## In Practice: Using Pre-trained Embeddings (Python)

```python
import gensim.downloader as api

# Load pre-trained Word2Vec embeddings (Google News, 300-dim)
model = api.load("word2vec-google-news-300")

print(model.similarity("cat", "dog"))    # high similarity
print(model.similarity("cat", "car"))    # low similarity

# Classic analogy: king - man + woman ≈ queen
print(model.most_similar(positive=["king", "woman"], negative=["man"], topn=1))
```

## Common Pitfalls & Practical Tips

- **Embeddings are static per word** — Word2Vec/GloVe give each word *one* vector regardless of context, so "bank" (river) and "bank" (finance) share the same embedding. This is exactly the **polysemy** problem from [[NLP Text Preprocessing Pipeline]], and is what motivates **contextual embeddings** from models like [[Transformer (Attention Is All You Need)|Transformers]] (e.g. BERT), where a word's vector depends on its surrounding sentence.
- **Choose embedding dimensionality based on corpus size** — using 300-dim embeddings on a tiny domain-specific corpus risks overfitting; smaller dimensions (25-50) may generalise better with limited data.
- **Pre-trained vs. trained-from-scratch** — pre-trained GloVe/Word2Vec embeddings (trained on huge general corpora like Wikipedia) capture broad semantics quickly, but may miss domain-specific vocabulary (e.g. medical or legal terms) — domain-specific corpora may need their own embeddings or fine-tuning.

## Related Concepts

- [[TF-IDF and Feature Selection for Text]] — the sparse, count-based alternative that word embeddings improve on for semantic similarity.
- [[Recurrent Neural Networks (RNN)]] — early sequence models that consumed word embeddings as input (Lecture 10).
- [[Transformer (Attention Is All You Need)]] — modern architectures that produce *contextual* embeddings, addressing the static-embedding limitation above.

**Source:** [Ria Kulshrestha: NLP 101 — Word2Vec, Skip-gram and CBOW (Medium)](https://medium.com/data-science/nlp-101-word2vec-skip-gram-and-cbow-93512ee24314); [Stanford NLP: GloVe — Global Vectors for Word Representation](https://nlp.stanford.edu/projects/glove/); COMP723 Lecture 9 (one-hot limitations, skip-gram worked example, embedding matrix as lookup table).
