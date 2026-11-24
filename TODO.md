# Milestone 1 — The Couch Demo

Complete each slice in order. Run it in Godot and visually verify the listed result before moving on.

- [ ] **Bootable shell:** Create the minimal Godot 4 project and a launchable main scene. Verify it opens and runs without errors.
- [ ] **Test arena:** Add a simple flat practice area, visible boundaries, and a chase camera. Verify the whole driving area stays readable on screen.
- [ ] **Drive one kart:** Add arcade acceleration, braking, steering, and a configurable speed cap. Verify it starts, stops, turns, and remains upright.
- [ ] **Tune from data:** Put core handling values in a human-readable config with documented units. Change one value and verify the kart visibly responds.
- [ ] **Use either device:** Add keyboard and gamepad actions through the same input mapping. Verify both can steer and accelerate without switching modes.
- [ ] **Charge a drift:** Add drift initiation and charge progression through Blue, Orange, and Purple. Verify each tier has a distinct spark effect and rising audio pitch.
- [ ] **Release the boost:** Apply a tier-scaled boost when a drift ends. Verify a longer charge produces a stronger, visible speed burst.
- [ ] **Add visual juice:** Apply a restrained toon/rim-lit look and clear acceleration/boost feedback. Verify kart and arena remain legible at speed.
- [ ] **Split the couch:** Add two-player local play with separate controls and SubViewport cameras. Verify both players can drive at once and remain visible.
- [ ] **Define the mod contract:** Document the expected local mod layout and JSON stats in `mods/README.md`; load optional content with validation and a built-in CC0 fallback. Verify the default game works with no `mods/` content installed.
- [ ] **Demo pass:** Run the full two-player flow from launch through driving and drift boosts. Verify it works offline on keyboard and gamepad and that tuning edits take effect.
