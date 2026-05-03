class Review {
  const Review({
    required this.id,
    required this.productId,
    required this.author,
    required this.rating,
    required this.text,
  });

  final int id;
  final int productId;
  final String author;
  final int rating;
  final String text;

  factory Review.fromMap(Map<String, Object?> map) {
    return Review(
      id: (map['id'] as int?) ?? (map['id'] as num?)!.toInt(),
      productId:
          (map['productId'] as int?) ?? (map['productId'] as num?)!.toInt(),
      author: map['author']! as String,
      rating: (map['rating'] as int?) ?? (map['rating'] as num?)!.toInt(),
      text: map['text']! as String,
    );
  }
}
