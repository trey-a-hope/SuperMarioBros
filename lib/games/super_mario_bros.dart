import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:super_mario_bros/actors/mario.dart';
import 'package:super_mario_bros/constants/globals.dart';
import 'package:flutter/services.dart';

class SuperMarioBrosGame extends StatefulWidget {
  const SuperMarioBrosGame({Key? key}) : super(key: key);

  @override
  State<SuperMarioBrosGame> createState() => _SuperMarioBrosGameState();
}

class _SuperMarioBrosGameState extends State<SuperMarioBrosGame> {
  @override
  Widget build(BuildContext context) => BonfireWidget(
        joystick: Joystick(
          directional: JoystickDirectional(),
          keyboardConfig: KeyboardConfig(
            acceptedKeys: [
              LogicalKeyboardKey.numpadEnter,
              LogicalKeyboardKey.numpad0,
            ],
          ),
          actions: [
            // JoystickAction(
            //   actionId: AttackType.melee,
            //   size: 80,
            //   margin: const EdgeInsets.only(bottom: 50, right: 50),
            //   align: JoystickActionAlign.BOTTOM_RIGHT,
            //   sprite: Sprite.load(Globals.sword),
            // ),
            // JoystickAction(
            //   actionId: AttackType.range,
            //   size: 50,
            //   margin: const EdgeInsets.only(bottom: 50, right: 160),
            //   sprite: Sprite.load(Globals.shurikenSingle),
            // )
          ],
        ),
        player: Mario(
          Vector2(100, 100),
        ),
        map: WorldMapByTiled(
          Globals.lv_1_1,
          forceTileSize: Vector2(
            32,
            32,
          ),
          objectsBuilder: {},
        ),
      );
}
