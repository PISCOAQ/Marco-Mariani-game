import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Percorso.dart';
import 'package:gioco_demo/class/models/utente.dart';
import 'package:gioco_demo/class/services/API_service.dart'; 
import 'package:gioco_demo/screens/MapScreen.dart';
import 'package:gioco_demo/widgets/AvatarSelector.dart';
import 'package:gioco_demo/widgets/PercorsoSelector.dart';
import 'package:gioco_demo/widgets/StartButton.dart';
import 'package:gioco_demo/widgets/codeSelector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showCodeInput = false;
  bool showPercorsoSelector = false;
  bool showAvatarSelector = false;
  Percorso? selectedPercorso; 
  int? selectedAvatar;
  String userCode = "";
  String? idPercorso;

  List<Percorso> _percorsi = [];

  final ApiService _apiService = ApiService();
  bool isLoading = false;
  Utente? currentUser;

  // Gestione vestiti di default se il DB è vuoto
  Map<String, String> _getAbitiDefault(int avatarId) {
    if (avatarId == 2) { // Femmina
      return {
        'shirts': 'top_white', 'pants': 'leggins_pink', 'hair': 'bob_cut', 'shoes': 'flat_brown',
      };
    } else { // Maschio
      return {
        'shirts': 'casual_red', 'pants': 'jeans_blue', 'hair': 'short_yellow', 'shoes': 'boots_brown',
      };
    }
  }

  // Posizione avatar per ogni livello
  static const Map<int, Offset> _positions = {
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
      print("Dati DB: $datiDb");
      if (!mounted) return;

      setState(() {
        userCode = code;
        showCodeInput = false;
        isLoading = false;

        // Passiamo tutto al Factory Constructor: pensa lui a monete, livelli e posizioni
        currentUser = Utente.fromMap(code, datiDb, _positions);
        _percorsi = currentUser!.percorsiAssegnati;

        // 3. MOSTRA IL SELETTORE PERCORSI
        showPercorsoSelector = true;
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

    try {
      // Salvataggio sul DB
      await _apiService.updateProgressi(userCode, {
          "percorsoId": currentUser!.percorsoAttivo!.flowId, // <--- OBBLIGATORIO
          "tipoAvatar": selectedAvatar,
          "lookAttuale": abiti,
          "inventario": abiti.map((k, v) => MapEntry(k, [v])),
          "moneteNotifier": currentUser!.monete,
          "Livello_Attuale": currentUser!.percorsoAttivo!.Livello_Attuale,
          "PosizioneX": currentUser!.percorsoAttivo!.PosizioneX,
          "PosizioneY": currentUser!.percorsoAttivo!.PosizioneY,
      });

      setState(() {
        // Aggiorniamo l'utente finale
        currentUser!.tipoAvatar = selectedAvatar!;
        currentUser!.lookAttuale = abiti;
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

void _onPercorsoConfirmed() {
  if (selectedPercorso != null) {
    setState(() {
      currentUser!.percorsoAttivo = selectedPercorso;

      final livello = selectedPercorso!.Livello_Attuale;
      final pos = _positions[livello];

      if (pos != null) {
        selectedPercorso!.PosizioneX = pos.dx;
        selectedPercorso!.PosizioneY = pos.dy;
      }

      showPercorsoSelector = false;

      if (currentUser!.tipoAvatar == null) {
        showAvatarSelector = true;
      } else {
        _goToMap();
      }
    });
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

          if (!showCodeInput && !showPercorsoSelector && !showAvatarSelector)
            Center(child: StartButton(onPressed: _onStartPressed)),

          if (showCodeInput)
            CodeSelector(
              onConfirm: _onCodeConfirmed,
              onBack: () => setState(() => showCodeInput = false),
            ),

          if (showPercorsoSelector)
            PercorsoSelector(
              listaPercorsi: _percorsi,
              selectedPercorso: selectedPercorso, 
              onPercorsoSelected: (p) => setState(() => selectedPercorso = p),
              onConfirm: _onPercorsoConfirmed,
              onBack: () => setState(() => showPercorsoSelector = false),
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