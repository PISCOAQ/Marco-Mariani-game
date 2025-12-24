import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class Avatarselector extends StatelessWidget {
  final int? selectedAvatar;
  final Function(int) onAvatarSelected;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  // ⚠️ SOLO PREVIEW
  final Map<int, String> previewAvatars = const {
    1: '../avatars/MaleAvatar_spritesheet.png',
    2: '../avatars/FemaleAvatar_spritesheet.png',
  };

  const Avatarselector({
    required this.selectedAvatar,
    required this.onAvatarSelected,
    required this.onConfirm,
    required this.onBack,
    super.key,
  });

  Widget _buildAvatarTile(BuildContext context, int id, String imagePath) {
    final isSelected = selectedAvatar == id;

    return GestureDetector(
      onTap: () => onAvatarSelected(id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected
                ? Colors.yellowAccent.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            border: isSelected
                ? Border.all(color: Colors.yellowAccent, width: 4)
                : Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.yellowAccent.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: SizedBox(
            width: 80,
            height: 100,
            child: SpriteWidget.asset(
              path: imagePath,
              srcPosition: Vector2(0, 640),
              srcSize: Vector2(64, 64),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 400),
        child: Stack(
          children: [
            // CONTENUTO
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Scegli il tuo avatar iniziale',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: previewAvatars.entries.map((entry) {
                    return _buildAvatarTile(
                      context,
                      entry.key,
                      entry.value,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: selectedAvatar != null ? onConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 251, 119, 67),
                    disabledBackgroundColor:
                        const Color.fromARGB(255, 251, 119, 67),
                    foregroundColor: Colors.brown[900],
                    disabledForegroundColor:
                        Colors.white.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Conferma',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),

            // ❌ PULSANTE CHIUDI
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onBack,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
