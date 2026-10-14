# TAQI GAMES — Visual Milestone 1

Godot 4.3 mobile third-person training-island prototype. This update focuses on making the character and environment more readable while keeping the existing Android export workflow intact.

## What changed
- Replaced the visible two-shape capsule placeholder with a more detailed, procedurally assembled low-poly tactical soldier: helmet, face, torso, vest, pouches, backpack, limbs, boots, gloves and a rifle silhouette.
- Added a player collision shape so the CharacterBody3D can properly stand and move on the ground.
- Expanded the training island with varied tree canopies, rocks, three blockout buildings with collision, windows/doors and supply crates.
- Added a centered crosshair and moved the jump control to a screen-edge anchored position for different phone sizes.
- Preserved the current project structure and `.github/workflows/android-build.yml` export workflow.

## Important limitations
This is a **visual prototype**, not a BGMI/PUBG-quality game. The soldier is procedural low-poly geometry, not a rigged/skinned character model; it does not yet have proper skeletal animations. The rifle is visual only: no shooting, damage, bots, loot interaction, shrinking zone, plane/parachute, vehicles, accounts, rewards, or internet multiplayer have been implemented in this milestone. The buildings are simple blockout geometry. An APK build succeeding only confirms export/packaging, not that the game has been runtime-tested on a phone.

## Build
Upload the contents of this ZIP to the root of the existing `TAQI-GAMES` repository, preserving `.github/workflows/android-build.yml`, then run the existing Android build workflow. Do not replace the workflow if it is already succeeding. Install the resulting APK and test movement, camera, jumping, and collision before proceeding to the next milestone.

## Next milestone
Integrate a properly licensed rigged humanoid model with skeletal animations, then implement an actual weapon/combat loop. Do not describe the current procedural soldier as a realistic production character.
