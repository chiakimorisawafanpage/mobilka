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
  List<OrderLine> _items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final db = context.read<Database>();
    final o = await getOrder(db, widget.orderId);
    final li = await getOrderLines(db, widget.orderId);
    if (!mounted) return;
    setState(() {
      _order = o;
      _items = li;
    });
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
                  color: RetroTheme.bloodRed,
                ))),
      );
    }

    return Scaffold(
      appBar: retroAppBar('ORDER #${order.id}'),
      body: ListView(
        padding: const EdgeInsets.all(RetroSpacing.md),
        children: [
          RetroPanel(
            title: 'ORDER DETAILS',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATUS: ${order.status.dbValue.toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: RetroTheme.bloodRed,
                  ),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text(
                  'TOTAL: ${order.total.toStringAsFixed(0)} \u20BD',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: RetroTheme.boneWhite,
                  ),
                ),
                const SizedBox(height: RetroSpacing.xs),
                Text(
                  'PAYMENT: ${order.paymentMethod.name.toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    color: RetroTheme.text,
                  ),
                ),
                Text(
                  'DATE: ${order.createdAt}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    color: RetroTheme.text,
                  ),
                ),
                Text(
                  'ADDRESS: ${order.address}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    color: RetroTheme.text,
                  ),
                ),
                if (order.comment != null && order.comment!.isNotEmpty)
                  Text(
                    'COMMENT: ${order.comment!}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      color: RetroTheme.text,
                    ),
                  ),
                const SizedBox(height: RetroSpacing.sm),
                RetroButton(
                  title: 'SIMULATE: NEXT STATUS',
                  onPressed: () async {
                    final next = await advanceOrderStatus(db, widget.orderId);
                    if (!mounted) return;
                    setState(() => _order = next);
                  },
                ),
              ],
            ),
          ),
          const RainbowDivider(height: 2),
          RetroPanel(
            title: 'ORDER ITEMS',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: RetroSpacing.sm),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(RetroSpacing.sm),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        border:
                            Border.all(color: RetroTheme.border, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: RetroTheme.boneWhite,
                            ),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(
                            '${item.qty} x ${item.priceAtPurchase.toStringAsFixed(0)} \u20BD = ${(item.qty * item.priceAtPurchase).toStringAsFixed(0)} \u20BD',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                              color: RetroTheme.text,
                            ),
                          ),
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
