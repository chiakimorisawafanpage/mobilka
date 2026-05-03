import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/cart_repo.dart';
import '../models/cart_line.dart';
import '../navigation/app_shell_controller.dart';
import '../navigation/route_observer.dart';
import '../theme.dart';
import '../widgets/rainbow_divider.dart';
import '../widgets/product_thumb.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with RouteAware {
  List<CartLine> _lines = [];
  double _total = 0;
  AppShellController? _shell;

  Future<void> _reload() async {
    final db = context.read<Database>();
    final l = await getCartLines(db);
    final t = await getCartTotal(db);
    if (!mounted) return;
    setState(() {
      _lines = l;
      _total = t;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      cartRouteObserver.subscribe(this, route);
    }
    final shell = context.read<AppShellController>();
    if (!identical(shell, _shell)) {
      _shell?.removeListener(_onShellChanged);
      _shell = shell;
      _shell!.addListener(_onShellChanged);
    }
  }

  void _onShellChanged() {
    if (_shell?.tab == 1) {
      _reload();
    }
  }

  @override
  void dispose() {
    _shell?.removeListener(_onShellChanged);
    cartRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _reload();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<Database>();

    return Scaffold(
      appBar: retroAppBar('CART', automaticallyImplyLeading: false),
      body: Column(
        children: [
          // Cart summary header
          Container(
            margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_cart_rounded,
                        color: RetroTheme.accentBlue, size: 22),
                    const SizedBox(width: 8),
                    const Text('Your Cart',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        )),
                    const Spacer(),
                    Text(
                      '${_total.toStringAsFixed(0)} \u20BD',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: RetroTheme.accentBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward_rounded,
                              size: 18),
                          label: const Text('Checkout',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _lines.isEmpty
                              ? null
                              : () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push<void>(
                                    MaterialPageRoute<void>(
                                        builder: (_) =>
                                            const CheckoutScreen()),
                                  );
                                },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: _lines.isEmpty
                            ? null
                            : () async {
                                await clearCart(db);
                                await _reload();
                              },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: RetroTheme.danger,
                          side: const BorderSide(color: RetroTheme.danger),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Clear',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: RainbowDivider(height: 2),
          ),
          // Cart items list
          Expanded(
            child: _lines.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 56,
                            color: RetroTheme.muted.withValues(alpha: 0.4)),
                        const SizedBox(height: 12),
                        const Text('Cart is empty',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: RetroTheme.muted,
                            )),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(14),
                    itemCount: _lines.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final item = _lines[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: ProductThumb(
                                    label: item.imageLabel,
                                    gifUrl: item.gifUrl,
                                    height: 70,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item.price.toStringAsFixed(0)} \u20BD/pc',
                                      style: const TextStyle(
                                        color: RetroTheme.muted,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (item.qty > item.stock)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Only ${item.stock} in stock!',
                                          style: const TextStyle(
                                            color: RetroTheme.danger,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    // Quantity controls
                                    Row(
                                      children: [
                                        _QtyButton(
                                          icon: Icons.remove,
                                          onTap: () async {
                                            try {
                                              await setCartQty(db,
                                                  item.productId,
                                                  item.qty - 1);
                                            } catch (_) {}
                                            await _reload();
                                          },
                                        ),
                                        Container(
                                          width: 36,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${item.qty}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        _QtyButton(
                                          icon: Icons.add,
                                          onTap: () async {
                                            try {
                                              await setCartQty(db,
                                                  item.productId,
                                                  item.qty + 1);
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text('$e'),
                                                  backgroundColor:
                                                      RetroTheme.danger,
                                                ),
                                              );
                                            }
                                            await _reload();
                                          },
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${(item.qty * item.price).toStringAsFixed(0)} \u20BD',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                            color: RetroTheme.accentBlue,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () async {
                                            await removeFromCart(
                                                db, item.productId);
                                            await _reload();
                                          },
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color:
                                                  const Color(0xFFFFEBEE),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                                Icons.delete_outline,
                                                size: 18,
                                                color: RetroTheme.danger),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: RetroTheme.border),
        ),
        child: Icon(icon, size: 16, color: RetroTheme.text),
      ),
    );
  }
}
