import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/cart_repo.dart';
import '../db/products_repo.dart';
import '../models/product.dart';
import '../navigation/route_observer.dart';
import '../theme.dart';
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
    const RetroSelectOption(value: ProductSort.priceAsc, label: 'ЦЕНА ↑'),
    const RetroSelectOption(value: ProductSort.priceDesc, label: 'ЦЕНА ↓'),
    const RetroSelectOption(
        value: ProductSort.titleAsc, label: 'НАЗВАНИЕ (A-Z)'),
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
      const RetroSelectOption<String>(value: 'any', label: 'ЛЮБОЙ БРЕНД'),
      ..._brands
          .map((b) => RetroSelectOption(value: b, label: b.toUpperCase())),
    ];
    final flavorOptions = [
      const RetroSelectOption<String>(value: 'any', label: 'ЛЮБОЙ ВКУС'),
      ..._flavors
          .map((f) => RetroSelectOption(value: f, label: f.toUpperCase())),
    ];

    return Scaffold(
      appBar: retroAppBar('КАТАЛОГ', automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          const RetroMarquee(
            text:
                '★ ДОБРО ПОЖАЛОВАТЬ В RETRO ENERGY SHOP ★ ЛУЧШИЕ ЦЕНЫ 2005 ★ GIF КАК НА СТАРЫХ САЙТАХ ★ ЖМИ «В КОРЗИНУ» ★',
          ),
          const SizedBox(height: RetroSpacing.sm),
          RetroPanel(
            title: 'ПОИСК ПО КАТАЛОГУ',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RetroInput(
                  label: 'ПОИСК',
                  value: _search,
                  onChanged: (t) => setState(() => _search = t),
                  placeholder: 'monster / burn / cola…',
                ),
                RetroSelect<String>(
                  label: 'БРЕНД',
                  value: _brand,
                  options: brandOptions,
                  onChanged: (v) => setState(() => _brand = v),
                ),
                RetroSelect<String>(
                  label: 'ВКУС',
                  value: _flavor,
                  options: flavorOptions,
                  onChanged: (v) => setState(() => _flavor = v),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RetroInput(
                        label: 'ЦЕНА ОТ',
                        value: _minPrice,
                        onChanged: (t) => setState(() => _minPrice = t),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: RetroSpacing.sm),
                    Expanded(
                      child: RetroInput(
                        label: 'ЦЕНА ДО',
                        value: _maxPrice,
                        onChanged: (t) => setState(() => _maxPrice = t),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                RetroSelect<ProductSort>(
                  label: 'СОРТИРОВКА',
                  value: _sort,
                  options: _sortOptions,
                  onChanged: (v) => setState(() => _sort = v),
                ),
                Wrap(
                  spacing: RetroSpacing.sm,
                  runSpacing: RetroSpacing.sm,
                  children: [
                    RetroButton(
                        title: 'ПРИМЕНИТЬ ФИЛЬТРЫ', onPressed: _reloadProducts),
                    RetroButton(
                      title: 'СБРОС',
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
          const SizedBox(height: RetroSpacing.md),
          Text(
            'ТОВАРЫ (${_products.length})',
            style: const TextStyle(
                fontWeight: FontWeight.w900, color: RetroTheme.text),
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
                              color: RetroTheme.link,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          ProductThumb(
                              label: item.imageLabel, gifUrl: item.gifUrl),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(
                            '${item.brand.toUpperCase()} · ${item.flavor.toUpperCase()} · ${item.volumeMl} мл',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: RetroTheme.muted),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(
                            '${item.price.toStringAsFixed(0)} ₽',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: RetroTheme.text),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(item.eraNote,
                              style: const TextStyle(color: RetroTheme.text)),
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
                          title: 'В КОРЗИНУ (+1)',
                          onPressed: () async {
                            try {
                              await addToCart(db, item.id, 1);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'В корзину: ${item.title} (+1). Открой вкладку КОРЗИНА.'),
                                  duration: const Duration(milliseconds: 1400),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Ошибка корзины: $e'),
                                  backgroundColor: RetroTheme.danger,
                                ),
                              );
                            }
                          },
                        ),
                        RetroButton(
                          title: 'В КОРЗИНУ (+3)',
                          onPressed: () async {
                            try {
                              await addToCart(db, item.id, 3);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Добавлено +3. Смотри вкладку КОРЗИНА.'),
                                  duration: Duration(milliseconds: 1200),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Ошибка корзины: $e'),
                                  backgroundColor: RetroTheme.danger,
                                ),
                              );
                            }
                          },
                        ),
                        RetroButton(
                          title: 'КАРТОЧКА',
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
        ],
      ),
    );
  }
}
