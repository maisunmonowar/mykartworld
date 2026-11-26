# MyKartWorld

An offline-first, moddable kart-racing playground focused on playful local and couch multiplayer. This is an early prototype; the current build is a practice arena, not a complete game.

## Run the prototype

1. Install the standard Godot 4 editor. This project uses GDScript and does not need the .NET edition.
2. Open **Godot Project Manager**, select **Import**, and choose this repository's `project.godot`.
3. Open the imported project and press **F5** to run it.
4. On the title screen, choose **ENTER PRACTICE ARENA**.

Godot does not need to be on your `PATH` when launched this way. The project is configured for the GL Compatibility renderer. It has been checked with Godot 4.7.2; visual appearance and keyboard feel still need hands-on play-testing.

## Current controls

| Action | Keyboard | Gamepad |
| --- | --- | --- |
| Accelerate | W | Right trigger |
| Brake | S | Left trigger |
| Steer left | A | Left stick or D-pad |
| Steer right | D | Left stick or D-pad |

Braking slows the sphere to a stop; reverse, drift, and boosts are not implemented yet. Gamepad bindings are configured but still need testing with a physical controller.

## Tune handling

Edit `configs/kart_handling.cfg` with a text editor, then restart the game to load the new values. For a clear first comparison, change `max_speed_mps` from `24.0` to `12.0`; while holding W, the sphere should reach a lower top speed. Units for every setting are documented in the config.

## Current prototype

- A title screen that opens the practice arena.
- A flat arena with visible, collidable boundaries.
- A follow camera and a spherical placeholder racer.
- Basic keyboard acceleration, braking, steering, and a speed cap.

Handling values are loaded from `configs/kart_handling.cfg`. Edit the values there and restart the game to try a different feel; units are documented in the file. The next planned slice after input play-testing is drift charging.

## Project layout

- `scenes/` — Godot scenes, including the title screen and practice arena.
- `scripts/` — menu, chase-camera, and kart-controller scripts.
- `configs/` — human-readable gameplay tuning data.
- `assets_cc0/` — reserved for shipped assets with clear CC0 provenance.
- `mods/` — local user mods; runtime mod content is git-ignored.
- `DOCTRINE.md` — project principles, licensing boundaries, and mod policy.
- `ROADMAP.md` and `TODO.md` — planned milestones and implementation checklist.

The project currently uses only built-in Godot primitives and does not require network access or external assets to run.
