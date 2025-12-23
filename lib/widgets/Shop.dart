import 'package:flutter/material.dart';
import 'package:gioco_demo/game/MyGame.dart';

class ChestPage extends StatefulWidget {
  final VoidCallback onExit;
  final MyGame game;

  const ChestPage({
    super.key,
    required this.onExit,
    required this.game,
  });

  @override
  State<ChestPage> createState() => _ChestPageState();
}

class _ChestPageState extends State<ChestPage> {
  /// layer -> colore selezionato temporaneo
  final Map<String, String?> selectedColors = {
    'shirt': null,
    'pants': null,
  };

  @override
  Widget build(BuildContext context) {
    final player = widget.game.player;
    final avatarConfig = player.avatarConfig;

    final layers = ['shirt', 'pants', 'hair', 'shoes'];

    final layerOptions = {
      'shirt': avatarConfig.shirts,
      'pants': avatarConfig.pants,
      'hair': avatarConfig.hair,
      'shoes': avatarConfig.shoes
    };

    return Container(
      margin: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Personalizza avatar',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // ================= PREVIEW =================
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blueGrey, width: 2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Corpo
                      _buildSpriteFrame(
                        path: avatarConfig.bodyPath.replaceFirst('../', 'assets/'),
                      ),

                      // Layer già indossati nel game
                      for (final layer in layers)
                        if (player.currentLayerColor[layer] != null)
                          _buildSpriteFrame(
                            path: layerOptions[layer]![player.currentLayerColor[layer]!]!
                                .replaceFirst('../', 'assets/'),
                          ),

                      // Layer selezionati temporaneamente
                      for (final layer in layers)
                        if (selectedColors[layer] != null)
                          _buildSpriteFrame(
                            path: layerOptions[layer]![selectedColors[layer]!]!
                                .replaceFirst('../', 'assets/'),
                          ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ================= SELEZIONE =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: layers.map((layer) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            layer.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...layerOptions[layer]!.keys.map((color) {
                            final selected = selectedColors[layer] == color;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColors[layer] = color;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: selected ? Colors.green[100] : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selected ? Colors.green : Colors.grey,
                                  ),
                                ),
                                child: Text(color.toUpperCase()),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),

                // ================= CONFERMA =================
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () async {
                    for (final layer in layers) {
                      final color = selectedColors[layer];
                      if (color != null) {
                        await player.changeLayer(layer, layerOptions[layer]!, color);
                      }
                    }
                    widget.onExit();
                  },
                  child: const Text(
                    'CONFERMA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= CHIUDI =================
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: widget.onExit,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSpriteFrame({required String path}) {
  return Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(path),
        fit: BoxFit.none,
        alignment: const Alignment(-1.0, -0.62),
        scale: 0.5,
      ),
    ),
  );
}
