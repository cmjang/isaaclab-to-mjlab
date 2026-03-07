# OpenCode Adapter

This adapter installs `mjlab-skillkit` into OpenCode as a full skill directory.

- Global skill directory: `~/.config/opencode/skills/mjlab-skillkit/`
- Project-level skill directory: `<project>/.opencode/skills/mjlab-skillkit/`
- Installed skill contents mirror the repository layout, including `SKILL.md`, `README.md`, `references/`, `shared/`, and `scripts/`

## Installation Methods

### Global Install (default)
Copies or symlinks the full repository layout into your global OpenCode skills directory.

### Project-level Install
Copies or symlinks the full repository layout into your project under `.opencode/skills/mjlab-skillkit/`.

### Symlink vs Copy
- **Symlink**: Points the installed `mjlab-skillkit/` directory at the repository root. Updates to the source are reflected automatically. Recommended for development.
- **Copy**: Copies the repository contents, excluding `.git/`, into the target location. Recommended for production use.

The installer prints an install summary with the exact destination directory after installation.
