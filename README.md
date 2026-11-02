# Super Mario Bros (Flame study)

A fan-made learning project that rebuilds the basics of a classic side-scrolling platformer level in Flutter with the [Flame](https://flame-engine.org) engine and a Tiled map. It's a study of platformer physics, tile-map loading and block interactions, not a full game. Not affiliated with or endorsed by Nintendo.

## What works

- **Movement and physics**: left/right with the arrow keys, jump with `Space`; gravity, a capped fall speed and ground detection from collision normals (`lib/actors/mario.dart`).
- **Animations**: idle, running and jumping states with `SpriteAnimationGroupComponent`.
- **Blocks**: hitting a block from below bumps it; mystery blocks switch to an empty block after the first hit, and brick blocks can crumble (`lib/objects/blocks/`).
- **Enemy**: Goombas patrol back and forth with a move effect.
- **Camera** follows the player and is bounded to the level.
- **Pause**: `A` pauses and resumes the engine.
- Sound effects for jumping, bumping, breaking blocks and pausing.

## How it works

`SuperMarioBrosGame` (`lib/games/super_mario_bros.dart`) sets up a `CameraComponent` and loads a `LevelComponent`. The level (`lib/level/level_component.dart`) reads the Tiled map in `assets/tiles/` and builds components from its object layers:

| Tiled layer | Objects created |
|---|---|
| `Blocks` | `MysteryBlock`, `BrickBlock` |
| `Platforms` | `Platform` colliders |
| `Actors` | `Mario`, `Goomba` |

```
lib/
├── main.dart
├── games/super_mario_bros.dart
├── level/          # LevelComponent, LevelOption (map paths)
├── actors/         # player and Goomba
├── objects/        # platform, blocks
└── constants/      # globals (asset names), animation configs, sprite sheets
assets/
├── tiles/          # .tmx map and .tsx tileset
├── images/
└── audio/
```

## Tech stack

- Flutter with Dart `>=2.19.6 <3.0.0` (pre-Dart 3)
- `flame` 1.8, `flame_tiled`, `flame_audio`

## Running it

Use a Flutter SDK that still supports Dart 2.19 (Flutter 3.7.x). Keyboard controls make desktop or web the easiest target.

```sh
flutter pub get
flutter run -d macos     # or -d chrome / -d windows
```
