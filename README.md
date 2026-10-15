# cd to a git worktree

Select one of the current repository's worktrees with [fzf](https://github.com/junegunn/fzf)
and `cd` into it.

## Installation

This depends on [fzf](https://github.com/junegunn/fzf), which needs to be installed manually.

Load `cdw.plugin.zsh` in your `~/.zshrc` or similar, for example with `zgen`:

    zgen load ~/.dotfiles/cdw

## What it does

`cdw` lists the worktrees formatted like `git branch-date`. fzf renders the list bottom-up, so the
most recently committed worktree is closest to the prompt:

        fix/typo  .worktrees/fix_typo (4 weeks ago)
        feature/login  .worktrees/feature_login (2 days ago)
    > * main  . (4 hours ago)
      3/3
    >

- The current worktree is marked with `*` and its branch is green.
- The path is grey and relative to the repository root, or abbreviated with `~` when outside it.
- Detached worktrees show a yellow `(detached <sha>)` instead of a branch.

Any arguments are used as the initial fzf query, which fuzzy-matches both the branch name and the
path. If only one worktree matches, `cdw` changes to it without showing fzf:

    cdw feature/login   # by branch name
    cdw feature_login   # by path: .worktrees/feature_login
    cdw login           # by substring of either
