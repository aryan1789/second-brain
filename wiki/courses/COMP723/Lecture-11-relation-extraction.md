---
title: COMP723 Lecture 11 - Relation Extraction
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture11.pptx]
related: [COMP723, Named Entity Recognition and Relation Extraction, Confusion Matrix Metrics, COMP723 Lecture 8.2 - NER/Relation Extraction Preview and Evaluation]
created: 13-06-2026
last-updated: 13-06-2026
---

# COMP723 Lecture 11 - Relation Extraction

> [!tip] Going Deeper
> [[Named Entity Recognition and Relation Extraction]] is a new concept page covering this entire lecture in full: triples/RDF/SPARQL/DBpedia, taxonomic relations and Hearst's IS-A patterns, ACE relation types, and all three relation-extraction approaches (hand-written patterns, supervised ML with feature types, and bootstrapping) with the lecture's worked examples. This note tracks the lecture's own structure across all 34 slides.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **Define "relation" and "triple". What is DBpedia, and how is it queried?**
- **List the 4 taxonomic relation types covered (IS-A, instance-of, co-hyponym, meronym), with an example of each.**
- **State Hearst's 6 patterns for IS-A relations, with the example occurrence for each.**
- **Walk through the "Agar... such as Gelidium" example — what does the pattern tell us about Gelidium, and why does that matter?**
- **Give an example of an ACE relation type and the named-entity-type pair it connects.**
- **What are RDF triples and OWL? What's the difference between "OWL defines structures" and "ontology population"?**
- **List the 3 approaches to building relation extractors. What's the precision/recall trade-off for hand-written patterns?**
- **Describe the 2-step classification process in supervised relation extraction, and why the extra step is worthwhile.**
- **List the 4 categories of features used in supervised relation extraction, with one example feature from each.**
- **Walk through the Hearst (1992) bootstrapping algorithm using the Mark Twain/Elmira example — what patterns are discovered, and what do they find next?**

---

## Notes

### What Is a Relation?

A **relation** is a **predicate describing the link between two entities** — relations may be application-specific, but some are **generic**. Relations are represented as **triples** (similar to tuples), stored in a **triple store** (e.g. **DBpedia**), queried via **SPARQL** (Protocol and RDF Query Language) — "a somewhat SQL interface".

### Thesaurus Induction and Taxonomic Relations

**Thesaurus induction** = building a structured, consistent thesaurus of sense-disambiguated **synsets** (taxonomy induction examples: "bambara ndang" IS-A "bow lute"; "ostrich" IS-A "bird"; "wallaby" is-like "kangaroo") — covering relations like **hypernymy** and **meronymy**. This is a **special case of relation extraction**, covering:

- **IS-A (hypernym)** — subsumption: `Giraffe IS-A ruminant IS-A ungulate IS-A mammal IS-A vertebrate IS-A animal ...`
- **Instance-of** — `Auckland instance-of city`
- **Co-ordinate term (co-hyponym)** — `Auckland, Wellington, Christchurch`
- **Meronym** — `Bumper is-part-of car`

### Extracting Relations From Text — IBM Example

