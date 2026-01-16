import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class TeoriaMenteView extends StatelessWidget {
  final TeoriaDellaMente domanda;
  final String? rispostaUtente;
  final ValueChanged<String> onChanged;

  const TeoriaMenteView({
    super.key,
    required this.domanda,
    required this.rispostaUtente,
    required this.onChanged,
  });

  void _updatePart(int index, String newValue) {
    List<String> parti = rispostaUtente?.split('|') ?? ["", "", ""];
    while (parti.length < 3) parti.add("");
    parti[index] = newValue;
    onChanged(parti.join('|'));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> parti = rispostaUtente?.split('|') ?? ["", "", ""];
    final String r1 = parti.isNotEmpty ? parti[0] : "";
    final String r2 = parti.length > 1 ? parti[1] : "";
    final String r3 = parti.length > 2 ? parti[2] : "";

    return Column(
      children: [
        const SizedBox(height: 30),

        // 1. SCENARIO
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            domanda.testo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
        ),

        const SizedBox(height: 30),

        // 2. QUESTION 1 (Dinamica da opzioni1)
        _buildSezione(
          domanda.question1,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: domanda.opzioni1.map((opt) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildBtn(opt, r1 == opt, () => _updatePart(0, opt)),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 30),

        // 3. QUESTION 2 (Dinamica da opzioni2 - Se presente)
        if (domanda.question2 != null && domanda.opzioni2 != null)
          _buildSezione(
            domanda.question2!,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: domanda.opzioni2!.map((opt) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildBtn(opt, r2 == opt, () => _updatePart(1, opt)),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 30),

        // 4. QUESTION 3 (Risposta Aperta)
        _buildSezione(
          domanda.question3,
          SizedBox(
            width: 500,
            child: TextField(
              key: ValueKey(domanda.testo + "q3"),
              textAlign: TextAlign.center,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: r3,
                  selection: TextSelection.collapsed(offset: r3.length),
                ),
              ),
              decoration: InputDecoration(
                hintText: "Scrivi qui...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black12)),
              ),
              onChanged: (val) => _updatePart(2, val),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSezione(String titolo, Widget child) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            titolo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, color: Colors.black54, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildBtn(String testo, bool selected, VoidCallback onTap) {
    return SizedBox(
      width: 140,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.blue[700] : Colors.white,
          foregroundColor: selected ? Colors.white : Colors.black87,
          elevation: selected ? 2 : 0,
          side: BorderSide(color: selected ? Colors.blue[900]! : Colors.grey[400]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text(testo.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}