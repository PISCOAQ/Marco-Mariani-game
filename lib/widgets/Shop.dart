import 'package:flutter/material.dart';

class ChestPage extends StatelessWidget {
  final VoidCallback onExit; 

  const ChestPage({super.key, required this.onExit});

  @override
  Widget build(BuildContext context) {

    return Container(
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.95),
      ),
      
      //margine intorno per non toccare i bordi dello schermo
      margin: const EdgeInsets.all(40.0), 
      
      child: Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisSize: MainAxisSize.min, 
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Benvenuto nel Negozio!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 50),
                  
                  Container(
                    width: 500, 
                    height: 250,
                    color: Colors.grey[200],
                    child: const Center(child: Text('Qui potrai comprare le skin...')),
                  ),
                  
                ],
              ),
            ),
          ),
          
          //icona chiusura pagina
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: onExit, 
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6), 
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24, 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}