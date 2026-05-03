import 'package:sqflite/sqflite.dart';

import '../models/review.dart';

Future<List<Review>> listReviewsForProduct(Database db, int productId) async {
  final rows = await db.rawQuery(
    '''SELECT id, productId, author, rating, text
     FROM reviews
     WHERE productId = ?
     ORDER BY id DESC''',
    [productId],
  );
  return rows.map(Review.fromMap).toList();
}
