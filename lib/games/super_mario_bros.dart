import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:super_mario_bros/level/level_component.dart';
import 'package:super_mario_bros/level/level_option.dart';

class SuperMarioBrosGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  LevelComponent? _currentLevel;

  @override
  Future<void> onLoad() async {
    // Configure camera component.
    camera = CameraComponent(world: world)
      ..viewport.size = Vector2(450, 50)
      ..viewport.position = Vector2(500, 0)
      ..viewfinder.visibleGameSize = Vector2(500, 0)
      ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.anchor = Anchor.topLeft;

    // Update the currentLevel then add it to the view.
    _loadLevel(LevelOption.lv_1_1);

    return super.onLoad();
  }

  void _loadLevel(LevelOption level) {
    _currentLevel?.removeFromParent();
    _currentLevel = LevelComponent(level);
    add(_currentLevel!);
  }
}
