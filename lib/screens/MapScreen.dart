import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gioco_demo/game/MyGame.dart';
import 'package:gioco_demo/widgets/PageOverlay.dart';
import 'package:gioco_demo/widgets/Shop.dart';

class MapScreen extends StatefulWidget {
  final int avatarIndex;

  const MapScreen({super.key, required this.avatarIndex});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MyGame _myGame; 
  bool _isPageActive = false; 
  bool _isChestPage = false;

  @override
  void initState() {
    super.initState();
    _myGame = MyGame(
      avatarIndex: widget.avatarIndex,
      onShowPopup: _showPopup, 
      onShowChestPopup: _showChestPage,
    );
  }

  void _showChestPage(){
    setState(() {
      _isChestPage = true;
      _myGame.pauseEngine();
    });
  }

  // Funzione chiamata dal codice Flame quando c'è una collisione
  void _showPopup() {
    setState(() {
      _isPageActive = true;
      _myGame.pauseEngine(); // Metti in pausa il gioco per bloccare il movimento dell'avatar
    });
  }

  void _CloseChestPage(){
    setState(() {
      _isChestPage = false;
      _myGame.resumeEngine();
    });
  }

  // Funzione chiamata dal pulsante 'X' del popup per chiuderlo
  void _closePage() {
    setState(() {
      _isPageActive = false;
      // Riprendi il gioco per permettere all'avatar di muoversi
      _myGame.resumeEngine(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( //Stack per sovrapporre il popup al gioco
        children: [
          GameWidget(game: _myGame),

          //Il Widget Overlay (visibile solo se _isQuizActive è true)
          if (_isPageActive)
            PageOverlay( 
              onExit: _closePage,
            ),

          if (_isChestPage)
          ChestPage( // Un widget diverso o lo stesso con dati diversi
            game: _myGame,
            onExit: _CloseChestPage,
          ),
        ],
      ),
    );
  }
}