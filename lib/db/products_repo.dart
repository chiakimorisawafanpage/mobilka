import 'package:sqflite/sqflite.dart';

import '../models/product.dart';

enum ProductSort { priceAsc, priceDesc, titleAsc }

class ProductFilters {
  ProductFilters({
    this.search,
    this.brand,
    this.flavor,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  final String? search;
  final String? brand;
  final String? flavor;
  final double? minPrice;
  final double? maxPrice;
  final ProductSort? sort;
}

({String sql, List<Object?> params}) _buildWhere(ProductFilters filters) {
  final clauses = <String>[];
  final params = <Object?>[];

  final search = filters.search?.trim();
  if (search != null && search.isNotEmpty) {
    final q = '%$search%';
    clauses.add(
        '(title LIKE ? OR brand LIKE ? OR flavor LIKE ? OR description LIKE ?)');
    params.addAll([q, q, q, q]);
  }

  if (filters.brand != null && filters.brand != 'any') {
    clauses.add('brand = ?');
    params.add(filters.brand);
  }

  if (filters.flavor != null && filters.flavor != 'any') {
    clauses.add('flavor = ?');
    params.add(filters.flavor);
  }

  if (filters.minPrice != null && !filters.minPrice!.isNaN) {
    clauses.add('price >= ?');
    params.add(filters.minPrice);
  }

  if (filters.maxPrice != null && !filters.maxPrice!.isNaN) {
    clauses.add('price <= ?');
    params.add(filters.maxPrice);
  }

  final sql = clauses.isNotEmpty ? 'WHERE ${clauses.join(' AND ')}' : '';
  return (sql: sql, params: params);
}

String _orderByClause(ProductSort? sort) {
  switch (sort) {
    case ProductSort.priceDesc:
      return 'ORDER BY price DESC, title COLLATE NOCASE ASC';
    case ProductSort.titleAsc:
      return 'ORDER BY title COLLATE NOCASE ASC';
    case ProductSort.priceAsc:
    case null:
      return 'ORDER BY price ASC, title COLLATE NOCASE ASC';
  }
}

Future<List<Product>> listProducts(Database db, ProductFilters filters) async {
  final w = _buildWhere(filters);
  final orderBy = _orderByClause(filters.sort);
  final query =
      '''SELECT id, title, brand, flavor, volumeMl, price, description, ingredients, eraNote, imageLabel, gifUrl
     FROM products
     ${w.sql}
     $orderBy''';

  final rows = await db.rawQuery(query, w.params);
  return rows.map(Product.fromMap).toList();
}

Future<Product?> getProduct(Database db, int id) async {
  final rows = await db.rawQuery(
    '''SELECT id, title, brand, flavor, volumeMl, price, description, ingredients, eraNote, imageLabel, gifUrl
     FROM products
     WHERE id = ?''',
    [id],
  );
  if (rows.isEmpty) return null;
  return Product.fromMap(rows.first);
}

Future<List<String>> listDistinctBrands(Database db) async {
  final rows = await db.rawQuery(
    'SELECT DISTINCT brand FROM products ORDER BY brand COLLATE NOCASE ASC',
  );
  return rows.map((r) => r['brand']! as String).toList();
}

Future<List<String>> listDistinctFlavors(Database db) async {
  final rows = await db.rawQuery(
    'SELECT DISTINCT flavor FROM products ORDER BY flavor COLLATE NOCASE ASC',
  );
  return rows.map((r) => r['flavor']! as String).toList();
}
