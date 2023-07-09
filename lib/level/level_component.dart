import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:super_mario_bros/actors/mario.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/games/super_mario_bros.dart';
import 'package:super_mario_bros/level/level_option.dart';
import 'package:super_mario_bros/objects/platform.dart';

class LevelComponent extends Component with HasGameRef<SuperMarioBrosGame> {
  final LevelOption option;

  late Rectangle _levelBounds;

  late Mario _mario;

  LevelComponent(this.option) : super();

  @override
  Future<void>? onLoad() async {
    // Apply main level to canvas.
    final TiledComponent level = await TiledComponent.load(
      option.path,
      Vector2.all(Globals.tileSize),
    );

    gameRef.world.add(level);

    // Set on screen boundaries for Mario.
    _levelBounds = Rectangle.fromPoints(
      Vector2(
        0,
        0,
      ),
      Vector2(
            level.tileMap.map.width.toDouble(),
            level.tileMap.map.height.toDouble(),
          ) *
          Globals.tileSize,
    );

    print(_levelBounds);

    createPlatforms(level.tileMap);
    createActors(level.tileMap);

    _setupCamera();

    return super.onLoad();
  }

  // Create Platforms.
  void createPlatforms(RenderableTiledMap tileMap) {
    // Create platforms.
    ObjectGroup? platformsLayer = tileMap.getLayer<ObjectGroup>('Platforms');

    if (platformsLayer == null) {
      throw Exception('Platforms layer not found.');
    }

    for (final TiledObject obj in platformsLayer.objects) {
      final Platform platform = Platform(
        position: Vector2(obj.x, obj.y),
        size: Vector2(obj.width, obj.height),
      );
      gameRef.world.add(platform);
    }
  }

  // Create Actors.
  void createActors(RenderableTiledMap tileMap) {
    // Create platforms.
    ObjectGroup? platformsLayer = tileMap.getLayer<ObjectGroup>('Actors');

    if (platformsLayer == null) {
      throw Exception('Actors layer not found.');
    }

    for (final TiledObject obj in platformsLayer.objects) {
      switch (obj.name) {
        case 'Mario':
          _mario = Mario(
            position: Vector2(
              obj.x,
              obj.y,
            ),
            levelBounds: _levelBounds,
          );
          gameRef.world.add(_mario);

          break;
        default:
          break;
      }
    }
  }

  void _setupCamera() {
    gameRef.cameraComponent.follow(_mario, maxSpeed: 1000);
    gameRef.cameraComponent.setBounds(
      Rectangle.fromPoints(
        _levelBounds.topRight,
        _levelBounds.topLeft,
      ),
    );
  }
}
