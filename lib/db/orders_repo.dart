import 'package:sqflite/sqflite.dart';

import '../models/order_header.dart';
import '../models/order_line.dart';
import '../models/order_status.dart';
import '../models/payment_method.dart';
import 'cart_repo.dart';

class CreateOrderInput {
  CreateOrderInput({
    required this.address,
    required this.comment,
    required this.paymentMethod,
    this.userId,
  });

  final String address;
  final String comment;
  final PaymentMethod paymentMethod;
  final int? userId;
}

Future<int> createOrderFromCart(Database db, CreateOrderInput input) async {
  final lines = await getCartLines(db);
  if (lines.isEmpty) {
    throw StateError('Корзина пустая');
  }

  final total = await getCartTotal(db);
  final createdAt = DateTime.now().toUtc().toIso8601String();

  late int orderId;

  await db.transaction((txn) async {
    orderId = await txn.rawInsert(
      '''INSERT INTO orders (userId, createdAt, total, address, comment, paymentMethod, status)
       VALUES (?, ?, ?, ?, ?, ?, ?)''',
      [
        input.userId,
        createdAt,
        total,
        input.address.trim(),
        input.comment.trim().isNotEmpty ? input.comment.trim() : null,
        input.paymentMethod.dbValue,
        'accepted',
      ],
    );

    for (final line in lines) {
      await txn.rawInsert(
        '''INSERT INTO order_items (orderId, productId, qty, priceAtPurchase, titleSnapshot)
         VALUES (?, ?, ?, ?, ?)''',
        [orderId, line.productId, line.qty, line.price, line.title],
      );
    }

    await txn.execute('DELETE FROM cart_items');
  });

  return orderId;
}

Future<List<OrderHeader>> listOrders(Database db, {int? userId}) async {
  if (userId != null) {
    final rows = await db.rawQuery(
      '''SELECT id, userId, createdAt, total, address, comment, paymentMethod, status
       FROM orders
       WHERE userId = ?
       ORDER BY id DESC''',
      [userId],
    );
    return rows.map(OrderHeader.fromMap).toList();
  }
  final rows = await db.rawQuery(
    '''SELECT id, userId, createdAt, total, address, comment, paymentMethod, status
     FROM orders
     ORDER BY id DESC''',
  );
  return rows.map(OrderHeader.fromMap).toList();
}

Future<OrderHeader?> getOrder(Database db, int orderId) async {
  final rows = await db.rawQuery(
    '''SELECT id, userId, createdAt, total, address, comment, paymentMethod, status
     FROM orders
     WHERE id = ?''',
    [orderId],
  );
  if (rows.isEmpty) return null;
  return OrderHeader.fromMap(rows.first);
}

Future<List<OrderLine>> getOrderLines(Database db, int orderId) async {
  final rows = await db.rawQuery(
    '''SELECT productId, titleSnapshot as title, qty, priceAtPurchase
     FROM order_items
     WHERE orderId = ?
     ORDER BY id ASC''',
    [orderId],
  );
  return rows.map(OrderLine.fromMap).toList();
}

Future<OrderHeader?> advanceOrderStatus(Database db, int orderId) async {
  final current = await getOrder(db, orderId);
  if (current == null) return null;

  final next = switch (current.status) {
    OrderStatus.accepted => OrderStatus.shipping,
    OrderStatus.shipping => OrderStatus.delivered,
    OrderStatus.delivered => OrderStatus.delivered,
  };

  await db.rawUpdate(
    'UPDATE orders SET status = ? WHERE id = ?',
    [next.dbValue, orderId],
  );
  return getOrder(db, orderId);
}

Future<int> countOrdersForUser(Database db, int userId) async {
  final row = await db.rawQuery(
    'SELECT COUNT(*) as c FROM orders WHERE userId = ?',
    [userId],
  );
  final v = row.first['c'];
  if (v is int) return v;
  return (v as num).toInt();
}
