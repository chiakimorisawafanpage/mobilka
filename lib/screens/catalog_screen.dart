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
import '../widgets/retro_button.dart';
import '../widgets/retro_input.dart';
import '../widgets/retro_panel.dart';
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
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
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
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          const RetroMarquee(
            text:
                '\u2620 WELCOME TO THE DARK ENERGY SHOP \u2620 BEWARE \u2620 ENTER AT YOUR OWN RISK \u2620',
          ),
          const SizedBox(height: RetroSpacing.sm),
          const Center(child: GeocitiesUnderConstruction()),
          const SizedBox(height: RetroSpacing.sm),
          const Center(
            child: BlinkText(
              text: '\u2620\u2620\u2620 NEW ITEMS ADDED \u2620\u2620\u2620',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: RetroTheme.bloodRed,
              ),
            ),
          ),
          const RainbowDivider(),
          RetroPanel(
            title: 'SEARCH THE DARKNESS',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  ],
                ),
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
                    RetroButton(
                        title: 'APPLY FILTERS', onPressed: _reloadProducts),
                    RetroButton(
                      title: 'RESET',
                      variant: RetroButtonVariant.link,
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
                    ),
                  ],
                ),
              ],
            ),
          ),
          const RainbowDivider(),
          Text(
            '\u2620 PRODUCTS (${_products.length}) \u2620',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: RetroTheme.bloodRed,
              shadows: [
                Shadow(
                    offset: Offset(1, 1),
                    color: Color(0xFF000000),
                    blurRadius: 0),
              ],
            ),
          ),
          const SizedBox(height: RetroSpacing.sm),
          ..._products.map(
            (item) => Padding(
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
                              color: RetroTheme.bloodRed,
                              decoration: TextDecoration.underline,
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
                            ),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(
                            '${item.price.toStringAsFixed(0)} \u20BD',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: RetroTheme.boneWhite,
                              shadows: [
                                Shadow(
                                    offset: Offset(1, 1),
                                    color: Color(0xFFCC0000),
                                    blurRadius: 0),
                              ],
                            ),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(item.eraNote,
                              style: const TextStyle(
                                color: RetroTheme.silver,
                                fontFamily: 'monospace',
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              )),
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
                          title: 'ADD TO CART (+1)',
                          onPressed: () async {
                            try {
                              await addToCart(db, item.id, 1);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Item added! Check CART tab.'),
                                  duration: Duration(milliseconds: 1200),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
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
            ),
          ),
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
}
