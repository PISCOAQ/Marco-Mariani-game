import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';

class SituazioniSocialiView extends StatelessWidget {
  final SituazioniSociali pagina;
  final String? rispostaUtente;
  final ValueChanged<String> onChanged;

  const SituazioniSocialiView({
    super.key,
    required this.pagina,
    required this.rispostaUtente,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final domanda = pagina.lista_domande[0];

    return Column(
      children: [
        const SizedBox(height: 40),
        
        // IL TESTO COMPOSTO (Before + Bold + After)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),
              children: [
                if (pagina.narrazione_before != null)
                  TextSpan(text: "${pagina.narrazione_before} "),
                TextSpan(
                  text: pagina.bold,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
                if (pagina.narrazione_after != null)
                  TextSpan(text: " ${pagina.narrazione_after}"),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 50),

        // LE OPZIONI DI RISPOSTA
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: domanda.opzioni.map((opt) {
            final bool isSelected = rispostaUtente == opt;
            return _buildOptionBtn(opt, isSelected, () => onChanged(opt));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptionBtn(String testo, bool isSelected, VoidCallback onTap) {
    return SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue[700] : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          side: BorderSide(color: isSelected ? Colors.blue[900]! : Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onTap,
        child: Text(testo, textAlign: TextAlign.center),
      ),
    );
  }
}