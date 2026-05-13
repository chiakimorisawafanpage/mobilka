import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/cart_repo.dart';
import '../models/cart_line.dart';
import '../navigation/app_shell_controller.dart';
import '../navigation/route_observer.dart';
import '../theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_panel.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return Scaffold(
      appBar: retroAppBar('CART', automaticallyImplyLeading: false),
      body: Column(
        children: [
          Expanded(
            child: _lines.isEmpty
                ? const Center(
                    child: Text(
                      'Cart is empty.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        color: RetroTheme.muted,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 24.0 : RetroSpacing.md,
                      vertical: RetroSpacing.md,
                    ),
                    itemCount: _lines.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: RetroSpacing.sm),
                    itemBuilder: (context, i) {
                      final item = _lines[i];
                      return RetroPanel(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 64,
                              height: 64,
                              child: ProductThumb(
                                label: item.imageLabel,
                                gifUrl: item.gifUrl,
                                height: 64,
                              ),
                            ),
                            const SizedBox(width: RetroSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'monospace',
                                      color: RetroTheme.text,
                                      fontSize: 13,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.price.toStringAsFixed(0)} \u20BD/pc',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      color: RetroTheme.muted,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: RetroSpacing.xs),
                                  Row(
                                    children: [
                                      _QtyButton(
                                        icon: Icons.remove,
                                        onTap: () async {
                                          await setCartQty(db,
                                              item.productId, item.qty - 1);
                                          await _reload();
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12),
                                        child: Text(
                                          '${item.qty}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'monospace',
                                            fontSize: 16,
                                            color: RetroTheme.text,
                                          ),
                                        ),
                                      ),
                                      _QtyButton(
                                        icon: Icons.add,
                                        onTap: () async {
                                          await setCartQty(db,
                                              item.productId, item.qty + 1);
                                          await _reload();
                                        },
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${(item.qty * item.price).toStringAsFixed(0)} \u20BD',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'monospace',
                                          color: RetroTheme.accentBlue,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await removeFromCart(db, item.productId);
                                await _reload();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.close,
                                    size: 18, color: RetroTheme.muted),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (_lines.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 24.0 : RetroSpacing.md,
                vertical: RetroSpacing.sm,
              ),
              decoration: const BoxDecoration(
                color: RetroTheme.panel,
                border: Border(
                  top: BorderSide(color: RetroTheme.border, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: RetroTheme.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${_total.toStringAsFixed(0)} \u20BD',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: RetroTheme.accentBlue,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RetroButton(
                      title: 'CLEAR',
                      variant: RetroButtonVariant.danger,
                      onPressed: () async {
                        await clearCart(db);
                        await _reload();
                      },
                    ),
                    const SizedBox(width: RetroSpacing.sm),
                    RetroButton(
                      title: 'CHECKOUT \u00BB',
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .push<void>(
                          MaterialPageRoute<void>(
                              builder: (_) => const CheckoutScreen()),
                        );
                      },
                    ),
                  ],
                ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: RetroTheme.win98Gray,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: RetroTheme.border, width: 1),
        ),
        child: Center(
          child: Icon(icon, size: 16, color: RetroTheme.text),
        ),
        child: Icon(icon, size: 16, color: RetroTheme.text),
      ),
    );
  }
}
