---
name: mjlab-skillkit
description: Use when asked to migrate IsaacLab projects to mjlab, compare IsaacLab and mjlab APIs, import meshes into mjlab tasks, or author new mjlab-native tasks/components directly from local or bundled mjlab docs and examples. This skillkit includes an IsaacLab Migration Skill and an mjlab Native Skill. Prefer mjlab public APIs, preserve behavior in migration mode, and avoid compatibility layers.
---

# mjlab-skillkit

## Skill Suite

- **IsaacLab Migration Skill** (`migrate`)
  - Use when there is an IsaacLab source project to port into mjlab-native code.
  - Priority: preserve task behavior while translating APIs, config structure, and registration.
- **mjlab Native Skill** (`author`)
  - Use when writing new mjlab-native tasks, configs, managers, sensors, terrain, RL wiring, or mesh workflows directly.
  - Priority: follow mjlab public APIs, existing task patterns, and bundled references.

> Previously branded as `isaaclab-to-mjlab`.

## Official Repositories

- Migration pattern (official): `https://github.com/mujocolab/anymal_c_velocity`
- mjlab repository (read-only reference): `https://github.com/mujocolab/mjlab`
- IsaacLab repository (source behavior reference): `https://github.com/isaac-sim/IsaacLab`

## Documentation Priority

- Use local `docs/` in the target workspace as source of truth first (for example `mjlab/docs` and `IsaacLab/docs`).
- Read `references/docs-interface-diff.md` before implementation and follow the listed API differences.
- Read `references/mjlab-api-pack.md` for the quick API shortlist.
- Read `references/mjlab-api-index.md` to choose the exact mjlab API domain files you need.
- When writing new mjlab-native code, also read `references/mjlab-authoring-workflow.md`.
- For common coding requests, read `references/mjlab-authoring-recipes.md` and follow the matching minimal recipe instead of exploring broadly.
- Then load only the matching `references/mjlab-api-*.md` and `references/mjlab-mdp-builtins.md` files instead of reading the whole API surface at once.
- Do not bulk-ingest the whole `mjlab/docs` tree or crawl large raw upstream doc sets into context; read only the exact page/signature/example you still need after using the bundled references.
- Fall back to online docs only when local docs are missing or incomplete.

## Reference Resolution Order

- Treat raw paths such as `mjlab/docs/source/...` and `mjlab/src/mjlab/...` as preferred lookup targets only when a local `mjlab/` checkout exists.
- If there is no local `mjlab/` checkout, use this skill's bundled references first:
  - `references/mjlab-api-*.md`
  - `references/mjlab-mdp-builtins.md`
  - `references/mjlab-authoring-workflow.md`
  - `references/mjlab-authoring-recipes.md`
- If the user provides another local mjlab repo path, use that path as the upstream reference root instead of assuming `./mjlab`.
- Use online docs / GitHub only as a last resort for exact upstream signatures or examples missing from both the local checkout and bundled references.
- Do not block `author` mode just because the current workspace has no `mjlab/` directory.

## Working Modes

- `migrate`
  - Use when there is an IsaacLab source task/project to port.
  - Goal: preserve behavior while converting to mjlab-native code.
- `author`
  - Use when writing new mjlab-native code directly.
  - Goal: build tasks/components/configs/scripts that already follow mjlab docs and examples.

If the user does not specify a mode, infer it from the request:
- mentions IsaacLab/source parity/porting -> `migrate`
- mentions write/build/create mjlab task/config/component -> `author`

## Layout Mode (migration only)

- `preserve-layout`:
  - Keep original repository structure and module paths.
  - Only migrate API/config semantics to mjlab.
- `mjlab-layout`:
  - Reorganize into `anymal_c_velocity` style task package layout (for example `src/<task_pkg>/...`).
  - Use `mjlab.tasks` entry points and `register_mjlab_task(...)` for registration.
- If user does not specify, ask first:
  - `Do you want to keep the original project layout, or convert directly to mjlab layout?`

## Shared Workflow

