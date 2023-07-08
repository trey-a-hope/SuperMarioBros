import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/level/level_component.dart';
import 'package:super_mario_bros/level/level_option.dart';

class SuperMarioBrosGame extends FlameGame {
  late CameraComponent cameraComponent;
  final World world = World();

  LevelComponent? _currentLevel;

  @override
  Future<void> onLoad() async {
    final TiledComponent level = await TiledComponent.load(
      Globals.lv_1_1,
      Vector2.all(Globals.tileSize),
    );

    loadLevel(LevelOption.lv_1_1);

    cameraComponent = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Vector2(450, 50)
      ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.anchor = Anchor.topLeft;

    addAll([cameraComponent, world]);

    return super.onLoad();
  }

  void loadLevel(LevelOption level) {
    _currentLevel?.removeFromParent();
    _currentLevel = LevelComponent(level);
    add(_currentLevel!);
  }
}
