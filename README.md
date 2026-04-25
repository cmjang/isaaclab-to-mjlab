# mjlab-skillkit

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)

`mjlab-skillkit` is a promotion-ready skill kit for AI coding assistants (Codex, Claude Code, Gemini CLI, Cursor, OpenCode) built around two core capabilities for `mjlab`:

- **IsaacLab Migration Skill** — port IsaacLab projects into clean, mjlab-native implementations while preserving task behavior.
- **mjlab Native Skill** — author new mjlab-native tasks, configs, sensors, RL wiring, and mesh workflows directly from local or bundled mjlab docs and examples.

Chinese users can also discover and install skills through [Skills宝](https://skilery.com).

## Installation

### Interactive Mode

Run the installer to launch the interactive TUI:

```bash
cd mjlab-skillkit
bash scripts/install.sh
```

The TUI supports:

- Multi-select target tools (Codex / Claude Code / Gemini CLI / Cursor / OpenCode)
- Choose install method: `copy` (production) or `symlink` (development)
- Preview target paths before confirming

| Key | Action |
|-----|--------|
| `↑` / `↓` | Navigate |
| `Space` | Toggle selection / switch method |
| `Enter` | Confirm and install |
| `Q` | Quit |

### CLI Mode

```bash
# Install to a single tool
bash scripts/install.sh --tool claude

# Install to all tools at once
bash scripts/install.sh --tool all

# Use symlink (convenient when iterating on rules)
bash scripts/install.sh --tool claude --method symlink

# Specify a project directory (Cursor / OpenCode)
bash scripts/install.sh --tool cursor --project /path/to/your/project
```

### Install Paths

| Tool | Command | Install Location |
|------|---------|-----------------|
| Codex | `--tool codex` | `${CODEX_HOME:-~/.codex}/skills/mjlab-skillkit` |
| Claude Code | `--tool claude` | `~/.claude/rules/mjlab-skillkit.md` |
| Gemini CLI | `--tool gemini` | `~/.gemini/rules/mjlab-skillkit.md` |
| Cursor | `--tool cursor` | `<project>/.cursor/rules/mjlab-skillkit.mdc` |
| OpenCode | `--tool opencode` | `~/.config/opencode/skills/mjlab-skillkit/` or `<project>/.opencode/skills/mjlab-skillkit/` |

> `codex`, `claude`, and `gemini` install to global user paths by default. `cursor` and `opencode` also support `--project` for project-local installs.

## Skill Suite

### 1) IsaacLab Migration Skill

Use this skill when the job is to move an IsaacLab environment, task, or project into `mjlab` without losing behavioral intent.

- Preserves parity for rewards, observations, actions, commands, reset/events, terminations, and curriculum.
- Maps IsaacLab concepts to mjlab APIs, managers, sensors, terrains, RL config, and task registration.
- Enforces mjlab-native outputs instead of compatibility shims.
- Includes migration rules, API mappings, gotchas, checklists, and complex-task playbooks.

### 2) mjlab Native Skill

Use this skill when the job is to build new mjlab-native code directly.

- Authors new tasks, `EnvCfg` / scene configs, manager terms, sensors, terrain setup, RL config, and task registration.
- Reuses local mjlab examples first, bundled references second, online docs only as a last resort.
- Supports direct mesh-import and asset authoring workflows.
- Helps assistants write code that already matches mjlab structure and public APIs.

## What’s Included

- **Migration references** — rules, mappings, patterns, gotchas, checklist, and task migration playbooks.
- **mjlab API pack** — focused docs for envs, managers, scene, sensors, simulation, terrains, RL, viewer, and tasks.
- **Authoring workflow** — step-by-step native mjlab guidance for new code.
- **Assistant adapters** — installation surfaces for Codex, Claude Code, Gemini CLI, Cursor, and OpenCode.

## Who It’s For

- Teams migrating IsaacLab task stacks to `mjlab`
- Engineers building new `mjlab` environments from scratch
- AI-assisted coding workflows that need precise, bounded mjlab guidance
- Internal platform or research teams standardizing mjlab development patterns

## Scope

- Migrate IsaacLab projects to **mjlab-native** code.
- Author new mjlab-native tasks, components, and configurations from scratch.
- Preserve behavior parity where migration is the goal.
- Keep outputs aligned with public mjlab APIs and real task examples.

## Repository Structure

```text
mjlab-skillkit/
├── SKILL.md                             # Main skillkit entry point
├── agents/openai.yaml                   # Codex/OpenAI agent config
├── references/                          # Domain-specific reference docs
│   ├── migration-rules.md               #   Migration rules
│   ├── mapping.md                       #   Field mapping table
│   ├── patterns.md                      #   Common migration patterns
│   ├── checklist.md                     #   Migration checklist
│   ├── migration-gotchas.md             #   Common pitfalls
│   ├── mjlab-api-index.md               #   API index
│   ├── mjlab-api-*.md                   #   Per-domain API references
│   ├── mjlab-mdp-builtins.md            #   MDP built-in functions index
│   ├── mjlab-authoring-workflow.md      #   Authoring workflow
│   ├── mjlab-authoring-recipes.md       #   Authoring recipes
│   ├── mjlab-mesh-import-guidelines.md  #   Mesh import guide
│   ├── complex-task-migration-playbook.md
│   └── tracking-case-study.md
├── shared/mjlab-skillkit-rules.md       # Shared cross-tool rules
├── adapters/cursor/mjlab-skillkit.mdc   # Cursor adapter format
└── scripts/
    ├── install.sh                       # Installer
    └── package.sh                       # Release packager
```

## Release Packaging

```bash
bash scripts/package.sh v0.1.0
```

Generates:

- `dist/mjlab-skillkit-v0.1.0.tar.gz`
- `dist/mjlab-skillkit-v0.1.0.zip`

## Promotion Notes

- Use `PROMO.md` for short-form and long-form launch copy.
- Present the project as a **skill kit** rather than a single migration helper.
- Lead with the two-skill story: **migration** + **native authoring**.

## License

MIT License — see `LICENSE`.