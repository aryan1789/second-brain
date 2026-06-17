# Courses

Cornell Method lecture notes, organized by course code. Populated by the `lecture-notes-to-cornell` skill.

## Structure

Each course gets its own folder:

```
courses/
  COMP821/
    index.md              (type: project — course overview, lists lectures)
    Lecture-1.1-topic.md
    Lecture-1.2-topic.md
    ...
```

## File Naming

- Course folders: `{COURSE_CODE}/` (e.g. `COMP821/`)
- Lecture notes: `Lecture-{lecture number}.{sub topic number}-{sub-topic-in-kebab-case}.md`
- Course index: `index.md` inside the course folder

## Frontmatter

Lecture notes use `type: source-summary`. Concept terms introduced in lectures are extracted into atomic pages under `wiki/concepts/` and linked via `[[wikilinks]]`.

## Workflow

New courses and lectures are added by the `lecture-notes-to-cornell` skill when processing lecture material. Each run updates this directory, links new concepts in `wiki/concepts/`, and logs changes to `wiki/log.md`.
