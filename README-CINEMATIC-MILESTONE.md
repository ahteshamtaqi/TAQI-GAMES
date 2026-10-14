# TAQI GAMES — Cinematic + Visual Milestone

This package combines the cinematic opening with the updated game-world prototype.

## Included
- Cinematic intro scene with moving camera over an island-style environment.
- TAQI GAMES title reveal, skip button, timed transition to gameplay.
- Original synthesized cinematic background score at `audio/taqi_cinematic_score.wav`.
- Updated gameplay scene with richer procedural environment and a more detailed soldier-shaped fallback.
- Runtime loading support for `res://assets/characters/character-soldier.glb` if the model is added.
- Existing Android export settings and GitHub Actions workflow retained.

## Important limitation
The cinematic intro and score are implemented in the project, but this package does NOT yet contain a PUBG-quality rigged/animated character. The in-game fallback is made of shapes. A real character asset and matching animation clips still need to be downloaded and added; do not describe this build as PUBG-quality until it has been tested.

## Next steps on phone
1. Extract this ZIP.
2. In the `Visual-milestone1` GitHub branch, upload/replace these paths: `project.godot`, `scenes/cinematic_intro.tscn`, `scenes/main.tscn`, `scripts/cinematic_intro.gd`, `scripts/game.gd`, `scripts/player.gd`, and `audio/taqi_cinematic_score.wav`.
3. Keep `.github/workflows/android-build.yml` and `export_presets.cfg` unchanged.
4. Commit to `Visual-milestone1`.
5. Run the existing GitHub Actions workflow manually and select `Visual-milestone1`.
6. Test intro, audio, skip button, transition, movement and environment on the phone.

## Next character milestone
Add a legally usable rigged human model in GLB format and compatible idle/walk/run/jump/combat animations, then wire them through an AnimationTree or AnimationPlayer. The asset must be tested in Godot before claiming full animation support.
