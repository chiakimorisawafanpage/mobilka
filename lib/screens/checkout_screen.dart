import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/cart_repo.dart';
import '../db/orders_repo.dart';
import '../models/cart_line.dart';
import '../models/payment_method.dart';
import '../theme.dart';
import '../widgets/rainbow_divider.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_input.dart';
import '../widgets/retro_panel.dart';
import '../widgets/retro_select.dart';
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

  static final List<RetroSelectOption<PaymentMethod>> _payOptions = [
    const RetroSelectOption(
        value: PaymentMethod.cash, label: 'CASH (old school)'),
    const RetroSelectOption(
        value: PaymentMethod.card, label: 'CARD (stub)'),
    const RetroSelectOption(value: PaymentMethod.sbp, label: 'SBP (stub)'),
  ];

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<Database>();

    return Scaffold(
      appBar: retroAppBar('\u2605 CHECKOUT \u2605'),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          RetroPanel(
            title: '\u2605 CHECKOUT (local) \u2605',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL: ${_total.toStringAsFixed(0)} \u20BD',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: RetroTheme.accentYellow,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: RetroSpacing.sm),
                RetroInput(
                  label: 'ADDRESS',
                  value: _address,
                  onChanged: (t) => setState(() => _address = t),
                  placeholder: 'City, street, building...',
                ),
                RetroInput(
                  label: 'COMMENT',
                  value: _comment,
                  onChanged: (t) => setState(() => _comment = t),
                  placeholder: 'Entrance/intercom...',
                  multiline: true,
                ),
                RetroSelect<PaymentMethod>(
                  label: 'PAYMENT',
                  value: _payment,
                  options: _payOptions,
                  onChanged: (v) => setState(() => _payment = v),
                ),
                RetroButton(
                    title: 'REFRESH CART',
                    variant: RetroButtonVariant.link,
                    onPressed: _reload),
                RetroButton(
                  title: 'CONFIRM ORDER >>',
                  disabled: _lines.isEmpty || _isSubmitting,
                  onPressed: () async {
                    if (_lines.isEmpty) {
                      return;
                    }
                    if (_address.trim().length < 5) {
                      await showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('ERROR'),
                          content: const Text('Address is too short'),
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
                          builder: (_) => OrderSuccessScreen(orderId: orderId),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      await showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('ERROR'),
                          content: Text(
                              e is Error ? e.toString() : 'Unknown error'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK')),
                          ],
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isSubmitting = false);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const RainbowDivider(height: 2),
          RetroPanel(
            title: '\u2605 CART CONTENTS \u2605',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_lines.isEmpty)
                  const Text('Cart is empty.',
                      style: TextStyle(
                        color: RetroTheme.text,
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
