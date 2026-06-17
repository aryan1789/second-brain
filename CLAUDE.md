# Second Brain Vault — Claude Guidelines

Guidelines for Claude to create and maintain this knowledge base.

---

## 1. Project Structure

### raw/ — Source Material (Read-only)

Original documents and exports from external tools. Never modified after import. Organized by source:

- **claude-exports/** — Conversations and artifacts from Claude.ai and Claude Code
- **chatgpt-exports/** — Conversations and outputs from ChatGPT
- **lecture-notes/** — Notes from courses and educational content
- **assignments/** — Course assignments, problem sets, and homework
- **articles/** — Blog posts and published articles saved for reference

**Workflow:** New insights from raw/ are synthesized and processed into wiki/ pages. Raw materials stay here as the source of truth for attribution and future reference.

### wiki/ — Processed Knowledge Base (Claude's Domain)

The curated, interconnected knowledge system. Organized into four categories:

- **concepts/** — Timeless topics, frameworks, and reusable knowledge
- **projects/** — Time-bound goals, initiatives, and their status
- **people/** — Dossiers on collaborators, mentors, and key contacts
- **courses/** — Cornell Method lecture notes, organized by course code (e.g. `courses/COMP821/`). Each course folder has an `index.md` (type: project) listing its lectures. Populated by the `lecture-notes-to-cornell` skill.

**Key Files:**
- **index.md** — Master catalog of all wiki pages, organized by category
- **log.md** — Append-only activity log recording all changes, new pages, and updates (entries include date, change type, page affected, and brief summary)

**Principles:** Pages are atomic (one main idea), interconnected via `[[wikilinks]]`, and derived from raw/ sources.

### journal/ — Daily Reflections

Personal notes and journaling space. Date-organized (`DD-MM-YYYY.md`). Reflections may inspire new wiki pages.

### content/ — Publishing Pipeline

Polished content derived from wiki and journal insights. Drafts, final pieces, and publication records.

---

## 2. Page Conventions

### YAML Frontmatter

Every wiki page must begin with frontmatter containing these fields:

```yaml
---
title: Page Title
type: [concept | entity | source-summary | comparison | project | person]
sources: [list of raw/ files or external references]
related: [list of related page titles or concepts]
created: DD-MM-YYYY
last-updated: DD-MM-YYYY
---
```

**Type Definitions:**
- **concept** — Timeless ideas, frameworks, patterns
- **entity** — Things: tools, technologies, systems
- **source-summary** — Summary of an article, book, or paper
- **comparison** — Side-by-side analysis of two or more things
- **project** — Active or completed initiative with goals and status
- **person** — Dossier on a person (collaborator, mentor, author)

### Structure and Style

- **Atomic pages** — One main idea per page. If a page covers multiple concepts, break it into separate pages and link them.
- **Wiki links** — Use `[[page-title]]` to reference other pages. The system will resolve these to actual links.
- **Headings** — Use consistent heading hierarchy: `# Title` (H1, page title in body), `## Major Section` (H2), `### Subsection` (H3). Avoid H4+.
- **Lists over prose** — Prefer bullet points and structured lists where appropriate; use prose to explain context and relationships.

### Attribution and Sources

- **Attribute every claim** — When stating a fact, idea, or framework, cite the source using `[[source-page]]` or `[source text](URL)`.
- **Note contradictions** — If sources disagree, flag this explicitly: *"Source A claims X, but Source B argues Y because..."*
- **Link to raw/** — When summarizing or processing raw material, link to the original: "From [[claude-exports]] conversation on [date]" or similar.

---

## 3. Style Guide

### Prose

- **Clear and concise** — Favor simple language over jargon. If jargon is necessary, define it.
- **Direct voice** — Write in active voice where possible. Be specific: avoid hedging with "might," "could," "perhaps" unless genuinely uncertain.
- **Show, don't tell** — Use examples, lists, and structure to clarify ideas before explaining.

### Formatting

- **Bullet points** — Use liberally for lists, definitions, and breakdowns. Keep items parallel in structure.
- **Bold for emphasis** — Use sparingly to highlight key terms or distinctions.
- *Italics for asides* — Use for clarifications, caveats, and editorial notes.
- `Code blocks` — For examples, structured data, or direct quotes from technical sources.

### Citations and References

- **Inline attribution** — Use `[[page-title]]` for internal pages and `[text](URL)` for external sources.
- **Source credibility** — If a source is less reliable or contested, note it: *"According to [unreliable source], X. However, [authoritative source] disputes this."*
- **Quotation** — Use block quotes sparingly and only when exact wording matters. Always cite the source.

### Consistency

- Use standard date format: `DD-MM-YYYY`
- Keep terminology consistent across related pages (use wikilinks to establish canonically)
- Organize similar pages with parallel structures

---

## 4. Domain Context

You're a final-year Software Engineering student building depth across the full engineering stack. Your focus is becoming a better software engineer overall, which means learning from projects, assignments, and deliberate practice across key areas: data structures & algorithms (DSA), system design, DevOps, and machine learning. Assignments will vary throughout the semester, and you're exploring different tech stacks and frameworks rather than locking into one approach. This vault should capture insights and patterns from your coursework and personal projects—what worked, what didn't, how concepts connect across domains—so you can refer back and apply lessons to future work. Think of it as a learning log that builds your professional intuition over time.
