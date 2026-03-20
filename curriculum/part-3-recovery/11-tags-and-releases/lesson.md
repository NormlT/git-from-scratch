# Module 11: Tags & Releases

## TL;DR

Tags mark specific points in history as important (usually releases), and GitHub Releases add downloadable assets and release notes on top.

## The Concept

Tags are permanent bookmarks in your commit history. While branches move forward with each new commit, a tag stays fixed -- it always points to the same commit. This makes tags ideal for marking releases: when you ship version 1.0.0, you tag that exact commit so you can always find it later, even after hundreds of subsequent commits.

There are two types of tags. **Lightweight tags** are just a name pointing to a commit -- like a sticky note on a specific page. **Annotated tags** are the recommended type for releases. They store the tagger's name, email, date, and a message, essentially acting like a commit object dedicated to the tag itself. Use annotated tags for anything you plan to share or publish; use lightweight tags for private/temporary bookmarks.

The convention for naming tags is **semantic versioning**: `vMAJOR.MINOR.PATCH` (for example, `v1.2.3`). The major number changes when you make breaking changes, the minor number changes when you add features, and the patch number changes when you fix bugs. This gives users and tools a clear signal about what to expect from each release.

**GitHub Releases** build on top of git tags. A release takes a tag and adds human-readable release notes, a changelog, and optional downloadable assets (compiled binaries, archives, etc.). The `gh` CLI makes it easy to create releases from the command line. Tags are a git feature; releases are a GitHub feature that uses tags as anchors.

## Key Commands

| Command | What It Does |
|---|---|
| `git tag` | Lists all tags in the repository. |
| `git tag v1.0.0` | Creates a lightweight tag on the current commit. |
| `git tag -a v1.0.0 -m "Release 1.0.0"` | Creates an annotated tag with a message on the current commit. |
| `git tag -a v0.9.0 <commit>` | Creates an annotated tag on a specific past commit. |
| `git show v1.0.0` | Shows the tag details (tagger, date, message) and the commit it points to. |
| `git tag -d v1.0.0` | Deletes a tag locally. |
| `git push origin v1.0.0` | Pushes a specific tag to the remote. Tags are not pushed by default. |
| `git push origin --tags` | Pushes all local tags to the remote. |
| `gh release create v1.0.0` | Creates a GitHub Release from a tag using the GitHub CLI. |
| `gh release list` | Lists all releases in the GitHub repository. |

## Watch

- [Git Tags -- The Net Ninja](https://www.youtube.com/watch?v=govmXpDGLpo) -- practical walkthrough of creating and managing tags.
- [Semantic Versioning Explained -- Fireship](https://www.youtube.com/watch?v=Ob9llA_QhQY) -- short explanation of the v1.2.3 convention and why it matters.

## Read More

- [Pro Git -- Tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging) -- comprehensive coverage of lightweight vs. annotated tags, listing, and sharing.
- [GitHub -- Managing Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository) -- how to create and manage releases on GitHub.
