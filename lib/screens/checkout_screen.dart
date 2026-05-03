import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/auth_repo.dart';
import '../db/cart_repo.dart';
import '../db/orders_repo.dart';
import '../models/cart_line.dart';
import '../models/payment_method.dart';
import '../theme.dart';
import '../widgets/rainbow_divider.dart';
import '../widgets/retro_panel.dart';
import 'auth_screen.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _address = '';
  String _comment = '';
  PaymentMethod _payment = PaymentMethod.cash;

  List<CartLine> _lines = [];
  double _total = 0;
  bool _isSubmitting = false;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
      _reload();
    });
  }

  void _checkAuth() {
    final auth = context.read<AuthState>();
    if (!auth.isLoggedIn) {
      Navigator.of(context, rootNavigator: true).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => AuthScreen(
            onSuccess: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<Database>();
    final auth = context.watch<AuthState>();

    return Scaffold(
      appBar: retroAppBar('CHECKOUT'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!auth.isLoggedIn) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFCC00)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.lock_outline,
                      color: Color(0xFFFF9800), size: 40),
                  const SizedBox(height: 8),
                  const Text(
                    'Please sign in to place an order',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: const Text('Sign In / Register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RetroTheme.accentBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _checkAuth,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
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
                Row(
                  children: [
                    const Icon(Icons.receipt_long_rounded,
                        color: RetroTheme.accentBlue, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
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
                const SizedBox(height: 16),
                TextField(
                  onChanged: (t) => setState(() => _address = t),
                  decoration: InputDecoration(
                    labelText: 'Delivery address',
                    prefixIcon:
                        const Icon(Icons.location_on_outlined, size: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: RetroTheme.border),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8F8F6),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (t) => setState(() => _comment = t),
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Comment (optional)',
                    prefixIcon: const Icon(Icons.comment_outlined, size: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: RetroTheme.border),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8F8F6),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<PaymentMethod>(
                  initialValue: _payment,
                  decoration: InputDecoration(
                    labelText: 'Payment method',
                    prefixIcon: const Icon(Icons.payment_outlined, size: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: RetroTheme.border),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8F8F6),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: PaymentMethod.cash, child: Text('Cash')),
                    DropdownMenuItem(
                        value: PaymentMethod.card, child: Text('Card')),
                    DropdownMenuItem(
                        value: PaymentMethod.sbp, child: Text('SBP')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _payment = v);
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline, size: 20),
                    label: Text(
                      _isSubmitting
                          ? 'Processing...'
                          : 'Confirm Order \u2022 ${_total.toStringAsFixed(0)} \u20BD',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: (!auth.isLoggedIn ||
                            _lines.isEmpty ||
                            _isSubmitting)
                        ? null
                        : () async {
                            if (_address.trim().length < 5) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Address is too short'),
                                  backgroundColor: RetroTheme.danger,
                                ),
                              );
                              return;
                            }
                            try {
                              setState(() => _isSubmitting = true);
                              final orderId = await createOrderFromCart(
                                db,
                                CreateOrderInput(
                                  address: _address,
                                  comment: _comment,
                                  paymentMethod: _payment,
                                ),
                              );
                              if (!context.mounted) return;
                              await Navigator.of(context, rootNavigator: true)
                                  .pushReplacement<void, void>(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      OrderSuccessScreen(orderId: orderId),
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
                            } finally {
                              if (mounted) {
                                setState(() => _isSubmitting = false);
                              }
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const RainbowDivider(height: 2),
          RetroPanel(
            title: 'CART CONTENTS',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_lines.isEmpty)
                  const Text('Cart is empty.',
                      style: TextStyle(
                        color: RetroTheme.muted,
                        fontFamily: 'monospace',
                      )),
                ..._lines.map(
                  (l) => Padding(
                    padding: const EdgeInsets.only(top: RetroSpacing.xs),
                    child: Text(
                      '> ${l.title} x${l.qty} = ${(l.qty * l.price).toStringAsFixed(0)} \u20BD',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                        color: RetroTheme.text,
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
