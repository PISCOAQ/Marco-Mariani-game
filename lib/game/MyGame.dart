import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gioco_demo/class/models/SensorLevel.dart';
import 'package:gioco_demo/class/models/gateComponent.dart';
import 'package:gioco_demo/class/models/utente.dart';
import 'package:gioco_demo/game/chest.dart';
import 'package:gioco_demo/game/components/Interactive_object.dart';
import 'package:gioco_demo/widgets/LuceCartello.dart';
import 'player.dart';
import 'wall.dart';
import 'package:tiled/tiled.dart' as tiled;

// Definizione callback
typedef ShowActivityCallback = void Function(String tipo, int levelId);
typedef ShowChestCallback = void Function();
typedef LevelUnlockedCallback = void Function();
typedef ProgressCallback = void Function(double progress);

class MyGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  final Utente utente;
  final ShowActivityCallback onShowPopup;
  final ShowChestCallback onShowChestPopup;
  final LevelUnlockedCallback onLevelUnlocked;
  final ProgressCallback onProgress;
  final List<GateComponent> _activeGates = [];

  late Player player;
  late TiledComponent mapComponent;
  late TiledComponent ponteComponent;

  bool _sentieriVisibili = true;

  MyGame({
    required this.utente,
    required this.onShowPopup,
    required this.onShowChestPopup,
    required this.onLevelUnlocked,
    required this.onProgress,
  });

  @override
  Future<void> onLoad() async {
    onProgress(0.1);
    await super.onLoad();

    // 3. CARICAMENTO MAPPE
    mapComponent = await TiledComponent.load('game_map_Copia.tmx', Vector2.all(32));
    mapComponent.priority = 0;
    world.add(mapComponent);

    ponteComponent = await TiledComponent.load('game_map_Copia.tmx', Vector2.all(32));
    ponteComponent.priority = 15;
    world.add(ponteComponent);

    // Gestione visibilità layer ponte
    mapComponent.tileMap.getLayer<tiled.Layer>('livello_2')?.visible = false;
    for (var layer in ponteComponent.tileMap.renderableLayers) {
      String nome = layer.layer.name;
      if (nome != 'livello_2' && nome != 'interactions' && !nome.startsWith('percorso_')) {
        layer.layer.visible = false;
      }
    }

    // 4. COLLISIONI (Muri)
    for (final obj in _getObjects('collisioni')) {
      world.add(Wall(Vector2(obj.x, obj.y), Vector2(obj.width, obj.height)));
    }

    // 5. OGGETTI INTERATTIVI (Quiz, Chest, Cartelli)
    for (final object in _getObjects('interactions')) {
      final int levelId = object.properties.getValue<int>('levelId') ?? 1;

      if (object.type == 'trigger_quiz') {
        world.add(InteractiveObject(
          object.x, object.y, object.width, object.height,
          () => onShowPopup('quiz', levelId),
          spritePath: 'quiz.png',
          levelId: levelId,
        )..priority = 30);
      }

      if (object.type == 'trigger_esercitazione') {
        world.add(InteractiveObject(
          object.x, object.y, object.width, object.height,
          () => onShowPopup('esercitazione', levelId),
          spritePath: 'training.png',
          levelId: levelId,
        )..priority = 30);
      }

      if (object.type == 'chest') {
        final int chestLevel = object.properties.getValue<int>('level') ?? 1;
        world.add(Chest(
          position: Vector2(object.x, object.y),
          size: Vector2(object.width, object.height),
          onOpen: onShowChestPopup,
          level: chestLevel,
        ));
      }

      if (object.type == 'cartello_guida') {
        List<Vector2>? vertici;
        if (object.isPolygon) {
          vertici = object.polygon.map((p) => Vector2(p.x, p.y)).toList();
        }
        world.add(BaglioreCartello(
          position: Vector2(object.x, object.y),
          size: Vector2(object.width, object.height),
          levelId: levelId,
          punti: vertici,
        )..priority = 100);
      }
    }

    // 6. CANCELLI (Basati sull'utente)
    for (final obj in _getObjects('LevelBarriers')) {
      final String levelIdStr = obj.properties.getValue('valore')?.toString() ?? '1';
      final int levelId = int.tryParse(levelIdStr) ?? 1;

      // Se il livello del cancello è già stato sbloccato, non aggiungerlo
      if (levelId <= utente.Livello_Attuale) continue;

      final gate = GateComponent(
        position: Vector2(obj.x, obj.y),
        size: Vector2(obj.width, obj.height),
        gateId: levelIdStr,
      );
      _activeGates.add(gate);
      world.add(gate);
    }

    player = Player(
      avatarIndex: utente.tipoAvatar,
      position: Vector2(utente.PosizioneX, utente.PosizioneY),
      utente: utente,
    );
    world.add(player);

    // 8. SENSORI DI PIANO
    for (final obj in _getObjects('CurrentLevel')) {
      final int? piano = obj.properties.getValue<int>('current_level');
      if (piano != null) {
        world.add(FloorSensor(
          position: Vector2(obj.x, obj.y),
          size: Vector2(obj.width, obj.height),
          floorValue: piano,
        ));
      }
    }

    // 9. SINCRONIZZAZIONE PERCORSI LUMINOSI
    aggiornaPercorsi(utente.Livello_Attuale);

    // 10. CAMERA
    camera.viewfinder.zoom = 2.0;
    camera.follow(player);

    await Future.delayed(const Duration(milliseconds: 300));
    onProgress(1.0);
  }

  // --- METODI LOGICI ---

  void unlockLevel(String levelId) {
    final int? nuovoLivello = int.tryParse(levelId);
    if (nuovoLivello != null && nuovoLivello > utente.Livello_Attuale) {
      // Aggiorna l'oggetto utente
      utente.Livello_Attuale = nuovoLivello;

      // Rimuovi i cancelli ora superati
      _activeGates.removeWhere((gate) {
        int idCancello = int.tryParse(gate.gateId) ?? 0;
        if (idCancello <= utente.Livello_Attuale) {
          gate.removeFromParent();
          return true;
        }
        return false;
      });

      // Aggiorna i percorsi luminosi sulla mappa
      aggiornaPercorsi(utente.Livello_Attuale);
      onLevelUnlocked();
    }
  }

  void aggiornaPercorsi(int livelloAttuale, {bool? mostrare}) {
    if (mostrare != null) _sentieriVisibili = mostrare;

    for (int i = 1; i <= 5; i++) {
      String nomeLayer = 'percorso_$i';
      bool deveEssereVisibile = (livelloAttuale == i) && _sentieriVisibili;
      _impostaVisibilitaLayer(nomeLayer, deveEssereVisibile);
    }
  }

  void _impostaVisibilitaLayer(String nomeLayer, bool visibile) {
    double opacita = visibile ? 0.5 : 0.0;
    for (var comp in [mapComponent, ponteComponent]) {
      final layer = comp.tileMap.getLayer<tiled.Layer>(nomeLayer);
      if (layer != null) {
        layer.opacity = opacita;
        layer.visible = visibile;
      }
    }
  }

  // --- UTILITY ---
  List<tiled.TiledObject> _getObjects(String layerName) {
    final allObjects = <tiled.TiledObject>[];
    for (final renderableLayer in mapComponent.tileMap.renderableLayers) {
      allObjects.addAll(_searchInLayer(renderableLayer.layer, layerName));
    }
    return allObjects;
  }

  Iterable<tiled.TiledObject> _searchInLayer(tiled.Layer layer, String name) {
    if (layer is tiled.ObjectGroup && layer.name == name) return layer.objects;
    if (layer is tiled.Group) {
      return layer.layers.expand((subLayer) => _searchInLayer(subLayer, name));
    }
    return [];
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> pressedKeys) {
    if (event is KeyDownEvent) player.pressKey(event.logicalKey, true);
    if (event is KeyUpEvent) player.pressKey(event.logicalKey, false);
    return super.onKeyEvent(event, pressedKeys);
  }

  void resetInput() => player.resetMovement();
}