import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/constants/sprite_sheets.dart';
import 'package:super_mario_bros/games/super_mario_bros.dart';

SuperMarioBrosGame _superMarioBrosGame = SuperMarioBrosGame();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-load sprite sheets.
  await SpriteSheets.load();

  await FlameAudio.audioCache.loadAll(
    [
      Globals.jumpSmallSFX,
      Globals.pauseSFX,
      Globals.bumpSFX,
      Globals.powerUpAppearsSFX,
      Globals.breakBlockSFX,
    ],
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget(game: _superMarioBrosGame),
    ),
  );
}
