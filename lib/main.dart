import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/constants/sprite_sheets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-load sprite sheets.
  await SpriteSheets.load();

  // Pre-load audio.
  FlameAudio.bgm.initialize();

  await FlameAudio.audioCache.loadAll(
    [
      Globals.jumpSmallSFX,
      Globals.pauseSFX,
      Globals.bumpSFX,
      Globals.powerUpAppearsSFX,
    ],
  );

  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: Container()),
  );
}
