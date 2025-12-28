import 'package:flutter/material.dart';

class GameNotification extends StatefulWidget {
  final String messaggio;

  const GameNotification({super.key, required this.messaggio});

  @override
  State<GameNotification> createState() => _GameNotificationState();
}

class _GameNotificationState extends State<GameNotification> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    // Il widget si "auto-distrugge" visivamente dopo 3 secondi
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isVisible = false);
      }
    });
  }

@override
Widget build(BuildContext context) {
  if (!_isVisible) return const SizedBox.shrink();

  // Usiamo Align per imitare il comportamento del Moneywidget
  return Align(
    alignment: Alignment.topCenter, // Al centro in alto
    child: Padding(
      padding: const EdgeInsets.all(20.0), // Stesso padding del Moneywidget
      child: Material(
        color: Colors.transparent,
        child: Container(
          // Altezza minima per pareggiare visivamente l'icona del Moneywidget (size 28 + vertical padding)
          constraints: const BoxConstraints(minHeight: 48), 
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.orange[900],
            borderRadius: BorderRadius.circular(25), // Stesso raggio del Moneywidget
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 4))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Flexible( // Protegge da testi troppo lunghi che spaccano il layout
                child: Text(
                  widget.messaggio,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}