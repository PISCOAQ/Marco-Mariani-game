import 'dart:convert';
import 'package:flame/flame.dart';
import 'package:gioco_demo/class/avatarConfig.dart';

Future<AvatarConfig> loadAvatarFromJson(
  String path,
  int avatarIndex,
) async {
  final jsonString = await Flame.assets.readFile(path);
  final jsonMap = jsonDecode(jsonString);

  final avatarJson = jsonMap['avatars'][avatarIndex.toString()];
  if (avatarJson == null) {
    throw Exception('Avatar $avatarIndex non trovato nel JSON');
  }

  return AvatarConfig.fromJson(avatarJson);
}
