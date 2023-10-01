import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:super_mario_bros/constants/animation_configs.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/games/super_mario_bros.dart';
import 'package:super_mario_bros/objects/blocks/game_block.dart';
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

  bool sideHit = false;

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
    // Set Mario's velocity based on direction and speed.
    if (!sideHit) {
      velocity.x = _hAxisInput * _currentMoveSpeed;
    }

    // Apply gravity to Mario if he's not on the ground.
    if (!isOnGround) {
      velocity.y += _gravity;
    }

    // Ensure Mario's velocity stays within bounds.
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
          // Move mario up one tile size since he grew vertically one tile size.
          position.y -= Globals.tileSize;
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

    platformPositionCheck(other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    // Mario is no longer in contact with a platform or Gameblock, so he's not on the ground.
    isOnGround = false;
    sideHit = false;
  }

  // Method that stops Mario's velocity for colliding with solid object.
  void platformPositionCheck(PositionComponent other) {
    late Rect objRect;
    final Rect marioRect = toRect();

    // If platform, use toRect for boundaries.
    if (other is Platform) {
      objRect = other.toRect();
    }

    // If game block, use the original position rect boundaries.
    else if (other is GameBlock) {
      objRect = other.rect;
    }

    // Otherwise, component isn't a solid object, so just return.
    else {
      return;
    }

    // Mario's top has collided with solid object.
    bool hitTop =
        marioRect.top <= objRect.bottom && marioRect.bottom >= objRect.bottom;

    // Mario's bottom has collided with solid object.
    bool hitBottom =
        marioRect.bottom >= objRect.top && marioRect.top <= objRect.top;

    // Mario's left has collided with solid object.
    bool hitLeft =
        marioRect.left <= objRect.right && marioRect.right >= objRect.right;

    // Mario's right has collided with solid object.
    bool hitRight =
        marioRect.right >= objRect.left && marioRect.left <= objRect.left;

    if (hitTop) {
      // Mario hit his head, so stop his velocity.
      velocity.y = 0;

      // If it's a Gameblock, call hit function.
      if (other is GameBlock) {
        other.hit();
      }
    }

    if (hitBottom) {
      // Mario is standing on something, so stop his velocity.
      velocity.y = 0;
      isOnGround = true;
    }

    if (hitLeft) {
      velocity.x = 0;
      sideHit = true;
    }

    if (hitRight) {
      velocity.x = 0;
      sideHit = true;
    }
  }
}
