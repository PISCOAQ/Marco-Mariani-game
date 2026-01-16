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
    return SizedBox(
      // Forza la larghezza massima per permettere al Column interno di centrare
      width: double.infinity, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // DISTACCO DAL BORDO SUPERIORE (Immagine 2)
          const SizedBox(height: 100),

          // TESTO SCENARIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              domanda.testo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // TESTO DOMANDA (Question)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              domanda.question ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),

          // SPAZIO PRIMA DELLA BARRA (Per centrarla verticalmente o quasi)
          const SizedBox(height: 150),

          // BARRA DI SCRITTURA (Larghezza 500)
          SizedBox(
            width: 500,
            child: TextField(
              key: ValueKey(domanda.testo),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
              onChanged: onChanged,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            "Una parola è sufficiente",
            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}