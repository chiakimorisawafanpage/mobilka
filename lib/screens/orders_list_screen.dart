import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/orders_repo.dart';
import '../models/order_header.dart';
import '../navigation/route_observer.dart';
import '../theme.dart';
import '../widgets/retro_panel.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> with RouteAware {
  List<OrderHeader> _orders = [];

  Future<void> _reload() async {
    final db = context.read<Database>();
    final o = await listOrders(db);
    if (!mounted) return;
    setState(() => _orders = o);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
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
    return Scaffold(
      appBar: retroAppBar('ЗАКАЗЫ', automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(RetroSpacing.md),
        child: _orders.isEmpty
            ? const Text(
                'ЗАКАЗОВ НЕТ (пока).',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: RetroTheme.text),
              )
            : ListView.separated(
                itemCount: _orders.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: RetroSpacing.sm),
                itemBuilder: (context, i) {
                  final item = _orders[i];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/order', arguments: item.id);
                    },
                    child: RetroPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ЗАКАЗ #${item.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: RetroTheme.link,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(
                            '${item.createdAt} · ${item.status.dbValue.toUpperCase()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: RetroTheme.muted),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(
                            '${item.total.toStringAsFixed(0)} ₽',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: RetroTheme.text),
                          ),
                          const SizedBox(height: RetroSpacing.xs),
                          Text(item.address,
                              style: const TextStyle(color: RetroTheme.text)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
