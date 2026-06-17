---
title: COMP723 Lecture 8.2 - NER/Relation Extraction Preview and Evaluation
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture8.pptx]
related: [COMP723, Confusion Matrix Metrics, Named Entity Recognition and Relation Extraction, NLP Text Preprocessing Pipeline]
created: 13-06-2026
last-updated: 13-06-2026
---

# COMP723 Lecture 8.2 - NER/Relation Extraction Preview and Evaluation

> [!tip] Going Deeper
> [[Confusion Matrix Metrics]] has been supplemented with this lecture's Sensitivity/Specificity terminology and the general Fβ measure, including the worked 250/750-document exercise. [[Named Entity Recognition and Relation Extraction]] (created for Lecture 11) covers coreference, relation/event extraction, and information extraction techniques in full — this note previews those tasks as introduced here (slides 19-30), then covers the lecture's evaluation and POS-tagging material (slides 31-45).

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **What is coreference (anaphora), and why does it matter for text understanding?**
- **Give an example of "relation recognition" and "event detection and linking" from the lecture's news-article examples.**
- **List the 4 categories of NLP features used for information extraction. Give an example of each.**
- **What's the difference between a domain-independent and a domain-dependent classification scheme for information extraction? Give an example of each.**
- **What are the 4 possible "forms" a classification scheme can take?**
- **Derive the confusion matrix for the lecture's 250/750-document exercise, and compute Precision, Recall, Specificity, and Accuracy.**
- **What is the Penn Treebank, and what does a POS-tagged sentence look like?**

---

## Notes

### Coreference (Anaphora)

**Coreference** is the use of a word to refer to a previously-mentioned entity — also called **anaphora** (a more generic term). It's one of the key tools for establishing **cohesiveness** in language. The lecture's worked example is a New Zealand election news article, annotated to show how pronouns and definite descriptions ("the leaders", "them", "her", "the owner", "Collins") all **resolve back to** specific named entities (Judith Collins, Jacinda Ardern, etc.) introduced earlier in the text — without resolving these references, a system can't tell that "her advance vote" and "Collins" refer to the same person.

### Relation and Event Extraction (Preview)

- **Relation recognition**: given a sentence like *"Motorola, Inc. announced that the company and General Instrument Corporation completed their previously announced merger..."*, the task is to extract the **relation** (a merger) and its participants (Motorola, GIC).
- **Event detection and linking**: given a news article about Microsoft withdrawing its Yahoo! acquisition proposal, the task is to detect **event-denoting words** (*announced, withdrawn, believe, pursuing, provide, create*) and link them into a coherent event structure.
- **More general information extraction examples**: extracting event details (type, time, location, victims, symptoms), web page info (email, product availability dates), opinions on a topic, and scientific facts from publications (gene localisation, disease treatments).

These tasks — and the techniques (hand-written patterns, supervised learning, bootstrapping) used to perform them — are the focus of [[Named Entity Recognition and Relation Extraction]] (Lecture 11).

### The Role of NLP Features

Text (the "object of study") can be described via four kinds of features:

- **Lexical features** — e.g. **tokenization**: in space-delimited languages (most European languages), a word = a string of characters separated by whitespace; in **unsegmented languages** (Chinese, Thai, Japanese), word boundaries require a **machine-readable dictionary (MRD)** or word list.
- **Morpho-syntactic features** — **POS tagging and sentence parsing**: a word's **part-of-speech** contributes to its meaning in a phrase and is a distinct component of syntactic structure. **Content words** (nouns, adjectives, verbs, adverbs) carry meaning; **function words** (determiners, quantifiers, prepositions, connectives — articles, pronouns, particles) serve syntactic roles.
- **Semantic features** — e.g. from lexico-semantic resources, or obtained from previous extraction tasks.
- **Discourse features** — e.g. discourse distance, and document-format-specific features like HTML tags.

Together, these features **describe the information unit to be classified and its context**.

### Classification Schemes for Information Extraction

