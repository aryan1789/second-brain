# How to Use This Vault

A practical guide for Aryan — how the second brain works, when to use each tool, and the habits that make it useful vs. a passive archive.

---

## The Core Loop

```
Work session / lecture / conversation
        │
        ▼
   journal/          ← capture raw thoughts during or right after (3 bullets minimum)
        │
        ▼  (when something is worth keeping permanently)
   /log or /ingest   ← promote to wiki
        │
        ▼
   wiki/             ← query BEFORE starting future work
```

The vault only compounds if you **write into journal first** and **query wiki before starting work**. Without those two habits, it's just a backup.

---

## Folder Map

| Folder | What goes here | Who writes it |
|---|---|---|
| `raw/` | Original exports, lecture transcripts, assignment PDFs — never edited | You (import only) |
| `wiki/` | Processed, permanent knowledge — concepts, projects, courses | Claude (via /ingest) |
| `journal/` | Raw daily notes, session reflections, quick captures | You (freeform) |
| `content/` | Polished writing derived from wiki + journal | You + Claude |

---

## Journal — Do This Every Session

File: `journal/DD-MM-YYYY.md`

**When:** Right after any work session, lecture, or meeting. Takes 2–5 minutes.

**Format (no structure required, but this works):**
```
## FYP session - afternoon

- Got the LSTM within 1pp of RF using only 8 raw features — confirms it learns the temporal pattern end-to-end
- Subject 7 is a consistent outlier; median frequency doesn't decline like others
- Question: would fusing LSTM hidden state into RF as extra features help?
```

**The rule:** Three bullets minimum. Don't aim for perfect notes — aim for not losing the insight. You can always clean it up later.

**When a journal entry should become a wiki page:** When you find yourself re-reading the same journal entry to remind yourself of something. That's the signal to promote it.

---

## Claude Commands

### `/ingest` — Turn raw exports into wiki knowledge

**When to use:**
- After a big Claude.ai session that produced useful output (export it, drop into `raw/claude-exports/`, then run /ingest)
- After adding lecture notes to `raw/lecture-notes/`
- After finishing a project phase (to capture what was learned while it's fresh)

**When NOT to use:**
- Don't run it blind on everything. Skim the file names first and decide: worth a wiki page / worth a one-line log note / discard. Most debugging sessions are discard.

**How to run:** Open Claude Code in this vault, type `/ingest`. It processes 5–10 files per run and creates/updates wiki pages. You can limit it: `/ingest 3` to process only 3 files.

**What it produces:** A source-summary page per raw file, plus updated concept/project pages, plus a log entry.

---

### `/log` — Quick one-line capture without a full ingest

**When to use:**
- You had an insight mid-session and want to capture it in the wiki log without a full journal entry
- You made a decision on a project and want it recorded
- You noticed a connection between two concepts

**How to run:** `/log Realised that the LSTM hidden state could be fused into RF as extra columns — worth trying next semester`

**What it does:** Appends a timestamped entry to `wiki/log.md` and updates the `last-updated` field on any related wiki pages it recognises.

**Rule of thumb:** Journal is for raw capture during sessions. `/log` is for when the insight is already clean and you want it in the wiki record.

---

### `/query` — Ask the wiki a question

**When to use:**
- Before starting an assignment — check what you already know
- Before a meeting where the topic was covered in lecture notes
- When you half-remember a concept and want the full version

**How to run:** `/query What is the difference between LSTM and GRU and when would I use each?`

**What it does:** Reads the index, finds relevant wiki pages, synthesises a grounded answer with citations. If the wiki doesn't have enough, it says so.

**This is the most underused command.** The vault pays off when you query it before writing, not just write into it after.

---

### `/lint` — Health check

**When to use:**
- Once a month, or before a big ingest run
- When the wiki feels messy or you suspect broken links

**What it checks:** Broken wikilinks, orphan pages, missing frontmatter, stale pages (30+ days old), contradictions, index inconsistencies.

**What it does NOT do:** Fix anything automatically — it reports and asks for permission first.

---

## Wiki Page Types — Quick Reference

| Type | Use for | Example |
|---|---|---|
| `concept` | Timeless ideas, algorithms, frameworks | LSTM, Backpropagation, Cross-Validation |
| `entity` | Tools, technologies, systems | PyTorch, Obsidian, OpenBCI |
| `project` | Active or completed work with goals | FYP, Deep Learning Assignment |
| `source-summary` | Summary of a raw file | Created by /ingest automatically |
| `comparison` | Side-by-side of two things | LSTM vs GRU |
| `person` | Collaborator, mentor, contact | (create when genuinely useful) |

---

## What to Avoid

- **Don't run /ingest on everything.** Debugging sessions, one-off code fixes, and administrative chats produce no wiki value. Triage first.
- **Don't use the wiki as a task manager.** It's for knowledge that compounds, not todos. Todos go in your actual task system.
- **Don't let the journal stay empty.** If you haven't written a journal entry this week and you've done work, something is being lost.
- **Don't only write to the vault — read from it too.** Open `wiki/index.md` before starting work on a topic you've covered before.
- **Don't over-structure journal entries.** The journal is for capture, not polish. Write messily, promote selectively.

---

## Weekly Rhythm (suggested)

| Trigger | Action |
|---|---|
| After any work session | 3-bullet journal entry in `journal/DD-MM-YYYY.md` |
| After a useful Claude.ai session | Export → `raw/claude-exports/` → `/ingest` |
| Before an assignment or exam | `/query` the relevant concept pages |
| Friday or Sunday | Skim journal entries from the week; run `/log` on anything worth keeping |
| Once a month | Run `/lint` to catch broken links and stale pages |

---

## Current State (as of 16-06-2026)

**Strong:**
- COMP838 and COMP723 fully processed (lecture notes + concept pages)
- FYP project page is detailed and up to date
- ~65 concept pages covering ML/DL fundamentals

**Needs work:**
- `journal/` is empty — start here first
- ~44 raw files unprocessed (FYP signal processing, career prep, course assignments)
- Project pages for Radar, SkillSwap, and Deep Learning Assignment are stubs
- No cross-domain synthesis pages yet ("what COMP838 A1 taught me about feature engineering for FYP")

**Next action:** Write one journal entry. Then `/ingest` the FYP signal processing files.
