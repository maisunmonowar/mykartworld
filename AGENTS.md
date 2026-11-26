# Agent instructions

Read `DOCTRINE.md`, `ROADMAP.md`, and `TODO.md` before making project changes. Keep the game offline-first, lightweight, moddable, and within the project's asset and licensing boundaries.

## Collaboration preferences

- Work in small, playable slices and keep changes focused.
- After a playable slice is ready, explain how to launch it and pause for the user's play-test feedback before starting the next feature.
- The user wants to learn the Godot setup later. Give clear launch steps without assuming Godot is on `PATH`; save longer explanations for when they ask.
- Distinguish headless engine checks from visual or hands-on play-testing. Do not claim visuals or controls were verified unless they were actually tested that way.
- Keep the user informed about current controls, known limitations, and the next planned step.

## Project practices

- Prefer built-in Godot primitives and original assets with clear redistribution rights.
- Do not add copyrighted game characters, brands, rips, or assets with unclear provenance.
- Keep gameplay values understandable and move tuning into human-readable data where practical.
- Preserve offline single-player and local multiplayer. Do not add accounts, telemetry, paid services, or required online features.
- Run the smallest relevant Godot validation after changes and report any validation that could not be performed.
