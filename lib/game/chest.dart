import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:gioco_demo/game/player.dart';

class Chest extends SpriteGroupComponent<bool> with CollisionCallbacks, HasGameRef {
  bool isOpen = false;
  bool _canTrigger = true;
  final VoidCallback onOpen;

  late SpriteComponent _topPart;

  Chest({required Vector2 position, required Vector2 size, required this.onOpen}) 
      : super(position: position, size: size, priority: position.y.toInt());

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

    current = false;
    add(RectangleHitbox());
  }

  void open() {
    if (_canTrigger) {
      _canTrigger = false; 

      // 1. Apriamo graficamente se è chiuso
      if (!isOpen) {
        isOpen = true;
        current = true;
        add(_topPart);
      }

      // 2. Lanciamo la schermata. 
      // Rimuoviamo il delay eccessivo o gestiamo il trigger in modo che onOpen 
      // venga chiamato anche se isOpen è già true.
      Future.delayed(const Duration(milliseconds: 150), () {
        onOpen();
      });
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Player) {
      // Quando il player si allontana, resettiamo TUTTO.
      // Così al prossimo contatto potrà riaprirsi.
      _canTrigger = true; 
      
      if (isOpen) {
        isOpen = false;
        current = false;
        if (contains(_topPart)) {
          remove(_topPart);
        }
      }
    }
  }
}