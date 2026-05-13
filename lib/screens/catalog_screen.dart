import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/cart_repo.dart';
import '../db/products_repo.dart';
import '../models/product.dart';
import '../navigation/route_observer.dart';
import '../theme.dart';
import '../widgets/blink_text.dart';
import '../widgets/geocities_badges.dart';
import '../widgets/rainbow_divider.dart';
import '../widgets/retro_input.dart';
import '../widgets/retro_select.dart';
import '../widgets/product_thumb.dart';
import '../widgets/retro_marquee.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> with RouteAware {
  String _search = '';
  String _brand = 'any';
  String _flavor = 'any';
  String _minPrice = '';
  String _maxPrice = '';
  ProductSort _sort = ProductSort.priceAsc;

  List<String> _brands = [];
  List<String> _flavors = [];
  List<Product> _products = [];

  static final List<RetroSelectOption<ProductSort>> _sortOptions = [
    const RetroSelectOption(value: ProductSort.priceAsc, label: 'PRICE \u2191'),
    const RetroSelectOption(
        value: ProductSort.priceDesc, label: 'PRICE \u2193'),
    const RetroSelectOption(
        value: ProductSort.titleAsc, label: 'TITLE (A-Z)'),
  ];

  ProductFilters get _filters {
    double? minP;
    double? maxP;
    final minT = _minPrice.trim();
    final maxT = _maxPrice.trim();
    if (minT.isNotEmpty) {
      final n = double.tryParse(minT);
      if (n != null && n.isFinite) minP = n;
    }
    if (maxT.isNotEmpty) {
      final n = double.tryParse(maxT);
      if (n != null && n.isFinite) maxP = n;
    }
    return ProductFilters(
      search: _search,
      brand: _brand,
      flavor: _flavor,
      minPrice: minP,
      maxPrice: maxP,
      sort: _sort,
    );
  }

  Future<void> _reloadMeta() async {
    final db = context.read<Database>();
    final b = await listDistinctBrands(db);
    final f = await listDistinctFlavors(db);
    if (!mounted) return;
    setState(() {
      _brands = b;
      _flavors = f;
    });
  }

  Future<void> _reloadProducts() async {
    final db = context.read<Database>();
    final rows = await listProducts(db, _filters);
    if (!mounted) return;
    setState(() => _products = rows);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      shopRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    shopRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _reloadMeta();
    _reloadProducts();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reloadMeta();
      _reloadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<Database>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    final brandOptions = [
      const RetroSelectOption<String>(value: 'any', label: 'ALL BRANDS'),
      ..._brands
          .map((b) => RetroSelectOption(value: b, label: b.toUpperCase())),
    ];
    final flavorOptions = [
      const RetroSelectOption<String>(value: 'any', label: 'ALL FLAVORS'),
      ..._flavors
          .map((f) => RetroSelectOption(value: f, label: f.toUpperCase())),
    ];

    return Scaffold(
      appBar: retroAppBar('CATALOG', automaticallyImplyLeading: false),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 24.0 : RetroSpacing.md,
          vertical: RetroSpacing.md,
        ),
        children: [
          const RetroMarquee(
            text:
                'Welcome to Retro Energy Shop \u2022 Best prices \u2022 Fast delivery',
          ),
          const SizedBox(height: RetroSpacing.sm),
          const Center(child: GeocitiesUnderConstruction()),
          const SizedBox(height: RetroSpacing.sm),
          const Center(
            child: BlinkText(
              text: '\u2605\u2605\u2605 NEW ITEMS ADDED \u2605\u2605\u2605',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: RetroTheme.accentBlue,
              ),
            ),
          ),
          const RainbowDivider(),
          // Search / Filter section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: RetroInput(
                          label: 'SEARCH',
                          value: _search,
                          onChanged: (t) => setState(() => _search = t),
                          placeholder: 'monster / burn / cola...',
                        ),
                      ),
                      const SizedBox(width: RetroSpacing.sm),
                      Expanded(
                        child: RetroSelect<String>(
                          label: 'BRAND',
                          value: _brand,
                          options: brandOptions,
                          onChanged: (v) => setState(() => _brand = v),
                        ),
                      ),
                      const SizedBox(width: RetroSpacing.sm),
                      Expanded(
                        child: RetroSelect<String>(
                          label: 'FLAVOR',
                          value: _flavor,
                          options: flavorOptions,
                          onChanged: (v) => setState(() => _flavor = v),
                        ),
                      ),
                    ],
                  )
                else ...[
                  RetroInput(
                    label: 'SEARCH',
                    value: _search,
                    onChanged: (t) => setState(() => _search = t),
                    placeholder: 'monster / burn / cola...',
                  ),
                  RetroSelect<String>(
                    label: 'BRAND',
                    value: _brand,
                    options: brandOptions,
                    onChanged: (v) => setState(() => _brand = v),
                  ),
                  RetroSelect<String>(
                    label: 'FLAVOR',
                    value: _flavor,
                    options: flavorOptions,
                    onChanged: (v) => setState(() => _flavor = v),
                  ),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RetroInput(
                        label: 'PRICE FROM',
                        value: _minPrice,
                        onChanged: (t) => setState(() => _minPrice = t),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: RetroSpacing.sm),
                    Expanded(
                      child: RetroInput(
                        label: 'PRICE TO',
                        value: _maxPrice,
                        onChanged: (t) => setState(() => _maxPrice = t),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    if (isWide) ...[
                      const SizedBox(width: RetroSpacing.sm),
                      Expanded(
                        child: RetroSelect<ProductSort>(
                          label: 'SORT BY',
                          value: _sort,
                          options: _sortOptions,
                          onChanged: (v) => setState(() => _sort = v),
                        ),
                      ),
                    ],
                  ],
                ),
                if (!isWide)
                  RetroSelect<ProductSort>(
                    label: 'SORT BY',
                    value: _sort,
                    options: _sortOptions,
                    onChanged: (v) => setState(() => _sort = v),
                  ),
                Wrap(
                  spacing: RetroSpacing.sm,
                  runSpacing: RetroSpacing.sm,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.filter_list, size: 16),
                          label: const Text('Apply',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RetroTheme.accentBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _reloadProducts,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _search = '';
                            _brand = 'any';
                            _flavor = 'any';
                            _minPrice = '';
                            _maxPrice = '';
                            _sort = ProductSort.priceAsc;
                          });
                          _reloadProducts();
                        },
                        child: const Text('Reset',
                            style: TextStyle(color: RetroTheme.muted)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const RainbowDivider(),
          Text(
            'PRODUCTS (${_products.length})',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: RetroTheme.text,
            ),
          ),
          const SizedBox(height: RetroSpacing.sm),
          if (isWide)
            _buildProductGrid(db, screenWidth)
          else
            ..._products.map((item) => _buildProductCard(db, item)),
          const RainbowDivider(),
          const Center(child: GeocitiesHitCounter()),
          const SizedBox(height: RetroSpacing.sm),
          const Center(child: GeocitiesBestViewed()),
          const SizedBox(height: RetroSpacing.sm),
          const Center(child: GeocitiesWebring()),
          const SizedBox(height: RetroSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildProductGrid(Database db, double screenWidth) {
    final crossAxisCount = screenWidth > 900 ? 3 : 2;
    final rows = <Widget>[];
    for (var i = 0; i < _products.length; i += crossAxisCount) {
      final rowItems = <Widget>[];
      for (var j = 0; j < crossAxisCount; j++) {
        if (i + j < _products.length) {
          rowItems.add(
            Expanded(child: _buildProductCard(db, _products[i + j])),
          );
        } else {
          rowItems.add(const Expanded(child: SizedBox()));
        }
        if (j < crossAxisCount - 1) {
          rowItems.add(const SizedBox(width: RetroSpacing.sm));
        }
      }
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: RetroSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowItems,
        ),
      ));
    }
    return Column(children: rows);
  }

  Widget _buildProductCard(Database db, Product item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RetroSpacing.sm),
      child: RetroPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/product', arguments: item.id);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      color: RetroTheme.link,
                      decoration: TextDecoration.underline,
                      decorationColor: RetroTheme.link,
                    ),
                  ),
                  const SizedBox(height: RetroSpacing.xs),
                  ProductThumb(
                      label: item.imageLabel, gifUrl: item.gifUrl),
                  const SizedBox(height: RetroSpacing.xs),
                  Text(
                    '${item.brand.toUpperCase()} \u00B7 ${item.flavor.toUpperCase()} \u00B7 ${item.volumeMl} ml',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                      color: RetroTheme.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: RetroSpacing.xs),
                  Text(
                    '${item.price.toStringAsFixed(0)} \u20BD',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      color: RetroTheme.accentBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RetroSpacing.sm),
            Wrap(
              spacing: RetroSpacing.sm,
              runSpacing: RetroSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RetroButton(
                  title: 'ADD TO CART',
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await addToCart(db, item.id, 1);
                      messenger.showSnackBar(
                        const SnackBar(
                          content:
                              Text('Item added! Check CART tab.'),
                          duration: Duration(milliseconds: 1200),
                        ),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: RetroTheme.danger,
                        ),
                      );
                    }
                  },
                ),
                RetroButton(
                  title: 'DETAILS',
                  variant: RetroButtonVariant.link,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/product', arguments: item.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.stock});
  final int stock;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String text;
    if (stock <= 0) {
      bg = const Color(0xFFFFEBEE);
      fg = RetroTheme.danger;
      text = 'Out of stock';
    } else if (stock <= 5) {
      bg = const Color(0xFFFFF3E0);
      fg = const Color(0xFFE65100);
      text = 'Only $stock left';
    } else {
      bg = const Color(0xFFE8F5E9);
      fg = const Color(0xFF2E7D32);
      text = 'In stock';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: fg,
          )),
    );
  }
}
