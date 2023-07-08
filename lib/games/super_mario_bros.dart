import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:super_mario_bros/constants/globals.dart';

class SuperMarioBrosGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final TiledComponent level = await TiledComponent.load(
      Globals.lv_1_1,
      Vector2.all(Globals.tileSize),
    );

    add(level);

    return super.onLoad();
  }
}
