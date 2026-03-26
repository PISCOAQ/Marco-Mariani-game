import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ApiService {
  // Se testi su PC/Web: localhost. Se testi su emulatore Android: 10.0.2.2
  static final String baseUrl = dotenv.env['API_URL'] ?? "http://localhost:3000";

  Future<Map<String, dynamic>> getDatiUtente(String codiceGioco) async {
    
    final url = Uri.parse('$baseUrl/utente/$codiceGioco');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Verifichiamo che i dati fondamentali ci siano
        if (data == null) throw Exception('Risposta vuota dal server');
        
        return data; 
      } else if (response.statusCode == 404) {
        throw Exception('Codice gioco non trovato');
      } else {
        throw Exception('Errore server: ${response.statusCode}');
      }
    } catch (e) {
      print("Errore API Service: $e");
      rethrow;
    }
  }

  // Metodo per salvare i progressi quando il bambino gioca
  Future<void> updateProgressi(String codiceGioco, Map<String, dynamic> progressi) async {
    final url = Uri.parse('$baseUrl/utenti/$codiceGioco/progressi');
    
    try {
      await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(progressi),
      );
    } catch (e) {
      print("Errore salvataggio: $e");
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
}