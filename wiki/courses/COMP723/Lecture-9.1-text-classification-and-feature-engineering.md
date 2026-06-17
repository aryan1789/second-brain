---
title: COMP723 Lecture 9.1 - Text Classification and Feature Engineering
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture9.pptx]
related: [COMP723, TF-IDF and Feature Selection for Text, NLP Text Preprocessing Pipeline, Overfitting and Underfitting, Cross-Validation]
created: 13-06-2026
last-updated: 13-06-2026
---

# COMP723 Lecture 9.1 - Text Classification and Feature Engineering

> [!tip] Going Deeper
> [[TF-IDF and Feature Selection for Text]] is a new concept page covering bag-of-words, feature subset selection vs. construction, Mutual Information, TF-IDF (with worked examples), and classifier evaluation in full. This note summarises the lecture's framing of slides 1-20.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **List 5 "generic NLP problems" that can be framed as text classification.**
- **Contrast binary, multi-class, and multi-label classification, with an example of each from the lecture.**
- **What does "highly genre dependent" mean for text classification, and why does it matter for feature selection?**
- **Describe the bag-of-words model. What are the dimensions of the resulting term-document matrix?**
- **List 3 alternative document representations beyond bag-of-words.**
- **What are the two main feature engineering strategies, and how do they differ?**
- **Work through the lecture's MI(National) exercise — what do the numbers A, B, C, D, N represent here?**
- **Work through the lecture's TF-IDF(cat) exercise for a 20,000-document corpus.**
- **Why is a "baseline" essential when evaluating a text classifier?**

---

## Notes

### NLP Problems as Text Classification

