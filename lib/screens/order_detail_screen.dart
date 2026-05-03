import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/orders_repo.dart';
import '../models/order_header.dart';
import '../models/order_line.dart';
import '../theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_panel.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderHeader? _order;
  List<OrderLine> _lines = [];

  Future<void> _reload() async {
    final db = context.read<Database>();
    final o = await getOrder(db, widget.orderId);
    final l = await getOrderLines(db, widget.orderId);
    if (!mounted) return;
    setState(() {
      _order = o;
      _lines = l;
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
    final order = _order;

    if (order == null) {
      return Scaffold(
        appBar: retroAppBar('ЗАКАЗ'),
        body: const Center(
            child: Text('ЗАГРУЗКА…',
                style: TextStyle(fontWeight: FontWeight.w800))),
      );
    }

    return Scaffold(
      appBar: retroAppBar('ЗАКАЗ'),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          RetroPanel(
            title: 'ЗАКАЗ #${order.id}',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: const TextStyle(color: RetroTheme.text),
                    children: [
                      const TextSpan(
                          text: 'СТАТУС: ',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      TextSpan(text: order.status.dbValue.toUpperCase()),
                    ],
                  ),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(color: RetroTheme.text),
                    children: [
                      const TextSpan(
                          text: 'СУММА: ',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      TextSpan(text: '${order.total.toStringAsFixed(0)} ₽'),
                    ],
                  ),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(color: RetroTheme.text),
                    children: [
                      const TextSpan(
                          text: 'ОПЛАТА: ',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      TextSpan(text: order.paymentMethod.dbValue.toUpperCase()),
                    ],
                  ),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(color: RetroTheme.text),
                    children: [
                      const TextSpan(
                          text: 'ДАТА: ',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      TextSpan(text: order.createdAt),
                    ],
                  ),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(color: RetroTheme.text),
                    children: [
                      const TextSpan(
                          text: 'АДРЕС: ',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      TextSpan(text: order.address),
                    ],
                  ),
                ),
                if (order.comment != null && order.comment!.isNotEmpty) ...[
                  const SizedBox(height: RetroSpacing.xs),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(color: RetroTheme.text),
                      children: [
                        const TextSpan(
                            text: 'КОММЕНТ: ',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        TextSpan(text: order.comment!),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: RetroSpacing.sm),
                RetroButton(
                  title: 'ИМИТАЦИЯ: СЛЕДУЮЩИЙ СТАТУС',
                  onPressed: () async {
                    await advanceOrderStatus(db, order.id);
                    await _reload();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: RetroSpacing.md),
          RetroPanel(
            title: 'ПОЗИЦИИ',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._lines.map(
                  (l) => Padding(
                    padding: const EdgeInsets.only(top: RetroSpacing.xs),
                    child: Text(
                      '- ${l.title} × ${l.qty} @ ${l.priceAtPurchase.toStringAsFixed(0)} ₽ = ${(l.qty * l.priceAtPurchase).toStringAsFixed(0)} ₽',
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
