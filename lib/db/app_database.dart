import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'products_seed.dart';
import 'reviews_seed.dart';

/// Same DDL as [src/db/schema.ts](retro-energy-shop/src/db/schema.ts).
/// One statement per `execute` for sqflite compatibility.
Future<void> _createSchema(Database db) async {
  await db.execute('PRAGMA foreign_keys = ON');
  await db.execute('''
CREATE TABLE IF NOT EXISTS products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  brand TEXT NOT NULL,
  flavor TEXT NOT NULL,
  volumeMl INTEGER NOT NULL,
  price REAL NOT NULL,
  description TEXT NOT NULL,
  ingredients TEXT NOT NULL,
  eraNote TEXT NOT NULL,
  imageLabel TEXT NOT NULL DEFAULT 'NO IMAGE',
  gifUrl TEXT
)''');
  await db.execute('''
CREATE TABLE IF NOT EXISTS reviews (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  productId INTEGER NOT NULL,
  author TEXT NOT NULL,
  rating INTEGER NOT NULL,
  text TEXT NOT NULL,
  FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
)''');
  await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_reviews_productId ON reviews(productId)');
  await db.execute('''
CREATE TABLE IF NOT EXISTS cart_items (
  productId INTEGER PRIMARY KEY,
  qty INTEGER NOT NULL,
  FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
)''');
  await db.execute('''
CREATE TABLE IF NOT EXISTS orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  createdAt TEXT NOT NULL,
  total REAL NOT NULL,
  address TEXT NOT NULL,
  comment TEXT,
  paymentMethod TEXT NOT NULL,
  status TEXT NOT NULL
)''');
  await db.execute('''
CREATE TABLE IF NOT EXISTS order_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  orderId INTEGER NOT NULL,
  productId INTEGER NOT NULL,
  qty INTEGER NOT NULL,
  priceAtPurchase REAL NOT NULL,
  titleSnapshot TEXT NOT NULL,
  FOREIGN KEY (orderId) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (productId) REFERENCES products(id)
)''');
  await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_order_items_orderId ON order_items(orderId)');
  await db.execute('''
CREATE TABLE IF NOT EXISTS user_profile (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  name TEXT NOT NULL,
  phone TEXT NOT NULL
)''');
}

/// Port of [src/db/init.ts](retro-energy-shop/src/db/init.ts).
Future<void> _seedIfEmpty(Database db) async {
  final row = await db.rawQuery('SELECT COUNT(*) as c FROM products');
  final count = (row.first['c'] as int?) ?? (row.first['c'] as num?)!.toInt();

  if (count == 0) {
    await db.transaction((txn) async {
      for (final p in productsSeed) {
        await txn.rawInsert(
          '''INSERT INTO products (title, brand, flavor, volumeMl, price, description, ingredients, eraNote, imageLabel, gifUrl)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''',
          [
            p.title,
            p.brand,
            p.flavor,
            p.volumeMl,
            p.price,
            p.description,
            p.ingredients,
            p.eraNote,
            p.imageLabel,
            p.gifUrl,
          ],
        );
      }

      for (final r in reviewsSeed) {
        await txn.rawInsert(
          '''INSERT INTO reviews (productId, author, rating, text)
           SELECT id, ?, ?, ? FROM products WHERE title = ? LIMIT 1''',
          [r.author, r.rating, r.text, r.productTitle],
        );
      }

      await txn.rawInsert(
        '''INSERT OR IGNORE INTO user_profile (id, name, phone) VALUES (1, ?, ?)''',
        ['Гость', ''],
      );
    });
  } else {
    await db.execute(
      '''INSERT OR IGNORE INTO user_profile (id, name, phone) VALUES (1, ?, ?)''',
      ['Гость', ''],
    );
  }
}

Future<void> _backfillProductGifUrls(Database db) async {
  final rows = await db.rawQuery('SELECT id FROM products ORDER BY id ASC');
  for (var i = 0; i < rows.length; i++) {
    final id = (rows[i]['id'] as int?) ?? (rows[i]['id'] as num).toInt();
    final url = kY2KGifAt(i);
    await db.rawUpdate(
      'UPDATE products SET gifUrl = ? WHERE id = ? AND (gifUrl IS NULL OR gifUrl = ?)',
      [url, id, ''],
    );
  }
}

Future<Database> openAppDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = p.join(dir.path, 'retro-energy-shop.db');

  return openDatabase(
    path,
    version: 3,
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },
    onCreate: (db, version) async {
      await _createSchema(db);
      await _seedIfEmpty(db);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
          "ALTER TABLE products ADD COLUMN imageLabel TEXT NOT NULL DEFAULT 'NO IMAGE'",
        );
      }
      if (oldVersion < 3) {
        await db.execute('ALTER TABLE products ADD COLUMN gifUrl TEXT');
      }
      await _backfillProductGifUrls(db);
      await _seedIfEmpty(db);
    },
    onOpen: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
      await _backfillProductGifUrls(db);
      await _seedIfEmpty(db);
    },
  );
}
