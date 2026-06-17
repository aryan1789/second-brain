---
title: Recurring Prompting Patterns from Your Chats
type: concept
sources: raw/claude-exports/conversations.json (sample analysis from 170 files)
related: [[Claude Prompting Guide]]
created: 12-06-2026
last-updated: 12-06-2026
---

## Overview

Analysis of recurring patterns across your 163 conversation exports. Identifies common prompting mistakes, what works well, and actionable improvements for more efficient Claude interactions.

## Pattern 1: Vague Initial Asks (Most Common)

**Examples from your chats:**
- "can u pls explain this" (Clarification request)
- "can u firstly check why this code isnt running and then do the rest of things that need to be done" (Code debugging)
- "whys it displaying empty cart even when..." (Empty Cart Display)

**What went wrong:**
- Missing referent ("this" — this what?)
- Undefined scope ("the rest of things")
- Incomplete problem statement (missing error message, partial context)

**Impact:**
- Claude generates generic response
- Requires follow-up clarification turn
- Wastes time iterating toward actual need

**How to fix:**
- Lead with the specific thing you need help with
- Name the file, function, or concept explicitly
- Provide constraints: "I need this for [assignment/project]" or "I have 30 minutes"
- Copy-paste full error messages, not summaries

**Better versions:**
- ✅ "I need you to explain the Generative AI Agent architecture from Lecture 2. I'm revising for my Contemporary Issues in Software Engineering exam next week, and I need to understand this deeply enough to get an A+."
- ✅ "My Java Swing shopping cart keeps re-adding the first item when I add a second item. Can you help me debug `addToCart()`? Here's the code: [full code]"

---

## Pattern 2: Missing Code Context

**Examples:**
- Code debugging request: Didn't provide the actual code initially
- ASP.NET connection error: Provided Program.cs and appsettings.json, but missing exact error message
- Empty cart display: Provided code but missing database schema

**What went wrong:**
- Requires Claude to ask follow-up questions
- "Here's my code" without pasting it
- Partial error logs (stack trace cut off)
- Missing file type context (.ipynb vs .cs vs .ts)

**Impact:**
- Adds round-trip latency
- Claude gives generic suggestions instead of precise fixes
- You get solutions that don't apply to your exact setup

**How to fix:**
- Always paste the **full, exact code** where the bug is
- Include **full error messages** (stack traces, all lines)
- Specify **file type and context** (e.g., "This is a React component in TypeScript")
- Include **relevant config files** (package.json, appsettings.json, etc.)

**Better version:**
Instead of: "My ASP.NET app won't connect to Supabase"
Try: "I'm connecting ASP.NET to Supabase. Here's Program.cs: [full code]. Here's appsettings.json: [full code]. When I run `dotnet run`, I get this error: [FULL ERROR MESSAGE]. My Supabase connection string is Host=... Password=..."

---

## Pattern 3: Iterative Refinement (Shows Learning!)

**Examples:**
- Clarification request: First vague ("explain this") → second turn provides full context
- Code debugging: First incomplete → second turn asks for cell-by-cell changes
- Emergency communication rewording: First attempt → second attempt fixes specific line

**What went right:**
- You iterated and improved the request
- Provided more context in follow-ups
- Asked for specific output format (e.g., "exactly which cells")

**What could improve:**
- Frontload this context in the initial ask
- You learned to iterate; now anticipate what you'll need to clarify upfront

**Pattern insight:**
Your second asks are significantly better than your first asks. This suggests you could improve by doing upfront what you currently do in follow-ups:
- Think through what Claude needs before you ask
- Provide context, constraints, and examples in message 1
- Save iterations for genuine refinements, not clarifications

---

## Pattern 4: Scope Creep ("Do the rest...")

**Examples:**
- "can u firstly check why this code isnt running and then do the rest of things that need to be done"
- Asks that combine multiple tasks without clear boundaries

**What went wrong:**
- "The rest of things" is undefined
- Claude doesn't know priority or scope
- Results in either incomplete work or wasted effort on low-value tasks

**Impact:**
- Ambiguous response quality
- You get a solution to 60% of your actual problem
- Difficult to know what to ask for in follow-up

**How to fix:**
- Break into discrete asks: "First, help me fix the bug. Then, help me add unit tests."
- Or list what you need: "I need (1) debugging help, (2) code review, (3) documentation"
- Be explicit: "I only need you to fix the bug, not refactor"

**Better version:**
Instead of: "Check the code and do the rest of things"
Try: "My Jupyter notebook has two issues: (1) the audio files aren't loading, and (2) the spectrogram generation fails. Can you fix the loading first?"

---

## Pattern 5: Assignment/Exam Asks Need Context

