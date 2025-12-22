import 'package:flutter/material.dart';
import 'package:gioco_demo/screens/MapScreen.dart';
import 'package:gioco_demo/widgets/AvatarSelector.dart';
import 'package:gioco_demo/widgets/StartButton.dart'; 


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // Stato per controllare la visibilità dell'overlay
  bool showAvatarSelector = false;
  // Stato per l'avatar selezionato
  int? selectedAvatar; 

  // LOGICA: Mostra l'overlay quando si preme Start
  void _onStartPressed() {
    setState(() {
      showAvatarSelector = true;
    });
  }

  // LOGICA: Gestisce la selezione dell'avatar
  void _onAvatarSelected(int index) {
    setState(() {
      selectedAvatar = index;
    });
  }
  
  // LOGICA: Conferma e naviga al gioco
  void _onConfirmPressed() {
    if (selectedAvatar != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(
            avatarIndex: selectedAvatar!,
          ),
        ),
      );
    }
  }

  void _onBack(){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Sfondo Immobile
          Positioned.fill(
            child: Image.asset(
              '/images/casa.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Pulsante Start (Visibile solo se AvatarSelector NON è mostrato)
          if (!showAvatarSelector)
            Center(
              // Il pulsante chiama la logica per mostrare l'overlay
              child: StartButton(onPressed: _onStartPressed), 
            ),

          // 3. Overlay di Selezione Avatar (Visibile solo se showAvatarSelector è TRUE)
          if (showAvatarSelector)
            Avatarselector(
              selectedAvatar: selectedAvatar,
              onAvatarSelected: _onAvatarSelected,
              onConfirm: _onConfirmPressed,
              onBack: _onBack,
              // Nota: qui potresti voler aggiungere un pulsante 'Chiudi' per tornare alla Home
            ),
        ],
      ),
    );
  }
}