# Module 05: Pull Request Workflow

## TL;DR

Pull requests are how you propose changes to a shared codebase -- branch, push, open PR, get reviewed, merge.

## The Concept

A pull request (PR) is a formal way of saying "I have some changes on a branch -- please review them and merge them into the main branch." It is the central mechanism for collaboration on GitHub. The word "pull" comes from the idea that you are asking the project maintainer to **pull** your changes into their codebase.

The full PR lifecycle looks like this: you create a branch locally, do your work and make commits, then push that branch to GitHub. On GitHub, you open a pull request which shows all the changes between your branch and the target branch (usually `main`). Other people can now see your changes, leave comments, request modifications, and eventually approve the work. Once approved, the PR gets merged -- your changes become part of the main branch. This process exists because **code review catches bugs, shares knowledge, and keeps code quality high**. It also creates a written record of why changes were made.

There are two main PR workflows. In a **branch-based workflow**, everyone has push access to the same repository and creates branches directly. This is common in teams and private projects. In a **fork-based workflow**, you fork (copy) the entire repository to your own account, make changes there, then open a PR from your fork back to the original. This is how open source contributions work -- you do not need write access to the original repository to propose changes.

A few practical details: when you push a branch for the first time, you use `git push -u origin <branch>` to set up **upstream tracking** (so future pushes just need `git push`). You can create **draft PRs** to signal that work is still in progress. And PR descriptions should explain **what** changed and **why** -- not just restate the code. Good PR descriptions save reviewers time and create useful history.

## Key Commands

| Command | What It Does |
|---|---|
| `git push -u origin <branch>` | Pushes your branch to GitHub and sets up tracking so future pushes are simpler. |
| `git push` | Pushes new commits on a tracked branch to the remote. |
| `gh pr create` | Opens a pull request from the current branch using the GitHub CLI. |
| `gh pr list` | Lists open pull requests in the repository. |
| `gh pr view` | Shows details of the current branch's pull request. |
| `gh pr merge` | Merges a pull request (with options for merge commit, squash, or rebase). |
| `gh pr checkout <number>` | Checks out a pull request's branch locally by PR number. |

## Watch

- [GitHub Pull Request in 100 Seconds -- Fireship](https://www.youtube.com/watch?v=8lGpZkjnkt4) (2 min) -- fast overview of what PRs are and why they exist.
- [How to Make a Pull Request -- Corey Schafer](https://www.youtube.com/watch?v=e3bjQX9jIBk) -- detailed walkthrough of forking, branching, and creating a real PR.

## Read More

- [GitHub Docs -- Creating a Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) -- official step-by-step guide.
- [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow) -- the lightweight workflow built around branches and pull requests.
