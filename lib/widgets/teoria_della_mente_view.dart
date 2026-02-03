import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class TeoriaMenteView extends StatelessWidget {
  final TeoriaDellaMente pagina;
  final List<String> risposteDate;
  final ValueChanged<List<String>> onChanged;

  const TeoriaMenteView({
    super.key,
    required this.pagina,
    required this.risposteDate,
    required this.onChanged,
  });

  void _updatePart(int index, String newValue) {
      List<String> nuovaLista = List.from(risposteDate);
      
      // Safety check: allunghiamo se necessario
      while (nuovaLista.length <= index) {
        nuovaLista.add("");
      }
      
      nuovaLista[index] = newValue;
      onChanged(nuovaLista);
    }

  @override
  Widget build(BuildContext context) {
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
        ...pagina.lista_domande.asMap().entries.map((entry) {
          int idx = entry.key;
          Domanda domandaSingola = entry.value;

          // Recuperiamo la risposta direttamente dall'indice della lista
          String rispostaCorrente = risposteDate.length > idx ? risposteDate[idx] : "";

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
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 15,
      runSpacing: 10,
      children: opzioni.asMap().entries.map((entry) {
        int optIdx = entry.key;
        String optTesto = entry.value;
        
        // Salviamo l'indice come stringa per coerenza con il loader degli indici
        return _buildBtn(optTesto, selezionata == optIdx.toString(), () => _updatePart(idx, optIdx.toString()));
      }).toList(),
    );
  }

  // Widget per le domande a risposta aperta
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