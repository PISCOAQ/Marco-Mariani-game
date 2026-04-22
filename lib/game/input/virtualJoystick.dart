import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class VirtualJoystick extends StatefulWidget {
  final Function(Vector2 direction) onDirectionChanged;

  const VirtualJoystick({super.key, required this.onDirectionChanged});

  @override
  State<VirtualJoystick> createState() => _VirtualJoystickState();
}

class _VirtualJoystickState extends State<VirtualJoystick> {
  Offset knobPosition = Offset.zero;

  final double size = 140; // grandezza joystick
  late final double radius;
  late final double knobRadius;

  @override
  void initState() {
    super.initState();
    radius = size / 2;
    knobRadius = size / 4;
  }

  void _updatePosition(Offset localPosition) {
    final center = Offset(radius, radius);
    Offset delta = localPosition - center;

    final maxDistance = radius - knobRadius / 2;

    if (delta.distance > maxDistance) {
      delta = Offset.fromDirection(delta.direction, maxDistance);
    }

    setState(() {
      knobPosition = delta;
    });

    // Convertiamo in Vector2 normalizzato
    final direction = Vector2(delta.dx, delta.dy);

    if (direction.length > 0) {
      direction.normalize();
    }

    widget.onDirectionChanged(direction);
  }

  void _reset() {
    setState(() {
      knobPosition = Offset.zero;
    });

    widget.onDirectionChanged(Vector2.zero());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => _updatePosition(details.localPosition),
      onPanEnd: (_) => _reset(),
      onPanCancel: _reset,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            // Stick interno
            Positioned(
              left: radius + knobPosition.dx - knobRadius / 2,
              top: radius + knobPosition.dy - knobRadius / 2,
              child: Container(
                width: knobRadius,
                height: knobRadius,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}