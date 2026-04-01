import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ApiService {
  static final String baseUrl =dotenv.env['API_URL'] ?? "http://localhost:3000";


  Future<Map<String, dynamic>> getDatiUtente(String codiceGioco) async {
    // 1. Prendiamo i dati base (avatar, monete, posizione)
    final urlDati = Uri.parse('$baseUrl/utente/$codiceGioco');
    // 2. Prendiamo i percorsi dalla rotta dedicata
    final urlPercorsi = Uri.parse('$baseUrl/utenti/$codiceGioco/percorsi');

    try {
      final resDati = await http.get(urlDati);
      final resPercorsi = await http.get(urlPercorsi);

      if (resDati.statusCode == 200 && resPercorsi.statusCode == 200) {
        final Map<String, dynamic> dati = json.decode(resDati.body);
        final List<dynamic> percorsi = json.decode(resPercorsi.body);

        // Uniamo i dati: mettiamo la lista dei percorsi dentro l'oggetto dati
        dati['percorsiAssegnati'] = percorsi;
        
        return dati;
      } else {
        throw Exception('Errore nel recupero dati combinati');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Metodo per salvare i progressi quando il bambino gioca
  Future<void> updateProgressi(String codiceGioco, Map<String, dynamic> progressi) async {
    final url = Uri.parse('$baseUrl/utenti/$codiceGioco/progressi');

    print("Body inviato: ${jsonEncode(progressi)}");

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(progressi),
      );

      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");
    } catch (e) {
      print("Errore: $e");
    }
  }


  // Questa versione invia il JSON tecnico con i dati del quiz
  Future<void> uploadDatiJson(String codiceGioco, Map<String, dynamic> progressi) async {
    final url = Uri.parse('$baseUrl/api/tentativi-test');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(progressi),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("✅ Report Quiz salvato correttamente!");
      } else {
        print("⚠️ Errore invio report: Status ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Errore connessione uploadDatiJson: $e");
    }
  }


  // Nuovo metodo per ottenere solo l'ID del percorso assegnato
  Future<String> getPercorsoIdAssegnato(String codiceGioco) async {
    final url = Uri.parse('$baseUrl/utenti/$codiceGioco/percorsi');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> percorsi = json.decode(response.body);

        if (percorsi.isNotEmpty) {
          // Estraiamo l'ID e lo restituiamo come String sicura
          final String idPercorso = percorsi[0]['percorsoIdEsterno'].toString();
          print("✅ ID Percorso trovato: $idPercorso");
          return idPercorso;
        } else {
          // Se l'array è vuoto, è un errore di logica di business
          throw Exception('Nessun percorso assegnato per il codice: $codiceGioco');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Utente non trovato');
      } else {
        throw Exception('Errore server: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Errore critico getPercorsoIdAssegnato: $e");
      // Lanciamo l'errore per non dover restituire null
      rethrow; 
    }
  }

  // Metodo per aggiornare il ctxId di un percorso specifico nel DB
  Future<void> updateCtxId(
    String codiceGioco,
    String percorsoId,
    String ctxId,
  ) async {

    print("--- DEBUG UPDATE CTX ---");
  print("Codice Gioco: $codiceGioco");
  print("Percorso ID (FlowID): $percorsoId");
  print("Context ID (ctxId): $ctxId");


    final url = Uri.parse('$baseUrl/utenti/$codiceGioco/ctx'); // Verifica il path col tuo amico, nell'API sembra puntare qui
print("Chiamata a URL: $url");
    try {
      final response = await http.patch(
        // Usiamo PATCH o POST in base a come è registrata la rotta
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'percorsoId': percorsoId, 'ctxId': ctxId}),
      );

      print("--- RISPOSTA SERVER ---");
    print("Status Code: ${response.statusCode}");
    print("Body Risposta: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ ctxId aggiornato nel DB per il percorso $percorsoId");
      } else {
        print("⚠️ Errore aggiornamento ctxId: ${response.body}");
      }
    } catch (e) {
      print("❌ Errore connessione updateCtxId: $e");
    }
  }
}