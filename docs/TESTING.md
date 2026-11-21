# Testing — BHARAT: BEYOND THE STREETS

## Verified (headless Godot, zero errors)
- Project boots (GameManager autoload, Main scene, input map)
- Player movement (walk/run/sprint/jump), interact raycast
- Vehicle enter/exit + driving physics
- World generation: 14 buildings + 6 traffic vehicles in metro_city
- Camera follow (player & vehicle)
- HUD speed display + main menu (New Game/Continue/Exit)
- Save/load JSON slots (GameManager)

## Test Categories (per project requirements)
- Player movement / jump / interactions / camera
- Vehicle entry / exit / handling / traffic
- Region loading / world transitions / map / weather / day-night / festivals
- Missions / rewards / inventory / economy / achievements / save-load
- Android: install, launch, touch controls, UI scaling, landscape, performance, memory, offline

## Status
Automated headless smoke test: PASS (zero errors). On-device Android testing:
NOT performed (no physical device connected). Full test suite: IN PROGRESS.