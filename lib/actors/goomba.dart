import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:super_mario_bros/actors/mario.dart';
import 'package:super_mario_bros/constants/animation_configs.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/games/super_mario_bros.dart';

class Goomba extends SpriteAnimationComponent
    with HasGameRef<SuperMarioBrosGame>, CollisionCallbacks {
  final double _speed = 50;

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
        ) {
    Vector2 targetPosition = position;

    // Goomba will move 100 pixels to the left and right.
    targetPosition.x -= 100;

    final SequenceEffect effect = SequenceEffect(
      [
        MoveToEffect(
          targetPosition,
          EffectController(speed: _speed),
        ),
        MoveToEffect(
          position,
          EffectController(speed: _speed),
        ),
      ],
      infinite: true,
      alternate: true,
    );

    add(effect);

    add(CircleHitbox());
  }

  @override
  void onCollision(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    if (other is Mario) {
      if (!other.isOnGround) {
        other.jump();

        animation = AnimationConfigs.goomba.dead();

        position.y += 0.5;

        // Display defeated Goomba for 0.5 seconds.
        await Future.delayed(
          const Duration(
            milliseconds: 500,
          ),
        );

        // Remove dead Goomba.
        removeFromParent();
      }
    }

    super.onCollision(intersectionPoints, other);
  }
}
