# Game Architecture — BHARAT: BEYOND THE STREETS

## Module Structure (Godot 4.x)
res://
  scenes/            # .tscn scenes
  scripts/           # .gd scripts
  assets/            # textures, models, audio, fonts
  build/             # build output
  exports/           # Android export templates + APK/AAB
  tests/             # test scenes/scripts
  reference/         # research notes, links, style guide
  .planning/         # GSD state, roadmap

## Core Modules (autoload singletons)
- GameManager      — game state, save/load, scene transitions
- World            — region generation, buildings, traffic
- UI               — main menu + HUD
- TimeSystem       — day/night cycle, calendar
- WeatherSystem    — rain, fog, wind, storm
- TrafficManager   — vehicle spawning, lane following
- NPCManager       — NPC schedules, navigation
- EconomySystem    — currency, shops, inventory
- MissionSystem    — missions, objectives, rewards
- FestivalSystem   — festival events, decorations
- InputManager     — touch joystick, buttons, sensitivity
- AudioManager     — mixer, ambience, SFX, music
- SaveSystem       — slots, validation, versioning
- PhysicsConfig    — presets, collision layers/masks

## Physics Timestep
- Fixed physics timestep (60 Hz), decoupled from rendering.
- Collision layers/masks defined consistently.
- Deterministic/reproducible behavior where practical.

## Android First
- Mobile touch controls (joystick + action buttons).
- Low/Medium/High graphics presets.
- Object pooling, NPC/traffic distance scaling.
- World streaming to avoid single-enormous-scene crashes on Android.