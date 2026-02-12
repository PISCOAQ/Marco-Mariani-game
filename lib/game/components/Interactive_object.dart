import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:gioco_demo/game/player.dart';
import 'package:gioco_demo/game/MyGame.dart'; 

typedef ShowQuizCallback = void Function();

class InteractiveObject extends PositionComponent with CollisionCallbacks, HasGameRef<MyGame> {
  final ShowQuizCallback onTrigger;
  final String spritePath; 
  final int levelId;

  late SpriteComponent indicator;
  bool _canTrigger = true;

  InteractiveObject(
    double x,
    double y,
    double width,
    double height,
    this.onTrigger, {
    required this.spritePath,
    required this.levelId,
  }) : super(
          position: Vector2(x, y),
          size: Vector2(width, height),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(RectangleHitbox(isSolid: false));

    final sprite = await Sprite.load(spritePath);
    
    indicator = SpriteComponent(
      sprite: sprite,
      size: Vector2(20, 20),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, -12), 
    );

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

    if (game.utente.Livello_Attuale > levelId) {
      indicator.opacity = 0.0;
    } else {
      indicator.opacity = 1.0;
    }

    add(indicator);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // --- LOGICA AGGIORNATA ---
    // Controlliamo costantemente se l'icona deve sparire perché il livello è stato superato
    if (game.utente.Livello_Attuale > levelId) {
      if (indicator.opacity != 0.0) indicator.opacity = 0.0;
    } else {
      if (indicator.opacity != 1.0) indicator.opacity = 1.0;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player && _canTrigger) {
      // Opzionale: puoi aggiungere qui un controllo se vuoi che l'interazione 
      // avvenga solo se il livello attuale è ESATTAMENTE quello dell'oggetto
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