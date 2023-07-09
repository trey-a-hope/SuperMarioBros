import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:super_mario_bros/level/level_component.dart';
import 'package:super_mario_bros/level/level_option.dart';

class SuperMarioBrosGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late CameraComponent cameraComponent;
  final World world = World();

  LevelComponent? _currentLevel;

  @override
  Future<void> onLoad() async {
    loadLevel(LevelOption.lv_1_1);

    cameraComponent = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Vector2(400, 50)
      ..viewfinder.position = Vector2(0, 0)
      ..viewport.position = Vector2(500, 0)
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
