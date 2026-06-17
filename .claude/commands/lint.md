---
description: Run a health check on the wiki.
argument-hint: (optional) specific directory or pattern to check
---

# Lint the Wiki

Your task: Scan the wiki for quality issues and inconsistencies.

## Checks to Run

1. **Broken wiki-links** — Find [[wiki-links]] in wiki pages that don't point to an actual page. Report the page containing the link and the target.

2. **Orphan pages** — Find pages in wiki/ that are never referenced by other pages and don't appear in index.md. Flag them but note if they're "stubs" (newly created, waiting for links).

3. **Missing frontmatter** — Find wiki pages missing required frontmatter fields: `title`, `type`, `sources`, `related`, `created`, `last-updated`. Report the page and missing field(s).

4. **Stale pages** — Find pages where `last-updated` is 30+ days old. Distinguish between pages that should be evergreen (concepts) and time-bound ones (projects).

5. **Contradictions** — Scan for factual claims across pages that contradict each other. Flag the pages and the conflicting claims.

6. **Index consistency** — Verify that wiki/index.md lists all pages in their correct categories (concepts, projects, people). Flag missing entries.

## Report Format

Structure your findings as:

```
## Broken Wiki-Links
- [page.md]: [[nonexistent-page]] (line X)

## Orphan Pages
- [page.md] (status: new / established)

## Missing Frontmatter
- [page.md]: missing `type`, `sources`

## Stale Pages (30+ days)
- [page.md] (last-updated: DD-MM-YYYY) — type: concept/project

## Contradictions
- [[page-A]] claims X, but [[page-B]] claims Y

## Index Inconsistencies
- Missing from index: [page.md]
- Listed but not found: [page.md]
```

## When Done

Ask for permission before fixing anything. Offer to:
- Remove or redirect orphan pages
- Update broken links
- Fill in missing frontmatter
- Flag stale pages for review
- Create new pages to resolve contradictions
