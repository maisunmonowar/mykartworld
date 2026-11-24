# Local mods (not distributed with the game)

Place optional user-installed content in this directory. Everything here except this README is git-ignored and is not part of the public game repository.

The loader contract will support custom character/kart `.glb` models, textures, voice clips, and JSON stat configs. A future schema example could look like:

```json
{
  "id": "example-kart",
  "display_name": "Example Kart",
  "stats": {
    "top_speed": 24.0,
    "acceleration": 12.0,
    "handling": 1.0
  }
}
```

This is illustrative, not a finalized schema. Keep values within the limits documented by the game. Missing or invalid optional content must leave the built-in CC0 mascots playable.

Only install or share content you have permission to use and redistribute. This directory is not a place for copyrighted game rips or unlicensed characters, brands, models, textures, or audio.
