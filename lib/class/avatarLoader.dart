import 'dart:convert';
import 'package:flame/flame.dart';
import 'package:gioco_demo/class/avatarConfig.dart';

Future<AvatarConfig> loadAvatarFromJson(String path) async {
  final jsonString = await Flame.assets.readFile(path);
  final jsonMap = jsonDecode(jsonString);
  return AvatarConfig.fromJson(jsonMap);
}
