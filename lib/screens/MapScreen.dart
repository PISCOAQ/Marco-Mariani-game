import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gioco_demo/class/services/Activity_loader.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/game/MyGame.dart';
import 'package:gioco_demo/widgets/ChestPage.dart';
import 'package:gioco_demo/widgets/GameNotification.dart';
import 'package:gioco_demo/widgets/MoneyWidget.dart';
import 'package:gioco_demo/widgets/PageOverlay.dart';
import 'package:gioco_demo/widgets/levelNotification.dart';

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
  String? _messaggioNotifica;
  dynamic _attivitaCaricata;

  final ValueNotifier<bool> _levelUpNotifier = ValueNotifier<bool>(false);


  // 1. Creiamo il FocusNode dedicato al gioco
  final FocusNode _gameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _myGame = MyGame(
      avatarIndex: widget.avatarIndex,
      onShowPopup: _showPopup, 
      onShowChestPopup: _showChestPage,
      onLevelUnlocked: () {
        print("CALLBACK RICEVUTA IN MAPSCREEN!"); // Verifica se leggi questo in console
        _levelUpNotifier.value = true;
        Future.delayed(const Duration(seconds: 5), () {
          _levelUpNotifier.value = false;
        });
      },
    );  
  }

  @override
  void dispose() {
    // 2. Liberiamo la memoria
    _gameFocusNode.dispose();
    super.dispose();
  }

  void _showChestPage(){
    setState(() {
      _messaggioNotifica = null;
      _isChestPage = true;
      _myGame.pauseEngine();
    });
  }

  void _showPopup(String tipo) async {
    final risultato = await ActivityLoader.carica();
    if (risultato == null) return;

    if (risultato is Esercitazione) {
      if (tipo == 'quiz') {
        _mostraMessaggioAvviso("Fai l'esercitazione, poi torna qui!");
        return; 
      } else {
        setState(() {
          _messaggioNotifica = null;
          _attivitaCaricata = risultato;
          _isPageActive = true;
          _myGame.pauseEngine();
        });
        return; 
      }
    }

    if (risultato is Quiz) {
      if (tipo == 'esercitazione') {
        _mostraMessaggioAvviso("Esegui il quiz!");
        return;
      } else {
        setState(() {
          _messaggioNotifica = null;
          _attivitaCaricata = risultato;
          _isPageActive = true;
          _myGame.pauseEngine();
        });
        return;
      }
    }
  }

  void _mostraMessaggioAvviso(String testo) {
    setState(() {
      _messaggioNotifica = testo;
    });
  }

  // 3. Funzioni di chiusura: riprendiamo il focus
  void _CloseChestPage(){
    setState(() {
      _isChestPage = false;
      _myGame.resumeEngine();
    });
    _gameFocusNode.requestFocus(); // Torna al gioco
  }

  void _closePage() {
    setState(() {
      _isPageActive = false;
      _myGame.resumeEngine(); 
    });
    
    // Usiamo addPostFrameCallback per essere sicuri che la UI sia chiusa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gameFocusNode.requestFocus();
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // 1. IL GIOCO (Sotto a tutto)
        GameWidget(
          game: _myGame,
          focusNode: _gameFocusNode,
          autofocus: true,
          overlayBuilderMap: {
            'LevelUp': (context, MyGame game) => LevelUpOverlay(game: game),
          },
        ),

        // 2. Widget delle monete
        Moneywidget(walletNotifier: _myGame.playerState.coins),

        // 3. Notifiche di sistema
        if (_messaggioNotifica != null)
          GameNotification(
            key: UniqueKey(),
            messaggio: _messaggioNotifica!,
          ),

        // 4. Overlay della Pagina Quiz/Esercitazione
        if (_isPageActive)
          PageOverlay(
            onExit: _closePage,
            attivita: _attivitaCaricata,
          ),

        // 5. Pagina dello Scrigno
        if (_isChestPage)
          ChestPage(
            game: _myGame,
            onExit: _CloseChestPage,
          ),

        // 6. L'ANIMAZIONE DI LIVELLO (DEVE ESSERE L'ULTIMA PER STARE SOPRA)
        ValueListenableBuilder<bool>(
          valueListenable: _levelUpNotifier,
          builder: (context, visible, child) {
            if (!visible) return const SizedBox.shrink();
            
            // Usiamo IgnorePointer così se l'utente clicca mentre c'è l'animazione, 
            // il click passa al quiz o al gioco sottostante
            return IgnorePointer(
              child: LevelUpOverlay(game: _myGame),
            );
          },
        ),
      ],
    ),
  );
}
  
}