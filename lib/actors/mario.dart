import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:super_mario_bros/constants/animation_configs.dart';
import 'package:super_mario_bros/constants/globals.dart';

enum MarioAnimationState {
  idle,
  walk,
  jump,
}

class Mario extends SpriteAnimationGroupComponent<MarioAnimationState> {
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
}
