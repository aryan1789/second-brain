---
title: TF-IDF and Feature Selection for Text
type: concept
sources: [raw/lecture-notes/COMP723/Lecture9.pptx, https://www.geeksforgeeks.org/machine-learning/understanding-tf-idf-term-frequency-inverse-document-frequency/, https://en.wikipedia.org/wiki/Tf%E2%80%93idf]
related: [NLP Text Preprocessing Pipeline, Word Embeddings (Word2Vec and GloVe), Overfitting and Underfitting, Cross-Validation]
created: 13-06-2026
last-updated: 13-06-2026
---

# TF-IDF and Feature Selection for Text

> [!check] Verified
> Confirmed via [GeeksforGeeks: Understanding TF-IDF](https://www.geeksforgeeks.org/machine-learning/understanding-tf-idf-term-frequency-inverse-document-frequency/) and [Wikipedia: tf–idf](https://en.wikipedia.org/wiki/Tf%E2%80%93idf)

## The Core Idea

After [[NLP Text Preprocessing Pipeline|preprocessing]] (tokenizing, removing stop words, stemming), text still needs to become a **numeric vector** before any classifier can use it. The standard representation is the **Bag of Words (BoW)** model: a document is represented by a vector of fixed dimensionality, where each component is the **frequency of one word (term)** in that document — word *order* is discarded entirely.

A corpus of `n` documents and `m` terms becomes an `m × n` **term-document matrix**, where `w_ij` is the weight of term `i` in document `j`. Choosing *how* to compute these weights — and which terms to even include — is the central problem this page covers.

## Vector-Space Text Classification

Once documents are vectors, classification becomes geometric: a binary classifier separates the vector space into "relevant" vs. "not relevant" (or any other two-class split). For **multi-class (m-ary)** problems, either use a classifier that natively supports multiple classes, or combine several binary classifiers (e.g. **"one-against-the-rest"**) — though it's not always clear how to combine binary classifier outputs into a single multi-class decision, especially when a document could belong to several classes or have a *degree* of membership in each (multi-label).

## Alternative Document Representations

Beyond plain bag-of-words frequency counts:

- **One-hot representation** — a simplified, binary form of word frequency (word present/absent).
- **Multi-word level** — syntactic phrase indexing, e.g. noun phrases (`adjective-noun`) or co-occurrence patterns (e.g. `"speed limit"` as a single unit).
- **Semantic level** — **Latent Semantic Indexing (LSI)** automatically generates semantic categories from a bag-of-words representation, aiming to capture meaning beyond exact word matches.

More sophisticated representations than plain bag-of-words "have shown some improvements, but not significant" — bag-of-words remains a strong, simple baseline.

## Feature Selection vs. Feature Construction

With potentially thousands of distinct terms as features, **feature selection/engineering** removes irrelevant attributes — protecting against [[Overfitting and Underfitting|over-fitting]] and improving computational efficiency. Two strategies:

- **Feature subset selection** — use a subset of the original features (remove some terms entirely).
- **Feature construction** — build *new* features by combining original ones.

### Feature Subset Selection Techniques

- **Stopword removal** — removes high-frequency words (see [[NLP Text Preprocessing Pipeline]]).
- **Document frequency thresholding** — remove infrequent words (e.g. those occurring fewer than `m` times in the training corpus).
- **Mutual Information (MI)**
- **Chi-squared test (χ²)**

Ideally, a good learning algorithm should detect irrelevant features as part of learning — but with thousands of raw text features, explicit selection remains valuable in practice.

### Mutual Information (MI)

MI measures the **association between a term `t` and a category `c`** — how often they occur together, vs. how common the term and the category are individually:

```
MI(t,c) = log( A·N / ((A+C)(A+B)) )

where:
A = number of times t occurs in c
B = number of times t occurs outside c
C = number of documents in c in which t occurs
D = number of documents outside c in which t occurs
N = total number of documents
```

- `MI > 0` → **positive association** between `t` and `c`.
- `MI = 0` → **no association**.
- `MI < 0` → `t` and `c` are in **complementary distribution** (term tends to occur *outside* the category).

MI is measured in **bits of information**.

### Feature Construction Techniques

- **Stemming** (see [[NLP Text Preprocessing Pipeline]]) — collapses related word forms into one feature.
- **Thesauri** — group words into semantic categories/equivalence classes (e.g. synonyms).
- **Latent Semantic Indexing (LSI)** — based on the idea that words used in similar contexts tend to have similar meanings.
- **Term clustering** — cluster tokens into clusters representing categories/topics (recall [[K-Means Clustering]]).

## TF-IDF: Term Weighting

**TF-IDF (Term Frequency – Inverse Document Frequency)** is a **"soft" form of feature selection** — rather than removing attributes, it **adjusts their relative influence**. It evaluates how important a word is to a specific document *relative to the whole corpus*, and is a central tool search engines use to rank document relevance to a query.

```
TF(t, d)  = (number of times t appears in d) / (total number of terms in d)
IDF(t, D) = log( N / df(t) )      where N = total documents, df(t) = documents containing t

TF-IDF(t, d, D) = TF(t, d) · IDF(t, D)
```

- **TF** rewards terms that appear **often in this document** — normalised by document length so long documents don't automatically get higher scores.
- **IDF** *penalises* terms that appear in **many documents** (like "is", "of", "that" — low information) and *rewards* terms that are **rare across the corpus** (more likely to be meaningful/specific).
- An **un-normalised** form (without dividing TF by document length) is also commonly used.

### Worked Example

For a corpus of 3 documents, where Document 1 = "The cat sat on the mat" (6 terms, "cat" appears once) and "cat" appears in 2 of the 3 documents:

```
TF(cat, Doc1)  = 1/6 ≈ 0.167
IDF(cat, D)    = log(3/2) ≈ 0.176
TF-IDF(cat, Doc1, D) = 0.167 × 0.176 ≈ 0.029
```

A document where "cat" doesn't appear scores **0** for that term, regardless of IDF — TF-IDF is 0 whenever TF is 0.

**Lecture's exercise**: for a corpus of 20,000 documents, where "cat" appears 500 times across 1,000 documents — `IDF(cat) = log(20000/1000) = log(20) ≈ 1.30`, and TF-IDF is then `TF(cat,d) × 1.30` for whichever document `d` is being scored.

## Evaluating Text Classifiers

- **Avoid overfitting**: results on the training corpus may not generalise. Hold out **10-20%** of the corpus as a separate test set, or use [[Cross-Validation|N-fold cross-validation]], with separate development and test sets.
- **Baseline performance**: the minimum performance level you're trying to beat — could be a competing system, or a "dumb but easy" method (random choice, most-frequent-class, simple heuristic). Comparisons must be made **on the same test data** to be meaningful.

## In Practice: scikit-learn

```python
from sklearn.feature_extraction.text import TfidfVectorizer

corpus = [
    "The cat sat on the mat",
    "The dog played in the park",
    "Cats and dogs are great pets",
]

vectorizer = TfidfVectorizer(stop_words='english')
X = vectorizer.fit_transform(corpus)   # sparse term-document matrix
print(vectorizer.get_feature_names_out())
print(X.toarray())
```

`TfidfVectorizer` combines tokenization, stop-word removal, and TF-IDF weighting in one step — the practical realisation of the whole pipeline above.

## Common Pitfalls & Practical Tips

- **TF-IDF is a weighting, not a meaning representation** — two documents about completely different topics can still share high-TF-IDF rare words by coincidence. For *semantic* similarity, see [[Word Embeddings (Word2Vec and GloVe)]].
- **Document frequency thresholds need tuning per corpus** — a threshold that works for a 1,000-document corpus may be far too aggressive (or too lenient) for a 1,000,000-document corpus.
- **Always evaluate on held-out data with a defined baseline** — without a baseline, a "90% accurate" classifier is meaningless if 90% of documents are the majority class anyway.

## Related Concepts

- [[NLP Text Preprocessing Pipeline]] — produces the tokens/terms that feed into bag-of-words and TF-IDF.
- [[Word Embeddings (Word2Vec and GloVe)]] — a denser, semantically-aware alternative to bag-of-words/TF-IDF vectors.
- [[Overfitting and Underfitting]] — motivates feature selection.
- [[Cross-Validation]] — standard evaluation methodology for text classifiers.
- [[K-Means Clustering]] — term clustering as a feature-construction technique.

**Source:** [GeeksforGeeks: Understanding TF-IDF](https://www.geeksforgeeks.org/machine-learning/understanding-tf-idf-term-frequency-inverse-document-frequency/); [Wikipedia: tf–idf](https://en.wikipedia.org/wiki/Tf%E2%80%93idf); COMP723 Lecture 9 (bag-of-words, vector-space classification, mutual information, feature construction, baseline evaluation).
