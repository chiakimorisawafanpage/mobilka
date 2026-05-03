import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/cart_repo.dart';
import '../db/products_repo.dart';
import '../db/reviews_repo.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../navigation/app_shell_controller.dart';
import '../theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_input.dart';
import '../widgets/retro_panel.dart';
import '../widgets/product_thumb.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.productId});

  final int productId;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Product? _product;
  List<Review> _reviews = [];
  String _qty = '1';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final db = context.read<Database>();
    final p = await getProduct(db, widget.productId);
    final r = await listReviewsForProduct(db, widget.productId);
    if (!mounted) return;
    setState(() {
      _product = p;
      _reviews = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<Database>();
    final product = _product;

    if (product == null) {
      return Scaffold(
        appBar: retroAppBar('ТОВАР'),
        body: const Center(
            child: Text('ЗАГРУЗКА…',
                style: TextStyle(fontWeight: FontWeight.w800))),
      );
    }

    return Scaffold(
      appBar: retroAppBar('ТОВАР'),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          RetroPanel(
            title: 'ТОВАР',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: RetroTheme.text),
                ),
                const SizedBox(height: RetroSpacing.sm),
                ProductThumb(
                    label: product.imageLabel,
                    gifUrl: product.gifUrl,
                    height: 130),
                const SizedBox(height: RetroSpacing.sm),
                Text(
                  '${product.brand.toUpperCase()} · ${product.flavor.toUpperCase()} · ${product.volumeMl} мл',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: RetroTheme.muted),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text(
                  '${product.price.toStringAsFixed(0)} ₽',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: RetroTheme.text),
                ),
                const SizedBox(height: RetroSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(RetroSpacing.sm),
                  decoration: BoxDecoration(
                    color: RetroTheme.accentBg,
                    border: Border.all(color: RetroTheme.border, width: 2),
                  ),
                  child: Text(product.eraNote,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: RetroSpacing.md),
                const Text(
                  'ОПИСАНИЕ',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text(product.description,
                    style: const TextStyle(color: RetroTheme.text)),
                const SizedBox(height: RetroSpacing.md),
                const Text(
                  'СОСТАВ (как на старом сайте)',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text(product.ingredients,
                    style: const TextStyle(color: RetroTheme.text)),
              ],
            ),
          ),
          const SizedBox(height: RetroSpacing.md),
          RetroPanel(
            title: 'В КОРЗИНУ',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RetroInput(
                  label: 'КОЛ-ВО',
                  value: _qty,
                  onChanged: (t) => setState(() => _qty = t),
                  keyboardType: TextInputType.number,
                ),
                RetroButton(
                  title: 'ДОБАВИТЬ',
                  onPressed: () async {
                    final n = double.tryParse(_qty);
                    if (n == null || !n.isFinite || n <= 0) {
                      await showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('ОШИБКА'),
                          content: const Text('Введите нормальное количество'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK')),
                          ],
                        ),
                      );
                      return;
                    }
                    try {
                      await addToCart(db, product.id, n.floor());
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Товар добавлен в корзину (вкладка КОРЗИНА).'),
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
                  title: 'ПЕРЕЙТИ В КОРЗИНУ',
                  variant: RetroButtonVariant.link,
                  onPressed: () {
                    context.read<AppShellController>().setTab(1);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: RetroSpacing.md),
          RetroPanel(
            title: 'ОТЗЫВЫ (${_reviews.length})',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_reviews.isEmpty)
                  const Text('Пока нет отзывов (но это не баг, это эпоха).',
                      style: TextStyle(color: RetroTheme.text)),
                ..._reviews.map(
                  (rv) => Padding(
                    padding: const EdgeInsets.only(top: RetroSpacing.sm),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(RetroSpacing.sm),
                      decoration: BoxDecoration(
                        color: RetroTheme.panel,
                        border: Border.all(color: RetroTheme.border, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${rv.author} · ${rv.rating}/5',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(rv.text,
                              style: const TextStyle(color: RetroTheme.text)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: RetroSpacing.lg),
        ],
      ),
    );
  }
}
