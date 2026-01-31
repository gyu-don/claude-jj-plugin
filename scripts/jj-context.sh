#!/bin/bash
# Inject jj context at session start if in a jj repository

jj st >/dev/null 2>&1 || exit 0

# Prevent editor from hanging - fail fast if -m flag is forgotten
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export EDITOR=false' >> "$CLAUDE_ENV_FILE"
fi

cat << 'EOF'
This project uses Jujutsu (jj) for version control instead of git.

Key differences:
- Use `jj bookmark` instead of `git branch`
- Use `jj new` to start new work (creates empty commit)
- Use `jj describe` to set commit messages
- Changes are automatically tracked (no staging/git add needed)
- Use `jj git push` and `jj git fetch` for remote operations

Critical:
- Always use -m flag (jj desc -m "msg", jj new -m "msg")
- Set up .gitignore BEFORE creating sensitive files (jj auto-snapshots everything!)
- Use jj bookmark, NOT jj branch (deprecated)

Common commands:
- jj st - Show status
- jj new -m "message" - Create new commit
- jj describe -m "message" - Set/update commit message
- jj bookmark create <name> - Create bookmark
- jj undo - Undo last operation
EOF
