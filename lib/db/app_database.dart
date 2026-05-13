import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'products_seed.dart';
import 'reviews_seed.dart';
import 'energy_drinks_seed.dart';

/// Map of product title → new working image URL.
/// Used by v5 migration to fix broken sweet-shop.si CDN links.
const _energyDrinkImageFixes = <String, String>{
  'Monster Energy — Pacific Punch':
      'https://i5.walmartimages.com/asr/6a0c2ade-cfd2-4ec6-b2ec-8bc68c4daacc.b1c1fa4b09abad1e449123578c5e58ba.jpeg',
  'Monster Energy — Ultra Black':
      'https://i5.walmartimages.com/asr/10a2b16b-3ceb-482e-8004-238f72854ae2.a61dd710a02491a6d68446bd0470f92f.jpeg',
  'Monster Energy — Rehab Lemonade':
      'https://i0.wp.com/vikingcocacola.com/wp-content/uploads/2020/12/Monster-Rehab-Lemonade-1.png',
  'Monster Energy — Ultra Violet':
      'https://d2lnr5mha7bycj.cloudfront.net/product-image/file/large_69e9b17f-25ef-4f72-9fd1-9a64a5811300.png',
  'Monster Energy — Ripper':
      'https://web-assests.monsterenergy.com/mnst/231c4e82-d9dc-4a12-87e8-20d6564894a6.png',
  'Monster Energy — Ultra Peachy Keen':
      'https://i5.walmartimages.com/seo/Monster-Ultra-Peachy-Keen-16-fl-oz_98fe6dbc-345c-4806-895a-c3ea0746183a.989d3864101f7bf7bdba361551551881.jpeg',
  'Monster Energy — Bad Apple':
      'https://www.kroger.com/product/images/large/front/0007084789956',
  'Monster Energy — Nitro':
      'https://www.kroger.com/product/images/large/front/0007084703775',
  'Monster Energy — Ultra Watermelon':
      'https://groceries.morrisons.com/images-v3/4b85987b-1398-4173-a0c1-3546047c9d74/6a847da5-ae79-41d2-9083-9e6dc7a24866/500x500.jpg',
  'Rockstar Energy — Original':
      'https://www.kroger.com/product/images/large/front/0081809400010',
};

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
  gifUrl TEXT,
  stock INTEGER NOT NULL DEFAULT 20
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
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL UNIQUE,
  passwordHash TEXT NOT NULL DEFAULT '',
  name TEXT NOT NULL,
  googleId TEXT,
  createdAt TEXT NOT NULL
)''');
  await db.execute('''
CREATE TABLE IF NOT EXISTS orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId INTEGER,
  createdAt TEXT NOT NULL,
  total REAL NOT NULL,
  address TEXT NOT NULL,
  comment TEXT,
  paymentMethod TEXT NOT NULL,
  status TEXT NOT NULL,
  FOREIGN KEY (userId) REFERENCES users(id)
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
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL UNIQUE,
  passwordHash TEXT NOT NULL,
  name TEXT NOT NULL,
  createdAt TEXT NOT NULL
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
          '''INSERT INTO products (title, brand, flavor, volumeMl, price, description, ingredients, eraNote, imageLabel, gifUrl, stock)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''',
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
            p.stock,
          ],
        );
      }

      for (final p in energyDrinksSeed) {
        await txn.rawInsert(
          '''INSERT INTO products (title, brand, flavor, volumeMl, price, description, ingredients, eraNote, imageLabel, gifUrl, stock)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''',
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
            p.stock,
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

    });
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
    version: 4,
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
      if (oldVersion < 4) {
        await db.execute('''
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL UNIQUE,
  passwordHash TEXT NOT NULL DEFAULT '',
  name TEXT NOT NULL,
  googleId TEXT,
  createdAt TEXT NOT NULL
)''');
        // Add userId column to orders (nullable for old orders)
        try {
          await db.execute('ALTER TABLE orders ADD COLUMN userId INTEGER');
        } catch (_) {
          // column may already exist
        }
      }
      await _backfillProductGifUrls(db);
      await _seedIfEmpty(db);
    },
    onOpen: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
      await _backfillProductGifUrls(db);
      await _seedIfEmpty(db);
      for (final entry in _energyDrinkImageFixes.entries) {
        await db.rawUpdate(
          'UPDATE products SET gifUrl = ? WHERE title = ?',
          [entry.value, entry.key],
        );
      }
    },
  );
}
