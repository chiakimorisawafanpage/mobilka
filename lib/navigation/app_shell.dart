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
                observers: [shopRouteObserver],
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
                observers: [cartRouteObserver],
                onGenerateRoute: (settings) {
                  return MaterialPageRoute<void>(
                    settings: settings,
                    builder: (_) => const CartScreen(),
                  );
                },
              ),
              Navigator(
                key: ctrl.ordersNavKey,
                observers: [ordersRouteObserver],
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
                observers: [profileRouteObserver],
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
      bottomNavigationBar: _WinTaskbar(
        currentIndex: ctrl.tab,
        onTap: context.read<AppShellController>().setTab,
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _WinTaskbar extends StatelessWidget {
  const _WinTaskbar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: Icons.storefront, label: 'Shop'),
    _NavItem(icon: Icons.shopping_cart, label: 'Cart'),
    _NavItem(icon: Icons.receipt_long, label: 'Orders'),
    _NavItem(icon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: RetroTheme.win98Gray,
        border: Border(
          top: BorderSide(color: RetroTheme.win98Light, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            offset: Offset(0, -1),
            blurRadius: 3,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 48,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? RetroTheme.panel : Colors.transparent,
                      border: selected
                          ? const Border(
                              top: BorderSide(
                                  color: RetroTheme.accentBlue, width: 2),
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 18,
                          color: selected
                              ? RetroTheme.accentBlue
                              : RetroTheme.muted,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? RetroTheme.accentBlue
                                : RetroTheme.muted,
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
      ),
    );
  }
}
