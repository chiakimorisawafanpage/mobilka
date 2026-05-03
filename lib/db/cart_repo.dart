import 'package:sqflite/sqflite.dart';

import '../models/cart_line.dart';

Future<void> addToCart(Database db, int productId, int qty) async {
  final safeQty = qty < 1 ? 1 : qty;
  await db.transaction((txn) async {
    final rows = await txn.rawQuery(
      'SELECT qty FROM cart_items WHERE productId = ?',
      [productId],
    );
    if (rows.isEmpty) {
      await txn.rawInsert(
        'INSERT INTO cart_items (productId, qty) VALUES (?, ?)',
        [productId, safeQty],
      );
      return;
    }
    final current =
        (rows.first['qty'] as int?) ?? (rows.first['qty'] as num).toInt();
    await txn.rawUpdate(
      'UPDATE cart_items SET qty = ? WHERE productId = ?',
      [current + safeQty, productId],
    );
  });
}

Future<void> setCartQty(Database db, int productId, int qty) async {
  final safeQty = qty < 0 ? 0 : qty;
  if (safeQty == 0) {
    await db
        .rawDelete('DELETE FROM cart_items WHERE productId = ?', [productId]);
    return;
  }

  await db.transaction((txn) async {
    final rows = await txn.rawQuery(
      'SELECT 1 FROM cart_items WHERE productId = ?',
      [productId],
    );
    if (rows.isEmpty) {
      await txn.rawInsert(
        'INSERT INTO cart_items (productId, qty) VALUES (?, ?)',
        [productId, safeQty],
      );
    } else {
      await txn.rawUpdate(
        'UPDATE cart_items SET qty = ? WHERE productId = ?',
        [safeQty, productId],
      );
    }
  });
}

Future<void> removeFromCart(Database db, int productId) async {
  await db.rawDelete('DELETE FROM cart_items WHERE productId = ?', [productId]);
}

Future<void> clearCart(Database db) async {
  await db.execute('DELETE FROM cart_items');
}

Future<List<CartLine>> getCartLines(Database db) async {
  final rows = await db.rawQuery(
    '''SELECT
       ci.productId as productId,
       ci.qty as qty,
       p.title as title,
       p.brand as brand,
       p.volumeMl as volumeMl,
       p.price as price,
       p.imageLabel as imageLabel,
       p.gifUrl as gifUrl
     FROM cart_items ci
     JOIN products p ON p.id = ci.productId
     ORDER BY p.title COLLATE NOCASE ASC''',
  );
  return rows.map(CartLine.fromMap).toList();
}

Future<int> getCartCount(Database db) async {
  final row =
      await db.rawQuery('SELECT COALESCE(SUM(qty), 0) as c FROM cart_items');
  final v = row.first['c'];
  if (v is int) return v;
  return (v as num).toInt();
}

Future<double> getCartTotal(Database db) async {
  final row = await db.rawQuery(
    '''SELECT COALESCE(SUM(ci.qty * p.price), 0) as t
     FROM cart_items ci
     JOIN products p ON p.id = ci.productId''',
  );
  final v = row.first['t'];
  return (v as num?)?.toDouble() ?? 0;
}
