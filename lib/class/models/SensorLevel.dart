import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class FloorSensor extends PositionComponent {
  final int floorValue;

  FloorSensor({
    required Vector2 position,
    required Vector2 size,
    required this.floorValue,
  }) : super(position: position, size: size) {
    // Aggiungiamo un hitbox. 
    // collisionType = passive significa che non "sbatte" contro le cose, 
    // ma genera eventi quando qualcosa ci passa sopra.
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}