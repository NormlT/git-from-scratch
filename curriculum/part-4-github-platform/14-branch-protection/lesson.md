# Module 14: Branch Protection

## TL;DR

Branch protection rules prevent direct pushes to important branches, requiring pull requests and reviews before code can be merged.

## The Concept

On a team, you do not want anyone -- including yourself -- to push directly to `main`. One typo, one untested change, one accidental force push can break the production branch for everyone. Branch protection rules are guardrails that enforce quality gates. Once enabled, they require a pull request (no direct pushes), require at least one approval from a reviewer, require CI checks to pass, and prevent force pushes. This turns best practices into enforced policy.

Think of branch protection like the lock on a bank vault. Even if you are authorized, you still have to go through the proper procedure -- present credentials, get a second person to verify, wait for the time lock. Branch protection works the same way: even the repository owner has to open a PR, wait for tests to pass, and follow the process. This prevents the "it's just a small fix, I'll push it directly" shortcut that inevitably causes an outage on a Friday afternoon.

You configure branch protection in the repository settings on GitHub. The most common settings are: **Require a pull request before merging** (prevents direct pushes), **Require approvals** (someone else must review), **Require status checks to pass** (CI must be green), and **Do not allow force pushes** (protects history). You can also require that PR conversations are resolved before merging, require signed commits, and restrict who can push to matching branches.

GitHub has two systems for this: **classic branch protection rules** and the newer **rulesets**. Classic rules apply per-branch within a single repository. Rulesets are more flexible -- they can target multiple branches with patterns, apply across repositories in an organization, and have an "evaluate" mode that shows what would be blocked without actually enforcing it. For most single-repo use cases, either approach works fine. Organizations managing many repositories benefit from rulesets.

## Key Commands

| Command | What It Does |
|---|---|
| Settings > Branches > Branch protection rules | Where to configure classic branch protection in the GitHub web UI. |
| Settings > Rules > Rulesets | Where to configure the newer rulesets in the GitHub web UI. |
| `gh api repos/{owner}/{repo}/branches/main/protection` | View branch protection rules via the API. |
| `gh api repos/{owner}/{repo}/rulesets` | List rulesets via the API. |
| `gh pr create` | Required workflow when branch protection prevents direct pushes. |
| `gh pr merge` | Merges a PR (only succeeds if all protection requirements are met). |

## Watch

- [GitHub Branch Protection Rules -- DevOps Toolkit](https://www.youtube.com/watch?v=ASOSEiJCRME) -- practical walkthrough of setting up protection rules and understanding each option.
- [Protecting Your GitHub Branches -- Eddie Jaoude](https://www.youtube.com/watch?v=UQnVPBxMSEk) -- beginner-friendly guide to branch protection with real examples.

## Read More

- [GitHub Docs -- About Protected Branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches) -- official reference for all branch protection settings.
- [GitHub Docs -- About Rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) -- guide to the newer rulesets system and how it differs from classic protection.
