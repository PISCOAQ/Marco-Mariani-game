import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:gioco_demo/game/player.dart';

typedef ShowQuizCallback = void Function();

class InteractiveObject extends PositionComponent with CollisionCallbacks {
  final ShowQuizCallback onTrigger;
  final String spritePath; // Nome del file immagine
  late SpriteComponent indicator;
  bool _canTrigger = true;

  InteractiveObject(
    double x,
    double y,
    double width,
    double height,
    this.onTrigger, {
    required this.spritePath,
  }) : super(
          position: Vector2(x, y),
          size: Vector2(width, height),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 1. HITBOX (Invariata)
    add(RectangleHitbox(isSolid: false));

    // 2. CARICAMENTO ICONA PNG
    final sprite = await Sprite.load(spritePath);
    
    indicator = SpriteComponent(
      sprite: sprite,
      size: Vector2(20, 20), // Dimensione dell'icona
      anchor: Anchor.center,
      // Posizionata a metà larghezza dell'oggetto e 12 pixel sopra
      position: Vector2(size.x / 2, -12), 
    );

    // 3. EFFETTO MOVIMENTO
    indicator.add(
      MoveEffect.by(
        Vector2(0, -8),
        EffectController(
          duration: 1.0,
          reverseDuration: 1.0,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ),
    );

    add(indicator);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
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