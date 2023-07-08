import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:super_mario_bros/constants/globals.dart';

class SpriteSheets {
  static late SpriteSheet itemBlocksSpriteSheet;
  static late SpriteSheet goombaSpriteSheet;

  static Future<void> load() async {
    // Item Blocks Sprite Sheet
    final itemBlocksSpriteSheetImage = await Flame.images.load(
      Globals.blocksSpriteSheet,
    );
    itemBlocksSpriteSheet = SpriteSheet.fromColumnsAndRows(
      image: itemBlocksSpriteSheetImage,
      columns: 28,
      rows: 16,
    );

    // Goomba Sprite Sheet
    final goombaSpriteSheetImage = await Flame.images.load(
      Globals.goombaSpriteSheet,
    );
    goombaSpriteSheet = SpriteSheet.fromColumnsAndRows(
      image: goombaSpriteSheetImage,
      columns: 3,
      rows: 1,
    );
  }
}
