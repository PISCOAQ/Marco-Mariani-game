class ReactionTimer {
  int? _startTime;

  // Avvia il cronometro
  void start() {
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }

  // Ferma il cronometro e restituisce i millisecondi trascorsi
  int stop() {
    if (_startTime == null) return 0;
    final int endTime = DateTime.now().millisecondsSinceEpoch;
    final int elapsed = endTime - _startTime!;
    _startTime = null; // Resetta per sicurezza
    return elapsed;
  }
}