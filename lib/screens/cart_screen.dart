import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/cart_repo.dart';
import '../models/cart_line.dart';
import '../navigation/app_shell_controller.dart';
import '../navigation/route_observer.dart';
import '../theme.dart';
import '../widgets/rainbow_divider.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_input.dart';
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
      appRouteObserver.subscribe(this, route);
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
    appRouteObserver.unsubscribe(this);
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
      body: Padding(
        padding: const EdgeInsets.all(RetroSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RetroPanel(
              title: 'YOUR CART',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL: ${_total.toStringAsFixed(0)} \u20BD',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      color: RetroTheme.accentBlue,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: RetroSpacing.sm),
                  RetroButton(
                    title: 'CHECKOUT \u00BB',
                    disabled: _lines.isEmpty,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push<void>(
                        MaterialPageRoute<void>(
                            builder: (_) => const CheckoutScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: RetroSpacing.xs),
                  RetroButton(
                    title: 'CLEAR CART',
                    variant: RetroButtonVariant.danger,
                    disabled: _lines.isEmpty,
                    onPressed: () async {
                      await clearCart(db);
                      await _reload();
                    },
                  ),
                ],
              ),
            ),
            const RainbowDivider(height: 2),
            Expanded(
              child: _lines.isEmpty
                  ? const Text(
                      'Cart is empty.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        color: RetroTheme.muted,
                      ),
                    )
                  : ListView.separated(
                      itemCount: _lines.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: RetroSpacing.sm),
                      itemBuilder: (context, i) {
                        final item = _lines[i];
                        return RetroPanel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  color: RetroTheme.text,
                                ),
                              ),
                              const SizedBox(height: RetroSpacing.xs),
                              ProductThumb(
                                  label: item.imageLabel,
                                  gifUrl: item.gifUrl,
                                  height: 76),
                              const SizedBox(height: RetroSpacing.xs),
                              Text(
                                '${item.brand.toUpperCase()} \u00B7 ${item.volumeMl} ml \u00B7 ${item.price.toStringAsFixed(0)} \u20BD/pc',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'monospace',
                                  color: RetroTheme.muted,
                                ),
                              ),
                              const SizedBox(height: RetroSpacing.xs),
                              Text(
                                'SUBTOTAL: ${(item.qty * item.price).toStringAsFixed(0)} \u20BD',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  color: RetroTheme.accentBlue,
                                ),
                              ),
                              const SizedBox(height: RetroSpacing.sm),
                              RetroInput(
                                label: 'QTY',
                                value: '${item.qty}',
                                keyboardType: TextInputType.number,
                                onChanged: (t) async {
                                  final n = double.tryParse(t);
                                  if (n == null || !n.isFinite) return;
                                  await setCartQty(
                                      db, item.productId, n.floor());
                                  await _reload();
                                },
                              ),
                              Wrap(
                                spacing: RetroSpacing.sm,
                                runSpacing: RetroSpacing.sm,
                                children: [
                                  RetroButton(
                                    title: '-1',
                                    onPressed: () async {
                                      await setCartQty(
                                          db, item.productId, item.qty - 1);
                                      await _reload();
                                    },
                                  ),
                                  RetroButton(
                                    title: '+1',
                                    onPressed: () async {
                                      await setCartQty(
                                          db, item.productId, item.qty + 1);
                                      await _reload();
                                    },
                                  ),
                                  RetroButton(
                                    title: 'REMOVE',
                                    variant: RetroButtonVariant.danger,
                                    onPressed: () async {
                                      await removeFromCart(db, item.productId);
                                      await _reload();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
