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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ctrl.tab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: RetroTheme.accentBg,
        selectedItemColor: RetroTheme.link,
        unselectedItemColor: RetroTheme.muted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        onTap: context.read<AppShellController>().setTab,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.storefront), label: 'МАГАЗИН'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'КОРЗИНА'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'ЗАКАЗЫ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ПРОФИЛЬ'),
        ],
      ),
    );
  }
}
