import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/orders_repo.dart';
import '../models/order_header.dart';
import '../navigation/app_shell_controller.dart';
import '../navigation/route_observer.dart';
import '../providers/auth_provider.dart';
import '../theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_panel.dart';
import 'login_screen.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> with RouteAware {
  List<OrderHeader> _orders = [];
  AppShellController? _shell;

  Future<void> _reload() async {
    final db = context.read<Database>();
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      if (mounted) setState(() => _orders = []);
      return;
    }
    final o = await listOrders(db, userId: auth.user?.id);
    if (!mounted) return;
    setState(() => _orders = o);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      ordersRouteObserver.subscribe(this, route);
    }
    final shell = context.read<AppShellController>();
    if (!identical(shell, _shell)) {
      _shell?.removeListener(_onShellChanged);
      _shell = shell;
      _shell!.addListener(_onShellChanged);
    }
  }

  void _onShellChanged() {
    if (_shell?.tab == 2) {
      _reload();
    }
  }

  @override
  void dispose() {
    _shell?.removeListener(_onShellChanged);
    ordersRouteObserver.unsubscribe(this);
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
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: retroAppBar('ORDERS', automaticallyImplyLeading: false),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(RetroSpacing.md),
            child: RetroPanel(
              title: 'LOGIN REQUIRED',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sign in to view your orders.',
                    style: TextStyle(
                      color: RetroTheme.muted,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: RetroSpacing.md),
                  RetroButton(
                    title: 'SIGN IN',
                    onPressed: () async {
                      final result = await Navigator.of(context,
                              rootNavigator: true)
                          .push<bool>(MaterialPageRoute<bool>(
                              builder: (_) => const LoginScreen()));
                      if (result == true && mounted) _reload();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: retroAppBar('ORDERS', automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(RetroSpacing.md),
        child: _orders.isEmpty
            ? const Center(
                child: Text(
                  'No orders yet.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                    color: RetroTheme.muted,
                  ),
                ),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ORDER #${item.id}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'monospace',
                                    color: RetroTheme.link,
                                    decoration: TextDecoration.underline,
                                    decorationColor: RetroTheme.link,
                                  ),
                                ),
                                const SizedBox(height: RetroSpacing.xs),
                                Text(
                                  '${item.createdAt.substring(0, 10)} \u00B7 ${item.status.dbValue.toUpperCase()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'monospace',
                                    color: RetroTheme.muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${item.total.toStringAsFixed(0)} \u20BD',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              color: RetroTheme.accentBlue,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: RetroSpacing.xs),
                          const Icon(Icons.chevron_right,
                              color: RetroTheme.muted, size: 20),
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
