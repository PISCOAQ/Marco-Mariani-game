import 'dart:ui';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gioco_demo/class/models/Levelmanager.dart';

class BaglioreCartello extends PositionComponent with HasGameRef {
  final int levelId;
  final List<Vector2>? punti;

  BaglioreCartello({
    required Vector2 position,
    required Vector2 size,
    required this.levelId,
    this.punti,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  void render(Canvas canvas) {
    // Ritorno alla logica lineare standard
    if (levelId != LevelManager.currentLevel - 1) return;

    double t = DateTime.now().millisecondsSinceEpoch / 1000; 
    double pulse = 0.4 + (math.sin(t * 2.6) * 0.4); 

    final paintGlow = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 0).withOpacity(0.6 * pulse)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final paintCore = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 0).withOpacity(0.8 * pulse)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    if (punti != null && punti!.isNotEmpty) {
      final path = Path();
      path.moveTo(punti![0].x, punti![0].y);
      for (var i = 1; i < punti!.length; i++) {
        path.lineTo(punti![i].x, punti![i].y);
      }
      path.close();

      canvas.drawPath(path, paintGlow);
      canvas.drawPath(path, paintCore);
    } else {
      final rect = Rect.fromLTWH(0, 0, size.x, size.y);
      canvas.drawRect(rect, paintGlow);
      canvas.drawRect(rect, paintCore);
    }
  }
}