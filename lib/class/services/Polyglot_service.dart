import 'dart:convert';
import 'package:http/http.dart' as http; // Usiamo la libreria standard

class PolyglotService {
  // URL e configurazioni restano private all'interno della classe
  static const String _baseUrl = "https://piscoaq-editor.polyglot-edu.com/api/execution";
  
  String? _ctxId;
  Map<String, dynamic>? lastRawResponse;

  PolyglotService();

  // Metodo per iniziare la sessione
  Future<String?> firstCall(String flowId) async {
    try {
      final url = Uri.parse("$_baseUrl/first");
      final response = await http.post(
        url,
        body: jsonEncode({"flowId": flowId}),
        headers: {"Content-Type": "application/json"},
      );
      
      final data = jsonDecode(response.body);
      _ctxId = data["ctx"];
      return _ctxId;
    } catch (e) {
      print("Errore Polyglot (First): $e");
    }
  }

  // Metodo per scaricare i dati attuali (il JSON del quiz)
  Future<void> actualCall(String ctxId) async {
    _ctxId = ctxId;
    try {
      final url = Uri.parse("$_baseUrl/actual");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ctxId": ctxId, // Inviamo il token di sessione nel body
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        lastRawResponse = jsonDecode(response.body);
        print("✅ Polyglot ACTUAL OK: Ricevuto nodo tipo ${lastRawResponse?['type']}");
        
        // LOG DI DEBUG PER VEDERE LA VALIDAZIONE
        if (lastRawResponse!.containsKey('validation')) {
          print("📊 Regole validazione trovate: ${lastRawResponse!['validation']}");
        }
      } else {
        print("❌ Errore ACTUAL: ${response.statusCode}");
        print("Body errore: ${response.body}");
      }
    } catch (e) {
      print("❌ Errore di rete su ACTUAL: $e");
    }
  }

  // 3. NEXT: Avanza (Anche questa solitamente è POST)
  Future<void> nextCall(List<String> choiceIds) async {
    if (_ctxId == null) return;
    try {
      final url = Uri.parse("$_baseUrl/next");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ctxId": _ctxId,
          "satisfiedConditions": choiceIds,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Polyglot NEXT OK: Scelta inviata con successo");
      } else {
        print("❌ Errore NEXT: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Errore di rete su NEXT: $e");
    }
  }
}