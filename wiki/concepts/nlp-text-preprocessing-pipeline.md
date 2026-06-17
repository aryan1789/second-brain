---
title: NLP Text Preprocessing Pipeline
type: concept
sources: [raw/lecture-notes/COMP723/Lecture8.pptx, https://www.geeksforgeeks.org/nlp/text-preprocessing-for-nlp-tasks/, https://vijinimallawaarachchi.com/2017/05/09/porter-stemming-algorithm/]
related: [Knowledge Discovery (KDD) Process, Data Preprocessing and Data Quality, TF-IDF and Feature Selection for Text]
created: 13-06-2026
last-updated: 13-06-2026
---

# NLP Text Preprocessing Pipeline

> [!check] Verified
> Confirmed via [GeeksforGeeks: Text Preprocessing in NLP](https://www.geeksforgeeks.org/nlp/text-preprocessing-for-nlp-tasks/) and [Vijini Mallawaarachchi: Porter Stemming Algorithm](https://vijinimallawaarachchi.com/2017/05/09/porter-stemming-algorithm/)

## The Core Idea

Most of the world's data is **unstructured text** — free text, web pages, PDFs, documents, news, Wikipedia. Unlike [[Data Preprocessing and Data Quality|structured data]] (spreadsheets, databases), unstructured text has **inconsistent, variable-length records** and is **not data-mining-friendly** until it has been transformed into a consistent, structured representation. The **text mining process flow** mirrors the [[Knowledge Discovery (KDD) Process]]: determine the purpose, explore the data, **prepare the data** (this preprocessing pipeline), develop and assess models, evaluate results, and deploy for decision-making.

The standard preprocessing pipeline, in order:

```
Tokenize → POS tag/parse → Stemming/Lemmatization → Stop word removal
  → Remove uninteresting words/numbers → Chunking → Clause/Concept extraction
```

## Why Text Mining Is Hard

Natural language is fundamentally **ambiguous** and **context-dependent** — the same sentence can be parsed multiple ways (a classic example: *"Please use the toilets, not the pool. The pool for members only."*, where "pool" could ambiguously refer to a swimming pool or a betting pool depending on context). Several named types of lexical ambiguity make this concrete:

- **Polysemy / Homonymy** — the same word, different meanings (e.g. *"bank"* = riverbank or financial institution).
- **Synonymy** — different words, the same meaning (e.g. *"big"* / *"large"*).
- **Hyponymy** — a concept hierarchy (e.g. *"dog"* and *"cat"* are both *"animals"*).
- **Meronymy** — whole/part relations (e.g. *"windows"* are part of a *"house"*).

Additionally: concept/word extraction tends to produce **very high-dimensional** representations (thousands of fields), each with **low information content**, and real text is full of **misspellings, abbreviations, and spelling variants**.

## Tokenization: Tokens, Types, and Terms

- **Token** = a sequence of characters, at a particular position in a particular document — most commonly separated by whitespace, though other delimiters (hyphens) are possible.
- **Type** = the class of all tokens that share the same character sequence (i.e. distinct "words" after deduplication).
- **Term** = a *normalized* type that is included in the IR dictionary — may consist of more than one token (e.g. multi-word phrases).

**Worked example**: *"Auckland University of Technology is located in the city of Auckland in the north part of the North Island."* — this sentence has **20 tokens** but only **16 types** (because "Auckland", "of", "the", "in" repeat).

## Stop Words

**Stop words** are the list of most common words in a language — they carry **little semantic content** (*"the, a, and, to, be"*) but are extremely frequent: roughly **30% of any text** is made up of just the top 30 words. Stop word lists are typically built by **sorting tokens by collection frequency** and selecting the most common types, often hand-filtered for semantic content, then **excluded from the dictionary**.

## Normalization

**Token normalization** reduces multiple surface forms to the same canonical **term**, creating **equivalence classes** (named after one member of the class) so that matches occur despite superficial differences:

- `{anti-discriminatory, antidiscriminatory}` — hyphenation variants.
- `{U.S.A., USA}` — abbreviation variants. (But what about `C.A.T` vs `CAT`? — normalization rules don't always generalize cleanly.)
- Can be extended with **synonym lists** (e.g. `car`, `automobile`).

### Case Folding

**Case-folding** reduces all letters to lower case (so "Automobile" at the start of a sentence matches "automobile" elsewhere). Because naive case-folding can lose information (e.g. proper nouns), heuristics are common:

- Only lowercase words at the **beginning of sentences**.
- Only lowercase words in a **title** where most words are capitalized.
- **Truecasing** — use a trained classifier to decide *when* to fold case, based on many heuristic features.

## Lemmatization vs. Stemming

Both reduce word forms to a common base — but differently:

- **Lemmatization** reduces a word to its **lemma** (base/dictionary form): `is, am, are → be`; `car, cars → car`. It commonly only collapses **inflectional** forms — e.g. `saw → see` (if it's a verb) but `saw → saw` (if it's a noun, as in the tool).
- **Stemming** reduces **inflectional and sometimes derivational** forms to a common stem/root — a much **cruder, language-dependent "chopping"** that can return non-dictionary forms: `automate, automates, automatic, automation → automat`; `see, saw → s`; `compressed, compression → compress`.

## Porter's Algorithm (Stemming)

**Porter's Algorithm** is the most common English stemmer — "at least as good as other stemming options" — and applies **5 phases of word reductions sequentially**. The lecture summarises it as 6 steps:

1. **Step 1**: Gets rid of plurals and `-ed` or `-ing` suffixes.
2. **Step 2**: Turns a terminal `y` to `i` when there is another vowel in the stem.
3. **Step 3**: Maps double suffixes to single ones (`-ization`, `-ational`, etc.).
4. **Step 4**: Deals with suffixes like `-full`, `-ness`, etc.
5. **Step 5**: Removes suffixes like `-ant`, `-ence`, etc.
6. **Step 6**: Removes a final `-e`.

**Worked example**: `Abate, abated, abatement, abatements, abates` might all stem to **`abat`** — illustrating how Porter's "crude chopping" can produce a non-dictionary stem, but one that's consistent across all related forms (useful for matching in IR).

## In Practice: Python (NLTK)

```python
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer, WordNetLemmatizer

text = "The cats are running and jumping over compressed files"
tokens = word_tokenize(text.lower())

stop_words = set(stopwords.words('english'))
tokens_no_stop = [t for t in tokens if t not in stop_words]

stemmer = PorterStemmer()
stems = [stemmer.stem(t) for t in tokens_no_stop]
# 'compressed' -> 'compress', 'running' -> 'run', 'jumping' -> 'jump'

lemmatizer = WordNetLemmatizer()
lemmas = [lemmatizer.lemmatize(t) for t in tokens_no_stop]
# 'running' -> 'running' (needs POS info to fully lemmatize verbs)
```

## Common Pitfalls & Practical Tips

- **Stemming can produce non-words.** `PorterStemmer().stem("compression")` → `"compress"`, but more aggressive cases can produce stems with no dictionary meaning — fine for matching/retrieval, confusing for display to users.
- **Stop word lists are domain-dependent.** A generic English stop list may remove words that carry meaning in a specific domain (e.g. "not" matters a lot for sentiment analysis).
- **Order matters.** Case-folding, normalization, and stop-word removal typically happen *after* tokenization but *before* stemming/lemmatization, since stemmers expect individual word tokens.
- **Lemmatization needs POS information** to be fully correct (e.g. distinguishing `saw` the verb from `saw` the noun) — plain stemmers ignore part-of-speech entirely.

## Related Concepts

- [[Knowledge Discovery (KDD) Process]] — the text mining process flow (purpose → explore → prepare → model → evaluate → deploy) mirrors this general framework.
- [[Data Preprocessing and Data Quality]] — the structured-data analogue (noise, missing values, normalization) of this pipeline.
- [[TF-IDF and Feature Selection for Text]] — the next step after preprocessing: turning cleaned tokens into numeric features.

**Source:** [GeeksforGeeks: Text Preprocessing in NLP](https://www.geeksforgeeks.org/nlp/text-preprocessing-for-nlp-tasks/); [Vijini Mallawaarachchi: Porter Stemming Algorithm – Basic Intro](https://vijinimallawaarachchi.com/2017/05/09/porter-stemming-algorithm/); COMP723 Lecture 8 (ambiguity types, tokenization worked example, Porter's algorithm steps).
