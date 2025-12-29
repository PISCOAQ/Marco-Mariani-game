class ClothingItem {
  final String id;        // shirt_red
  final String category;  // shirt, pants, hair, shoes
  final String color;     // red, blue...
  final String path;      // asset path
  final int price;        // prezzo (non usato ancora)

  ClothingItem({
    required this.id,
    required this.category,
    required this.color,
    required this.path,
    required this.price,
  });

  factory ClothingItem.fromJson(
    String category,
    String color,
    Map<String, dynamic> json,
  ) {
    return ClothingItem(
      id: '${category}_$color',
      category: category,
      color: color,
      path: json['path'],
      price: json['price'],
    );
  }
}
