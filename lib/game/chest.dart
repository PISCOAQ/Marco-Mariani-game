import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart'; 
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:gioco_demo/game/player.dart';

class Chest extends SpriteGroupComponent<bool> with CollisionCallbacks, HasGameRef {
  bool isOpen = false;
  bool _canTrigger = true;
  final VoidCallback onOpen;

  late SpriteComponent _topPart;
  late SpriteComponent indicator; // Il nuovo indicatore visivo

  Chest({required Vector2 position, required Vector2 size, required this.onOpen}) 
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    final image = await gameRef.images.load("TX Props.png");

    sprites = {
      false: Sprite(image, srcPosition: Vector2(96, 32), srcSize: Vector2(32, 32)),
      true: Sprite(image, srcPosition: Vector2(96, 96), srcSize: Vector2(32, 32)),
    };

    _topPart = SpriteComponent(
      sprite: Sprite(image, srcPosition: Vector2(96, 64), srcSize: Vector2(32, 32)),
      size: Vector2(32, 32),
      position: Vector2(0, -32),
      priority: 1, 
    );

    // --- AGGIUNTA INDICATORE ---
    // Carichiamo l'icona (usa lo stesso spritePath dell'InteractiveObject o uno diverso)
    final indicatorSprite = await Sprite.load('shop.png'); 
    indicator = SpriteComponent(
      sprite: indicatorSprite,
      size: Vector2(20, 20), // Leggermente più piccola per il baule
      anchor: Anchor.center,
      position: Vector2(size.x / 2, -10), // Posizionata sopra il baule
    );

    // Effetto di galleggiamento
    indicator.add(
      MoveEffect.by(
        Vector2(0, -5),
        EffectController(
          duration: 1.0,
          reverseDuration: 1.0,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ),
    );

    add(indicator); // Aggiungiamo l'indicatore all'avvio

    current = false;
    add(RectangleHitbox());
  }

  void open() {
    if (_canTrigger) {
      _canTrigger = false; 

      if (!isOpen) {
        isOpen = true;
        current = true;
        add(_topPart);
        
        // Nascondiamo l'indicatore quando il baule è aperto
        indicator.opacity = 0; 
      }

      Future.delayed(const Duration(milliseconds: 150), () {
        onOpen();
      });
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Player) {
      _canTrigger = true; 
      
      if (isOpen) {
        isOpen = false;
        current = false;
        
        // Riportiamo l'opacità a 1 quando il player si allontana e il baule si chiude
        indicator.opacity = 1;

        if (contains(_topPart)) {
          remove(_topPart);
        }
      }
    }
  }
}