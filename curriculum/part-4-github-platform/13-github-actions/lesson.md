# Module 13: GitHub Actions

## TL;DR

GitHub Actions automatically runs tasks -- tests, builds, deploys -- whenever you push code or open a pull request.

## The Concept

GitHub Actions is GitHub's built-in CI/CD system (Continuous Integration / Continuous Deployment). The idea is simple: you define a set of tasks in a YAML file, and GitHub runs them automatically when certain events happen. Push to main? Run the tests. Open a PR? Lint the code and check for security issues. Merge to production? Build and deploy the app. This automation catches problems early, before bad code reaches your main branch.

Workflows live in `.github/workflows/` as YAML files. Each workflow has three layers: **events** (what triggers it), **jobs** (groups of work that run in parallel by default), and **steps** (individual commands within a job). Steps can either run shell commands directly or use **actions** -- pre-built, reusable building blocks from GitHub's marketplace. For example, `actions/checkout@v4` checks out your code, `actions/setup-node@v4` installs Node.js, and there are thousands more for testing, deploying, sending notifications, and everything in between.

Workflows run on GitHub's servers in isolated virtual machines (called **runners**). They cannot access your local machine. Each job gets a fresh VM, does its work, and reports back with a pass/fail status. You can see results in the Actions tab on GitHub, and PR status checks show whether the workflow passed. If you have specific needs, you can also set up **self-hosted runners** on your own servers, but GitHub's hosted runners cover most use cases.

A practical pattern: most repositories have at least one workflow that runs tests on every push and PR. This is the safety net that lets you merge with confidence. As your project grows, you add more workflows -- code formatting checks, dependency audits, automated releases, scheduled maintenance tasks. Start simple and add complexity only when you need it.

## Key Commands

| Command | What It Does |
|---|---|
| `.github/workflows/*.yml` | Where workflow files live. GitHub automatically detects them. |
| `gh workflow list` | Lists all workflows defined in the repository. |
| `gh run list` | Lists recent workflow runs with their status. |
| `gh run view <id>` | Shows details of a specific workflow run. |
| `gh run watch <id>` | Watches a run in progress, streaming its output. |
| `gh run rerun <id>` | Re-runs a failed workflow run. |

## Watch

- [GitHub Actions Tutorial -- Fireship](https://www.youtube.com/watch?v=eB0nUzAI7M8) -- fast-paced overview of what Actions are and how to set up your first workflow.
- [GitHub Actions CI/CD -- TechWorld with Nana](https://www.youtube.com/watch?v=R8_veQiYBjI) -- deeper walkthrough covering CI/CD concepts and real workflow examples.

## Read More

- [GitHub Docs -- Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions) -- official explanation of events, jobs, steps, and how they fit together.
- [GitHub Docs -- Quickstart for GitHub Actions](https://docs.github.com/en/actions/quickstart) -- step-by-step guide to creating your first workflow.
