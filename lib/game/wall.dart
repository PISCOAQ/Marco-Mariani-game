import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Wall extends PositionComponent with CollisionCallbacks {
  Wall(Vector2 position, Vector2 size) {
    this.position = position;
    this.size = size;
    add(RectangleHitbox());
  }
}