**What works:**
- Clear role context: "You are a lecturer/tutor"
- Time pressure: "I have 30 minutes to understand this"
- Explicit goal: "I need to score A+ on my exam"
- Document attachment: Actual lecture slides/rubric referenced

**What doesn't work:**
- Generic academic questions without context
- Implicit scope ("make me understand")
- Missing source material (asking about Lecture 3 without sharing Lecture 3)

**Pattern:**
Your exam-prep asks that succeeded had:
- ✅ Role-play framing ("You are a Software/AI lecturer")
- ✅ Specific document: ("I have attached the lecture slide")
- ✅ Clear success criteria: ("I need for u to give a good answer... so i fully understand everything")
- ✅ Constraints: ("I have several other exams to study for")

**Improvement:**
Your second clarification request (after initial vague "explain this") was much better because you added all of these. You already know this; just apply it first-time.

---

## Pattern 6: Error Messages Need Full Context

**Recurring issue:**
You provide partial error messages or describe errors instead of pasting them

**Examples:**
- "throws errors" (ASP.NET) — which errors?
- "it keeps throwing errors" — full message?
- Debugging tasks that reference stack traces without the full trace

**Why it matters:**
- Full error messages often contain the fix (line numbers, root cause)
- Claude can search for solutions using exact error text
- Partial messages are often misleading (you summarize wrong)

**How to fix:**
Copy-paste the **entire error output**, including:
- Full stack trace (every line)
- All context lines (not just the error, but what triggered it)
- Any warnings or related messages

**Better version:**
Instead of: "it keeps throwing errors"
Try: "When I run [command], I get: [PASTE ENTIRE OUTPUT FROM CONSOLE]"

---

## Pattern 7: What You Do Well

**These prompts succeed:**
- **Providing full code upfront** (Radar sweep code example)
- **Clear problem + expected vs actual behavior** (Shopping cart duplication: "first item added correctly but second item also re-adds first")
- **Specific file/function names** ("can you help me debug addToCart()?")
- **Iterating on feedback** (You learn quickly and improve asks in follow-ups)
- **Following up with precise refinements** (Emergency communication: "try again, esp for this line:")

**These are your strengths — lean into them from the start of conversations.**

---

## Pattern 8: Vague Success Criteria

**Examples:**
- "help me understand autoencoders" (what does understanding look like?)
- "fix the code" (what counts as fixed?)
- "reword this properly" (what does "properly" mean?)

**Better:**
- "Explain autoencoders simply enough that I can draw the architecture and explain encoder→bottleneck→decoder in my own words"
- "Fix the code so that adding a second item doesn't re-add the first"
- "Reword to emphasize architectural decision-making rather than just technical choices; maintain A+ formal academic tone"

---

## Quick Reference: Anti-Patterns vs. Good Patterns

| Anti-Pattern | Good Pattern |
|---|---|
| "Can u explain this?" | "Explain the Generative AI architecture from Lecture 2. I'm revising for my exam next week. Here's the slide: [attachment]" |
| "My code has a bug" | "When I add a second item to cart, the first item also re-appears. Here's the code: [full code]" |
| "Help me with my assignment" | "I need to write a 4-page report on CNN & YOLO architectures for COMP838. I've attached the rubric. Can you help me structure the outline?" |
| "Throws errors" | "When I run `dotnet run`, I get: [FULL ERROR MESSAGE]" |
| "Check the code and do the rest" | "First, help me fix the bug. Then, can you suggest unit tests?" |
| "Reword this" | "Reword this for A+ formal academic tone, emphasizing architectural reasoning over technical implementation details" |

---

## Your Improvement Opportunity

**Your meta-pattern:** You frontload important context in your 2nd and 3rd messages that you could provide in message 1.

**What this means:**
- You understand what information Claude needs (you provide it in follow-ups)
- You're iterating toward clarity when you could start clear
- You're wasting turns on clarification when you could get solutions immediately

**The fix:**
Before hitting send, ask yourself:
- *What would I say if Claude asked me "can you be more specific?"*
- *What file/code/error would I paste if I needed to follow up?*
- *What is my actual goal, not my stated question?*

Include those upfront. You'll get better answers faster.

---

## When Vagueness is OK

Not all asks need to be detailed. These are fine:
- ✅ "Can you access other chats?" (yes/no question, inherently simple)
- ✅ "What's the difference between X and Y?" (general knowledge)
- ✅ "How do I deploy to Cloud Run?" (reference question, not debugging)

**The pattern:** Vague is OK for **questions**. It's problematic for **problems requiring context** (debugging, code review, assignment help).

---

## Related Pages

- [[Claude Prompting Guide]] — General best practices
