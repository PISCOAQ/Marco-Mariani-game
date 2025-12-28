import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gioco_demo/game/player.dart';

typedef ShowQuizCallback = void Function();

class OggettoEsercitazione extends PositionComponent with CollisionCallbacks {
  final ShowQuizCallback onTrigger;

  OggettoEsercitazione(
    // Riceviamo direttamente le dimensioni e la posizione
    double x,
    double y,
    double width,
    double height,
    this.onTrigger,
  ) : super(
          position: Vector2(x, y), // Uso x, y per la posizione
          size: Vector2(width, height), // Uso width, height per la dimensione
        ) {
    // Aggiunge la hitbox. 
    add(RectangleHitbox(isSolid: false));
  }

  bool _canTrigger = true;

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player && _canTrigger) {
      _canTrigger = false;
      onTrigger();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    
    if (other is Player) {
      _canTrigger = true;
    }
  }
}