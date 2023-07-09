import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:super_mario_bros/constants/animation_configs.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/objects/platform.dart';

enum MarioAnimationState {
  idle,
  walk,
  jump,
}

class Mario extends SpriteAnimationGroupComponent<MarioAnimationState>
    with CollisionCallbacks {
  final double _gravity = 15;
  final Vector2 velocity = Vector2.zero();
  final double _jumpSpeed = 400;

  late Vector2 _minClamp;
  late Vector2 _maxClamp;

  Mario({
    required Vector2 position,
    required Rect levelBounds,
  }) : super(
          position: position,
          size: Vector2(
            Globals.tileSize,
            Globals.tileSize,
          ),
          anchor: Anchor.center,
        ) {
    debugMode = true;
    // Prevent Mario from going out of bounds of level.
    // Since anchor is in the center, split size in half for calculation.
    _minClamp = levelBounds.topLeft.toVector2() + (size / 2);
    _maxClamp = levelBounds.bottomRight.toVector2() - (size / 2);

    add(CircleHitbox());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final SpriteAnimation idle = await AnimationConfigs.mario.idle();

    animations = {
      MarioAnimationState.idle: idle,
    };

    current = MarioAnimationState.idle;
  }

  void velocityUpdate() {
    // Modify Mario's velocity based on inputs and gravity.
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpSpeed, 150);
  }

  void positionUpdate(double dt) {
    // Distance = velocity * time.
    Vector2 distance = velocity * dt;
    position += distance;

    // Screen boundaries for Mario, top left and bottom right points.
    position.clamp(_minClamp, _maxClamp);
  }

  @override
  void update(double dt) {
    super.update(dt);
    /*  dt effects velocity, so this makes sure Mario doesn't 
        go too far when there's a lag in the framerate. 

        Average dt is 0.016668.
      */
    if (dt > 0.05) return;

    velocityUpdate();
    positionUpdate(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Platform) {
      if (intersectionPoints.length == 2) {
        platformPositionCheck(intersectionPoints);
      }
    }
  }

  // Move Mario out of the platform he's standing on.
  void platformPositionCheck(Set<Vector2> intersectionPoints) {
    // Calculate the collision normal and penetration depth
    final Vector2 mid =
        (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;

    final Vector2 collisionNormal = absoluteCenter - mid;
    double penetrationDepth = (size.x / 2) - collisionNormal.length;
    collisionNormal.normalize();

    // Fix this collision by moving the player along the collision normal by penetrationDepth.
    position += collisionNormal.scaled(penetrationDepth);
  }
}
