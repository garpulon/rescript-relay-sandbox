# Version Control Guidelines

## Introduction

This document outlines the version control guidelines for Cruise Control.

## Version Control System

We use [Git](https://git-scm.com/) as our version control system and will be
using [GitHub](https://github.com/) to host our repositories.

All repositories should be hosted in the
[Garpulon](https://github.com/garpulon) GitHub organization.

## General Guidelines

- Always pull the latest changes from `develop` (or `main` if you are working on
  a `hotfix` branch) before branching off of it.
- Always make sure to review your changes before committing them.
- Commit early and often.
- Commit messages should be brief but descriptive.

## Branches

### Branching Strategy

There are two main branches: `main` and `develop`. All other branches should be
branched off of one of these two branches. The `main` branch is the production
branch. The `develop` branch is the development branch.

The `main` branch should always be in a deployable state. To achieve this, we
use the following branching strategy:

- `main` is the main branch. It should always be in a deployable state.
- `develop` is the branch that all feature branches are merged into. It should
  always be in a deployable state.
- `feature` branches are branched off of `develop` and are merged back into
  `develop` when the feature is complete.
- `bugfix` branches are branched off of `develop` and are merged back into
  `develop` when the bug is fixed.
- `hotfix` branches are branched off of `main` and are merged back into
  `main` and `develop` when the hotfix is complete.
- `refactor` branches are branched off of `develop` and are merged back into
  `develop` when the refactor is complete.
- `style` branches are branched off of `develop` and are merged back into
  `develop` when the style changes are complete.

### Branch Naming

Branches should be named in the following format:

```
<type>/<name>
```

where `<type>` is one of the following:

- `feature`
- `bugfix`
- `hotfix`
- `refactor`
- `style`
- `test`

and `<name>` is a short description of the branch.

Always make sure to pull the latest changes from `develop` (or `main` if you are
working on a `hotfix` branch) before branching off of it.

### Pull Requests

Pull requests should be made for all branches that are to be merged into
`develop` or `main`. Pull requests should be reviewed by at least one other
team member before being merged.

With the exception of `hotfix` branches, which can be merged directly into
`main`, all branches should be merged into `develop` first. Once a branch is
merged into `develop`, it should be deleted.

Pull request messages should be descriptive and, if applicable, should reference
the issue that the pull request is addressing.

## Commits

### Commit Messages

Commit messages should be written in the following format:

```
<type>: <description>
```

where `<type>` is one of the following:

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (white-space,
  formatting, missing semi-colons, etc)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools and libraries such as
  documentation generation

and `<description>` is a short description of the commit.
