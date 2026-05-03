class CartLine {
  const CartLine({
    required this.productId,
    required this.qty,
    required this.title,
    required this.brand,
    required this.volumeMl,
    required this.price,
    required this.imageLabel,
    this.gifUrl,
  });

  final int productId;
  final int qty;
  final String title;
  final String brand;
  final int volumeMl;
  final double price;
  final String imageLabel;
  final String? gifUrl;

  factory CartLine.fromMap(Map<String, Object?> map) {
    return CartLine(
      productId:
          (map['productId'] as int?) ?? (map['productId'] as num?)!.toInt(),
      qty: (map['qty'] as int?) ?? (map['qty'] as num?)!.toInt(),
      title: map['title']! as String,
      brand: map['brand']! as String,
      volumeMl: (map['volumeMl'] as int?) ?? (map['volumeMl'] as num?)!.toInt(),
      price: (map['price'] as num?)!.toDouble(),
      imageLabel: (map['imageLabel'] as String?) ?? 'NO IMAGE',
      gifUrl: map['gifUrl'] as String?,
    );
  }
}
