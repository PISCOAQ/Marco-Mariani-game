import 'package:flame/components.dart';
import 'package:flutter/services.dart';

mixin KeyboardMove on PositionComponent {
  double speed = 100;
  final Set<LogicalKeyboardKey> _keysPressed = {};

  void pressKey(LogicalKeyboardKey key, bool down) {
    if (down) {
      _keysPressed.add(key);
    } else {
      _keysPressed.remove(key);
    }
  }

  void handleKeyboard(double dt) {
    final move = Vector2.zero();

    if (_keysPressed.contains(LogicalKeyboardKey.arrowUp)) move.y -= 1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowDown)) move.y += 1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowLeft)) move.x -= 1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowRight)) move.x += 1;

    if (move.length != 0) {
      move.normalize();
      position += move * speed * dt;
    }
  }
}



