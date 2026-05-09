# Changelog

All notable changes to this project are documented here. The format is loosely based on [Keep a Changelog](https://keepachangelog.com/), and this project follows [Semantic Versioning](https://semver.org/).

## [v2.0.0] -- 2026-05-09

### Breaking changes
- **Removed Claude Code slash commands** `/lab` and `/redo`. The interactive lab experience has moved to a self-contained Python CLI (`lab.py`). Anyone on the old workflow needs to install Python 3.9+ and run `python lab.py` instead of typing `/lab` inside Claude Code.
- **Guided mode now requires** an OpenRouter API key and the `openai` package. Self-guided (markdown-only) mode is unaffected.

### Added
- `lab.py` -- new Python CLI. Subcommands: `lab` (next module), `lab NN` (jump to module), `redo` (reset current module), `redo course` (reset entire course), `--version`. The full system prompt instructs the model on the teaching protocol (one command per message, Predict sub-flow, GitHub auth precondition, quote-back, strict completion-token contract).
- `requirements.txt` -- pinned to `openai==1.109.1`.
- `requirements.lock.txt` -- full transitive dependency lock (16 packages).
- `.env.example` -- placeholder for `OPENROUTER_API_KEY` and `OPENROUTER_MODEL`.
- `.gitleaks.toml` -- allow-list for the educational fake credentials in Modules 10 and 17 (which intentionally commit fake secrets to teach credential hygiene).
- Safe-rm guards in all 17 `curriculum/*/*/setup.sh` scripts (`[[ "$LAB_DIR" == /tmp/git-lab-* ]] || exit 1` before every destructive line).
- README "Tested end-to-end" callout, model recommendation table (4 tiers), and per-tier cost projection table backed by a real measured $0.40 full-course run on `google/gemini-3.1-flash-lite-preview`.

### Changed
- README rewritten with `uv`-first and `venv + pip` install paths, explicit Python 3.9+ prerequisite, and PEP 668 explanation.
- `.gitignore` now keeps project-level `.claude/` files tracked (only nested per-module overlays under `curriculum/**/.claude/` are ignored), adds `__pycache__/` and `*.pyc`, and uses `!.env.example` to keep the example env file tracked while ignoring real `.env*` files.
- `.github/copilot-instructions.md`, `.claude/CLAUDE.md`, and `.claude/rules/repo-primer.md` now point at `lab.py` as the source of truth for teaching rules.
- `lab.py` exception handling narrowed from bare `except Exception` to `(openai.APIError, openai.APIConnectionError, httpx.HTTPError)` so genuine bugs surface instead of being masked as "network errors" (CN-003).
- Modules 10 and 17 setup scripts now have `DELIBERATELY BAD` header comments explaining why credential-pattern scanners flag them.

### Verified
- Full 17-module sweep on `google/gemini-3.1-flash-lite-preview`: **17/17 modules complete cleanly**, 0 HIGH severity issues, $0.40 total measured cost.
- The teaching system prompt was hardened across 6 rounds of automated cooperative-learner testing.
- Security re-scan after audit fixes: `trivy`, `pip-audit`, `gitleaks`, `semgrep` all return zero findings.
- All 17 setup scripts pass `bash -n` syntax check; one was smoke-tested end-to-end.

### Security audit (cyber-neo CN-001..006)
- **CN-001** Pinned `openai` to exact version (was `>=1.50,<2`).
- **CN-002** Documented the educational fake credentials in Modules 10/17 setup scripts.
- **CN-003** Narrowed broad `except Exception` in `lab.py:474`.
- **CN-004** Added `requirements.lock.txt`.
- **CN-005** Resolved `.gitignore` inconsistency around tracked `.claude/` files.
- **CN-006** Added safe-rm guards in all 17 `setup.sh` files.

### Removed
- `.claude/commands/lab.md`
- `.claude/commands/redo.md`

---

## [v1.0.0] -- 2026-03-20

### Initial release
Complete 17-module Git/GitHub course, designed to be guided by Claude Code's `/lab` slash command:

- Part 1: Foundations (what is git, setup, basics)
- Part 2: Branching & Collaboration (branches, PRs, merging, rebasing, stashing)
- Part 3: Recovery & History (undo, cherry-pick, tags)
- Part 4: GitHub Platform (issues, actions, branch protection)
- Part 5: Security (account, repo, public repo best practices)

Each module includes lesson material, curated video links, and hands-on lab exercises.

[v2.0.0]: https://github.com/clatter971/git-from-scratch/releases/tag/v2.0.0
[v1.0.0]: https://github.com/clatter971/git-from-scratch/releases/tag/v1.0.0
