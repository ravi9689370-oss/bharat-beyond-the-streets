# Android Build — BHARAT: BEYOND THE STREETS

## Prerequisites
- Godot 4.7.2-stable (linux.arm64) — ./godot/
- Android SDK at /opt/android-sdk (adb, build-tools 35/37, platform android-36)
- Android export templates (debug + release)

## Export Templates (BLOCKER)
Godot 4.7 does not publish Android export templates as direct GitHub release assets,
and the tuxfamily /godotengine/ directory is empty. The templates must be obtained
via the Godot editor GUI (Editor -> Manage Export Templates -> Install Android Export
Template) on a machine with a display, then copied to exports/android_templates/.
No physical Android device is connected for on-device testing.

## Build Steps
1. Install Android export templates (debug + release) in Godot editor.
2. Set ANDROID_SDK_ROOT=/opt/android-sdk.
3. In Godot: Project -> Export -> Android -> set APK/AAB output path.
4. Export project -> APK (debug) / AAB (release).
5. Sign release APK/AAB with a keystore (never commit keys).

## CI
See .github/workflows/android.yml for the GitHub Actions pipeline.
ONLINE BUILD: requires export templates + signing credentials (secrets).