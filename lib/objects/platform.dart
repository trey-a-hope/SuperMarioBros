import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Platform extends PositionComponent {
  Platform({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
        ) {
    debugMode = true;
  }

  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }
}