From a company report: *"International Business Machines Corporation (IBM or the company) was incorporated in the State of New York on June 16, 1911, as the Computing-Tabulating-Recording Co. (C-T-R)..."* — full extraction yields a **Company-Founding** record (Company, Location, Date, Original-Name); the **simpler task** (this lecture's focus) is extracting **relation triples**: `Founding-year(IBM, 1911)`, `Founding-location(IBM, New York)`.

### Why Relation Extraction?

- **Create new structured knowledge bases**, or **augment current ones** — lexical resources (add words to **WordNet**), fact bases (add facts to **FreeBase** or **DBPedia**).
- **Sample application — question answering**: *"The granddaughter of which actor starred in the movie 'E.T.'?"* → `(acted-in ?x "E.T.") (is-a ?y actor) (granddaughter-of ?x ?y)`.
- Open question: **which relations should we extract?**

### ACE (Automated Content Extraction) Relation Types

Examples: **Physical-Located** (PER-GPE, *"He was in Wellington"*); **Part-Whole-Subsidiary** (ORG-ORG, *"XYZ, the parent company of ABC"*); **Person-Social-Family** (PER-PER, *"John's wife Yoko"*); **Org-AFF-Founder** (PER-ORG, *"Steve Jobs, co-founder of Apple"*).

### RDF, OWL, and DBpedia

**RDF (Resource Description Framework)** triples: `<subject> <predicate> <object>`, e.g. `Sky Tower – location – Auckland` (`dbpedia:Sky_Tower dbpedia-owl:location dbpedia:Auckland`). **OWL (Web Ontology Language)** resembles OOP — **defined using structures and instances**: OWL **defines structures**, and **ontologies populate** those structures using information from heterogeneous/disparate sources. **DBpedia**: ~**1 billion RDF triples**, **385 million from English Wikipedia**. Frequent Freebase relations: `people/person/nationality`, `location/location/contains`, `people/person/profession`, `people/person/place-of-birth`, `biology/organism_higher_classification`, `film/film/genre`.

### How to Build Relation Extractors — Overview

Three families of approach: **hand-written patterns**; **supervised machine learning**; **semi-supervised/unsupervised bootstrapping (using seeds)**.

### Hand-Written Patterns

**Hearst's intuition (1992)**: in *"Agar is a substance prepared from a mixture of red algae, such as Gelidium, for laboratory or industrial use"*, the pattern `Y such as X` tells us **Gelidium IS-A red alga**, even without prior knowledge of what "Gelidium" means. **Hearst's Patterns for IS-A**: `Y such as X`, `such Y as X`, `X or other Y`, `X and other Y`, `Y including X`, `Y, especially X` — each with example occurrences (see [[Named Entity Recognition and Relation Extraction]] for the full table).

**Richer relations via rules + NE types**: relations often hold between **specific entity types** — `located-in(ORGANIZATION, LOCATION)`, `founded(PERSON, ORGANIZATION)`, `cures(DRUG, DISEASE)`. But **NE tags alone aren't enough** — a `(DRUG, DISEASE)` pair could mean "cures", "prevents", or "causes"; a `(PERSON, ORGANIZATION)` pair could mean "founder", "investor", "member", "employee", "president". Combining NE types with surrounding words gives patterns like `PERSON, POSITION of ORG` (*"Jacinda Ardern, prime minister of New Zealand"*), `PERSON (named|appointed|chose|etc.) PERSON Prep? POSITION` (*"Ardern appointed Bloomfield spokesman for Covid"*), and `PERSON [be]? (named|appointed|etc.) Prep? ORG POSITION` (*"Andrew Coster was named Commissioner of Police"*).

**Trade-offs**: **high-precision**, **tailorable to domains** — but **low-recall**, **a lot of work** to enumerate patterns, and **not reusable** across relations.

### Supervised Machine Learning for Relations

**Pipeline**: choose relations to extract → choose relevant named entities → **find and label data** (choose a representative corpus, label named entities, hand-label relations between entities) → split into train/dev/test → **train a classifier**.

**Classification process**: (1) find **all pairs of named entities** (usually in the same sentence); (2) decide **if** the two entities are related; (3) **if yes**, classify *which* relation. The extra step pays off via **faster training** (most pairs eliminated early) and **distinct feature sets per task**.

The lecture references **ACE's 17 sub-relations of 6 relations** (from SemEval-2008's "Relation Extraction Task"), and a running example: *"American Airlines, a unit of AMR, immediately matched the move, spokesman Tim Wagner said."* — to classify as `SUBSIDIARY`, `FAMILY`, `EMPLOYMENT`, `NIL`, `FOUNDER`, `CITIZEN`, `INVENTOR`, etc.

**Feature categories** (M1 = "American Airlines", M2 = "Tim Wagner"):

