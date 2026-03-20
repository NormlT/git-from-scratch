# Module 02: Setup & Config

## TL;DR

Before using git, you need to tell it who you are and how you want to connect to GitHub.

## The Concept

Git needs to know **who you are** before you can make any commits. Every commit is permanently tagged with an author name and email address. This is not about authentication -- it is about attribution. When your teammates look at the project history, they see who wrote each change. If you skip this step, your commits will show up with a default machine name that means nothing to anyone.

Git configuration works at **three levels**, each overriding the one above it:

- **System** (`/etc/gitconfig`) -- applies to every user on the machine. Rarely changed.
- **Global** (`~/.gitconfig`) -- applies to everything you do on this machine under your user account. This is where you set your name, email, default editor, and other preferences.
- **Local** (`.git/config` inside a specific repo) -- applies only to that one repository. Useful when you need a different email for work vs. personal projects.

When git looks up a setting, it checks local first, then global, then system. The most specific level wins.

**SSH keys** are how you prove your identity to GitHub without typing a password every time. Think of it like a lock and key pair: you generate two files -- a private key (which stays on your machine and you never share) and a public key (which you upload to GitHub). When you push or pull, git uses your private key to prove you are who you say you are. The alternative is HTTPS, which works but requires you to enter credentials or use a credential manager. SSH is the standard approach for developers who work with GitHub regularly.

The **GitHub CLI** (`gh`) is a command-line tool that lets you interact with GitHub directly from your terminal -- creating repos, opening pull requests, checking CI status, and more. Running `gh auth status` confirms that your CLI is properly connected to your GitHub account.

## Key Commands

| Command | What It Does |
|---|---|
| `git config --global user.name "Your Name"` | Sets your name for all commits on this machine. |
| `git config --global user.email "you@example.com"` | Sets your email for all commits. Should match your GitHub email. |
| `git config --list` | Shows all current git settings and their values. |
| `git config --list --show-origin` | Same as above but also shows which config file each setting comes from. |
| `git config --global init.defaultBranch main` | Sets the default branch name for new repos to `main`. |
| `ssh-keygen -t ed25519` | Generates a new SSH key pair for authentication. |
| `ssh -T git@github.com` | Tests your SSH connection to GitHub. |
| `gh auth status` | Shows whether the GitHub CLI is authenticated and which account it is using. |

## Watch

- [How to Set Up Git for the First Time -- Corey Schafer](https://www.youtube.com/watch?v=HVsySz-h9r4) (15 min) -- thorough walkthrough of initial git configuration.
- [SSH Keys for GitHub -- Fireship](https://www.youtube.com/watch?v=WgZIv5HI44o) (4 min) -- quick visual explanation of SSH keys and how to set them up.

## Read More

- [GitHub Docs -- Set up Git](https://docs.github.com/en/get-started/getting-started-with-git/set-up-git) -- official guide to installing and configuring git.
- [GitHub Docs -- Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) -- step-by-step guide to generating keys and adding them to your account.
