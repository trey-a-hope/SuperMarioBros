import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:super_mario_bros/actors/mario.dart';
import 'package:super_mario_bros/constants/globals.dart';

class GameBlock extends SpriteAnimationComponent with CollisionCallbacks {
  // Components position on the map, used to revert back.
  late Vector2 _originalPos;

  // Switch between disappearing and being bumped temporarily.
  final bool shouldCrumble;

  // How far the block moves up.
  final double _hitDistance = 5;

  // How for the block moves back down.
  final double _gravity = 0.5;

  // Constructor
  GameBlock({
    required Vector2 position,
    required SpriteAnimation animation,
    required this.shouldCrumble,
  }) : super(
          // Sequence of sprites.
          animation: animation,
          // Components position on the map.
          position: position,
          // Components size.
          size: Vector2(
            Globals.tileSize,
            Globals.tileSize,
          ),
        ) {
    // Apply collision detection.
    _originalPos = position;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    // Gradually move block back to original position.
    if (y != _originalPos.y) {
      y += _gravity;
    }
    super.update(dt);
  }

  // When Mario hits the block...
  void hit() async {
    if (shouldCrumble) {
      // Wait a quarter second.
      await Future.delayed(
        const Duration(
          milliseconds: 250,
        ),
      );

      // Remove the block from the view.
      add(RemoveEffect());
    } else {
      // Play sound effect.
      FlameAudio.play(Globals.bumpSFX);

      // Move the block up.
      y -= _hitDistance;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Mario) {
      if (intersectionPoints.length == 2) {
        // Average of two points on the circle that intersected.
        final Vector2 mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        // If hit from the bottom, (4 is for padding when hit from the sides).
        // When velocity.y is less than 0, Mario is moving up.
        // When velocity.y is greater than 0, Mario is moving down.
        if ((mid.y > position.y + size.y - 4) &&
            (mid.y < position.y + size.y + 4) &&
            other.velocity.y < 0) {
          // Mario bumps his head.
          // other.velocity.y = 0;

          hit();
        }

        other.platformPositionCheck(this);

        // other.platformPositionCheck(intersectionPoints);
      }
    }
  }
}
