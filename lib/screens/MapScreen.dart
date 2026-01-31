import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gioco_demo/class/models/Levelmanager.dart';
import 'package:gioco_demo/class/services/Activity_loader.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/game/MyGame.dart';
import 'package:gioco_demo/widgets/ChestPage.dart';
import 'package:gioco_demo/widgets/GameNotification.dart';
import 'package:gioco_demo/widgets/Gameloading_screen.dart';
import 'package:gioco_demo/widgets/MoneyWidget.dart';
import 'package:gioco_demo/widgets/PageOverlay.dart';
import 'package:gioco_demo/widgets/infoPopUp.dart';
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
  bool _isGuideOpen = false;
  bool _mostraSentieri = true;

  final ValueNotifier<bool> _levelUpNotifier = ValueNotifier<bool>(false);


  // 1. Creiamo il FocusNode dedicato al gioco
  final FocusNode _gameFocusNode = FocusNode();

  double _loadingProgress = 0.0;
  bool _isLoadingVisible = true;

  @override
  void initState() {
    super.initState();
    _myGame = MyGame(
      avatarIndex: widget.avatarIndex,
      onShowPopup: _showPopup, 
      onShowChestPopup: _showChestPage,
      onLevelUnlocked: () {
        _levelUpNotifier.value = true;
        Future.delayed(const Duration(seconds: 3), () {   //Durata levelNotification
          _levelUpNotifier.value = false;
        });
      },
      onProgress: (progress) {
        // Questo dice a Flutter: "Appena hai finito di disegnare, esegui questo"
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) { // Controllo di sicurezza: lo schermo è ancora attivo?
            setState(() {
              _loadingProgress = progress;
              if (progress >= 1.0) {
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (mounted) setState(() => _isLoadingVisible = false);
                });
              }
            });
          }
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

  void _toggleGuide() {
    setState(() {
      _isGuideOpen = !_isGuideOpen;
      if (_isGuideOpen) {
        _myGame.pauseEngine();
      } else {
        _myGame.resumeEngine();
        // Ridiamo il focus al gioco dopo la chiusura
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _gameFocusNode.requestFocus();
        });
      }
    });
  }

  void _showPopup(String tipo, int levelId) async {
    final risultato = await ActivityLoader.carica();
    if (risultato == null) return;

    if (LevelManager.currentLevel > levelId) {
      _mostraMessaggioAvviso("Sfida già completata!");
      return;
    }

    if (risultato is Esercitazione && tipo == "quiz") {
        _mostraMessaggioAvviso("Fai l'esercitazione, poi torna qui!");
        return; 
    }
    if (risultato is Quiz && tipo == "esercitazione") {
      _mostraMessaggioAvviso("Esegui il quiz!");
      return;
    }

    setState(() {
      _messaggioNotifica = null;
      _attivitaCaricata = risultato;
      _isPageActive = true;
      _myGame.pauseEngine();
    });

    //PROVVISORIO -> DOPO SBLOCCO QUANDO PASSO IL QUIZ
    _myGame.unlockLevel((levelId + 1).toString());

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
            'LevelUp': (context, MyGame game) => LevelNotification(game: game),
          },
        ),


        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min, // La riga occupa solo lo spazio necessario
              crossAxisAlignment: CrossAxisAlignment.center, // Allineamento verticale perfetto
              children: [
                // PRIMA IL PULSANTE GUIDA
Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: _toggleGuide,
    borderRadius: BorderRadius.circular(25),
    child: Container(
      height: 45,
      // Togliamo width: 45 per permettere al tasto di allargarsi in base al testo
      padding: const EdgeInsets.symmetric(horizontal: 16), // Spazio interno laterale
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        // Cambiamo da BoxShape.circle a una forma rettangolare arrotondata
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min, // Il contenitore stringe intorno al contenuto
        children: [
          Icon(
            Icons.help_outline, 
            color: Colors.white, 
            size: 20
          ),
          SizedBox(width: 8), // Spazio tra icona e scritta
          Text(
            'AIUTO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5, // Un tocco di stile gaming
            ),
          ),
        ],
      ),
    ),
  ),
),
                
                const SizedBox(width: 12), // Spazio preciso tra pulsante e monete

                // POI IL WIDGET MONETE
                Moneywidget(walletNotifier: _myGame.playerState.coins),
              ],
            ),
          ),
        ),

        if (_isGuideOpen)
          InfoPopup(
            sentieriAttivi: _mostraSentieri,
            onToggleSentieri: (nuovoStato) {
              setState(() {
                _mostraSentieri = nuovoStato;
              });
              // Comunichiamo al gioco di aggiornare la visibilità dei layer
              _myGame.aggiornaPercorsi(LevelManager.currentLevel, mostrare: nuovoStato);
            },
            onExit: _toggleGuide,
          ), 

        // 5. NOTIFICHE DI SISTEMA (Messaggi avviso)
        if (_messaggioNotifica != null)
          GameNotification(
            key: UniqueKey(),
            messaggio: _messaggioNotifica!,
          ),

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
              child: LevelNotification(game: _myGame),
            );
          },
        ),



        // 7. SCHERMATA DI CARICAMENTO (Sopra a tutto finché non finisce)
        IgnorePointer(
          ignoring: !_isLoadingVisible, // Lascia passare i click quando sparisce
          child: AnimatedOpacity(
            opacity: _isLoadingVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1000), // Dissolvenza fluida
            curve: Curves.easeOut,
            child: GameLoadingScreen(progress: _loadingProgress),
          ),
        ),
      ],
    ),
  );
}
  
  
}