import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gioco_demo/game/MyGame.dart';
import 'package:gioco_demo/widgets/Gameloading_screen.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late MyGame _game;
  double _loadingProgress = 0;
  bool _isGameReady = false;

  @override
  void initState() {
    super.initState();
    _game = MyGame(
      avatarIndex: 1, // o il tuo indice
      onShowPopup: (tipo) => print("Popup: $tipo"),
      onShowChestPopup: () => print("Chest!"),
      onLevelUnlocked: () => print("Level Unlocked"),
      // Aggiungiamo una callback per il progresso (la definiamo dopo nel MyGame)
      onProgress: (val) {
        setState(() {
          _loadingProgress = val;
          if (val >= 1.0) {
            // Piccolo delay per far vedere il 100% e poi sfumare
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() => _isGameReady = true);
            });
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. IL GIOCO
          GameWidget(game: _game),

          // 2. OVERLAY DI CARICAMENTO CON DISSOLVENZA
          IgnorePointer(
            ignoring: _isGameReady,
            child: AnimatedOpacity(
              opacity: _isGameReady ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 1000), // Dissolvenza fluida
              child: GameLoadingScreen(progress: _loadingProgress),
            ),
          ),
        ],
      ),
    );
  }
}