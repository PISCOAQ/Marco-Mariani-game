import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:gioco_demo/class/models/ClothingItem.dart';
import 'package:gioco_demo/class/models/PlayerState.dart';
import 'package:gioco_demo/class/models/avatarConfig.dart';
import 'package:gioco_demo/class/services/Avatar_loader.dart';
import 'package:gioco_demo/game/chest.dart';

class Player extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef {
  Vector2 velocity = Vector2.zero();
  final double speed = 130;
  final Set<LogicalKeyboardKey> _keysPressed = {};
  late Vector2 lastDelta;

  final PlayerState playerState;

  late final AvatarConfig avatarConfig;

  // Animazioni Corpo
  late SpriteAnimation walkRightAnimation, walkLeftAnimation, walkBackAnimation, walkAnimation, idleAnimation;

  final int avatarIndex;

  Map<String, String?> currentLayers = {
  'shirt': null,
  'pants': null,
  'hair': null,
  'shoes': null,
};


  // --- NUOVO: multi-layer generico ---
  final Map<String, SpriteAnimationComponent> layers = {};
  final Map<String, SpriteAnimation?> animations = {};
  final Map<String, String?> currentLayerColor = {};

  Player({required this.avatarIndex, required Vector2 position, required this.playerState})
      : super(position: position, size: Vector2(64, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // 1. CARICAMENTO CORPO
    avatarConfig = await loadAvatarFromJson('../data/avatar.json',avatarIndex);


    final image = await gameRef.images.load(avatarConfig.bodyPath);
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(64, 64));

    await _applyEquippedItems();

    walkBackAnimation = spriteSheet.createAnimation(row: avatarConfig.rowBack, stepTime: avatarConfig.stepTime, to: 9);
    walkRightAnimation = spriteSheet.createAnimation(row: avatarConfig.rowRight, stepTime: avatarConfig.stepTime, to: 9);
    walkLeftAnimation = spriteSheet.createAnimation(row: avatarConfig.rowLeft, stepTime: avatarConfig.stepTime, to: 9);
    walkAnimation = spriteSheet.createAnimation(row: avatarConfig.rowFront, stepTime: avatarConfig.stepTime, to: 9);
    idleAnimation = spriteSheet.createAnimation(row: avatarConfig.rowIdle, stepTime: avatarConfig.idleStepTime, from: 0, to: 1);

    animation = idleAnimation;

    // 2. HITBOX
    add(RectangleHitbox(size: Vector2(20, 10), position: Vector2(22, 50)));

    priority = 2;
  }

  // --- NUOVO: funzione generica per aggiungere layer ---
  Future<void> loadLayer(String layerName, Map<String, ClothingItem> items, String? color) async {
    if (color == null) return;

    final item = items[color];
    if (item == null) return;

    final image = await gameRef.images.load(item.path);
    final sheet = SpriteSheet(image: image, srcSize: Vector2(64, 64));

    animations['${layerName}_back'] =
        sheet.createAnimation(row: avatarConfig.rowBack, stepTime: avatarConfig.stepTime, to: 9);
    animations['${layerName}_left'] =
        sheet.createAnimation(row: avatarConfig.rowLeft, stepTime: avatarConfig.stepTime, to: 9);
    animations['${layerName}_front'] =
        sheet.createAnimation(row: avatarConfig.rowFront, stepTime: avatarConfig.stepTime, to: 9);
    animations['${layerName}_right'] =
        sheet.createAnimation(row: avatarConfig.rowRight, stepTime: avatarConfig.stepTime, to: 9);
    animations['${layerName}_idle'] =
        sheet.createAnimation(row: avatarConfig.rowIdle, stepTime: avatarConfig.idleStepTime, from: 0, to: 1);

    if (!layers.containsKey(layerName)) {
      final comp = SpriteAnimationComponent(size: size);
      layers[layerName] = comp;
      add(comp);
    }

    layers[layerName]!.animation = animations['${layerName}_idle'];
    currentLayerColor[layerName] = color;
  }

  Future<void> changeLayer(String layerName, Map<String, ClothingItem> assets, String color) async {
    currentLayerColor[layerName] = color;
    await loadLayer(layerName, assets, color);
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocity.setZero();
    if (_keysPressed.contains(LogicalKeyboardKey.arrowUp)) velocity.y = -1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowDown)) velocity.y = 1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowLeft)) velocity.x = -1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowRight)) velocity.x = 1;

    if (velocity.length != 0) {
  // Muovi e aggiorna le animazioni normalmente
  velocity.normalize();
  lastDelta = velocity * speed * dt;
  position += lastDelta;

  // Aggiorna animazioni layer
  for (final layerName in layers.keys) {
    if (velocity.y < 0) layers[layerName]!.animation = animations['${layerName}_back'];
    else if (velocity.y > 0) layers[layerName]!.animation = animations['${layerName}_front'];
    else if (velocity.x < 0) layers[layerName]!.animation = animations['${layerName}_left'];
    else if (velocity.x > 0) layers[layerName]!.animation = animations['${layerName}_right'];

    layers[layerName]!.animation!.stepTime = avatarConfig.stepTime; // assicurati che l'animazione scorra
  }

      // Aggiorna corpo principale
      animation = (velocity.y < 0)
          ? walkBackAnimation
          : (velocity.y > 0)
              ? walkAnimation
              : (velocity.x < 0)
                  ? walkLeftAnimation
                  : walkRightAnimation;
      animation!.stepTime = avatarConfig.stepTime;

    } else {
      lastDelta = Vector2.zero();

      // Quando fermo, blocco le animazioni multi-layer e corpo principale sul frame corrente
      for (final layerName in layers.keys) {
        final anim = layers[layerName]!.animation;
        if (anim != null) {
          anim.stepTime = double.infinity; // ferma l'avanzamento dei frame
        }
      }
      if (animation != null) animation!.stepTime = double.infinity;
    }
    
    priority = position.y.toInt(); // Aggiorna priority in base alla posizione y
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Chest) other.open();
    if (other is! Player) position -= lastDelta;
    super.onCollision(intersectionPoints, other);
  }

  void pressKey(LogicalKeyboardKey key, bool down) {
    if (down)
      _keysPressed.add(key);
    else
      _keysPressed.remove(key);
  }

  Future<void> _applyEquippedItems() async {
    for (final entry in playerState.equippedItems.entries) {
      final category = entry.key;
      final color = entry.value;

      if (color == null) continue;

      switch (category) {
        case 'shirts':
          await changeLayer(category, avatarConfig.shirts, color);
          break;
        case 'pants':
          await changeLayer(category, avatarConfig.pants, color);
          break;
        case 'hair':
          await changeLayer(category, avatarConfig.hair, color);
          break;
        case 'shoes':
          await changeLayer(category, avatarConfig.shoes, color);
          break;
      }
    }
  }

  Future<void> applyState() async {
    await _applyEquippedItems();
  }


}
