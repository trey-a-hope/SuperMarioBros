// import 'package:flame/components.dart';
// import 'package:super_mario_bros/constants/animation_configs.dart';
// import 'package:super_mario_bros/games/super_mario_bros.dart';
// import 'package:super_mario_bros/objects/blocks/game_block.dart';

// class MysteryBlock extends GameBlock with HasGameRef<SuperMarioBrosGame> {
//   bool _hit = false;

//   MysteryBlock({
//     required Vector2 position,
//   }) : super(
//           animation: AnimationConfigs.block.mysteryBlockIdle(),
//           position: position,
//           shouldCrumble: false,
//         );

//   @override
//   void hit() {
//     if (!_hit) {
//       _hit = true;

//       // Updated to empty block animation.
//       animation = AnimationConfigs.block.mysteryBlockHit();
//     }

//     super.hit();
//   }
// }
