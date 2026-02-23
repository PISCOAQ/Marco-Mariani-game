import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/utente.dart';
import 'package:gioco_demo/class/services/db_service.dart'; 
import 'package:gioco_demo/screens/MapScreen.dart';
import 'package:gioco_demo/widgets/AvatarSelector.dart';
import 'package:gioco_demo/widgets/StartButton.dart';
import 'package:gioco_demo/widgets/codeSelector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showAvatarSelector = false;
  int? selectedAvatar;
  bool showCodeInput = false;
  String userCode = "";

  final ApiService _apiService = ApiService();
  bool isLoading = false;
  Utente? currentUser;

  // Gestione vestiti di default se il DB è vuoto
  Map<String, String> _getAbitiDefault(int avatarId) {
    if (avatarId == 2) { // Femmina
      return {
        'shirts': 'top_white',
        'pants': 'leggins_pink',
        'hair': 'bob_cut',
        'shoes': 'flat_brown',
      };
    } else { // Maschio
      return {
        'shirts': 'casual_red',
        'pants': 'jeans_blue',
        'hair': 'short_yellow',
        'shoes': 'boots_brown',
      };
    }
  }

  // Posizione avatar per ogni livello
  static const Map<int, Offset> _spawnPoints = {
    1: Offset(400.0, 900.0),   
    2: Offset(820.0, 730.0),  
    3: Offset(890.0, 550.0),  
    4: Offset(750.0, 215.0),
    5: Offset(375.0, 260.0),
  };



  void _onStartPressed() {
    setState(() => showCodeInput = true);
  }

  // 1. FASE LOGIN: Ricezione dati dal database
  void _onCodeConfirmed(String code) async {
    setState(() => isLoading = true);

    try {
      final datiDb = await _apiService.getDatiUtente(code);

      if (!mounted) return;

      setState(() {
        userCode = code;
        showCodeInput = false;
        isLoading = false;

        if (datiDb['tipoAvatar'] == null) {
          showAvatarSelector = true;
        } else {
          // 1. Recuperiamo il livello attuale dal DB
          int livello = datiDb['Livello_Attuale'] ?? 1;

          // 2. Determiniamo la posizione corretta in base al livello
          // Se per qualche motivo il livello non è in mappa, usiamo il livello 1 come fallback
          Offset posizioneLivello = _spawnPoints[livello] ?? _spawnPoints[1]!;

          currentUser = Utente(
            codiceGioco: userCode,
            tipoAvatar: datiDb['tipoAvatar'],
            // AGGIORNATO: Usiamo la posizione legata al livello
            PosizioneX: posizioneLivello.dx,
            PosizioneY: posizioneLivello.dy,
            Monete: datiDb['moneteNotifier'] ?? 0,
            Livello_Attuale: livello,
            lookIniziale: Map<String, String>.from(datiDb['lookAttuale'] ?? {}),
            inventarioIniziale: (datiDb['inventario'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            ) ?? {},
          );
          _goToMap();
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Codice gioco non valido o errore di rete")),
      );
    }
  }

  // 2. FASE CREAZIONE: Salvataggio primo avatar
void _onConfirmPressed() async {
    if (selectedAvatar != null) {
      setState(() => isLoading = true);
      final abiti = _getAbitiDefault(selectedAvatar!);

      final datiIniziali = {
        "tipoAvatar": selectedAvatar,
        "moneteNotifier": 50,
        "Livello_Attuale": 1,
        "lookAttuale": abiti,
        "PosizioneX": 400.0,
        "PosizioneY": 900.0,
        "inventario": abiti.map((k, v) => MapEntry(k, [v])),
      };

      try {
        // Usiamo userCode che abbiamo salvato prima
        await _apiService.updateProgressi(userCode, datiIniziali);

        if (!mounted) return;

        setState(() {
          // AGGIORNATO: Passiamo il codice anche qui
          currentUser = Utente(
            codiceGioco: userCode, 
            tipoAvatar: selectedAvatar!,
            PosizioneX: 400.0,
            PosizioneY: 900.0,
            Monete: 50,
            Livello_Attuale: 1,
            lookIniziale: abiti,
            inventarioIniziale: abiti.map((k, v) => MapEntry(k, [v])),
          );
          isLoading = false;
        });
        _goToMap();
      } catch (e) {
        if (!mounted) return;
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Errore salvataggio: $e")),
        );
      }
    }
  }

  void _goToMap() {
    if (currentUser != null) {
      Navigator.pushReplacement( // Replacement evita di tornare indietro al login
        context,
        MaterialPageRoute(builder: (context) => MapScreen(utente: currentUser!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home.png', // Assicurati che il percorso sia corretto nel pubspec.yaml
              fit: BoxFit.cover,
            ),
          ),

          if (!showCodeInput && !showAvatarSelector)
            Center(child: StartButton(onPressed: _onStartPressed)),

          if (showCodeInput)
            CodeSelector(
              onConfirm: _onCodeConfirmed,
              onBack: () => setState(() => showCodeInput = false),
            ),

          if (showAvatarSelector)
            Avatarselector( // Assicurati che il widget si chiami esattamente così
              selectedAvatar: selectedAvatar,
              onAvatarSelected: (index) => setState(() => selectedAvatar = index),
              onConfirm: _onConfirmPressed,
              onBack: () => setState(() => showAvatarSelector = false),
            ),

          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}