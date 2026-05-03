import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/orders_repo.dart';
import '../db/products_repo.dart';
import '../models/order_header.dart';
import '../models/order_status.dart';
import '../models/product.dart';
import '../theme.dart';

const String _adminPassword = 'admin';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  bool _unlocked = false;
  String _passwordInput = '';
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_unlocked) {
      return Scaffold(
        appBar: retroAppBar('ADMIN', automaticallyImplyLeading: false),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings_rounded,
                    size: 48, color: RetroTheme.accentBlue),
                const SizedBox(height: 12),
                const Text('Admin Panel',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 4),
                const Text('Enter password to access',
                    style: TextStyle(
                      fontSize: 13,
                      color: RetroTheme.muted,
                    )),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  onChanged: (v) => _passwordInput = v,
                  onSubmitted: (_) => _tryUnlock(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon:
                        const Icon(Icons.lock_outline, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8F8F6),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: const Text('Unlock',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RetroTheme.accentBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _tryUnlock,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Default password: admin',
                  style: TextStyle(fontSize: 11, color: RetroTheme.muted),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN PANEL',
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w900,
              fontSize: 14,
            )),
        backgroundColor: RetroTheme.win98Gray,
        foregroundColor: RetroTheme.text,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: RetroTheme.accentBlue,
          unselectedLabelColor: RetroTheme.muted,
          indicatorColor: RetroTheme.accentBlue,
          tabs: const [
            Tab(icon: Icon(Icons.inventory_2, size: 18), text: 'Products'),
            Tab(icon: Icon(Icons.receipt_long, size: 18), text: 'Orders'),
            Tab(icon: Icon(Icons.people, size: 18), text: 'Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          _AdminProductsTab(),
          _AdminOrdersTab(),
          _AdminUsersTab(),
        ],
      ),
    );
  }

  void _tryUnlock() {
    if (_passwordInput == _adminPassword) {
      setState(() => _unlocked = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong password'),
          backgroundColor: RetroTheme.danger,
        ),
      );
    }
  }
}

// ─── Products Tab ───────────────────────────────────────────────

class _AdminProductsTab extends StatefulWidget {
  const _AdminProductsTab();

  @override
  State<_AdminProductsTab> createState() => _AdminProductsTabState();
}

class _AdminProductsTabState extends State<_AdminProductsTab> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    final db = context.read<Database>();
    final rows = await listProducts(
        db, ProductFilters(sort: ProductSort.titleAsc));
    if (!mounted) return;
    setState(() => _products = rows);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final p = _products[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                      '${p.price.toStringAsFixed(0)} \u20BD \u00B7 Stock: ${p.stock}',
                      style: TextStyle(
                        fontSize: 12,
                        color: p.stock > 0
                            ? RetroTheme.muted
                            : RetroTheme.danger,
                        fontWeight: p.stock <= 0
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: RetroTheme.accentBlue,
                onPressed: () => _showEditDialog(p),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEditDialog(Product product) async {
    final titleCtrl = TextEditingController(text: product.title);
    final priceCtrl =
        TextEditingController(text: product.price.toStringAsFixed(0));
    final stockCtrl = TextEditingController(text: '${product.stock}');
    final descCtrl = TextEditingController(text: product.description);

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Product',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field('Title', titleCtrl),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _field('Price', priceCtrl, isNum: true)),
                  const SizedBox(width: 10),
                  Expanded(child: _field('Stock', stockCtrl, isNum: true)),
                ],
              ),
              const SizedBox(height: 10),
              _field('Description', descCtrl, maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child:
                const Text('Cancel', style: TextStyle(color: RetroTheme.muted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: RetroTheme.accentBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved == true && mounted) {
      final db = context.read<Database>();
      final newPrice = double.tryParse(priceCtrl.text) ?? product.price;
      final newStock = int.tryParse(stockCtrl.text) ?? product.stock;
      await db.rawUpdate(
        '''UPDATE products SET title = ?, price = ?, stock = ?, description = ?
         WHERE id = ?''',
        [
          titleCtrl.text.trim(),
          newPrice,
          newStock,
          descCtrl.text.trim(),
          product.id,
        ],
      );
      await _reload();
    }

    titleCtrl.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
    descCtrl.dispose();
  }

  Widget _field(String label, TextEditingController ctrl,
      {bool isNum = false, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        isDense: true,
      ),
    );
  }
}

// ─── Orders Tab ─────────────────────────────────────────────────

class _AdminOrdersTab extends StatefulWidget {
  const _AdminOrdersTab();

  @override
  State<_AdminOrdersTab> createState() => _AdminOrdersTabState();
}

class _AdminOrdersTabState extends State<_AdminOrdersTab> {
  List<OrderHeader> _orders = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    final db = context.read<Database>();
    final rows = await listOrders(db);
    if (!mounted) return;
    setState(() => _orders = rows);
  }

  @override
  Widget build(BuildContext context) {
    if (_orders.isEmpty) {
      return const Center(
        child: Text('No orders yet',
            style: TextStyle(color: RetroTheme.muted, fontSize: 15)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final o = _orders[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Order #${o.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      )),
                  const Spacer(),
                  _statusBadge(o.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${o.total.toStringAsFixed(0)} \u20BD \u00B7 ${o.address}',
                style: const TextStyle(fontSize: 12, color: RetroTheme.muted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                o.createdAt.substring(0, 16).replaceFirst('T', ' '),
                style: const TextStyle(fontSize: 11, color: RetroTheme.muted),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Status:',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  ...OrderStatus.values.map((s) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(s.dbValue,
                              style: const TextStyle(fontSize: 11)),
                          selected: o.status == s,
                          selectedColor: _statusColor(s),
                          onSelected: (_) => _setStatus(o.id, s),
                          visualDensity: VisualDensity.compact,
                        ),
                      )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _setStatus(int orderId, OrderStatus status) async {
    final db = context.read<Database>();
    await db.rawUpdate(
      'UPDATE orders SET status = ? WHERE id = ?',
      [status.dbValue, orderId],
    );
    await _reload();
  }

  Widget _statusBadge(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _statusColor(status),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.dbValue.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _statusColor(OrderStatus status) {
    return switch (status) {
      OrderStatus.accepted => const Color(0xFFFF9800),
      OrderStatus.shipping => RetroTheme.accentBlue,
      OrderStatus.delivered => const Color(0xFF2E7D32),
    };
  }
}

// ─── Users Tab ──────────────────────────────────────────────────

class _AdminUsersTab extends StatefulWidget {
  const _AdminUsersTab();

  @override
  State<_AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<_AdminUsersTab> {
  List<Map<String, Object?>> _users = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    final db = context.read<Database>();
    final rows = await db.rawQuery(
      'SELECT id, email, name, createdAt FROM users ORDER BY id DESC',
    );
    if (!mounted) return;
    setState(() => _users = rows);
  }

  @override
  Widget build(BuildContext context) {
    if (_users.isEmpty) {
      return const Center(
        child: Text('No registered users',
            style: TextStyle(color: RetroTheme.muted, fontSize: 15)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final u = _users[i];
        final name = u['name'] as String;
        final email = u['email'] as String;
        final createdAt = (u['createdAt'] as String?) ?? '';
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: RetroTheme.accentBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        )),
                    Text(email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: RetroTheme.muted,
                        )),
                  ],
                ),
              ),
              Text(
                createdAt.isNotEmpty
                    ? createdAt.substring(0, 10)
                    : '',
                style: const TextStyle(fontSize: 11, color: RetroTheme.muted),
              ),
            ],
          ),
        );
      },
    );
  }
}
