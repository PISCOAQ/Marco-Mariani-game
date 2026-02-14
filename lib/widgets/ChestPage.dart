  import 'package:flutter/material.dart';
  import 'package:gioco_demo/class/models/ClothingItem.dart';
  import 'package:gioco_demo/game/MyGame.dart';

  class ChestPage extends StatefulWidget {
    final VoidCallback onExit;
    final MyGame game;

    const ChestPage({super.key, required this.onExit, required this.game});

    @override
    State<ChestPage> createState() => _ChestPageState();
  }



  class _ChestPageState extends State<ChestPage> {
    final Map<String, String?> selectedStyles = {};
    String activeCategory = 'shirts';
    late int _totalSelectedPrice = 0;

    @override
    void initState() {
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      final player = widget.game.player;
      final avatarConfig = player.avatarConfig;
      final layers = ['shirts', 'pants', 'hair', 'shoes'];
      final layerOptions = {
        'shirts': avatarConfig.shirts,
        'pants': avatarConfig.pants,
        'hair': avatarConfig.hair,
        'shoes': avatarConfig.shoes
      };

      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12, width: 1),
            boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 30)],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Row(
                      children: [
                        _buildPreviewSection(player, avatarConfig, layers, layerOptions),
                        _buildSelectionSection(layers, layerOptions),
                      ],
                    ),
                  ),
                  _buildFooter(player, layers, layerOptions),
                ],
              ),
              Positioned(
                top: 15,
                right: 15,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54, size: 30),
                  onPressed: widget.onExit,
                  hoverColor: Colors.redAccent.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildHeader() {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'GUARDAROBA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      );
    }

    Widget _buildPreviewSection(player, avatarConfig, layers, layerOptions) {
      return Container(
        width: 300,
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Colors.white10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.green.withOpacity(0.1), blurRadius: 40, spreadRadius: 10)
                    ],
                  ),
                ),
                _buildSpriteFrame(avatarConfig.bodyPath),
                for (final layer in layers) _buildLayerImage(layer, player, layerOptions),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildSelectionSection(List<String> layers, Map<String, Map<String, ClothingItem>> layerOptions) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: layers.map((l) => _buildCategoryTab(l)).toList(),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: layerOptions[activeCategory]!.keys.length,
                  itemBuilder: (context, index) {
                      // Prendiamo l'ID dello stile (es: "v1", "tipo_1", "red")
                      String styleId = layerOptions[activeCategory]!.keys.elementAt(index);                   
                      // Controlliamo se è selezionato usando lo styleId
                      bool isSelected = (selectedStyles[activeCategory] ?? 
                                        widget.game.utente.lookAttuale[activeCategory]) == styleId;
                      
                      return _buildItemCard(activeCategory, styleId, isSelected, layerOptions);
                    },
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildCategoryTab(String category) {
      bool isActive = activeCategory == category;
      return GestureDetector(
        onTap: () => setState(() => activeCategory = category),
        child: Container(
          margin: const EdgeInsets.only(right: 12),
          width: 110,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isActive ? Colors.green : Colors.white10),
          ),
          child: Center(
            child: Text(
              category.toUpperCase(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white38,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildItemCard( String category, String colorName, bool isSelected, Map<String, Map<String, ClothingItem>> layerOptions) {
      final item = layerOptions[category]![colorName]!;
      final path = item.path.replaceFirst('../', 'assets/');
      final image = AssetImage(path);

      // Controllo se il capo è già posseduto
      final owned = widget.game.utente.possiedeArticolo(category, colorName);

      return GestureDetector(
        
        onTap: () {
          setState(() {
            selectedStyles[category] = colorName;
          });
        _updateTotalSelectedPrice(layerOptions);
        },

        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.green.withOpacity(0.4)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CAPO
                Image(
                  image: image,
                  width: 64,
                  height: 64,
                  fit: BoxFit.none,
                  alignment: const Alignment(-1.0, -0.62),
                ),

                const SizedBox(height: 6),

                // PREZZO
                if(!owned)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.price.toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    }


  Widget _buildFooter(player, List<String> layers, Map<String, Map<String, ClothingItem>> layerOptions) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Totale selezione: $_totalSelectedPrice 🪙',
            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              int costoTotale = 0;
              final utente = widget.game.utente;

              // Calcolo costi
              for (final layer in layers) {
                final color = selectedStyles[layer];
                if (color == null) continue;
                if (!utente.possiedeArticolo(layer, color)) {
                  costoTotale += layerOptions[layer]![color]!.price;
                }
              }

              // 1. Controllo Monete
              if (utente.monete < costoTotale) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Monete insufficienti!")),
                );
                return;
              }

              // 2. Transazione e Aggiornamento Utente
              utente.monete -= costoTotale;

              for (final layer in layers) {
                final color = selectedStyles[layer];
                if (color == null) continue;

                // Aggiungiamo all'inventario se nuovo
                if (!utente.possiedeArticolo(layer, color)) {
                  if (!utente.inventario.containsKey(layer)) utente.inventario[layer] = [];
                  utente.inventario[layer]!.add(color);
                }

                // Salviamo il look indossato nell'oggetto Utente
                utente.lookAttuale[layer] = color;

                // Aggiorniamo visivamente il player nel gioco
                await widget.game.player.changeLayer(layer, layerOptions[layer]!, color);
              }

              widget.onExit();
            },
            child: const Text('SALVA LOOK', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }


  void _updateTotalSelectedPrice(Map<String, Map<String, ClothingItem>> layerOptions) {
    int total = 0;
    selectedStyles.forEach((layer, itemId) {
      if (itemId != null && !widget.game.utente.possiedeArticolo(layer, itemId)) {
        total += layerOptions[layer]![itemId]!.price;
      }
    });
    setState(() => _totalSelectedPrice = total);
  }


    Widget _buildLayerImage(String layer, dynamic player, Map<String, Map<String, ClothingItem>> options) {
      final color = selectedStyles[layer] ?? player.currentLayerColor[layer];
      
      // Se il colore è null o NON esiste nelle opzioni di questo specifico avatar
      if (color == null || options[layer] == null || options[layer]![color] == null) {
        return const SizedBox(); 
      }

      final ClothingItem item = options[layer]![color]!;
      return _buildSpriteFrame(item.path);
    }

    Widget _buildSpriteFrame(String path) {
      final assetPath = path.replaceFirst('../', 'assets/');
      return Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.none,
            alignment: const Alignment(-1.0, -0.62),
            scale: 0.4,
          ),
        ),
      );
    }
  }
