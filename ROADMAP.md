# Roadmap

Build and verify one playable slice at a time. Every milestone preserves offline single-machine play; networking is an optional later layer.

## Milestone 1 — The Couch Demo

Deliver a small, immediately playable local demo:

- Responsive, flip-proof rolling-sphere arcade kart handling.
- Three drift-charge tiers with distinct sparks, sound, and boost feedback.
- Cohesive low-poly look with toon lighting and readable speed/boost "juice."
- Keyboard and gamepad input, usable together.
- Two-player split-screen on one machine.
- A documented, data-driven `mods/` loader contract and git-ignored local mod directory, with a built-in CC0 fallback.
- Expose handling and drift tuning values in human-readable configuration.

## Milestone 2 — Items, AI Pathing & VS Circuit Barriers

- Add a small set of readable arcade items and host-independent local race rules.
- Create reusable AI routes and difficulty settings; verify racers can follow and complete a circuit.
- Use dynamic holographic barriers to close side roads and define lap circuits or point-to-point sprints on the shared map.
- Add a quick VS race flow and results screen.

## Milestone 3 — Connected Island & Tour Modes

- Connect Sunny Coast, Volcano Ridge, Neon Boardwalk, and Forest Loop with traversable boost highways and no zone-transition loading screens.
- Add Free Roam exploration, coins, jump ramps, and short P-Switch challenges.
- Add Path3D-based magnetic grind rails and their launch boosts.
- Add multi-stage Knockout Tour checkpoints and racer elimination.
- Keep the island usable as a shared world for the existing race modes.

## Milestone 4 — LAN Parties & Grand Prix

- Add zero-configuration LAN discovery beacons and ENet session joining, with clear host/join status.
- Support multiple local split-screen players on each LAN machine; synchronize karts and keep items/checkpoints host-refereed.
- Add a Free-Roam waiting room and four-race Grand Prix cups with podium results.
- Support an optional headless server suitable for a home NAS; preserve offline and couch-only play when no server is present.
