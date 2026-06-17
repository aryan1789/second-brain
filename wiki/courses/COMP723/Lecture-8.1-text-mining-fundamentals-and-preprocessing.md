---
title: COMP723 Lecture 8.1 - Text Mining Fundamentals and Preprocessing
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture8.pptx]
related: [COMP723, NLP Text Preprocessing Pipeline, Knowledge Discovery (KDD) Process, Data Preprocessing and Data Quality]
created: 13-06-2026
last-updated: 13-06-2026
---

# COMP723 Lecture 8.1 - Text Mining Fundamentals and Preprocessing

> [!tip] Going Deeper
> [[NLP Text Preprocessing Pipeline]] is a new concept page covering this lecture's ambiguity types, tokenization/type/term definitions, stop words, normalization, case folding, lemmatization vs. stemming, and Porter's Algorithm in full, plus a worked Python example. This note summarises the lecture's framing of slides 1-18.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **What are the 4 goals for the "text mining half" of this course?**
- **Why is text mining important — give 3 real-world examples where leveraging text improves decisions.**
- **Contrast structured vs. unstructured data along 3 dimensions.**
- **List the 4 sources of ambiguity in language (with an example for each).**
- **What is the "Text Mining Process Flow" — list its 6 steps. How does it relate to the [[Knowledge Discovery (KDD) Process|KDD process]]?**
- **List the preprocessing pipeline steps in order, from raw text to "clause/concept extraction".**
- **Define token, type, and term. In the AUT example sentence, how many tokens and types are there?**
- **What's the difference between lemmatization and stemming? Give an example where they'd produce different results.**
- **Outline Porter's Algorithm's 6 steps.**

---

## Notes

### Goals for the Text Mining Half of the Course

The lecture sets out 4 goals: be able to **compare and contrast text and data mining**; appreciate the **need for text mining**; appreciate the **multi-dimensional nature** of processing knowledge represented as natural language; and be able to **use and interpret results from typical text mining tools**.

### Why Text? Why Text Mining?

**1.8 Zettabytes** (1.8 trillion GB) of data exist, and **most of the world's data is unstructured**: free text, un-transcribed notes/comments, web pages, PDFs, word processor documents, news sites, Wikipedia, etc. **Structured (stored) data often misses elements critical to predictive modelling** — the information is there, just not in cells/columns.

Text mining is **already mainstream**: Google, ChatGPT, sentiment analysis (Twitter/Facebook/YouTube), predicting the stock market, customer influence, customer service/help desks, security, and precision medicine all **leverage text to improve decisions and predictions**.

### Structured vs. Unstructured Data

| | Structured | Unstructured |
|---|---|---|
| **Form** | Spreadsheets, databases, XML/UML/JSON | Not structured into cells; variable record length |
| **Consistency** | Consistent, uniform | Inconsistent, not uniform |
| **Mining-friendliness** | Data-mining friendly | Requires preprocessing first |
| **Content** | Each cell has a value | Could involve images, video, sound; information content varies very low to very high; can be **multimodal** |

### Why Text Mining Is Hard

- **Language is ambiguous** — context is needed to clarify meaning. The lecture's example (Charles Fillmore): *"Please use the toilets, not the pool. The pool for members only."* — "pool" reads differently depending on context.
- **Language is subtle** — a multi-turn dialogue example (two people discussing tents) shows how meaning ("tent") accumulates and shifts across a conversation via **discourse** structure, not just isolated sentences.
- **Concept/word extraction → high dimensionality** — thousands of fields, each with low information content.
- **Misspellings, abbreviations, and spelling variants** add further noise.

See [[NLP Text Preprocessing Pipeline]] for the 4 named types of ambiguity (polysemy/homonymy, synonymy, hyponymy, meronymy) with examples.

### Examples of Text Mining Tasks

The lecture surveys the landscape of text mining tasks (most of which recur as topics in Lectures 9-11):

- **Search and Information Retrieval (IR)** — storage/retrieval of documents, search engines, keyword search.
- **Document Clustering** — grouping terms, snippets, or documents (recall [[K-Means Clustering]] from Lecture 6).
- **Document Classification** — grouping documents into known categories.
- **Web Mining** — data/text mining on the web (web scraping).
- **Information Extraction** — identifying/extracting facts and relations between text snippets to make text structured (this is the focus of Lecture 11).
- **NLG (Natural Language Generation)** — question-answering, paraphrasing, document generation.
- **NLP / Computational Linguistics** — low-level language processing and understanding.

