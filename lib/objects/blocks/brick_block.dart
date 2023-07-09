import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:super_mario_bros/constants/animation_configs.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/objects/blocks/game_block.dart';

class BrickBlock extends GameBlock {
  BrickBlock({
    required Vector2 position,
    required shouldCrumble,
  }) : super(
          animation: AnimationConfigs.block.brickBlockIdle(),
          position: position,
          shouldCrumble: shouldCrumble,
        );

  @override
  void hit() async {
    if (shouldCrumble) {
      animation = AnimationConfigs.block.brickBlockHit();
      FlameAudio.play(Globals.breakBlockSFX);
    }

    super.hit();
  }
}
