import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db/orders_repo.dart';
import '../models/order_header.dart';
import '../navigation/app_shell_controller.dart';
import '../theme.dart';
import '../widgets/blink_text.dart';
import '../widgets/rainbow_divider.dart';
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
      appBar: retroAppBar('SUCCESS'),
      body: Padding(
        padding: const EdgeInsets.all(RetroSpacing.md),
        child: RetroPanel(
          title: 'ORDER SUBMITTED',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BlinkText(
                text: '\u2605\u2605\u2605 THANK YOU! \u2605\u2605\u2605',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  color: RetroTheme.accentBlue,
                ),
              ),
              const RainbowDivider(height: 2),
              Text('Order #${widget.orderId}',
                  style: const TextStyle(
                    color: RetroTheme.text,
                    fontFamily: 'monospace',
                  )),
              const SizedBox(height: RetroSpacing.sm),
              if (order != null)
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      color: RetroTheme.text,
                      fontFamily: 'monospace',
                    ),
                    children: [
                      const TextSpan(text: 'Status: '),
                      TextSpan(
                          text: order.status.dbValue,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: RetroTheme.accentBlue,
                          )),
                      const TextSpan(text: ' \u00B7 Total: '),
                      TextSpan(
                        text: order.total.toStringAsFixed(0),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: RetroTheme.accentBlue,
                        ),
                      ),
                      const TextSpan(text: ' \u20BD'),
                    ],
                  ),
                )
              else
                const Text('Loading status...',
                    style: TextStyle(
                      color: RetroTheme.muted,
                      fontFamily: 'monospace',
                    )),
              const SizedBox(height: RetroSpacing.sm),
              RetroButton(
                title: 'COPY ID',
                variant: RetroButtonVariant.link,
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: '${widget.orderId}'));
                  if (!context.mounted) return;
                  await showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('OK'),
                      content: const Text('ID copied!'),
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
                title: 'SIMULATE: NEXT STATUS',
                onPressed: () async {
                  final next = await advanceOrderStatus(db, widget.orderId);
                  if (!mounted) return;
                  setState(() => _order = next);
                },
              ),
              const SizedBox(height: RetroSpacing.sm),
              RetroButton(
                title: 'GO TO ORDERS',
                onPressed: () {
                  context.read<AppShellController>().goToTabAndPopToRoot(2);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              const SizedBox(height: RetroSpacing.sm),
              RetroButton(
                title: 'BACK TO CATALOG',
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
