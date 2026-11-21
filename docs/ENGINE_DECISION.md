# Engine Decision — Godot 4.7.2-stable

## Selection
Godot 4.7.2-stable (linux.arm64) is the primary engine.

## Rationale
- Open source (MIT) — no licensing fees or royalty concerns.
- Lightweight — fits tight memory (3.7GB RAM).
- Android export — GDScript games export to APK/AAB using Android SDK at /opt/android-sdk. No NDK needed for GDScript.
- 3D open-world features — LOD, occlusion culling, frustum culling, NavigationRegion3D, VehicleBody3D, world streaming.
- Headless mode — enables CI testing on this ARM64 box.
- GDScript — fast iteration, maintainable, documented.

## Candidates Considered
| Engine | Fit | Decision |
|--------|-----|----------|
| Godot 4.x | ARM64 binary, light, Android-capable, MIT | SELECTED |
| Unity 6 | Tarball present but heavy; would OOM with 3.7GB RAM | Rejected |

## Android SDK (present at /opt/android-sdk)
- platform-tools: adb, fastboot
- build-tools: 35.0.0, 37.0.0
- platforms: android-36
- Missing: NDK, cmake (not required for GDScript Android export)

## Limitations
- No physical Android device; ADB not connected to a device.
- Android export templates not directly in Godot 4.7 release assets.