### Text Mining Process Flow

A 6-step loop, directly analogous to the [[Knowledge Discovery (KDD) Process]]:

```
Determine the purpose → Explore data availability/nature → Prepare the data
  → Develop and assess the models → Evaluate the results → Deploy for decision-making
```

### Preprocessing Steps

The standard pipeline, in order: **Tokenize → POS tag/parse → Stemming/lemmatization → Stop word removal → Remove uninteresting words/numbers → Chunking → Clause/Concept extraction → Higher-level IR/visualisation.** See [[NLP Text Preprocessing Pipeline]] for the full treatment of each step.

### Tokenization, Types, and Terms

- **Tokenization** = segmenting text into **tokens** (a sequence of characters at a particular position), most commonly space-delimited.
- **Type** = the class of all tokens sharing the same character sequence.
- **Term** = a normalized type included in the IR dictionary (may span multiple tokens).

Worked example: *"Auckland University of Technology is located in the city of Auckland in the north part of the North Island."* → **20 tokens**, **16 types** (repeats like "Auckland", "of", "the", "in" collapse), and some smaller number of **terms** if normalizing to e.g. proper nouns, prepositions, determiners, verbs, common nouns, and punctuation.

### Stop Words, Normalization, and Case Folding

- **Stop words**: the most common words (~30% of any text is the top 30 words), carrying little semantic content (*the, a, and, to, be*) — excluded from the dictionary, typically chosen by sorting tokens by collection frequency.
- **Normalization**: collapsing surface variants into equivalence classes — `{anti-discriminatory, antidiscriminatory}`, `{U.S.A., USA}` — though edge cases like `C.A.T` vs `CAT` show normalization isn't always clean. Can be extended with synonym lists (`car`/`automobile`).
- **Case folding**: lowercase everything, with heuristics for sentence-initial words and titles, or **truecasing** via a trained classifier.

### Lemmatization and Stemming

- **Lemmatization** reduces a word to its dictionary **lemma** (`is, am, are → be`), generally only collapsing inflectional forms (`saw → see` if verb, `saw` stays `saw` if noun).
- **Stemming** is cruder — collapses inflectional *and* derivational forms to a common stem, which may not be a real word (`automate, automates, automatic, automation → automat`; `see, saw → s`).

### Porter's Algorithm

The most common English stemmer, applying **5 phases of word reductions** sequentially (described as 6 steps in the lecture): (1) strip plurals/`-ed`/`-ing`; (2) terminal `y → i` when another vowel precedes it; (3) map double suffixes to single (`-ization`, `-ational`); (4) handle suffixes like `-full`, `-ness`; (5) remove `-ant`, `-ence`, etc.; (6) remove a final `-e`. Example: `abate, abated, abatement, abatements, abates` might all stem to **`abat`**.

---

## Summary

This lecture motivates **text mining**: most of the world's data is unstructured text, and leveraging it (Google, ChatGPT, sentiment analysis, stock prediction, security, precision medicine) requires bridging the gap between **unstructured** text and the **structured, consistent** representations data mining algorithms need. Text mining is hard because **language is ambiguous and subtle** (polysemy, synonymy, hyponymy, meronymy; discourse-level context), and because extraction produces high-dimensional, noisy, low-information features. The **text mining process flow** mirrors [[Knowledge Discovery (KDD) Process|KDD]], and the **preprocessing pipeline** — tokenize, POS tag, stem/lemmatize, remove stop words, chunk, extract concepts — turns raw text into the structured form needed for the classification, vectorisation, and extraction techniques covered in Lectures 9-11. See [[NLP Text Preprocessing Pipeline]] for the full mechanics of tokenization (token/type/term), stop words, normalization, case folding, lemmatization vs. stemming, and Porter's Algorithm.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Ambiguity types, tokenization (token/type/term), stop words, normalization, case folding, lemmatization vs. stemming, Porter's Algorithm | [[NLP Text Preprocessing Pipeline]] | ✓ Verified |
| Text mining process flow vs. KDD process | [[Knowledge Discovery (KDD) Process]] | ✓ Verified |
| Structured vs. unstructured data, preprocessing motivation | [[Data Preprocessing and Data Quality]] | ✓ Verified |
| Document clustering as a text mining task | [[K-Means Clustering]] | ✓ Verified |
