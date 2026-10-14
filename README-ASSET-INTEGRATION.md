# TAQI GAMES — Asset Integration Milestone

This package improves the scene and world layout and prepares the project to load a real GLB soldier model if it is added.

## Required free character asset
Download the CC0 Kenney Mini Arena soldier model and texture from:
- GLB model: https://api.flockbay.com/bootstrap/library/models/v1/600d1583f26b24116f204a38632b78081ed36138b028cc8cbd1f0e26b5292473/character-soldier.glb
- Texture: https://api.flockbay.com/bootstrap/library/textures/v1/600d1583f26b24116f204a38632b78081ed36138b028cc8cbd1f0e26b5292473/colormap.png

Source/rights: Kenney's Mini Arena character distributed under CC0-1.0 (public domain dedication). Source description: https://flockbay.com/assets/character-soldier/

On your phone, download both files and upload them into the repository on the `Visual-milestone1` branch:
- `assets/characters/character-soldier.glb`
- `assets/characters/Textures/colormap.png`

Godot's GLB loader will use the model automatically when the file exists. Without it, a detailed procedural soldier fallback is drawn; this fallback is not a rigged or animated human.

## Safety for the existing branch
- Keep `.github/workflows/android-build.yml` and the existing Android export settings.
- Commit to `Visual-milestone1`, not `main`.
- Build via GitHub Actions only after the model and texture have been uploaded.
- Do not merge Pull Request #1 until the APK has been installed and tested.

## Scope
This is a visual prototype update, not a complete BGMI/PUBG clone. The included Kenney Mini Arena model is a low-poly static soldier, not a skeletal animated combat character. A rigged, animated soldier is a later asset milestone.
