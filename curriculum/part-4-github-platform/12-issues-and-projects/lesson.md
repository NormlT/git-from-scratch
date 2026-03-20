# Module 12: Issues & Projects

## TL;DR

GitHub Issues track bugs, features, and tasks; Projects organize them into boards for planning.

## The Concept

Issues are like todo items attached to your repository. Each issue has a title, description, labels (bug, feature, documentation), and can be assigned to people. You reference issues in commits and pull requests with `#number`. When you merge a PR that has "Fixes #123" in its description, the issue automatically closes. This linking between issues and code changes creates a clear record of why each change was made.

GitHub Projects (v2) are like Kanban boards for your issues. You can organize issues into columns -- Todo, In Progress, Done -- and drag them between columns as work progresses. Projects support custom fields (priority, estimated effort, sprint), multiple views (board, table, roadmap), and automation (move an issue to Done when its PR merges). They are great for planning sprints, tracking release progress, or managing a backlog of work.

Labels are the primary way to categorize issues. Common labels include `bug`, `feature`, `documentation`, `good first issue`, and priority levels. You can create custom labels with any name and color. Milestones group issues into release targets -- you create a milestone called "v1.0", assign issues to it, and GitHub shows you what percentage of work is complete. Together, issues, labels, milestones, and projects give you a full project management system without leaving GitHub.

One important pattern: when you start work on an issue, create a branch named after the issue (like `fix-login-layout` or `42-add-auth`), do your work there, and open a PR that references the issue number. This keeps everything connected -- the issue links to the PR, the PR links back to the issue, and merging closes the issue automatically.

## Key Commands

| Command | What It Does |
|---|---|
| `gh issue create --title "Bug" --body "Description"` | Creates a new issue with the given title and body text. |
| `gh issue list` | Lists all open issues in the current repository. |
| `gh issue view <number>` | Shows the details of a specific issue by its number. |
| `gh issue close <number>` | Closes an issue (marks it as resolved). |
| `gh issue edit <number> --add-label "bug"` | Adds a label to an existing issue. |
| `gh label create "priority:high" --color "FF0000"` | Creates a custom label with a name and color. |
| `gh project list` | Lists GitHub Projects in the current repository or organization. |
| `gh project create --title "Sprint 1"` | Creates a new GitHub Project board. |

## Watch

- [GitHub Issues and Projects -- GitHub](https://www.youtube.com/watch?v=oPQgFxHcjAw) -- official overview of how issues and projects work together for planning.
- [GitHub Project Management -- codeSTACKr](https://www.youtube.com/watch?v=RXEy6CFu9Hk) -- practical walkthrough of setting up project boards and workflows.

## Read More

- [GitHub Docs -- About Issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/about-issues) -- official guide to creating, labeling, and managing issues.
- [GitHub Docs -- About Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects) -- how to use the newer Projects (v2) boards for planning.
