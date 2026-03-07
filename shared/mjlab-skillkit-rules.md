# mjlab-skillkit Rules

This skillkit packages two core workflows:

- **IsaacLab Migration Skill** for behavior-preserving migration into mjlab-native code
- **mjlab Native Skill** for writing new mjlab-native tasks and components directly

## Goal

- Migrate projects built on IsaacLab to mjlab with behavior equivalence.
- Or author new mjlab-native tasks/components directly from local or bundled docs and examples.
- In migration mode, keep rewards, observations, actions, commands, reset/events, terminations, and curriculum equivalent.
- Use `mujocolab/anymal_c_velocity` as the primary migration pattern when migrating.

## Official References

- Pattern repo: `https://github.com/mujocolab/anymal_c_velocity`
- mjlab repo (read-only reference): `https://github.com/mujocolab/mjlab`
- IsaacLab repo (source behavior reference): `https://github.com/isaac-sim/IsaacLab`

## Mandatory Constraints

- Do not modify `mujocolab/mjlab` source code.
- Final implementation must be mjlab-native.
- No compatibility layer / adapter shim / bridge wrappers.
- In migration mode: preserve behavior/semantics first; if exact source implementation shape does not fit mjlab APIs, use the smallest mjlab-native adaptation that keeps behavior equivalent.
- In migration mode: no new fallback logic unless source has it, except for minimal guards explicitly required by mjlab/target API semantics.
- In migration mode: no new `raise`/`assert` unless source has it, except for minimal checks explicitly required by mjlab/target API semantics.
- In migration mode: keep original comments/TODOs; only do minimal mjlab wording updates when necessary.
- In migration mode: keep source function boundaries, call order, and config semantics.
- In migration mode: keep source-specific semantic names (for example `hack_generator`) unless forced field mapping is required.

## Manager Configuration (Hard Requirement)

- Do not use manager `@configclass`.
- All managers must be dict-based: `dict[str, XxxTermCfg]`.
- Cover all manager groups: `rewards`, `observations`, `actions`, `commands`, `terminations`, `events`, `curriculum`.
- Do not use bridge helpers:
  - `manager_terms_to_dict`
  - `AttrDict`
  - `observation_terms_from_class`

## Key Mapping Reminders

- `asset_name` -> `entity_name`
- `AdditiveUniformNoiseCfg` -> `UniformNoiseCfg`
- `body_pos_w` -> `body_link_pos_w`
- `body_quat_w` -> `body_link_quat_w`
- `body_lin_vel_w` -> `body_link_lin_vel_w`
- `body_ang_vel_w` -> `body_link_ang_vel_w`

## mjlab API Selection Cheat Sheet

- Environment shell: `mjlab.envs.ManagerBasedRlEnvCfg`, `mjlab.envs.ManagerBasedRlEnv`
- Scene composition: `mjlab.scene.SceneCfg`, `mjlab.scene.Scene`
- Manager configs: `mjlab.managers.*TermCfg`, `mjlab.managers.ObservationGroupCfg`
- Common term helpers: `mjlab.envs.mdp.actions`, `mjlab.envs.mdp.observations`, `mjlab.envs.mdp.rewards`, `mjlab.envs.mdp.events`, `mjlab.envs.mdp.metrics`, `mjlab.envs.mdp.terminations`, `mjlab.envs.mdp.dr`
- Sensors: `mjlab.sensor.ContactSensorCfg`, `RayCastSensorCfg`, `CameraSensorCfg`
- Simulation: `mjlab.sim.SimulationCfg`, `mjlab.sim.MujocoCfg`
- Terrain: `mjlab.terrains.TerrainEntityCfg`, `TerrainGeneratorCfg`
- Training: `mjlab.rl.MjlabOnPolicyRunner`, `RslRlOnPolicyRunnerCfg`, `RslRlVecEnvWrapper`
- Task registration: `mjlab.tasks.registry.register_mjlab_task`

## Mode Selection

- `migrate`: there is an IsaacLab source to port.
- `author`: write mjlab-native code directly.

## Layout Mode (Migration Only)

- `preserve-layout`: keep original project structure.
- `mjlab-layout`: reorganize to mjlab style (recommended for new long-term projects).
- If not specified in migration mode, ask user to choose before editing.

## Scope Notes

- IsaacLab-specific extension files are usually not kept (for example `ui_extension_example.py`, extension manifests, Omni UI scaffolding).
- Migration can change internal implementation due to API differences, but end behavior must remain equivalent.
- In authoring mode, resolve references in this order: target repo -> local `mjlab/` checkout if present -> bundled skill references -> online docs only if still blocked.
- In authoring mode, prefer local/bundled mjlab docs plus nearest existing task example before inventing new abstractions.
- Do not bulk-read the whole upstream docs tree into context; open only exact pages/files needed after the bundled references are exhausted.
- In authoring mode, prefer the smallest matching recipe/edit surface before creating new files or helper layers.
