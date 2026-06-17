---
description: Ingest new files from raw/ into wiki/.
argument-hint: (optional) limit to N sources
---

# Ingest Files into Wiki

Your task: Process unread files from raw/ and synthesize them into wiki pages.

## Process

1. **Identify unread sources** — Scan raw/ for files that haven't been summarized yet. Skip files already processed (referenced in existing wiki pages or log.md).

2. **For each source (5-10 per run, or limit to $ARGUMENTS if provided):**
   - Read the file
   - Create a source-summary page in wiki/ (filename: `[source-name]_summary.md`) with frontmatter type: `source-summary`
   - Identify concepts, entities, people, or projects mentioned
   - Create or update wiki pages (type: `concept`, `entity`, `person`, or `project`) as needed
   - Cross-link all pages with `[[wiki-links]]` in the frontmatter `related:` field
   - Update wiki/index.md to list any new pages under appropriate categories

3. **Log changes** — Append a timestamped entry to wiki/log.md for each new page and update, including:
   - Date
   - Type of change (new page, update)
   - Page name(s)
   - Brief summary

## Guidelines

- Use the frontmatter template from CLAUDE.md: `title`, `type`, `sources`, `related`, `created`, `last-updated`
- Cite the raw/ source file in the `sources:` field
- Be thorough but concise — extract the most useful insights
- If a source mentions multiple disconnected topics, create separate pages and link them
- Use DD-MM-YYYY for all dates

## When Done

Report:
- Number of files processed
- New pages created (list names and types)
- Pages updated (list names)
- Any topics you noticed but deferred for manual review
