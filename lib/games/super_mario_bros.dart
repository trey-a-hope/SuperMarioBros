import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:super_mario_bros/constants/globals.dart';

class SuperMarioBrosGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final World world = World();

    final TiledComponent level = await TiledComponent.load(
      Globals.lv_1_1,
      Vector2.all(Globals.tileSize),
    );

    world.add(level);

    CameraComponent cameraComponent = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Vector2(450, 50)
      ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.anchor = Anchor.topLeft;

    addAll([cameraComponent, world]);

    return super.onLoad();
  }
}
