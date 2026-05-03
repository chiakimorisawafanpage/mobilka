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
import '../widgets/rainbow_divider.dart';
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
        appBar: retroAppBar('PRODUCT'),
        body: const Center(
            child: Text('LOADING...',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                  color: RetroTheme.bloodRed,
                ))),
      );
    }

    return Scaffold(
      appBar: retroAppBar('PRODUCT'),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          RetroPanel(
            title: 'PRODUCT INFO',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: RetroTheme.boneWhite,
                    shadows: [
                      Shadow(
                          offset: Offset(2, 2),
                          color: Color(0xFFCC0000),
                          blurRadius: 0),
                    ],
                  ),
                ),
                const SizedBox(height: RetroSpacing.sm),
                ProductThumb(
                    label: product.imageLabel,
                    gifUrl: product.gifUrl,
                    height: 130),
                const SizedBox(height: RetroSpacing.sm),
                Text(
                  '${product.brand.toUpperCase()} \u00B7 ${product.flavor.toUpperCase()} \u00B7 ${product.volumeMl} ml',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    color: RetroTheme.muted,
                  ),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text(
                  '${product.price.toStringAsFixed(0)} \u20BD',
                  style: const TextStyle(
                    fontSize: 22,
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
                const SizedBox(height: RetroSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(RetroSpacing.sm),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    border:
                        Border.all(color: RetroTheme.darkRed, width: 1),
                  ),
                  child: Text(product.eraNote,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        color: RetroTheme.silver,
                        fontStyle: FontStyle.italic,
                      )),
                ),
                const RainbowDivider(height: 2),
                const Text(
                  '\u00BB DESCRIPTION',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: RetroTheme.bloodRed,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text(product.description,
                    style: const TextStyle(
                      color: RetroTheme.text,
                      fontFamily: 'monospace',
                    )),
                const SizedBox(height: RetroSpacing.md),
                const Text(
                  '\u00BB INGREDIENTS',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: RetroTheme.bloodRed,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text(product.ingredients,
                    style: const TextStyle(
                      color: RetroTheme.text,
                      fontFamily: 'monospace',
                    )),
              ],
            ),
          ),
          const SizedBox(height: RetroSpacing.md),
          RetroPanel(
            title: 'ADD TO CART',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RetroInput(
                  label: 'QTY',
                  value: _qty,
                  onChanged: (t) => setState(() => _qty = t),
                  keyboardType: TextInputType.number,
                ),
                RetroButton(
                  title: 'ADD TO CART',
                  onPressed: () async {
                    final n = double.tryParse(_qty);
                    if (n == null || !n.isFinite || n <= 0) {
                      await showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('ERROR'),
                          content: const Text('Enter a valid quantity'),
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
                          content: Text('Added to cart! Check CART tab.'),
                          duration: Duration(milliseconds: 1200),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Cart error: $e'),
                          backgroundColor: RetroTheme.danger,
                        ),
                      );
                    }
                  },
                ),
                RetroButton(
                  title: 'GO TO CART',
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
            title: 'REVIEWS (${_reviews.length})',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_reviews.isEmpty)
                  const Text('No reviews yet... the silence is deafening.',
                      style: TextStyle(
                        color: RetroTheme.text,
                        fontFamily: 'monospace',
                      )),
                ..._reviews.map(
                  (rv) => Padding(
                    padding: const EdgeInsets.only(top: RetroSpacing.sm),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(RetroSpacing.sm),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        border: Border.all(
                            color: RetroTheme.border, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${rv.author} \u00B7 ${rv.rating}/5 ${'★' * rv.rating}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: RetroTheme.bloodRed,
                            ),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(rv.text,
                              style: const TextStyle(
                                color: RetroTheme.text,
                                fontFamily: 'monospace',
                              )),
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
