import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:super_mario_bros/constants/animation_configs.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/games/super_mario_bros.dart';

class Goomba extends SpriteAnimationComponent
    with HasGameRef<SuperMarioBrosGame>, CollisionCallbacks {
  Goomba({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(
            Globals.tileSize,
            Globals.tileSize,
          ),
          anchor: Anchor.topCenter,
          animation: AnimationConfigs.goomba.walking(),
        );
}
