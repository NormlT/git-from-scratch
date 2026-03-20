# Module 17: Public Repo Best Practices

## TL;DR

Before making a repo public, ensure no secrets are in the history, you have a license, and your .gitignore catches sensitive files.

## The Concept

Making a repository public means anyone in the world can see everything -- including the full git history. This is the part that trips people up: a secret committed in an early commit and then "deleted" in a later commit is still in the history. Anyone can run `git log --all -p` and find it. Deleting a file does not erase it from git -- it just records a new commit where the file is gone. The old commits with the file still exist. This is why you hear about companies leaking AWS keys even though "we removed it right away." If it was pushed, it's compromised.

`.gitignore` prevents files from being tracked, but it only works going forward. If you already committed a `.env` file and then add `.env` to `.gitignore`, the file is still in your history. `.gitignore` is preventive, not curative. Get your `.gitignore` right from the start -- GitHub provides templates for most languages and frameworks. Common patterns to ignore include `.env` files, `*.pem` and `*.key` files, IDE settings, and build artifacts.

`CODEOWNERS` is a file that defines who must review changes to specific paths. If your repo has a `/config/` directory with sensitive settings, you can require that only senior team members can approve changes there. This is especially important for public repos where anyone can submit a pull request. `LICENSE` tells people what they can legally do with your code. No license means all rights reserved -- people can look at your code but technically cannot use, modify, or distribute it. If you want others to use your code, you need a license. MIT and Apache 2.0 are permissive (do whatever you want, just give credit). GPLv3 requires derivative works to also be open source.

Before going public, run a thorough audit: search the history for secrets with `git log --all -p -S "password"`, verify your `.gitignore` covers all sensitive patterns, choose an appropriate license, set up CODEOWNERS for critical paths, and write a clear README. If you find secrets in history, the only real fix is `git filter-repo` to rewrite the history entirely -- and even then, assume the secret was compromised and rotate it.

## Key Commands

| Command | What It Does |
|---|---|
| `.gitignore` | File listing patterns of files git should never track (e.g., `.env`, `*.key`). |
| `git log --all -p -S "password"` | Searches the entire git history for commits that added or removed the string "password." |
| `CODEOWNERS` | File (in root or `.github/`) that specifies required reviewers for file paths. |
| `LICENSE` | File declaring the legal terms under which your code can be used. |
| `git filter-repo --invert-paths --path <file>` | Rewrites history to permanently remove a file from all commits (nuclear option). |
| `gh repo edit --visibility public` | Changes a GitHub repository from private to public. |

## Watch

- [Open Source Best Practices -- Fireship](https://www.youtube.com/watch?v=yzeVMecydCE) -- fast-paced overview of what to do before open-sourcing a project.
- [Git Filter-Repo -- GitKraken](https://www.youtube.com/watch?v=z3b5V5GCwK4) -- how to use git-filter-repo to rewrite history and remove sensitive data.

## Read More

- [GitHub Docs -- Best practices for repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/best-practices-for-repositories) -- official checklist for well-maintained repositories.
- [GitHub Docs -- Removing sensitive data from a repository](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository) -- step-by-step guide to cleaning secrets from git history.
