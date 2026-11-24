# Project Doctrine

## Ownership and openness

- The game is offline-first and fully usable without an account, network access, telemetry, subscriptions, or paid services.
- Game code is licensed under MIT. Shipped original assets are licensed under CC0, with their provenance recorded. Do not add assets whose licenses or origins are unclear.
- Favor lightweight, moddable software that works on ordinary PCs and remains under the players' control.

## Legal boundary and mods

- The public repository contains only original work and assets that are explicitly safe to redistribute, such as CC0 assets. Do not commit copyrighted characters, brands, game assets, rips, or unlicensed derivatives.
- Runtime user mods live in the git-ignored `mods/` directory. The repository may include `mods/README.md` as a format example, but not mod content.
- Mods may provide character/kart models, textures, voice clips, and JSON stats. Treat them as optional local content; validate inputs and fall back to the built-in CC0 mascots when content is absent or unusable.
- A player who installs or shares a mod is responsible for having the rights to use and share it. The loader does not grant those rights or make redistribution in this repository acceptable.

## Play and learning

- Optimize for joyful local play, couch co-op, and home LAN parties—not monetization, retention, or data collection.
- Prioritize readable controls and kid-first sensory feedback: responsive handling, expressive animation, sound, color, and satisfying "juice" over photorealism.
- Keep gameplay values in clear, human-readable data files wherever practical. Make safe experimentation easy, explain the effect of important values, and provide sensible defaults.
- Prefer small, understandable systems and incremental slices that can be tested and enjoyed as they are built.
