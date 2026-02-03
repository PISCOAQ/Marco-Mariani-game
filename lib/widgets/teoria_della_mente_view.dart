import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class TeoriaMenteView extends StatelessWidget {
  final TeoriaDellaMente pagina;
  final String? rispostaUtente;
  final ValueChanged<String> onChanged;

  const TeoriaMenteView({
    super.key,
    required this.pagina,
    required this.rispostaUtente,
    required this.onChanged,
  });

  void _updatePart(int index, String newValue) {
    // Creiamo una lista basata sul numero reale di domande nella pagina
    List<String> parti = rispostaUtente?.split('|') ?? List.filled(pagina.lista_domande.length, "");
    // Sicurezza: se la lista è più corta del previsto, la allunghiamo
    while (parti.length < pagina.lista_domande.length) {
      parti.add("");
    } 
    parti[index] = newValue;
    onChanged(parti.join('|'));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> parti = rispostaUtente?.split('|') ?? ["", "", ""];

    return Column(
      children: [
        const SizedBox(height: 30),

        // 1. SCENARIO
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            pagina.narrazione,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
        ),

        const SizedBox(height: 30),


        // 2. CICLO DINAMICO SULLE DOMANDE
        // Usiamo .asMap().entries per avere sia l'indice che la domanda
        ...pagina.lista_domande.asMap().entries.map((entry) {
          int idx = entry.key;
          Domanda domandaSingola = entry.value;

          // Recuperiamo la risposta data per questa specifica sottodomanda
          String rispostaCorrente = parti.length > idx ? parti[idx] : "";

          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: _buildSezione(
              domandaSingola.testo,
              domandaSingola.opzioni.isEmpty 
                ? _buildCampoAperto(idx, rispostaCorrente) // Se non ha opzioni, è aperta
                : _buildOpzioniChiuse(idx, domandaSingola.opzioni, rispostaCorrente),
            ),
          );
        }).toList(),
      ],
    );
  }

  // Widget per le domande a scelta multipla
  Widget _buildOpzioniChiuse(int idx, List<String> opzioni, String selezionata) {
    return Wrap( // Wrap è meglio di Row se le opzioni sono lunghe o tante
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 10,
      children: opzioni.map((opt) {
        return _buildBtn(opt, selezionata == opt, () => _updatePart(idx, opt));
      }).toList(),
    );
  }

  // Widget per le domande a risposta aperta (se previste nel JSON)
  Widget _buildCampoAperto(int idx, String testo) {
    return SizedBox(
      width: 500,
      child: TextField(
        key: ValueKey("${pagina.narrazione}_$idx"),
        textAlign: TextAlign.center,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: testo,
            selection: TextSelection.collapsed(offset: testo.length),
          ),
        ),
        decoration: InputDecoration(
          hintText: "Scrivi qui...",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (val) => _updatePart(idx, val),
      ),
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