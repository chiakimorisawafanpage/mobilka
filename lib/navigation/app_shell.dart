import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../screens/catalog_screen.dart';
import '../screens/order_detail_screen.dart';
import '../screens/orders_list_screen.dart';
import '../screens/product_screen.dart';
import '../screens/profile_screen.dart';
import '../theme.dart';
import '../widgets/retro_y2k_background.dart';
import 'app_shell_controller.dart';
import 'route_observer.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppShellController>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const RetroY2KBackground(),
          IndexedStack(
            index: ctrl.tab,
            children: [
              Navigator(
                key: ctrl.shopNavKey,
                observers: [appRouteObserver],
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case '/product':
                      final id = settings.arguments! as int;
                      return MaterialPageRoute<void>(
                        settings: settings,
                        builder: (_) => ProductScreen(productId: id),
                      );
                    case '/catalog':
                    default:
                      return MaterialPageRoute<void>(
                        settings: settings,
                        builder: (_) => const CatalogScreen(),
                      );
                  }
                },
              ),
              Navigator(
                key: ctrl.cartNavKey,
                observers: [appRouteObserver],
                onGenerateRoute: (settings) {
                  return MaterialPageRoute<void>(
                    settings: settings,
                    builder: (_) => const CartScreen(),
                  );
                },
              ),
              Navigator(
                key: ctrl.ordersNavKey,
                observers: [appRouteObserver],
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case '/order':
                      final id = settings.arguments! as int;
                      return MaterialPageRoute<void>(
                        settings: settings,
                        builder: (_) => OrderDetailScreen(orderId: id),
                      );
                    case '/orders':
                    default:
                      return MaterialPageRoute<void>(
                        settings: settings,
                        builder: (_) => const OrdersListScreen(),
                      );
                  }
                },
              ),
              Navigator(
                key: ctrl.profileNavKey,
                observers: [appRouteObserver],
                onGenerateRoute: (settings) {
                  return MaterialPageRoute<void>(
                    settings: settings,
                    builder: (_) => const ProfileScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _GeocitiesNavBar(
        currentIndex: ctrl.tab,
        onTap: context.read<AppShellController>().setTab,
      ),
    );
  }
}

class _GeocitiesNavBar extends StatelessWidget {
  const _GeocitiesNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(icon: Icons.storefront, label: 'SHOP'),
      _NavItem(icon: Icons.shopping_cart, label: 'CART'),
      _NavItem(icon: Icons.receipt_long, label: 'ORDERS'),
      _NavItem(icon: Icons.person, label: 'PROFILE'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF000011),
        border: Border(
          top: BorderSide(color: RetroTheme.accentCyan, width: 2),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (i) {
            final selected = i == currentIndex;
            final item = items[i];
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF330066),
                              Color(0xFF000033),
                            ],
                          )
                        : null,
                    border: Border(
                      left: i > 0
                          ? BorderSide(
                              color:
                                  RetroTheme.border.withValues(alpha: 0.5),
                              width: 1)
                          : BorderSide.none,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: selected
                            ? RetroTheme.accentYellow
                            : RetroTheme.silver,
                        shadows: selected
                            ? const [
                                Shadow(
                                    color: Color(0xFFFFFF00),
                                    blurRadius: 8),
                              ]
                            : null,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w900,
                          fontSize: 9,
                          letterSpacing: 1.0,
                          color: selected
                              ? RetroTheme.accentCyan
                              : RetroTheme.silver,
                          shadows: selected
                              ? const [
                                  Shadow(
                                      color: Color(0xFF00FFFF),
                                      blurRadius: 6),
                                ]
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
