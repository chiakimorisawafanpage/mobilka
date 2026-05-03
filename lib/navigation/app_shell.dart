import 'package:flutter/material.dart';

import '../screens/cart_screen.dart';
import '../screens/catalog_screen.dart';
import '../screens/orders_list_screen.dart';
import '../screens/profile_screen.dart';
import '../theme.dart';
import '../widgets/retro_y2k_background.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;

  final _navKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: RetroY2KBackground()),
          Positioned.fill(
            child: IndexedStack(
              index: _tab,
              children: [
                _buildNav(0, const CatalogScreen()),
                _buildNav(1, const CartScreen()),
                _buildNav(2, const OrdersListScreen()),
                _buildNav(3, const ProfileScreen()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _WinTaskbar(
        currentIndex: _tab,
        onTap: (i) {
          if (i == _tab) {
            _navKeys[i].currentState?.popUntil((r) => r.isFirst);
          } else {
            setState(() => _tab = i);
          }
        },
      ),
    );
  }

  Widget _buildNav(int idx, Widget root) {
    return Navigator(
      key: _navKeys[idx],
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => root),
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
