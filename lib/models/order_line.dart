class OrderLine {
  const OrderLine({
    required this.productId,
    required this.title,
    required this.qty,
    required this.priceAtPurchase,
  });

  final int productId;
  final String title;
  final int qty;
  final double priceAtPurchase;

  factory OrderLine.fromMap(Map<String, Object?> map) {
    return OrderLine(
      productId:
          (map['productId'] as int?) ?? (map['productId'] as num?)!.toInt(),
      title: map['title']! as String,
      qty: (map['qty'] as int?) ?? (map['qty'] as num?)!.toInt(),
      priceAtPurchase: (map['priceAtPurchase'] as num?)!.toDouble(),
    );
  }
}
