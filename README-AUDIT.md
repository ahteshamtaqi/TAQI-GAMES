# TAQI GAMES — audited cinematic/lobby rebuild

## Changes
- Fixed landscape orientation in both Godot project settings and Android export preset (`0` = landscape).
- Added custom `icon.png` and connected it in project/export settings.
- Added a cinematic intro scene with animated island flyover, TAQI GAMES title, skip button and original generated background score.
- Intro transitions to a lobby scene instead of dropping directly into gameplay.
- Lobby contains selectable prototype map and character labels plus Start Match.
- Updated GitHub Actions to run on `main` and `Visual-milestone1`, and validate the new files.

## Important limitations
This is a cleaned-up prototype, not a PUBG-quality finished game. Map and character selection currently update UI labels; they do not yet load distinct maps or character models. The gameplay character is still procedural until a licensed rigged model and animation clips are integrated. No Godot executable is available in this preparation environment, so the project could not be run here; GitHub Actions and device testing are required before merging.

## Upload correctly
Upload/replace the files at the exact paths in this ZIP on `Visual-milestone1`. Keep the `.github/workflows/android-build.yml` included here; it has been updated to build this branch. Commit all changes in one commit, then open Actions and inspect the run. Do not merge PR #1 until the build succeeds and the installed APK opens in landscape, plays intro music, reaches lobby, and starts gameplay.
