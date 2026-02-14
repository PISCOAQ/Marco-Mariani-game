class ClothingItem {
  final String id;        // shirt_red
  final String category;  // shirt, pants, hair, shoes
  final String style;     // tipo_1, tipo_2, ...
  final String path;      // asset path
  final int price;        // prezzo

  ClothingItem({
    required this.id,
    required this.category,
    required this.style,
    required this.path,
    required this.price,
  });

  factory ClothingItem.fromJson(
    String category,
    String style,
    Map<String, dynamic> json,
  ) {
    return ClothingItem(
      id: '${category}_$style',
      category: category,
      style: style,
      path: json['path'],
      price: json['price'],
    );
  }
}
