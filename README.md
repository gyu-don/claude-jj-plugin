# jj Plugin for Claude Code

[Jujutsu (jj)](https://github.com/martinvonz/jj) version control integration for Claude Code and compatible AI agents.

## Features

- **Auto Context Injection**: Automatically injects jj usage guidance at session start when working in a jj repository
- **Auto Snapshot**: Triggers jj snapshot when Claude stops working
- **Setup Skill**: Checks jj installation and configures repositories (`/jj:jj-setup`)
- **Reference Guide**: Comprehensive jj command reference for AI agents (`/jj:jj-guide`)
- **Editor Hang Prevention**: Sets `EDITOR=false` to prevent hangs when `-m` flag is forgotten

## Installation

### From Marketplace (Recommended)

```
/plugin install jj
```

### From Local Directory

```bash
git clone https://github.com/gyu-don/claude-jj-plugin.git
claude --plugin-dir /path/to/claude-jj-plugin
```

## What's Included

```
claude-jj-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── hooks/
│   └── hooks.json           # SessionStart + PostToolUse hooks
├── scripts/
│   ├── jj-context.sh        # Context injection script
│   └── jj-snapshot.sh       # Auto-snapshot script
└── skills/
    ├── jj-guide/
    │   └── SKILL.md         # Comprehensive jj reference
    └── jj-setup/
        └── SKILL.md         # Installation & setup wizard
```

## Usage

### Automatic Behavior

When you start a Claude Code session in a jj repository:

1. **Context Injection**: Claude receives jj-specific guidance including:
   - Key differences from git (bookmarks vs branches, etc.)
   - Critical rules (always use `-m` flag, set up `.gitignore` first)
   - Common commands

2. **Environment Setup**: `EDITOR=false` is set to prevent editor hangs

3. **Auto Snapshot**: jj snapshot is triggered when Claude finishes working

### Manual Skills

- **`/jj:jj-setup`**: Run when jj commands fail or you need to set up a new repository
- **`/jj:jj-guide`**: Access the full jj command reference

## Requirements

- [Claude Code](https://claude.ai/code) v1.0.33 or later
- [Jujutsu (jj)](https://github.com/martinvonz/jj) installed on your system

### Installing jj

- **macOS**: `brew install jj`
- **Linux/Windows**: Download from [GitHub Releases](https://github.com/martinvonz/jj/releases)
- **With Cargo**: `cargo install --locked jj-cli`

## License

MIT