1. Confirm whether the task is `migrate` or `author`.
2. Resolve references in this order: target repo -> local `mjlab/` checkout if present -> bundled skill references -> online docs only if still blocked.
3. Read `references/mjlab-api-pack.md` and lock target APIs.
4. Read `references/mjlab-api-index.md`, then load only the relevant module references:
   - `references/mjlab-api-envs.md`
   - `references/mjlab-api-scene.md`
   - `references/mjlab-api-sim.md`
   - `references/mjlab-api-entity.md`
   - `references/mjlab-api-actuator.md`
   - `references/mjlab-api-sensor.md`
   - `references/mjlab-api-managers.md`
   - `references/mjlab-mdp-builtins.md`
   - `references/mjlab-api-terrains.md`
   - `references/mjlab-api-rl.md`
   - `references/mjlab-api-viewer.md`
   - `references/mjlab-api-tasks.md`
5. If the request involves importing STL / OBJ / other mesh assets, also read `references/mjlab-mesh-import-guidelines.md`.
6. Reuse native mjlab patterns from existing tasks in the target repo first, then from a local `mjlab/` checkout if present, then from bundled references.

## Migration Workflow

1. Confirm migration scope, source path, and target path before editing.
2. Confirm layout mode: `preserve-layout` or `mjlab-layout`.
3. Read `references/migration-rules.md` and enforce all hard constraints.
4. Read `references/docs-interface-diff.md` for API differences from local docs.
5. Read `references/official-migrating-from-isaaclab.md` for boundary notes.
6. Read `references/migration-gotchas.md` for the compressed high-value pitfalls list.
7. If the task is multi-variant / command-heavy / play-eval sensitive, first read `references/complex-task-migration-playbook.md`.
8. If the task is motion tracking / whole-body tracking / reference-motion tracking, then read `references/tracking-case-study.md` as a concrete example, not as the only migration pattern.
9. If the target task family has adjacent tests or registry files, treat them as invariants before editing (for example task `__init__.py` registration files and same-family tests).
10. For complex tasks, first write a variant matrix for base / play / eval / no-state-estimation / low-freq / robot-specific style variants before migrating code.
11. For `mjlab-layout`, align project packaging/registration with `anymal_c_velocity`.
12. Read `references/mapping.md` while replacing imports/fields/term APIs.
13. Read `references/patterns.md` while implementing EnvCfg/SceneCfg/manager structures.
14. If importing STL / OBJ / mesh assets, read `references/mjlab-mesh-import-guidelines.md` and explicitly separate visual mesh from collision representation.
15. Run `references/checklist.md` validation before completion.

## Authoring Workflow

1. Read `references/mjlab-authoring-workflow.md`.
2. Read `references/mjlab-authoring-recipes.md`.
3. Identify the artifact type:
   - new task package
   - new `EnvCfg` or scene
   - new manager terms / MDP helpers
   - new sensors / terrain / RL config / registration
4. Choose the closest example before writing:
   - target-repo example first
   - then local `mjlab/` example if available
   - then bundled skill references if no local `mjlab/` checkout exists
   - velocity-style -> `mjlab/src/mjlab/tasks/velocity/`
   - tracking-style -> `mjlab/src/mjlab/tasks/tracking/`
5. Build the config in mjlab-native order:
   - scene / sensors
   - observations
   - actions
   - commands
   - events
   - rewards
   - terminations
   - curriculum / metrics
   - simulation / viewer / episode settings
6. Prefer existing `mjlab.envs.mdp` helpers before adding custom terms.
7. Prefer the smallest edit surface that satisfies the request:
   - add a term before creating a new subsystem
   - modify robot-specific cfg before cloning a base factory
   - reuse an existing command/reward/event helper before inventing a new class
8. If creating a new task, add RL config plus `register_mjlab_task(...)`.
9. Validate syntax and config wiring before completion.

## Authoring Request Routing

