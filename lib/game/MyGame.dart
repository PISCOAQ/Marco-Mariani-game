import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gioco_demo/game/chest.dart';
import 'package:gioco_demo/game/components/interective_object.dart';
import 'player.dart';
import 'wall.dart'; 

// Definiamo il tipo di funzione di callback (void Function())
typedef ShowPopupCallback = void Function();

class MyGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  
  late Player player;
  late TiledComponent mapComponent; 
  
  final int avatarIndex;
  // Aggiungi la callback che riceverai da Flutter
  final ShowPopupCallback onShowPopup; 
  final ShowPopupCallback onShowChestPopup;

  // Aggiorna il costruttore per ricevere la callback
  MyGame({
    required this.avatarIndex,
    required this.onShowPopup,
    required this.onShowChestPopup,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Carica la mappa e assegna a mapComponent
    mapComponent = await TiledComponent.load('game_map.tmx', Vector2.all(32));

    // 2. Carica gli oggetti interattivi
    final objectLayer = mapComponent.tileMap.getLayer<ObjectGroup>('interactions');

    if (objectLayer != null) {
      for (final object in objectLayer.objects) {
          // TiledObject espone direttamente x, y, width e height
          if (object.type == 'trigger_quiz') {
              // Crea e aggiungi il componente QuizTrigger
              add(InterectiveObject(
                  object.x,        // <-- Usa object.x
                  object.y,        // <-- Usa object.y
                  object.width,    // <-- Usa object.width
                  object.height,   // <-- Usa object.height
                  onShowPopup,
              ));
          }
      }
    }

    for (final obj in objectLayer!.objects) {
      if (obj.type == 'chest') {
        final chest = Chest(
          position: Vector2(obj.x, obj.y),
          size: Vector2(obj.width, obj.height),
          onOpen: onShowChestPopup
        );
        world.add(chest);
      }
    }
    
    player = Player(avatarIndex: avatarIndex, position: Vector2(400, 900)); 

    // Aggiungi tutto al world
    world.add(mapComponent); // Usa mapComponent
    world.add(player);

    // Collisioni
    final collisionLayer = mapComponent.tileMap.getLayer<ObjectGroup>('collisioni');
    if (collisionLayer != null) {
      for (final obj in collisionLayer.objects) {
        world.add(Wall(Vector2(obj.x, obj.y), Vector2(obj.width, obj.height)));
      }
    }

    // Camera che segue il player
    camera.viewfinder.zoom = 2.0;
    camera.follow(player);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> pressedKeys) {
    if (event is KeyDownEvent) player.pressKey(event.logicalKey, true);
    if (event is KeyUpEvent) player.pressKey(event.logicalKey, false);
    return super.onKeyEvent(event, pressedKeys);
  }
}