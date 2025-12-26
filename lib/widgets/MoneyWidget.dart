import 'package:flutter/material.dart';

class Moneywidget extends StatelessWidget {
  final ValueNotifier<int> walletNotifier;
  const Moneywidget({super.key, required this.walletNotifier});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder "ascolta" il wallet e si aggiorna da solo
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ValueListenableBuilder<int>(
          valueListenable: walletNotifier,
          builder: (context, currentCoins, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [        
                  const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    '$currentCoins',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}