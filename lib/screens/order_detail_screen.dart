import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/orders_repo.dart';
import '../models/order_header.dart';
import '../models/order_line.dart';
import '../theme.dart';
import '../widgets/rainbow_divider.dart';
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
        appBar: retroAppBar('ORDER'),
        body: const Center(
            child: Text('LOADING...',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                  color: RetroTheme.text,
                ))),
      );
    }

    return Scaffold(
      appBar: retroAppBar('ORDER'),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          RetroPanel(
            title: '\u2605 ORDER #${order.id} \u2605',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow('STATUS', order.status.dbValue.toUpperCase()),
                const SizedBox(height: RetroSpacing.xs),
                _infoRow('TOTAL', '${order.total.toStringAsFixed(0)} \u20BD'),
                const SizedBox(height: RetroSpacing.xs),
                _infoRow(
                    'PAYMENT', order.paymentMethod.dbValue.toUpperCase()),
                const SizedBox(height: RetroSpacing.xs),
                _infoRow('DATE', order.createdAt),
                const SizedBox(height: RetroSpacing.xs),
                _infoRow('ADDRESS', order.address),
                if (order.comment != null &&
                    order.comment!.isNotEmpty) ...[
                  const SizedBox(height: RetroSpacing.xs),
                  _infoRow('COMMENT', order.comment!),
                ],
                const SizedBox(height: RetroSpacing.sm),
                RetroButton(
                  title: 'SIMULATE: NEXT STATUS',
                  onPressed: () async {
                    await advanceOrderStatus(db, order.id);
                    await _reload();
                  },
                ),
              ],
            ),
          ),
          const RainbowDivider(height: 2),
          RetroPanel(
            title: '\u2605 ORDER ITEMS \u2605',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._lines.map(
                  (l) => Padding(
                    padding: const EdgeInsets.only(top: RetroSpacing.xs),
                    child: Text(
                      '> ${l.title} x${l.qty} @ ${l.priceAtPurchase.toStringAsFixed(0)} \u20BD = ${(l.qty * l.priceAtPurchase).toStringAsFixed(0)} \u20BD',
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

  Widget _infoRow(String label, String value) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          color: RetroTheme.text,
          fontFamily: 'monospace',
        ),
        children: [
          TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: RetroTheme.accentCyan,
              )),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
