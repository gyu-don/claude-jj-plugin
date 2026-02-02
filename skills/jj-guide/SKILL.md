---
name: jj-guide
description: Jujutsu (jj) version control guide for AI agents. Use when working with jj commands, explaining jj concepts, or when jj operations fail.
---

# Jujutsu (jj) for AI Agents

jj is a Git-compatible version control system. Key advantages:
- **Safe experimentation**: `jj undo` reverses any operation
- **Auto-snapshots**: Working copy changes are automatically tracked
- **No staging area**: Simpler than `git add` + `git commit`

## Critical Rules

### Always Use `-m` Flag (except `jj new`)
Commands that set messages open an editor without `-m` and fail:
```bash
jj desc -m "message"        # ✅
jj squash -m "message"      # ✅
jj desc                     # ❌ Opens editor, fails
```

`jj split` and `jj commit` also need file paths to avoid interactive mode:
```bash
jj split -m "msg" file.txt  # ✅
jj commit -m "msg" file.txt # ✅
jj split -m "msg"           # ❌ Interactive file selection
```

Exception: `jj new` works without `-m` (creates empty change):
```bash
jj new -m "Start feature"  # ✅ Recommended
jj new                     # ✅ OK, describe later
```

### Use `jj bookmark`, NOT `jj branch`
`jj branch` is deprecated:
```bash
jj bookmark create feature-x  # ✅
jj branch create feature-x    # ❌ Deprecated
```

### ⚠️ SECURITY: .gitignore BEFORE Creating Files
**jj auto-tracks ALL files immediately.** Secrets created before .gitignore are tracked and may be pushed:
```bash
# ✅ SAFE: gitignore first
echo "*.env" >> .gitignore
echo "secret" > .env

# ❌ DANGER: Secret is already tracked!
echo "secret" > .env
echo "*.env" >> .gitignore  # Too late!
```
**If already tracked**:
```bash
echo ".env" >> .gitignore   # First! Otherwise re-tracked
jj file untrack .env
```
⚠️ Note: Past snapshots still contain the file.

## Essential Commands

### Status & History
```bash
jj st                    # Current status
jj log --limit 5         # Recent commits
jj op log --limit 5      # Recent operations (for undo)
jj diff                  # Changes in working copy
jj file search "pattern" # Search file contents (like git grep)
```

### Working with Changes
```bash
jj new -m "Start new work"        # Create new change
jj desc -m "Update message"       # Set commit message
jj desc -r @- -m "Fix parent"     # Update parent's message
```

### Splitting Changes
Both require `-m` and file paths to avoid interactive mode:
```bash
# jj commit: only works on @ (working copy), doesn't move bookmarks
jj commit -m "Extract" file.txt

# jj split: works on any revision with -r, moves bookmarks to child
jj split -m "Extract" file.txt
jj split -r @- -m "Extract from parent" file.txt
```

### History Manipulation
```bash
jj edit @-                # Switch to editing parent
jj squash -m "Combine"    # Squash into parent
jj undo                   # Undo last operation
```

### Sharing (Bookmarks)
```bash
jj bookmark list                              # List bookmarks
jj bookmark create <name>                     # Create bookmark
jj bookmark set <name>                        # Move bookmark to current commit
jj bookmark delete <name>                     # Delete bookmark
```

### Bookmark Tracking (for Git remotes)
```bash
# Track remote bookmark (required for push/pull)
jj bookmark track <name> --remote origin

# Or track all remotes with same name
jj bookmark track <name>

# Push to remote (must track first)
jj git push --bookmark <name>

# After fetch, remote bookmarks appear as <name>@origin
jj git fetch
jj log -r 'main@origin'
```

### Remote Operations
```bash
jj git fetch                     # Fetch from all remotes
jj git fetch --remote origin     # Fetch from specific remote
jj git push                      # Push current bookmark
jj git push --bookmark <name>    # Push specific bookmark
```

### Advanced Operations
```bash
jj restore <file>                # Restore file to parent's version
jj restore --from @-- <file>     # Restore from specific revision
jj absorb                        # Auto-absorb changes into ancestors
jj abandon @                     # Discard current commit
```

## Key Concepts

### Three Types of IDs
- **Change ID**: Stable identifier (survives rebases)
  - For divergent commits: `xyz/0` (latest), `xyz/1` (previous)
- **Commit ID**: SHA hash (changes with edits)
- **Operation ID**: Each jj command creates one (enables undo)

### Revset Syntax
```bash
@     # Current working copy
@-    # Parent
@--   # Grandparent

jj log -r @-            # Show parent
jj desc -r @- -m "msg"  # Edit parent's message
jj diff -r @-           # Diff against parent
```

**Note**: String patterns in revsets default to glob matching.
Use `substring:` or `exact:` prefix if needed:
```bash
jj log -r 'author(substring:"john")'
```

## Common Errors & Solutions

### Error: Editor Opens
**Cause**: Missing `-m` flag on `jj desc`, `jj squash`, `jj split`, etc.
**Solution**: Use `-m "message"` (except `jj new`)

### Error: 403 on Push
**Cause**: Wrong bookmark name or no permission
**Solution**: Check `jj bookmark list` for naming pattern

### Secret File Tracked
See Critical Rules above. Add to .gitignore first, then `jj file untrack <file>`.

## Common Workflows

### Starting Work
```bash
jj st                           # Check status
jj new -m "Implement feature"   # Create new change BEFORE starting work
# Make changes to files
jj new -m "Add tests"           # Create next change when ready to move on
```

### Cleaning History
```bash
jj log --limit 5
jj desc -r @- -m "Better message"
jj squash -m "Combined changes"
```

### Pushing to Remote
```bash
jj bookmark create feature-x
jj bookmark track feature-x --remote=origin
jj git push --bookmark feature-x
```

### When Something Goes Wrong
```bash
jj op log --limit 3    # Check what happened
jj undo                # Undo if needed
```

## Colocated Mode (jj + Git)

When working with both jj and Git:
- Use jj for all operations
- Git shows jj's working copy as "detached HEAD" (normal)
- Don't use `git commit` or `git checkout` (causes state mismatch)

## Best Practices

### Use `jj new` Frequently
Create commits at `git commit` granularity or finer. Unlike git, `jj new` is cheap—use it:
- Before starting a new logical unit of work
- After completing a feature or fix
- When switching context

### Use `jj undo` Liberally
If anything goes wrong, `jj undo` reverses the last operation. Experiment freely.

### Verify with `jj st`
Check status frequently to ensure no secrets are tracked.

### Debug with `jj op log`
When something goes wrong, `jj op log --limit 5` shows recent operations.
