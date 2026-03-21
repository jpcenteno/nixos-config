#! /usr/bin/env bash
set -euo pipefail

# Redirect output to stderr.
exec 1>&2

is_protected_branch() {
    [[ "$CURRENT_BRANCH" == "master" || "$CURRENT_BRANCH" == "main" ]]
}

confirm_commit_to_branch() {
    gum confirm \
        "You are about to commit to $CURRENT_BRANCH. Are you sure?" \
        --affirmative 'Commit anyways' \
        --negative 'Abort' \
        --default='no' \
        --show-output
}

CURRENT_BRANCH="$(git branch --show-current)"
if is_protected_branch; then
    if ! confirm_commit_to_branch; then
        exit 1
    fi
fi

REPO_HOOK="$( git rev-parse --absolute-git-dir )}/hooks/pre-commit"
if [ -x "$REPO_HOOK" ]; then
    exec "$REPO_HOOK" "$@"
fi
