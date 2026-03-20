# Module 07: Rebasing

## TL;DR

Rebasing rewrites your branch's history to sit on top of the latest main, creating a cleaner timeline.

## The Concept

In Module 06, you learned that merging creates a merge commit where two branches come together. Rebasing is a different way to integrate changes. Instead of creating a merge commit, rebase **replays** your commits on top of another branch, producing a straight line of history.

Here is the analogy: imagine you and a coworker are both writing chapters for a book. You started your chapter when the book had 10 chapters. While you were writing, your coworker added chapters 11 and 12. With **merge**, you combine everything and add a note saying "merged at this point" -- you can see where the timelines diverged and rejoined. With **rebase**, you pick up your chapter, set it down after chapter 12, and rewrite the page numbers so it looks like you started after chapter 12 all along. The content is the same, but the history is cleaner.

**Interactive rebase** (`git rebase -i`) is one of git's most powerful tools for cleaning up your work before sharing it. It lets you squash multiple small commits into one, reword commit messages, reorder commits, or drop commits entirely. This is perfect for when you have a series of commits like "WIP", "fix typo", "oops forgot a file", "actually working now" and you want to present them as one clean, professional commit before opening a PR.

**The golden rule of rebasing: never rebase commits that have been pushed to a shared branch.** Rebase rewrites commit history -- it creates new commits with new hashes. If someone else has based their work on the original commits, rewriting those commits will cause confusion and conflicts. Rebase your own local feature branch onto main before pushing -- that is fine and encouraged. But do not rebase `main` or any branch that other people are actively using.

## Key Commands

| Command | What It Does |
|---|---|
| `git rebase main` | Replays the current branch's commits on top of the latest `main`. |
| `git rebase -i HEAD~N` | Interactive rebase of the last N commits. Opens an editor to squash, reword, reorder, or drop. |
| `git rebase --abort` | Cancels a rebase in progress and returns to the original state. |
| `git rebase --continue` | After resolving a conflict during rebase, continues replaying the remaining commits. |

## Watch

- [Git MERGE vs REBASE -- Fireship](https://www.youtube.com/watch?v=0chZFIZLR_0) (5 min) -- clear visual comparison of when to use merge vs rebase.
- [Git Rebase -- The Net Ninja](https://www.youtube.com/watch?v=f1wnYdLEpfI) -- step-by-step walkthrough of rebasing a branch.

## Read More

- [Pro Git -- Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) -- thorough explanation with diagrams showing how commits are replayed.
- [Atlassian -- Git Rebase](https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase) -- practical guide covering standard rebase, interactive rebase, and the golden rule.

## Interactive Practice

- [Learn Git Branching](https://learngitbranching.js.org/) -- the "Ramping Up" section has excellent visual exercises for rebase. Seeing commits move in real time makes the concept click.
