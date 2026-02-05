import 'package:flutter/material.dart';

class CodeSelector extends StatefulWidget {
  final Function(String) onConfirm;
  final VoidCallback onBack;

  const CodeSelector({
    required this.onConfirm,
    required this.onBack,
    super.key,
  });

  @override
  State<CodeSelector> createState() => _CodeSelectorState();
}

class _CodeSelectorState extends State<CodeSelector> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7), // Un po' più scuro per leggere meglio il testo
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 400),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Inserisci il tuo codice giocatore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                
                // CAMPO DI TESTO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: _controller,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 4),
                    decoration: InputDecoration(
                      hintText: 'ES. AB123',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), letterSpacing: 1),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.yellowAccent, width: 2),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // PULSANTE CONFERMA
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      widget.onConfirm(_controller.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 251, 119, 67),
                    foregroundColor: Colors.brown[900],
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Avanti',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),

            // ❌ PULSANTE CHIUDI
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}