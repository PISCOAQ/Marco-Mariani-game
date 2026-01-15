import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class AttribuzioneEmozioniView extends StatelessWidget {
  final AttribuzioneEmozioni domanda;
  final String? rispostaUtente;
  final ValueChanged<String> onChanged;

  const AttribuzioneEmozioniView({
    super.key,
    required this.domanda,
    required this.rispostaUtente,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: 260,
            child: TextField(
              key: ValueKey(domanda.testo), // 6. Mantiene lo stato corretto
              maxLines: 1,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              
              // 7. Configurazione controller sicura per il focus
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: rispostaUtente ?? "",
                  selection: TextSelection.collapsed(offset: (rispostaUtente ?? "").length),
                ),
              ),
              
              decoration: InputDecoration(
                hintText: "Scrivi l'emozione",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Una parola è sufficiente",
            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}