- **Word features** — headwords of M1/M2 + combination (`Airlines`, `Wagner`, `Airlines-Wagner`); bag-of-words/bigrams in M1/M2 (`{American, Airlines, Tim, Wagner, American Airlines, Tim Wagner}`); words/bigrams at specific positions (`M2: -1 = spokesman`, `M2: +1 = said`, `M1: +1 = unit`).
- **Named-entity type and mention-level features** — NE types (`M1: ORG`, `M2: PERSON`), their concatenation (`ORG-PERSON`), and entity level — `NAME`, `NOMINAL` (e.g. "the company"), or `PRONOUN` (e.g. "it"/"he").
- **Gazetteer and trigger-word features** — trigger lists (e.g. kinship terms for "family": `parent, wife, husband, grandparent, etc.`, from WordNet); gazetteers (country-name lists, other geo/geopolitical word lists, other sub-entities).

**Classifiers**: any of **Naive Bayes**, **Logistic Regression (MaxEnt)**, **SVM**, **NN/DNN**, etc. — train on training set, tune on dev set, test on test set.

**Evaluation**: compute **P/R/F1 for each relation**.

**Summary trade-offs**: can achieve **high accuracy with enough hand-labelled data** if test/training domains match — but **labelling is expensive**, and models are **brittle**, **not generalising well to other domains**.

### Bootstrapping (Seed-Based) Relation Extraction

When there's **no training set**, but you have **a few seed tuples** or **a few high-precision patterns**: **bootstrapping** uses the seeds to directly learn to populate a relation.

**Relation Bootstrapping (Hearst 1992)**: gather seed pairs with relation `R` → **iterate**: find sentences with these pairs → generalise the surrounding context into patterns → use the patterns to **grep for more pairs**.

**Worked example** — seed tuple `<Mark Twain, Elmira>`:
- *"Mark Twain is buried in Elmira, NY."* → `X is buried in Y`
- *"The grave of Mark Twain is in Elmira"* → `The grave of X is in Y`
- *"Elmira is Mark Twain's final resting place"* → `Y is X's final resting place`
- Use these patterns to grep for **new tuples**, then iterate.

**Discovering novel hypernym/hyponym pairs** via `<hypernym> called <hyponym>`: learned from *"an uncommon bone cancer called osteogenic sarcoma"* (sarcoma/cancer) and *"heavy water rich in the doubly heavy hydrogen atom called deuterium"* (deuterium/atom) — discovers entirely new pairs: efflorescence/condition, hat_creek_outfit/ranch, tardive_dyskinesia/problem, bateau_mouche/attraction (full quotes in [[Named Entity Recognition and Relation Extraction]]).

### Demo (Slide 34)

The lecture closes with a "Relation Extraction Demo" (applied/lab content, not covered further here).

---

## Summary

This lecture covers **relation extraction** end-to-end: **relations as triples** stored in triple stores (DBpedia, queried via SPARQL); **taxonomic relations** (IS-A/hypernym, instance-of, co-hyponym, meronym) and **thesaurus induction** as a special case of RE, anchored by **Hearst's six lexical-syntactic IS-A patterns**; the motivation for RE (building/augmenting knowledge bases like WordNet, FreeBase, DBpedia, and enabling structured **question answering**); **ACE relation types** and the **RDF/OWL/DBpedia** knowledge-graph stack; and finally the **three approaches to building relation extractors** — **hand-written patterns** (high precision, low recall, not reusable), **supervised ML** (two-step classification with word/NE-type/gazetteer features, evaluated via P/R/F1, but expensive and domain-brittle), and **bootstrapping** (Hearst 1992's seed-pair-to-pattern-to-new-pairs iteration, illustrated with the Mark Twain/Elmira example and novel hypernym discovery). Together with [[COMP723 Lecture 8.2 - NER/Relation Extraction Preview and Evaluation|Lecture 8.2]]'s coreference preview, this completes COMP723's unstructured/text-mining unit. Full details, formulas, and all worked examples are in [[Named Entity Recognition and Relation Extraction]].

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| Triples, taxonomic relations, Hearst patterns, RDF/OWL/DBpedia, hand-written/supervised/bootstrapping RE approaches, all worked examples | [[Named Entity Recognition and Relation Extraction]] | ✓ Verified |
| P/R/F1 evaluation per relation | [[Confusion Matrix Metrics]] | ✓ Verified |
| Coreference as a prerequisite for relation extraction | [[COMP723 Lecture 8.2 - NER/Relation Extraction Preview and Evaluation]] | ✓ Verified |
