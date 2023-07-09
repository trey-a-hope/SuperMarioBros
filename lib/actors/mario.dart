import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:super_mario_bros/constants/animation_configs.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/objects/platform.dart';

enum MarioAnimationState {
  idle,
  walk,
  jump,
}

class Mario extends SpriteAnimationGroupComponent<MarioAnimationState>
    with CollisionCallbacks, KeyboardHandler {
  final double _gravity = 15;
  final Vector2 velocity = Vector2.zero();
  final double _jumpSpeed = 400;

  final Vector2 _up = Vector2(0, -1);

  static const double _minMoveSpeed = 125;
  static const double _maxMoveSpeed = _minMoveSpeed + 100;

  bool isFacingRight = true;

  double _currentMoveSpeed = _minMoveSpeed;

  bool _jumpInput = false;
  bool isOnGround = false;

  int _hAxisInput = 0;

  late Vector2 _minClamp;
  late Vector2 _maxClamp;

  Mario({
    required Vector2 position,
    required Rectangle levelBounds,
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
    _minClamp = levelBounds.topLeft + (size / 2);
    _maxClamp = levelBounds.bottomRight + (size / 2);

    add(CircleHitbox());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final SpriteAnimation idle = await AnimationConfigs.mario.idle();
    final SpriteAnimation walking = await AnimationConfigs.mario.walking();
    final SpriteAnimation jumping = await AnimationConfigs.mario.jumping();

    animations = {
      MarioAnimationState.idle: idle,
      MarioAnimationState.walk: walking,
      MarioAnimationState.jump: jumping,
    };

    current = MarioAnimationState.idle;
  }

  void velocityUpdate() {
    velocity.x = _hAxisInput * _currentMoveSpeed;
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

  // Stagger his speed while idle until he runs consistently.
  void speedUpdate() {
    if (_hAxisInput == 0) {
      _currentMoveSpeed = _minMoveSpeed;
    } else {
      if (_currentMoveSpeed <= _maxMoveSpeed) {
        _currentMoveSpeed++;
      }
    }
  }

  // Set facing direction.
  void facingDirectionUpdate() {
    if (_hAxisInput > 0) {
      isFacingRight = true;
    } else {
      isFacingRight = false;
    }

    if ((_hAxisInput < 0 && scale.x > 0) || (_hAxisInput > 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  // Allow jump only if jump button pressed and player is on the ground.
  void jumpUpdate() {
    if (_jumpInput && isOnGround) {
      jump();
    }
  }

  void jump() {
    velocity.y = -_jumpSpeed;
    isOnGround = false;

    // Play jump sound.
    FlameAudio.play(Globals.jumpSmallSFX);
  }

  void marioAnimationUpdate() {
    if (!isOnGround) {
      current = MarioAnimationState.jump;
    } else if (_hAxisInput < 0 || _hAxisInput > 0) {
      current = MarioAnimationState.walk;
    } else if (_hAxisInput == 0) {
      current = MarioAnimationState.idle;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.arrowLeft) ? -1 : 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.arrowRight) ? 1 : 0;
    _jumpInput = keysPressed.contains(LogicalKeyboardKey.space);

    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    /*  dt effects velocity, so this makes sure Mario doesn't 
        go too far when there's a lag in the framerate. 

        Average dt is 0.016668.
      */
    if (dt > 0.05) return;

    jumpUpdate();
    velocityUpdate();
    positionUpdate(dt);
    speedUpdate();
    facingDirectionUpdate();
    marioAnimationUpdate();
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

    // If collision normal is almost upwards, player is on the ground.
    if (_up.dot(collisionNormal) > 0.9) {
      isOnGround = true;
    }

    // Fix this collision by moving the player along the collision normal by penetrationDepth.
    position += collisionNormal.scaled(penetrationDepth);
  }
}
