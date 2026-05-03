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
  int _qty = 1;

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
                  color: RetroTheme.muted,
                ))),
      );
    }

    return Scaffold(
      appBar: retroAppBar('PRODUCT'),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Product card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: ProductThumb(
                      label: product.imageLabel,
                      gifUrl: product.gifUrl,
                      height: 160),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: RetroTheme.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${product.brand} \u00B7 ${product.flavor} \u00B7 ${product.volumeMl} ml',
                        style: const TextStyle(
                          fontSize: 13,
                          color: RetroTheme.muted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '${product.price.toStringAsFixed(0)} \u20BD',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: RetroTheme.accentBlue,
                            ),
                          ),
                          const Spacer(),
                          _buildStockBadge(product.stock),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(product.eraNote,
                            style: const TextStyle(
                              color: RetroTheme.muted,
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            )),
                      ),
                      const RainbowDivider(height: 2),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: RetroTheme.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(product.description,
                          style: const TextStyle(
                            color: RetroTheme.text,
                            fontSize: 13,
                            height: 1.5,
                          )),
                      const SizedBox(height: 14),
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: RetroTheme.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(product.ingredients,
                          style: const TextStyle(
                            color: RetroTheme.muted,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Add to cart section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        size: 18, color: RetroTheme.accentBlue),
                    SizedBox(width: 6),
                    Text('Add to Cart',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        )),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _qtyButton(Icons.remove, () {
                      if (_qty > 1) setState(() => _qty--);
                    }),
                    Container(
                      width: 48,
                      alignment: Alignment.center,
                      child: Text(
                        '$_qty',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    _qtyButton(Icons.add, () {
                      if (_qty < product.stock) setState(() => _qty++);
                    }),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_shopping_cart_rounded,
                              size: 18),
                          label: Text(
                            'Add \u2022 ${(product.price * _qty).toStringAsFixed(0)} \u20BD',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: product.inStock
                                ? const Color(0xFF2E7D32)
                                : RetroTheme.muted,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: product.inStock
                              ? () async {
                                  try {
                                    await addToCart(db, product.id, _qty);
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Added to cart!'),
                                        duration:
                                            Duration(milliseconds: 1200),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$e'),
                                        backgroundColor: RetroTheme.danger,
                                      ),
                                    );
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.shopping_cart_rounded, size: 16),
                    label: const Text('Go to Cart'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: RetroTheme.accentBlue,
                      side: const BorderSide(color: RetroTheme.accentBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.read<AppShellController>().setTab(1);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Reviews
          RetroPanel(
            title: 'REVIEWS (${_reviews.length})',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_reviews.isEmpty)
                  const Text('No reviews yet.',
                      style: TextStyle(
                        color: RetroTheme.muted,
                        fontFamily: 'monospace',
                      )),
                ..._reviews.map(
                  (rv) => Padding(
                    padding: const EdgeInsets.only(top: RetroSpacing.sm),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(RetroSpacing.sm),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: RetroTheme.border, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${rv.author} \u00B7 ${rv.rating}/5 ${'★' * rv.rating}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: RetroTheme.accentBlue,
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

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: RetroTheme.border),
        ),
        child: Icon(icon, size: 18, color: RetroTheme.text),
      ),
    );
  }

  Widget _buildStockBadge(int stock) {
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
      text = 'In stock ($stock)';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: fg,
          )),
    );
  }
}
