import 'package:flutter/foundation.dart';

class PlayerState {
  ValueNotifier<int> coins;

  final Map<String, Set<String>> ownedItems;
  final Map<String, String?> equippedItems;

  PlayerState({ int initialCoins = 10, //per ora poi va modificato quando usiamo db

    Map<String, Set<String>>? ownedItems,
    Map<String, String?>? equippedItems,
  })  : coins = ValueNotifier<int>(initialCoins),
        ownedItems = ownedItems ?? {},
        equippedItems = equippedItems ?? {};

  void addCoins(int amount) => coins.value += amount;

  bool spendCoins(int amount) {
    if (coins.value >= amount) {
      coins.value -= amount;
      return true;
    }
    return false;
  }

  void addClothesDefault(String layer, String color) {
    // Aggiorna equippedItems
    equippedItems[layer] = color;

    // Aggiungi al posseduto
    ownedItems.putIfAbsent(layer, () => <String>{});
    ownedItems[layer]!.add(color);
  }
}
