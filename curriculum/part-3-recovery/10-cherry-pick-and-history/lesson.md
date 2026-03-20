# Module 10: Cherry-pick & History

## TL;DR

Cherry-pick lets you copy individual commits between branches, and git's history tools help you find exactly when and why something changed.

## The Concept

Sometimes you don't want to merge an entire branch -- you just want one specific commit. Maybe a teammate fixed a critical bug on their feature branch, and you need that fix on main right now without pulling in their half-finished feature. `git cherry-pick` copies a single commit onto your current branch. It creates a new commit with the same changes and a new hash. Think of merge as pouring one jar into another (everything mixes together), while cherry-pick is using tweezers to pick out one specific thing you need.

Git also comes with powerful "detective" tools for investigating history. `git blame` shows who last modified each line of a file and when -- invaluable for understanding why a line of code looks the way it does. `git log` with its many filtering options lets you slice through history by author, date, file, or search term. And `git show` lets you inspect any individual commit in detail.

The most impressive detective tool is `git bisect`. When you know something is broken now but worked at some point in the past, bisect performs a binary search through your commit history to find the exact commit that introduced the problem. You mark one commit as "good" and one as "bad," and git checks out the midpoint for you to test. With each step, it cuts the search space in half. Even in a history of 1,000 commits, bisect finds the culprit in about 10 steps.

## Key Commands

| Command | What It Does |
|---|---|
| `git cherry-pick <commit>` | Copies a commit onto your current branch, creating a new commit with the same changes. |
| `git bisect start` | Begins a binary search session to find a bug-introducing commit. |
| `git bisect good <commit>` | Marks a commit as "good" (the bug is not present here). |
| `git bisect bad` | Marks the current commit as "bad" (the bug is present here). |
| `git bisect reset` | Ends the bisect session and returns to your original branch. |
| `git log --oneline --graph` | Shows commit history as a compact graph. |
| `git log --author="name"` | Filters history to show only commits by a specific author. |
| `git log --since="2 weeks ago"` | Filters history to show only recent commits. |
| `git log -p <file>` | Shows the full diff (patch) for each commit that touched a specific file. |
| `git blame <file>` | Shows who last changed each line of a file, with commit hash and date. |
| `git show <commit>` | Displays the details and diff of a specific commit. |

## Watch

- [Git Cherry Pick -- The Net Ninja](https://www.youtube.com/watch?v=WkCnqBhCy4o) -- clear walkthrough of cherry-pick with real examples.
- [Using Git Bisect to find bugs -- The Modern Coder](https://www.youtube.com/watch?v=P3ZR_s3NFvM) -- practical demonstration of binary search debugging.

## Read More

- [Pro Git -- Debugging with Git](https://git-scm.com/book/en/v2/Git-Tools-Debugging-with-Git) -- covers bisect, blame, and other investigative tools.
- [Atlassian -- Git Cherry Pick](https://www.atlassian.com/git/tutorials/cherry-pick) -- when and how to use cherry-pick effectively.
