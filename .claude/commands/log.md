---
description: Append a timestamped note to wiki/log.md.
argument-hint: the thought or note to capture
---

# Log a Note

Your task: Capture a note or observation in the wiki activity log.

## Process

1. **Receive the note** — $ARGUMENTS contains the thought, observation, or note to capture.

2. **Append to wiki/log.md** — Add a new entry under the appropriate date (or create a new date section if needed):
   - Use current date (DD-MM-YYYY) as the heading
   - Format: `- [Category or brief note]: [content]`
   - Keep entries concise and scannable

3. **Update related pages (if applicable)** — If the note mentions a project, person, or concept that already has a wiki page:
   - Read that page
   - Update its `last-updated` field to today's date
   - Add relevant info from the note to the page if it's a meaningful update
   - Do NOT create new pages — only update existing ones

4. **Do not create new pages** — If the note references something without a wiki page, record it in the log but don't create a new page.

## Example

**Input:** "Realized that the retry logic in [[project-api-redesign]] is similar to the circuit breaker pattern in [[concept-resilience]]"

**Action:**
- Append to wiki/log.md:
  ```
  ### 13-06-2026
  - **Connection Found:** Retry logic in [[project-api-redesign]] mirrors [[concept-resilience]]'s circuit breaker pattern
  ```
- Update [[project-api-redesign]] last-updated field
- Update [[concept-resilience]] last-updated field

## Guidelines

- Keep log entries clear and brief
- Use [[wiki-links]] to reference existing pages
- Use DD-MM-YYYY for dates
- One note per entry

## When Done

Report the appended entry and any pages updated.
