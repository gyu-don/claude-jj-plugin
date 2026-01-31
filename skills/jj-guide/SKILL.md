---
name: jj-guide
description: Jujutsu (jj) version control guide for AI agents. Use when working with jj commands, explaining jj concepts, or when jj operations fail.
---

# Jujutsu (jj) for AI Agents

jj is a Git-compatible version control system. Key advantages:
- **Safe experimentation**: `jj undo` reverses any operation
- **Auto-snapshots**: Working copy changes are automatically tracked
- **No staging area**: Simpler than `git add` + `git commit`

## Critical Rules (MUST FOLLOW)

### 1. Always Use `-m` Flag
```bash
# ✅ CORRECT - Non-interactive
jj desc -m "message"
jj squash -m "message"
jj new -m "message"

# ❌ WRONG - Opens editor, fails in non-interactive mode
jj desc
jj squash
```

### 2. Set Up .gitignore BEFORE Creating Files
```bash
# ✅ CORRECT order
echo "*.env" >> .gitignore
echo "secret" > .env  # Will be ignored

# ❌ DANGEROUS - File gets tracked automatically!
echo "secret" > .env  # Gets tracked by auto-snapshot
echo "*.env" >> .gitignore  # Too late - already tracked!
```

**Fix if already tracked**:
```bash
echo "secret.txt" >> .gitignore
jj file untrack secret.txt
```

### 3. Use `jj bookmark`, NOT `jj branch`
```bash
# ✅ CORRECT
jj bookmark create feature-x
jj bookmark list

# ❌ WRONG - deprecated!
jj branch create feature-x
```

### 4. Use `jj undo` Liberally
```bash
# If anything goes wrong:
jj undo
# Try different approach
```

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
jj new -m "Start new work"       # Create new change
jj desc -m "Update message"      # Set commit message
jj desc -r @- -m "Fix parent"    # Update parent's message
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
jj split                         # Interactively split current commit
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
**Cause**: Missing `-m` flag
**Solution**: Always use `-m "message"`

### Error: 403 on Push
**Cause**: Wrong bookmark name or no permission
**Solution**: Check `jj bookmark list` for naming pattern

### Issue: Secret File Tracked
**Cause**: File created before .gitignore
**Solution**:
```bash
echo "secret.txt" >> .gitignore
jj file untrack secret.txt
```

## Common Workflows

### Starting Work
```bash
jj st                           # Check status
# Make changes to files
jj new -m "Implement feature"   # Create checkpoint
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

## Best Practices for AI Agents

1. **Always specify messages with `-m`**
2. **Set up .gitignore before creating files**
3. **Use `jj st` frequently** - Verify no secrets are tracked
4. **Leverage `jj undo`** - Experiment safely
5. **Check `jj op log` when debugging**