- “Add a reward / penalty” -> `references/mjlab-authoring-recipes.md` + `references/mjlab-mdp-builtins.md`
- “Add an observation / actor-critic input” -> `references/mjlab-authoring-recipes.md` + `references/mjlab-api-managers.md`
- “Add contact / raycast / camera” -> `references/mjlab-authoring-recipes.md` + `references/mjlab-api-sensor.md`
- “Add command / curriculum / reset / DR” -> `references/mjlab-authoring-recipes.md` + `references/mjlab-mdp-builtins.md`
- “Create a new task / new robot env cfg / register a task” -> `references/mjlab-authoring-recipes.md` + `references/mjlab-api-tasks.md` + `references/mjlab-api-rl.md`
- “Import STL / OBJ / mesh assets” -> `references/mjlab-mesh-import-guidelines.md` + `references/mjlab-api-entity.md`
- “Unsure which file to edit” -> first read the “file placement” section in `references/mjlab-authoring-recipes.md`

## Shared Constraints

- Final implementation must be mjlab-native.
- Do not add arbitrary abstractions (extra inheritance/wrappers/major restructuring).
- Do not modify `mujocolab/mjlab` source code.
- Manager configuration must be dict-based (`dict[str, XxxTermCfg]`), not manager `@configclass`.
- Explicitly ban bridge helpers:
  - `manager_terms_to_dict`
  - `AttrDict`
  - `observation_terms_from_class`
- No compatibility layer / adapter shim / transition wrappers.

## Migration Constraints

- Preserve behavior equivalence for rewards, observations, actions, commands, reset/events, terminations, and curriculum.
- Keep function boundaries, call order, and config semantics aligned with source unless mjlab API differences require minimal internal changes.
- Prioritize functional/semantic equivalence over literal code-shape equivalence; if mjlab API constraints prevent a one-to-one implementation, use the smallest mjlab-native adaptation that preserves behavior.
- Do not drop source logic steps, config items, or execution order.
- Remove Isaac/IsaacLab API residue (imports, symbols, stale comments, legacy fields).
- Keep source-specific semantic names (for example `hack_generator`) unless forced field mapping is required.
- Do not keep IsaacLab/Omniverse extension scaffolding by default (`ui_extension_example.py`, `config/extension.toml`, `omni.*` extension files).
- Do not add new `raise` or `assert` if the source task has none, unless a minimal check is explicitly required by mjlab/target API semantics for correctness.
- Do not add fallback logic if the source task has none (no broad `try/except`, no `hasattr`-style fallback branches, no silent degradations), unless a minimal guard is explicitly required by mjlab/target API semantics for correctness.
- Keep original comments/TODOs. If wording must change, only do minimal mjlab terminology updates while preserving meaning.

## Authoring Constraints

- Prefer public `mjlab.*` modules and local task examples before inventing new helper layers.
- Prefer task factories such as `make_xxx_env_cfg()` when a reusable base pattern is helpful.
- Reuse `mjlab.envs.mdp` helper functions/configs whenever they already express the needed behavior.
- Keep new code consistent with existing mjlab task structure, config naming, and registration style.

## Execution Notes

- In `migrate` mode, prefer one-to-one migration, not refactor-oriented rewrite.
- In `author` mode, prefer nearest mjlab-native example, not a framework-agnostic rewrite.
- For API mismatch, use minimal mjlab-native adaptation instead of bridge code.
- When the question is “which mjlab API should replace this IsaacLab piece?”, choose the target module from `references/mjlab-api-index.md` first, then read only the matching reference file.
- For `mjlab-layout`, prefer `anymal_c_velocity` packaging pattern: standalone task package + `mjlab.tasks` entry point + `register_mjlab_task`.
- For `preserve-layout`, keep directory structure and only migrate API/config/registration wiring.
- Managers should be generated via dict factory functions and initialized with `field(default_factory=make_xxx)` when dataclass config style is used.
- If inherited config chains are not supported in target style, flatten them via explicit dict merge/override.
- Follow target project registration conventions (prefer project-level registrar; use `gym.register` only when target project explicitly requires it).
