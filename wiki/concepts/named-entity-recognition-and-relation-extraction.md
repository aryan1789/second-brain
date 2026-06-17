---
title: Named Entity Recognition and Relation Extraction
type: concept
sources: [raw/lecture-notes/COMP723/Lecture11.pptx, raw/lecture-notes/COMP723/Lecture8.pptx, https://medium.com/analytics-vidhya/automatic-extraction-of-hypernym-relations-from-text-using-ml-4b04eb33097f, https://ceur-ws.org/Vol-3064/DBpedia-Technology-tutorial.pdf]
related: [NLP Text Preprocessing Pipeline, Confusion Matrix Metrics, TF-IDF and Feature Selection for Text]
created: 13-06-2026
last-updated: 13-06-2026
---

# Named Entity Recognition and Relation Extraction

> [!check] Verified
> Hearst patterns confirmed via [Prakhar Mishra: Automatic Extraction of Hypernym Relations from Text using ML (Medium)](https://medium.com/analytics-vidhya/automatic-extraction-of-hypernym-relations-from-text-using-ml-4b04eb33097f); RDF/DBpedia confirmed via [The DBpedia Technology Tutorial](https://ceur-ws.org/Vol-3064/DBpedia-Technology-tutorial.pdf).

## The Core Idea

**Information Extraction (IE)** turns unstructured text into structured facts. The central unit of structure is a **relation**: a **predicate describing the link between two entities**. Relations are usually represented as **triples** (like tuples): `<subject> <predicate> <object>` — e.g. `Sky Tower – location – Auckland`. A database of such triples is a **triple store** (e.g. **DBpedia**), queried with **SPARQL** (Protocol and RDF Query Language — "a somewhat SQL interface" for triples).

This page covers the full pipeline previewed in [[COMP723 Lecture 8.2 - NER/Relation Extraction Preview and Evaluation|Lecture 8.2]]: **coreference**, **taxonomic relations**, and the three families of **relation extraction** techniques.

## Coreference (Anaphora)

**Coreference** (or **anaphora**, the more generic term) is the use of a word to refer to a previously-mentioned entity — e.g. pronouns ("them", "her") and definite descriptions ("the leaders", "the owner") resolving back to named entities introduced earlier in a text. It's a key tool for **cohesiveness** in language, and a prerequisite for relation/event extraction: without resolving "her advance vote" → "Collins", a system can't link that clause to the right entity. (See [[COMP723 Lecture 8.2 - NER/Relation Extraction Preview and Evaluation]] for the full New Zealand election worked example.)

## Taxonomic Relations and Thesaurus Induction

**Thesaurus induction** — building a structured, consistent thesaurus of sense-disambiguated **synsets** (e.g. linking "bambara ndang" IS-A "bow lute" IS-A "musical instrument", or "ostrich" IS-A "bird") — is a **special case of relation extraction**, focused on a few generic taxonomic relation types:

- **IS-A (hypernym)** — subsumption between classes: `Giraffe IS-A ruminant IS-A ungulate IS-A mammal IS-A vertebrate IS-A animal`.
- **Instance-of** — relation between an individual and a class: `Auckland instance-of city`.
- **Co-ordinate term (co-hyponym)** — siblings under the same hypernym: `Auckland, Wellington, Christchurch` (all `instance-of city`).
- **Meronym** — part-whole: `Bumper is-part-of car`.

### Hearst's Patterns for IS-A Relations

**Hearst (1992)** observed that certain **lexical-syntactic patterns** reliably signal an IS-A (hyponym/hypernym) relationship — these are manually-defined patterns, applied via regular-expression-style search, where **X is the hyponym** and **Y is the hypernym**:

| Hearst Pattern | Example Occurrence |
|---|---|
| `X and other Y` | "...temples, treasuries, **and other** important civic buildings." |
| `X or other Y` | "Bruises, wounds, broken bones **or other** injuries..." |
| `Y such as X` | "The bow lute, **such as** the Bambara ndang..." |
| `such Y as X` | "...**such** authors **as** Herrick, Goldsmith, and Shakespeare." |
| `Y including X` | "...common-law countries, **including** Canada and England..." |
| `Y, especially X` | "European countries, **especially** France, England, and Spain..." |

**Worked example**: in *"Agar is a substance prepared from a mixture of red algae, such as Gelidium, for laboratory or industrial use"*, the pattern `Y such as X` lets us infer that **Gelidium IS-A red alga** — without knowing what "Gelidium" means beforehand, the pattern alone tells us its taxonomic category.

## Extracting Relation Triples From Text

A richer example: from a company report — *"International Business Machines Corporation (IBM or the company) was incorporated in the State of New York on June 16, 1911, as the Computing-Tabulating-Recording Co. (C-T-R)..."* — full information extraction would produce a structured **Company-Founding** record (Company: IBM, Location: New York, Date: June 16 1911, Original-Name: Computing-Tabulating-Recording Co.). The **simpler task** this lecture focuses on is extracting **relation triples** directly: `Founding-year(IBM, 1911)`, `Founding-location(IBM, New York)`.

### Why Relation Extraction?

- **Create new structured knowledge bases**, or **augment existing ones**: add words/senses to lexical resources like **WordNet**, or facts to **FreeBase**/**DBPedia**.
- **Question answering**: e.g. *"The granddaughter of which actor starred in the movie 'E.T.'?"* decomposes into the relation-query `(acted-in ?x "E.T.") (is-a ?y actor) (granddaughter-of ?x ?y)` — relation extraction is what *populates* the knowledge base such queries run against.

### ACE Relation Types (Examples)

The **Automated Content Extraction (ACE)** program defines relation types between named-entity pairs, e.g.:

- **Physical-Located** (PER-GPE): *"He was in Wellington"*
- **Part-Whole-Subsidiary** (ORG-ORG): *"XYZ, the parent company of ABC"*
- **Person-Social-Family** (PER-PER): *"John's wife Yoko"*
- **Org-AFF-Founder** (PER-ORG): *"Steve Jobs, co-founder of Apple"*

### RDF Triples, OWL, and DBpedia

**Resource Description Framework (RDF)** triples take the form `<subject> <predicate> <object>` — e.g. `dbpedia:Sky_Tower dbpedia-owl:location dbpedia:Auckland`. **OWL (Web Ontology Language)** resembles OOP: it **defines structures** (classes/properties), while **ontology population** fills those structures using information from heterogeneous/disparate sources. **DBpedia** (per the lecture) contains roughly **1 billion RDF triples**, **385 million** derived from English Wikipedia. Frequent Freebase relation types include `people/person/nationality`, `location/location/contains`, `people/person/profession`, `people/person/place-of-birth`, `biology/organism_higher_classification`, and `film/film/genre`.

## Building Relation Extractors

There are three main approaches, trading off precision, recall, and the cost of labelled data.

### 1. Hand-Written Patterns

The intuition: relations often hold between **specific entity types** — `located-in(ORGANIZATION, LOCATION)`, `founded(PERSON, ORGANIZATION)`, `cures(DRUG, DISEASE)`. **Named Entity (NE) tags alone aren't enough** — knowing a sentence contains a `DRUG` and a `DISEASE` doesn't tell you whether the relation is "cures", "prevents", or "causes". So patterns combine **NE types with surrounding words**, e.g.:

- `PERSON, POSITION of ORG` → *"Jacinda Ardern, prime minister of New Zealand"*
- `PERSON (named|appointed|chose|etc.) PERSON Prep? POSITION` → *"Ardern appointed Bloomfield spokesman for Covid"*
- `PERSON [be]? (named|appointed|etc.) Prep? ORG POSITION` → *"Andrew Coster was named Commissioner of Police"*

**Trade-offs**: hand-written patterns tend to be **high-precision** and can be **tailored to specific domains**, but typically have **low recall**, require **a lot of work to enumerate all possible patterns**, and don't generalise — you'd need to repeat the effort for every relation type.

### 2. Supervised Machine Learning

A standard pipeline:

1. **Choose** the set of relations and named-entity types to extract.
2. **Find and label data** — choose a representative corpus, label the named entities, then **hand-label the relations** between entity pairs.
3. **Split** into training, development, and test sets, and **train a classifier**.

**Classification is done in two steps**: (1) find **all pairs of named entities** (usually within the same sentence) and decide **if** the two entities are related at all; (2) **if yes**, classify *which* relation holds. This extra step is worthwhile because it **eliminates most pairs early** (faster training) and allows **different feature sets** for the two distinct sub-tasks.

**Features** (illustrated on *"American Airlines, a unit of AMR, immediately matched the move, spokesman Tim Wagner said."*, with M1 = "American Airlines", M2 = "Tim Wagner"):

- **Word features** — headwords of M1/M2 and their combination (`Airlines`, `Wagner`, `Airlines-Wagner`); bag-of-words/bigrams *within* M1 and M2 (`{American, Airlines, Tim, Wagner, American Airlines, Tim Wagner}` — see [[TF-IDF and Feature Selection for Text]] for the bag-of-words representation generally); and words/bigrams at specific positions relative to M1/M2 (e.g. `M2: -1 = spokesman`, `M2: +1 = said`, `M1: +1 = unit`).
- **Named-entity type and mention-level features** — the NE type of each mention (`M1: ORG`, `M2: PERSON`), their concatenation (`ORG-PERSON`), and **entity/mention level** — `NAME` (proper name), `NOMINAL` (e.g. "the company"), or `PRONOUN` (e.g. "it"/"he").
- **Gazetteer and trigger-word features** — e.g. a **trigger list** of kinship terms for "family" relations (`parent, wife, husband, grandparent, ...`, sourced from WordNet), and **gazetteers**: lists of country names, geopolitical terms, or other relevant entity lists.

**Classifiers**: once features are extracted, **any classifier** can be used — **Naive Bayes**, **Logistic Regression (MaxEnt)**, **SVM**, **NN/DNN**, etc. — trained on the training set, tuned on the dev set, evaluated on the test set.

**Evaluation**: compute **Precision, Recall, and F1** (see [[Confusion Matrix Metrics]]) **for each relation type separately**.

**Trade-offs**: supervised relation extraction can achieve **high accuracy with enough hand-labelled training data**, *if* the test domain is similar enough to training — but **labelling a large training set is expensive**, and models trained on a narrow domain are **brittle** and **won't generalise well** to a different domain.

### 3. Bootstrapping (Semi-Supervised)

When there's **no training set**, but you have either **a few seed tuples** or **a few high-precision patterns**, **bootstrapping** uses those seeds to directly learn to populate a relation — alternating between finding new instances and generalising new patterns.

**Relation Bootstrapping (Hearst 1992)**:

1. Gather a set of **seed pairs** known to have relation `R`.
2. **Iterate**: find sentences containing these pairs → look at the surrounding context and **generalise it into patterns** → use those patterns to **grep for more pairs**.

**Worked example** — seed tuple `<Mark Twain, Elmira>`:

- Search ("grep"/Google) for the environments of the seed tuple:
  - *"Mark Twain is buried in Elmira, NY."* → pattern: `X is buried in Y`
  - *"The grave of Mark Twain is in Elmira"* → pattern: `The grave of X is in Y`
  - *"Elmira is Mark Twain's final resting place"* → pattern: `Y is X's final resting place`
- Use these **newly-discovered patterns** to find **new tuples**, then **iterate**.

**Discovering novel hyponym/hypernym pairs** with the pattern `<hypernym> called <hyponym>`: learned from examples like *"an uncommon bone **cancer called osteogenic sarcoma**"* (sarcoma/cancer) and *"heavy water rich in the doubly heavy hydrogen **atom called deuterium**"* (deuterium/atom), this single learned pattern then **discovers entirely new pairs** never seen during seeding — e.g. *"a **condition called efflorescence**"* (efflorescence/condition), *"run a small **ranch called the Hat Creek Outfit**"* (hat_creek_outfit/ranch), *"irreversible **problem called tardive dyskinesia**"* (tardive_dyskinesia/problem), *"local sightseeing **attraction called the Bateau Mouche**"* (bateau_mouche/attraction).

## Common Pitfalls & Practical Tips

- **Precision/recall trade-off mirrors the extraction method.** Hand-written patterns → high precision, low recall. Supervised ML → can balance both, but needs labelled data and won't transfer across domains. Bootstrapping → can scale to huge corpora from a handful of seeds, but pattern drift (a generalised pattern matching unrelated relations) can compound across iterations and hurt precision over time.
- **NE types alone under-determine the relation.** A `(DRUG, DISEASE)` pair could mean "cures", "prevents", or "causes" — always combine entity types with lexical/contextual features.
- **Coreference errors propagate.** If "the company" isn't resolved to "IBM", a correctly-extracted relation `Founding-location(the company, New York)` is useless for populating a knowledge base keyed on "IBM".
- **The find-pairs-then-classify two-step is a recall/efficiency trade-off** — any entity pair incorrectly filtered out in step 1 (related vs. not) can never be correctly classified in step 2, no matter how good the relation classifier is.

## Related Concepts

- [[NLP Text Preprocessing Pipeline]] — tokenization and NE recognition are prerequisites for identifying the entity mentions (M1/M2) that relation extraction operates on.
- [[Confusion Matrix Metrics]] — Precision/Recall/F1, used to evaluate supervised relation extractors per relation type.
- [[TF-IDF and Feature Selection for Text]] — bag-of-words/bigram features reused directly as word features for relation classification.

**Source:** [Prakhar Mishra: Automatic Extraction of Hypernym Relations from Text using ML (Medium)](https://medium.com/analytics-vidhya/automatic-extraction-of-hypernym-relations-from-text-using-ml-4b04eb33097f); [The DBpedia Technology Tutorial](https://ceur-ws.org/Vol-3064/DBpedia-Technology-tutorial.pdf); COMP723 Lecture 11 (triples, ACE relation types, Hearst patterns, supervised RE features, bootstrapping worked examples); COMP723 Lecture 8 (coreference).
