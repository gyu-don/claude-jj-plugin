---
name: jj-setup
description: Jujutsu (jj) installation checker and repository setup. Use when jj commands fail or repository needs initialization.
allowed-tools: Bash
---

# jj Setup

## 1. Check jj Installation
```bash
jj --version
```

If not installed:
- **macOS**: `brew install jj`
- **Linux/Windows**: Download binary from https://github.com/martinvonz/jj/releases
- **Alternative (if cargo available)**: `cargo install --locked jj-cli`

## 2. Check Repository Status
```bash
jj status
```

If not initialized:
- New repo: `jj git init`
- Existing git repo: `jj git init --colocate`

## 3. Check User Configuration
```bash
jj config list user.name
jj config list user.email
```

If not configured, ask the user then:
```bash
jj config set --user user.name "Name"
jj config set --user user.email "email@example.com"
```

## 4. Check .gitignore (Important!)

jj auto-snapshots all files. Ensure security-sensitive files are ignored:

```bash
# Check if .gitignore exists
cat .gitignore 2>/dev/null || echo "(no .gitignore)"
```

At minimum, these should be ignored (add if missing):
```
.env
.env.*
*.pem
*.key
credentials.json
secrets/
```

For language-specific entries (node_modules, __pycache__, etc.):
- Check existing project conventions
- Or ask user what to add

## 5. Verify Setup
```bash
jj st
jj log --limit 3
```

Report:
- jj version
- Repository status
- User configuration
- .gitignore status