Many core NLP tasks can be reframed as **generic text classification** problems: **language identification**, **word sense disambiguation**, **Named Entity Recognition**, **POS tagging**, **NP chunking**, and **text categorization** (by topic, genre, or author). Framing them this way means the same vectorisation/classification machinery (this lecture's focus) applies across all of them.

### Three Classification Setups

- **Binary** (simplest) — only two classes, e.g. "relevant" vs. "non-relevant" in IR, "spam" vs. "legitimate" in spam filters.
- **Multi-class** — e.g. routing a service-hotline email to one of ten customer representatives. Can be reduced to binary tasks via a **"one against the rest"** strategy.
- **Multi-label** — e.g. semantic topic identifiers for indexing news articles, where an article can belong to **one, many, or no** categories. Can also be split into a set of binary classification tasks.

### Highly Genre Dependent

**Genre** = the type or style of a text (newspaper, novel, magazine, inter-office memo, love letter, legal document, scientific paper, personal home page, FAQ, biomedical text, micro-blog/tweet, etc.) — genre depends on **what the text is like**, not where it comes from. Because classification performance is highly genre-dependent, you need to **choose a feature set appropriate to the genre** at hand.

### Bag of Words

A document `C` is represented as a **Bag of Words**: word ordering is assumed irrelevant, and only the **frequency of each word in the document** is recorded. This ensures every document is represented by a **vector of fixed dimensionality**, where each component is the value (e.g. term frequency, TF) of one attribute (term). A corpus of `n` documents and `m` terms becomes an `m × n` **term-document matrix** (`w_ij` = weight of term `i` in document `j`). See [[TF-IDF and Feature Selection for Text]] for the full vector-space framing.

### Alternative Document Representations

More sophisticated representations than bag-of-words "have shown some improvements, but not significant":

- **One-hot representation** — a simplified, binary form of word frequency.
- **Multi-word level** — syntactic phrase indexing (e.g. `adjective-noun` noun phrases) and co-occurrence patterns (e.g. `"speed limit"` as a single unit).
- **Semantic level** — **Latent Semantic Indexing (LSI)**, which automatically generates semantic categories from a bag-of-words representation.

### Feature Selection / Engineering

Goal: **remove irrelevant or inappropriate attributes** from the representation, for protection against [[Overfitting and Underfitting|over-fitting]] and increased computational efficiency with fewer dimensions. Two strategies:

- **Feature subset selection** — use a subset of the original features. Techniques: **stopword removal**, **document frequency thresholding**, **Mutual Information**, **chi-squared test (χ²)**. Ideally, a good learning algorithm should detect irrelevant features as part of learning anyway.
- **Feature construction** — build new features by combining original ones, aiming to represent most of the original information while **minimising the number of attributes**. Techniques: **stemming**, **thesauri** (group words into semantic equivalence classes, e.g. synonyms), **Latent Semantic Indexing** (words used in similar contexts tend to have similar meanings), **term clustering** (cluster tokens into clusters representing categories/topics).

### Mutual Information — Worked Exercise

**MI(t,c) = log( A·N / ((A+C)(A+B)) )**, where `A` = times `t` occurs in `c`, `B` = times `t` occurs outside `c`, `C` = documents in `c` where `t` occurs, `D` = documents outside `c` where `t` occurs, `N` = total documents.

**Exercise**: Calculate `MI(National)` given: 100 documents total; "National" occurs **47 times** in articles related to the National Party (`A=47`); occurs **23 times** in articles not related (`B=23`); occurs in **33 articles** which are related (`C=33`); occurs in **11 articles** which are not related (`D=11`).

```
MI(National, NationalParty) = log( A·N / ((A+C)(A+B)) )
                             = log( 47×100 / ((47+33)(47+23)) )
                             = log( 4700 / (80×70) )
                             = log( 4700 / 5600 )
                             = log(0.8393)
                             ≈ -0.25 bits   (using log base 2)
```

A negative MI here would indicate **complementary distribution** between "National" and the National Party category — applying the formula exactly as given on the slide. See [[TF-IDF and Feature Selection for Text]] for the general formula and interpretation of MI > 0 / = 0 / < 0.

### TF-IDF — Worked Exercise

**Exercise**: Consider a corpus of **20,000 documents**. The word "cat" appears **500 times across 1,000 documents**. Calculate TF-IDF for "cat".

```
IDF(cat) = log(N / df(cat)) = log(20000 / 1000) = log(20) ≈ 1.30
TF-IDF(cat, d) = TF(cat, d) × 1.30
```

`TF(cat, d)` depends on the specific document `d` being scored (its length and how many times "cat" appears in it) — the IDF component (`≈1.30`) is fixed for the whole corpus. See [[TF-IDF and Feature Selection for Text]] for the full TF-IDF formula, the "cat in a 3-document corpus" worked example, and the `TfidfVectorizer` code.

### Vector-Space Classifiers and Evaluation

Vector-space classification is fundamentally **binary** — a classifier separates the space into two regions — so **m-ary (multi-class)** problems either need a classifier that natively supports multiple classes, or a way to **combine binary classifiers** (not always straightforward, especially for multi-label documents with *degrees* of category membership).

**Evaluation**: results on the training corpus may not generalise (avoid [[Overfitting and Underfitting|overfitting]]) — hold out **10-20%** of the corpus as test data, or use [[Cross-Validation|N-fold cross-validation]] with separate development and test sets. Always compare against a **baseline**: the minimum performance you're trying to beat, either a competing system or a "dumb but easy" method (random choice, most-frequent-answer, simple heuristic) — comparisons must use the **same test data** to be meaningful.

---

## Summary

This lecture reframes many NLP tasks as **text classification** (binary, multi-class, or multi-label), emphasising that feature choice is **highly genre dependent**. The standard representation is **bag-of-words** (a fixed-dimensionality term-frequency vector per document, forming an `m × n` term-document matrix), with alternatives (one-hot, multi-word/phrase-level, LSI) offering little significant improvement. **Feature engineering** — via **subset selection** (stopwords, document frequency thresholds, **Mutual Information**, χ²) or **construction** (stemming, thesauri, LSI, term clustering) — reduces dimensionality and protects against overfitting. **TF-IDF** is the central "soft" feature-weighting technique. Two worked exercises (MI for "National", TF-IDF for "cat" in a 20,000-document corpus) apply these formulas directly. Evaluation requires held-out test data (or cross-validation) and a clearly defined **baseline**. All formulas, definitions, and full worked examples are in [[TF-IDF and Feature Selection for Text]]. The lecture's final topic — **multi-dimensional vectorisation via word embeddings** — is covered in [[COMP723 Lecture 9.2 - Word Embeddings - Word2Vec and GloVe|Lecture 9.2]].

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Bag-of-words, feature selection/construction, MI formula, TF-IDF formula and worked examples | [[TF-IDF and Feature Selection for Text]] | ✓ Verified |
| Overfitting motivation for feature selection | [[Overfitting and Underfitting]] | ✓ Verified |
| N-fold cross-validation for evaluation | [[Cross-Validation]] | ✓ Verified |
| Stop word removal as feature subset selection | [[NLP Text Preprocessing Pipeline]] | ✓ Verified |
