import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/constants/sprite_sheets.dart';

class AnimationConfigs {
  AnimationConfigs._();

  static GoombaAnimationConfigs goomba = GoombaAnimationConfigs();
  static MarioAnimationConfigs mario = MarioAnimationConfigs();
  static BlockConfigs block = BlockConfigs();
}

class BlockConfigs {
  SpriteAnimation mysteryBlockIdle() => SpriteAnimation.variableSpriteList(
        List<Sprite>.generate(
          3,
          (index) => SpriteSheets.itemBlocksSpriteSheet.getSprite(8, 5 + index),
        ),
        stepTimes:
            List<double>.generate(3, (index) => Globals.mysteryBlockStepTime),
      );

  SpriteAnimation mysteryBlockHit() => SpriteAnimation.variableSpriteList(
        [
          SpriteSheets.itemBlocksSpriteSheet.getSprite(7, 8),
        ],
        stepTimes: [
          Globals.mysteryBlockStepTime,
        ],
      );

  SpriteAnimation brickBlockIdle() => SpriteAnimation.variableSpriteList(
        [
          SpriteSheets.itemBlocksSpriteSheet.getSprite(7, 17),
        ],
        stepTimes: [
          Globals.mysteryBlockStepTime,
        ],
      );

  SpriteAnimation brickBlockHit() => SpriteAnimation.variableSpriteList(
        [
          SpriteSheets.itemBlocksSpriteSheet.getSprite(7, 19),
        ],
        stepTimes: [
          double.infinity,
        ],
      );
}

class GoombaAnimationConfigs {
  SpriteAnimation walking() => SpriteAnimation.variableSpriteList(
        List<Sprite>.generate(
          2,
          (index) => SpriteSheets.goombaSpriteSheet.getSprite(0, index),
        ),
        stepTimes:
            List<double>.generate(2, (index) => Globals.goombaSpriteStepTime),
      );

  SpriteAnimation dead() => SpriteAnimation.variableSpriteList(
        [
          SpriteSheets.goombaSpriteSheet.getSprite(0, 2),
        ],
        stepTimes: [
          Globals.goombaSpriteStepTime,
        ],
      );
}

class MarioAnimationConfigs {
  Future<SpriteAnimation> idle() async => SpriteAnimation.spriteList(
        [await Sprite.load(Globals.marioIdle)],
        stepTime: Globals.marioSpriteStepTime,
      );

  Future<SpriteAnimation> walking() async => SpriteAnimation.spriteList(
        await Future.wait(
            [1, 2, 3].map((i) => Sprite.load('mario_${i}_walk.gif')).toList()),
        stepTime: Globals.marioSpriteStepTime,
      );

  Future<SpriteAnimation> jumping() async => SpriteAnimation.spriteList(
        [await Sprite.load(Globals.marioJump)],
        stepTime: Globals.marioSpriteStepTime,
      );
}
