import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/cart_repo.dart';
import '../db/orders_repo.dart';
import '../models/cart_line.dart';
import '../models/payment_method.dart';
import '../theme.dart';
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
        value: PaymentMethod.cash, label: 'НАЛИЧНЫЕ (как раньше)'),
    const RetroSelectOption(
        value: PaymentMethod.card, label: 'КАРТА (заглушка)'),
    const RetroSelectOption(value: PaymentMethod.sbp, label: 'СБП (заглушка)'),
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
      appBar: retroAppBar('ОФОРМЛЕНИЕ'),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          RetroPanel(
            title: 'ЧЕКАУТ (локально)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ИТОГО: ${_total.toStringAsFixed(0)} ₽',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, color: RetroTheme.text),
                ),
                const SizedBox(height: RetroSpacing.sm),
                RetroInput(
                  label: 'АДРЕС',
                  value: _address,
                  onChanged: (t) => setState(() => _address = t),
                  placeholder: 'Город, улица, дом…',
                ),
                RetroInput(
                  label: 'КОММЕНТАРИЙ',
                  value: _comment,
                  onChanged: (t) => setState(() => _comment = t),
                  placeholder: 'Подъезд/домофон…',
                  multiline: true,
                ),
                RetroSelect<PaymentMethod>(
                  label: 'ОПЛАТА',
                  value: _payment,
                  options: _payOptions,
                  onChanged: (v) => setState(() => _payment = v),
                ),
                RetroButton(
                    title: 'ОБНОВИТЬ КОРЗИНУ',
                    variant: RetroButtonVariant.link,
                    onPressed: _reload),
                RetroButton(
                  title: 'ПОДТВЕРДИТЬ ЗАКАЗ',
                  disabled: _lines.isEmpty || _isSubmitting,
                  onPressed: () async {
                    if (_lines.isEmpty) {
                      return;
                    }
                    if (_address.trim().length < 5) {
                      await showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('ОШИБКА'),
                          content: const Text('Адрес слишком короткий'),
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
                          title: const Text('ОШИБКА'),
                          content: Text(
                              e is Error ? e.toString() : 'Неизвестная ошибка'),
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
          const SizedBox(height: RetroSpacing.md),
          RetroPanel(
            title: 'СОСТАВ',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_lines.isEmpty)
                  const Text('Корзина пустая.',
                      style: TextStyle(color: RetroTheme.text)),
                ..._lines.map(
                  (l) => Padding(
                    padding: const EdgeInsets.only(top: RetroSpacing.xs),
                    child: Text(
                      '- ${l.title} × ${l.qty} = ${(l.qty * l.price).toStringAsFixed(0)} ₽',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: RetroTheme.text),
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
