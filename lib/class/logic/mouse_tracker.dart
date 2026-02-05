import 'dart:math';
import 'package:flutter/material.dart';

class MouseTracker {
  double _totalDistance = 0;
  Offset? _lastPosition;

  // Inizia a tracciare (resetta i contatori)
  void start() {
    _totalDistance = 0;
    _lastPosition = null;
  }

  // Registra un nuovo movimento
  void recordMovement(Offset currentPosition) {
    if (_lastPosition != null) {
      // Formula della distanza tra due punti: $d = \sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}$
      double distance = sqrt(
        pow(currentPosition.dx - _lastPosition!.dx, 2) +
        pow(currentPosition.dy - _lastPosition!.dy, 2)
      );
      _totalDistance += distance;
    }
    _lastPosition = currentPosition;
  }

  // Ferma e restituisce la distanza totale (arrotondata)
  double stop() {
    double finalDistance = _totalDistance;
    _totalDistance = 0; // Reset
    return double.parse(finalDistance.toStringAsFixed(2));
  }
}