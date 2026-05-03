class Product {
  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.flavor,
    required this.volumeMl,
    required this.price,
    required this.description,
    required this.ingredients,
    required this.eraNote,
    required this.imageLabel,
    this.gifUrl,
    required this.stock,
  });

  final int id;
  final String title;
  final String brand;
  final String flavor;
  final int volumeMl;
  final double price;
  final String description;
  final String ingredients;
  final String eraNote;
  final String imageLabel;
  final String? gifUrl;
  final int stock;

  bool get inStock => stock > 0;

  factory Product.fromMap(Map<String, Object?> map) {
    return Product(
      id: (map['id'] as int?) ?? (map['id'] as num?)!.toInt(),
      title: map['title']! as String,
      brand: map['brand']! as String,
      flavor: map['flavor']! as String,
      volumeMl: (map['volumeMl'] as int?) ?? (map['volumeMl'] as num?)!.toInt(),
      price: (map['price'] as num?)!.toDouble(),
      description: map['description']! as String,
      ingredients: map['ingredients']! as String,
      eraNote: map['eraNote']! as String,
      imageLabel: (map['imageLabel'] as String?) ?? 'NO IMAGE',
      gifUrl: map['gifUrl'] as String?,
      stock: (map['stock'] as int?) ?? (map['stock'] as num?)?.toInt() ?? 0,
    );
  }
}
