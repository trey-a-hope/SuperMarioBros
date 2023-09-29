import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_mario_bros/constants/animation_configs.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/games/super_mario_bros.dart';
import 'package:super_mario_bros/objects/platform.dart';

// Form types for Mario.
enum MarioType {
  mario,
  superMario,
}

// Specific animations for each form of Mario.
enum MarioAnimations {
  idle,
  walk,
  jump,
  superIdle,
  superWalk,
  superJump,
}

class Mario extends SpriteAnimationGroupComponent<MarioAnimations>
    with CollisionCallbacks, KeyboardHandler, HasGameRef<SuperMarioBrosGame> {
  final double _gravity = 15;
  final Vector2 velocity = Vector2.zero();
  final double _jumpSpeed = 500;

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

  // Flag representing if the game is paused.
  bool _pause = false;

  // Default to small mario.
  MarioType _marioType = MarioType.mario;

  bool get isJumping => !isOnGround;
  bool get isWalking => _hAxisInput < 0 || _hAxisInput > 0;
  bool get isIdle => _hAxisInput == 0;

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

    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final SpriteAnimation idle = await AnimationConfigs.mario.idle();
    final SpriteAnimation walking = await AnimationConfigs.mario.walking();
    final SpriteAnimation jumping = await AnimationConfigs.mario.jumping();
    final SpriteAnimation superIdle = await AnimationConfigs.superMario.idle();
    final SpriteAnimation superWalking =
        await AnimationConfigs.superMario.walking();
    final SpriteAnimation superJumping =
        await AnimationConfigs.superMario.jumping();

    animations = {
      MarioAnimations.idle: idle,
      MarioAnimations.walk: walking,
      MarioAnimations.jump: jumping,
      MarioAnimations.superIdle: superIdle,
      MarioAnimations.superWalk: superWalking,
      MarioAnimations.superJump: superJumping,
    };

    current = MarioAnimations.idle;
  }

  void velocityUpdate() {
    velocity.x = _hAxisInput * _currentMoveSpeed;

    // Modify Mario's velocity based on inputs and gravity.
    if (!isOnGround) {
      //TODO: This conditional needs more logic.
      velocity.y += _gravity;
    }
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

  // Update animation for Mario based on his current form type.
  void marioAnimationUpdate() {
    switch (_marioType) {
      case MarioType.mario:
        if (isJumping) {
          current = MarioAnimations.jump;
        } else if (isWalking) {
          current = MarioAnimations.walk;
        } else if (isIdle) {
          current = MarioAnimations.idle;
        }
        break;
      case MarioType.superMario:
        if (isJumping) {
          current = MarioAnimations.superJump;
        } else if (isWalking) {
          current = MarioAnimations.superWalk;
        } else if (isIdle) {
          current = MarioAnimations.superIdle;
        }
        break;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.arrowLeft) ? -1 : 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.arrowRight) ? 1 : 0;
    _jumpInput = keysPressed.contains(LogicalKeyboardKey.space);

    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      _pauseGame();
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyT)) {
      if (_marioType == MarioType.mario) {
        _transform(upgrade: true);
      } else {
        _transform(upgrade: false);
      }
    }

    return true;
  }

  // Update form type and size of Mario.
  void _transform({required bool upgrade}) {
    if (upgrade) {
      switch (_marioType) {
        case MarioType.mario:
          size = Vector2(Globals.tileSize, Globals.tileSize * 2);
          _marioType = MarioType.superMario;
          break;
        case MarioType.superMario:
          break;
      }
    } else {
      switch (_marioType) {
        case MarioType.mario:
          break;
        case MarioType.superMario:
          size = Vector2(Globals.tileSize, Globals.tileSize);
          _marioType = MarioType.mario;
          break;
      }
    }
  }

  // Pause the game.
  void _pauseGame() {
    FlameAudio.play(Globals.pauseSFX);

    !_pause ? gameRef.pauseEngine() : gameRef.resumeEngine();

    _pause = !_pause;
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
      platformPositionCheck(other);
    }
  }

  // TODO: Finish flow of platform collisions.
  void platformPositionCheck(PositionComponent platform) {
    final Rect marioRect = toRect();
    final Rect platformRect = platform.toRect();

    bool hitTop = marioRect.top <= platformRect.bottom;
    bool hitBottom = marioRect.bottom >= platformRect.top;
    bool hitLeft = marioRect.left <= platformRect.right;
    bool hitRight = marioRect.right >= platformRect.left;

    if (hitTop) {
      velocity.y = 0;
    }

    if (hitBottom) {
      velocity.y = 0;
      isOnGround = true;
    }

    if (hitLeft) {
      velocity.x = 0;
    }

    if (hitRight) {
      velocity.x = 0;
    }
  }
}
