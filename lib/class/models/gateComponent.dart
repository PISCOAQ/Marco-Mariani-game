import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class GateComponent extends PositionComponent {
  final String gateId;

  GateComponent({
    required Vector2 position,
    required Vector2 size,
    required this.gateId,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // FONDAMENTALE: Senza questa hitbox, il componente è invisibile al sistema di collisioni
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}