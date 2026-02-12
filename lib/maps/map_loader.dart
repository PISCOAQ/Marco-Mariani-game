import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame/components.dart';
import '../game/wall.dart';

Future<TiledComponent> loadMap(FlameGame game) async {
  final map = await TiledComponent.load('game_map_Copia.tmx', Vector2.all(32));

  final collisionLayer = map.tileMap.getLayer<ObjectGroup>('collisioni');
  if (collisionLayer != null) {
    for (final obj in collisionLayer.objects) {
      game.add(Wall(
        Vector2(obj.x, obj.y),
        Vector2(obj.width, obj.height),
      ));
    }
  }

  return map;
}
