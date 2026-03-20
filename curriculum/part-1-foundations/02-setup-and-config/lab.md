# Lab 02: Verify Your Git Configuration

## Goal

Verify your git configuration and understand each setting. This lab works with your real system configuration -- no practice repo needed.

## Prerequisites

Module 01 completed.

## Setup

No setup script needed for this module. These exercises work with your actual git and SSH configuration.

```bash
bash setup.sh
```

(The setup script just creates an empty working directory at `/tmp/git-lab-02/` for consistency.)

## Exercises

### 1. See all your current settings

Run `git config --list --show-origin` to see every git setting currently active on your machine, along with the file each setting comes from. Notice how settings can come from different files (system, global, local).

```bash
git config --list --show-origin
```

### 2. Verify your name

Check what name git will attach to your commits. If it is wrong or missing, set it.

```bash
git config user.name
```

To set or update it:

```bash
git config --global user.name "Your Name"
```

### 3. Verify your email

Check your email. This should match the email associated with your GitHub account. If commits use a different email, GitHub will not link them to your profile.

```bash
git config user.email
```

To set or update it:

```bash
git config --global user.email "you@example.com"
```

### 4. Test your SSH connection

Run the SSH test command. If it responds with "Hi username! You've authenticated...", your SSH key is properly configured. If it fails, you will need to generate a key and add it to GitHub (see the lesson's "Read More" links).

```bash
ssh -T git@github.com
```

### 5. Check GitHub CLI authentication

Verify that the GitHub CLI is authenticated and connected to the right account.

```bash
gh auth status
```

### 6. Check your default branch name

See what name git uses when you create a new repository with `git init`. The modern convention is `main`. If this returns nothing or something else, set it.

```bash
git config --global init.defaultBranch
```

To set it:

```bash
git config --global init.defaultBranch main
```

### 7. Explore other useful settings

Check a few more settings that affect your daily workflow:

```bash
# What editor opens for commit messages?
git config --global core.editor

# How does 'git pull' behave? (rebase vs merge)
git config --global pull.rebase

# Are colors enabled in git output?
git config --global color.ui
```

These are optional to change, but good to be aware of. For example, setting `pull.rebase true` avoids unnecessary merge commits when pulling.

## Verify

After completing the exercises, confirm these work:

- `git config user.name` returns your correct name.
- `git config user.email` returns the email linked to your GitHub account.
- `ssh -T git@github.com` responds with a success message.

## Bonus

Open your `~/.gitconfig` file directly in a text editor. It is just a plain text file in INI format. You can edit settings here by hand -- anything you set with `git config --global` is simply written to this file.

```bash
cat ~/.gitconfig
```
