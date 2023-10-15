import 'package:bonfire/bonfire.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:super_mario_bros/constants/globals.dart';

class SpriteSheets {
  static late SpriteSheet itemBlocksSpriteSheet;
  static late SpriteSheet goombaSpriteSheet;

  static Future<void> load() async {
    // Item Blocks Sprite Sheet
    final itemBlocksSpriteSheetImage = await Flame.images.load(
      Globals.blocksSpriteSheet,
    );
    itemBlocksSpriteSheet = SpriteSheet.fromColumnsAndRows(
      image: itemBlocksSpriteSheetImage,
      columns: 28,
      rows: 16,
    );

    // Goomba Sprite Sheet
    final goombaSpriteSheetImage = await Flame.images.load(
      Globals.goombaSpriteSheet,
    );
    goombaSpriteSheet = SpriteSheet.fromColumnsAndRows(
      image: goombaSpriteSheetImage,
      columns: 3,
      rows: 1,
    );
  }
}

class MarioSpriteSheet {
  static Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        "mario_idle.gif",
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: Globals.marioSpriteStepTime,
          textureSize: Vector2(32, 32),
        ),
      );

  static Future<SpriteAnimation> get runRight {
    Future<Sprite> marioWalk1 =
        Sprite.load("mario_1_walk.gif", srcSize: Vector2(32, 32));
    Future<Sprite> marioWalk2 =
        Sprite.load("mario_2_walk.gif", srcSize: Vector2(32, 32));
    Future<Sprite> marioWalk3 =
        Sprite.load("mario_3_walk.gif", srcSize: Vector2(32, 32));

    return Future.wait([marioWalk1, marioWalk2, marioWalk3]).then(
      (value) => SpriteAnimation.spriteList([value[0], value[1], value[2]],
          stepTime: Globals.marioSpriteStepTime),
    );
  }
}
