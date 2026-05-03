import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/orders_repo.dart';
import '../models/order_header.dart';
import '../navigation/app_shell_controller.dart';
import '../theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_panel.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  OrderHeader? _order;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final db = context.read<Database>();
    final o = await getOrder(db, widget.orderId);
    if (!mounted) return;
    setState(() => _order = o);
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<Database>();
    final order = _order;

    return Scaffold(
      appBar: retroAppBar('ГОТОВО'),
      body: Padding(
        padding: const EdgeInsets.all(RetroSpacing.md),
        child: RetroPanel(
          title: 'ЗАКАЗ ОТПРАВЛЕН (локально)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'СПАСИБО!',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: RetroTheme.text),
              ),
              const SizedBox(height: RetroSpacing.sm),
              Text('Номер заказа: #${widget.orderId}',
                  style: const TextStyle(color: RetroTheme.text)),
              const SizedBox(height: RetroSpacing.sm),
              if (order != null)
                Text.rich(
                  TextSpan(
                    style: const TextStyle(color: RetroTheme.text),
                    children: [
                      const TextSpan(text: 'Статус: '),
                      TextSpan(
                          text: order.status.dbValue,
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      const TextSpan(text: ' · Сумма: '),
                      TextSpan(
                        text: order.total.toStringAsFixed(0),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const TextSpan(text: ' ₽'),
                    ],
                  ),
                )
              else
                const Text('Загрузка статуса…',
                    style: TextStyle(color: RetroTheme.text)),
              const SizedBox(height: RetroSpacing.sm),
              RetroButton(
                title: 'СКОПИРОВАТЬ ID',
                variant: RetroButtonVariant.link,
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: '${widget.orderId}'));
                  if (!context.mounted) return;
                  await showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('OK'),
                      content: const Text('ID скопирован'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('OK')),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: RetroSpacing.sm),
              RetroButton(
                title: 'ИМИТАЦИЯ: ДАЛЬШЕ ПО СТАТУСУ',
                onPressed: () async {
                  final next = await advanceOrderStatus(db, widget.orderId);
                  if (!mounted) return;
                  setState(() => _order = next);
                },
              ),
              const SizedBox(height: RetroSpacing.sm),
              RetroButton(
                title: 'К ЗАКАЗАМ',
                onPressed: () {
                  context.read<AppShellController>().goToTabAndPopToRoot(2);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              const SizedBox(height: RetroSpacing.sm),
              RetroButton(
                title: 'В КАТАЛОГ',
                onPressed: () {
                  context.read<AppShellController>().goToTabAndPopToRoot(0);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
