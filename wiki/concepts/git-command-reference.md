---
title: Git Command Reference
type: concept
sources: ["raw/articles/git-everything-you-need-to-know.md", "https://www.youtube.com/watch?v=K6Q31YkorUE"]
related: []
created: 26-06-2026
last-updated: 26-06-2026
---

# Git Command Reference

A quick, copy-paste cheat sheet for the everyday git workflow — from first-time setup to undoing mistakes. Derived from a [YouTube walkthrough](https://www.youtube.com/watch?v=K6Q31YkorUE); see the [[git-everything-you-need-to-know|original braindump]].

---

## Quick Reference

| Command | What it does |
|---|---|
| `git init` | Start tracking the current folder |
| `git clone <url>` | Copy an existing remote repo locally |
| `git add .` | Stage all changes for the next commit |
| `git status` | See what's staged, unstaged, untracked |
| `git diff` | Preview unstaged changes line-by-line |
| `git commit -m "msg"` | Save staged changes as a commit |
| `git log` | View commit history (and commit hashes) |
| `git remote add origin <url>` | Link local repo to a remote |
| `git push -u origin <branch>` | First push of a branch (sets upstream) |
| `git push` | Push later commits |
| `git pull origin <branch>` | Pull when local is behind remote |
| `git branch <name>` | Create a branch |
| `git switch <name>` | Switch to a branch |
| `git stash` / `git stash pop` | Shelve / restore uncommitted changes |
| `git revert <hash>` | Undo a commit with a new commit (safe) |
| `git reset --hard <hash>` | Reset to a commit, discarding everything after |

---

## 1. One-Time Setup

Do this once per device.

```bash
# Install git from https://git-scm.com, then:
git config --global user.name  "Your Name"            # who authors your commits
git config --global user.email "you@example.com"      # stamped into every commit
git config --global credential.helper store           # remember login after first push
```

Two different jobs here:

- **`user.name` / `user.email`** = **authorship**. Baked into every commit locally — `git commit` *refuses to run* without these, because it can't fill in the commit's "Author" field. Nothing to do with logging in.
- **`credential.helper store`** = **authentication**. Remembers your GitHub login so you aren't re-prompted on every `push`. *Saves credentials in plaintext at `~/.git-credentials` — fine for a personal machine, avoid on shared ones.*

---

## 2. Start a Project

Two ways in, depending on whether the repo already exists:

```bash
# A) Repo already on GitHub → just copy it down:
git clone <repo-url>     # downloads it AND wires up 'origin' for you

# B) Brand-new local folder:
git init                 # start tracking this folder
git add .                # stage all changed files
git status               # check what's staged vs not
git diff                 # (optional) see exactly what changed, line by line
git commit -m "Initial commit"
git log                  # view history + commit hashes
```

*Note: GitHub now names the default branch **`main`**, not `master`. Swap `master` → `main` (or whatever `git branch` shows) in the commands below if that's your default.*

**The core loop** you'll repeat forever: `add` → `status` → `commit` → `log`.

### .gitignore

Before your first `add`, create a `.gitignore` file listing paths git should **never** track — dependencies, secrets, build output:

```gitignore
node_modules/
.env
dist/
*.log
```

This keeps junk and secrets out of your history. (Already-committed files aren't auto-ignored — `.gitignore` only affects untracked files.)

---

## 3. Connect to the Remote

```bash
git remote add origin <repo-url>     # link to the GitHub repo
git push -u origin master            # FIRST push of this branch only
git push                             # every push after that
```

The `-u` (upstream) flag is only needed the **first** time you push a branch — it tells git which remote branch to track. Do it once per new branch (swap `master` for the branch name); afterwards plain `git push` works.

---

## 4. Branching

```bash
git branch <name>        # create a branch
git branch               # list branches (current one is marked *)
git switch <name>        # move onto a branch
```

---

## 5. Merging via Pull Request

After committing to a feature branch and you're ready to merge into main:

- Go to GitHub — a **"Compare & pull request"** button appears at the top.
- The PR lets you merge cleanly, surfaces and resolves **merge conflicts**, and lets a teammate **review** the code before it lands.

**Merging locally instead** (solo work, no review needed):

```bash
git switch main          # go to the branch you want to merge INTO
git merge <feature>      # pull the feature branch's commits in
```

---

## 6. Staying in Sync

```bash
git pull origin master   # pull down changes when your local is behind remote
```

---

## 7. Undoing Things

```bash
git revert <hash>                  # undo a commit by making a NEW commit (history kept — safe)
git reset --hard <hash>            # move branch back to <hash>, DELETE everything after it
git push --force origin <branch>   # push rewritten history to the remote
```

- **`revert`** is the safe choice: it doesn't erase history, it adds a commit that cancels out the target commit's changes. Grab the `<hash>` from `git log`.
- **`reset --hard`** is destructive: it discards commits *and* uncommitted work after `<hash>`. Use when you genuinely want that history gone.
- After a `reset --hard` (or any history rewrite), the remote will reject a normal push — `--force` overwrites it.
- **Safer force push:** `git push --force-with-lease origin <branch>` does the same thing but *aborts if someone else pushed in the meantime*, so you don't silently clobber a teammate's work. Prefer it over plain `--force` on shared branches.

---

## 8. Stashing — Move Work to Another Branch

Got uncommitted changes on the wrong branch?

```bash
git stash                # shelve your changes (working tree goes clean)
git switch <branch>      # move to the right branch
git stash pop            # re-apply the shelved changes here
```
