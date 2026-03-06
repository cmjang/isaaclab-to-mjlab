# OpenCode Adapter

This adapter installs the IsaacLab-to-mjlab migration skill into OpenCode as a full skill directory.

- Global skill directory: `~/.config/opencode/skills/isaaclab-to-mjlab/`
- Project-level skill directory: `<project>/.opencode/skills/isaaclab-to-mjlab/`
- Installed skill contents mirror the repository layout, including `SKILL.md`, `README.md`, `references/`, `shared/`, and `scripts/`

## Installation Methods

### Global Install (default)
Copies or symlinks the full repository layout into your global OpenCode skills directory.

### Project-level Install
Copies or symlinks the full repository layout into your project under `.opencode/skills/isaaclab-to-mjlab/`.

### Symlink vs Copy
- **Symlink**: Points the installed `isaaclab-to-mjlab/` directory at the repository root. Updates to the source are reflected automatically. Recommended for development.
- **Copy**: Copies the repository contents, excluding `.git/`, into the target location. Recommended for production use.

The installer prints an install summary with the exact destination directory after installation.
