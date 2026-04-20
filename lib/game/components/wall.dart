import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Wall extends PositionComponent with CollisionCallbacks {
  // Dichiariamo la hitbox come variabile della classe per potervi accedere dall'esterno
  late final RectangleHitbox hitbox;

  Wall(Vector2 position, Vector2 size) : super(position: position, size: size) {
    hitbox = RectangleHitbox(collisionType: CollisionType.active); // Forza ACTIVE
    add(hitbox);
  }

  // Metodo di utilità per cambiare lo stato della collisione
  void setCollisionActive(bool active) {
    // Qui usiamo CollisionType.active o CollisionType.inactive
    hitbox.collisionType = active ? CollisionType.active : CollisionType.inactive;
  }
}