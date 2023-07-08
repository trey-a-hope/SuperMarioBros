import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:super_mario_bros/games/super_mario_bros.dart';
import 'package:super_mario_bros/level/level_option.dart';

class LevelComponent extends Component with HasGameRef<SuperMarioBrosGame> {
  final LevelOption option;

  late Rect _levelBounds;

  LevelComponent(this.option) : super();

  @override
  Future<void>? onLoad() async {
    // Apply main level to canvas.
    final TiledComponent level = await TiledComponent.load(
      option.path,
      Vector2.all(Globals.tileSize),
    );

    gameRef.world.add(level);

    // Set on screen boundaries for Mario.
    _levelBounds = Rect.fromLTWH(
      0,
      0,
      (level.tileMap.map.width * level.tileMap.map.tileWidth).toDouble(),
      (level.tileMap.map.height * level.tileMap.map.tileHeight).toDouble(),
    );

    return super.onLoad();
  }
}