A **classification scheme** = a set of **semantic labels and their relationships** (external knowledge), which can be:

- **Domain-independent** — e.g. coreferent relations (apply across any domain).
- **Domain-dependent** — e.g. biomedical name classes (specific to a field).

The scheme's **form** can be a **list**, a **hierarchy**, a **binary scheme**, or an **ontology** (where labels have hierarchical/structured relationships).

### Evaluation: Confusion Matrix, F-measure, Sensitivity/Specificity, ROC

The lecture recaps the **confusion matrix** for binary and multi-class classification (column = system's predicted class, row = expert/ground-truth class — easy to spot which classes get confused), then covers **Recall, Precision, Error Rate, Accuracy**, the **F-measure** (combining recall and precision, with **F1** as the harmonic-mean special case), and **Sensitivity/Specificity** (a plot of sensitivity vs. specificity shows how well a class can be picked out of a population), and the **ROC curve** (area under the curve should be maximised). See [[Confusion Matrix Metrics]] for all formulas, including the general **Fβ** measure and the worked exercise below.

**Worked Exercise**: A document classifier handles 250 relevant + 750 non-relevant documents, correctly classifying 150 relevant and 720 non-relevant. The task: derive the confusion matrix and compute F, Precision, Recall, Specificity, and Sensitivity — see [[Confusion Matrix Metrics]] for the full worked solution (`Precision ≈ 0.83`, `Recall = 0.6`, `Specificity = 0.96`, `Accuracy = 0.87`).

### Resources: WordNet, Penn Treebank, and POS Tags

The lecture surveys standard NLP resources:

- **Machine-Readable Dictionaries (MRD)** — **WordNet**.
- **Large corpora** — **Penn Treebank** (4.5 million words of American English, POS-tagged and syntactically bracketed), released via the **Language Data Consortium (LDC)**; also RCV1, TRC2, Reuters21578, OntoNotes, DBpedia, Freebase.

**Example of POS-tagged output** (Penn Treebank tagset):

```
DataMining is a very interesting class and guess what it is also very useful.
DataMining/NNP is/VBZ a/DT very/RB interesting/JJ class/NN and/CC guess/VB what/WP it/PRP is/VBZ also/RB very/RB useful/JJ ./.
```

### Exercise: Syntactic Ambiguity

The lecture closes with a classic syntactic-ambiguity exercise: *"I saw the boy in the park with a telescope."* — students are asked to identify the ambiguity (who has the telescope — the speaker or the boy?), rewrite the sentence to remove it, and consider how a machine might resolve such ambiguities.

---

## Summary

This lecture previews **information extraction** tasks — **coreference/anaphora** resolution, **relation recognition**, and **event detection** — using real news-article examples, before covering the **NLP feature types** (lexical, morpho-syntactic, semantic, discourse) and **classification scheme forms** (list, hierarchy, binary, ontology; domain-independent vs. domain-dependent) that underpin them. It then recaps **evaluation**: the confusion matrix, **Sensitivity/Specificity** terminology, the general **Fβ measure**, and **ROC/AUC** — all now folded into [[Confusion Matrix Metrics]] alongside a worked 250/750-document exercise. Finally, it surveys NLP **resources** (WordNet, Penn Treebank, POS tagsets) with a worked POS-tagging example, and closes with a classic syntactic-ambiguity exercise. The information-extraction tasks previewed here (coreference, relation/event extraction) are developed in full in [[Named Entity Recognition and Relation Extraction]] (Lecture 11).

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Sensitivity, Specificity, Fβ, ROC/AUC, worked confusion-matrix exercise | [[Confusion Matrix Metrics]] | ✓ Verified |
| Coreference, relation/event extraction, IE techniques (full treatment) | [[Named Entity Recognition and Relation Extraction]] | ✓ Verified |
| Tokenization, POS tagging as lexical/morpho-syntactic features | [[NLP Text Preprocessing Pipeline]] | ✓ Verified |
