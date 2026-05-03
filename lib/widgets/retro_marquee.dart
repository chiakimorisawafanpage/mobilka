import 'package:flutter/material.dart';

import '../theme.dart';

class RetroMarquee extends StatefulWidget {
  const RetroMarquee({super.key, required this.text});

  final String text;

  @override
  State<RetroMarquee> createState() => _RetroMarqueeState();
}

class _RetroMarqueeState extends State<RetroMarquee>
    with SingleTickerProviderStateMixin {
  late final ScrollController _sc;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _sc = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scroll());
  }

  Future<void> _scroll() async {
    while (!_disposed && _sc.hasClients) {
      final max = _sc.position.maxScrollExtent;
      if (max <= 0) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        continue;
      }
      await _sc.animateTo(
        max,
        duration: Duration(milliseconds: (max * 40).floor()),
        curve: Curves.linear,
      );
      if (_disposed || !_sc.hasClients) break;
      _sc.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontWeight: FontWeight.w700,
      fontFamily: 'monospace',
      fontSize: 12,
      letterSpacing: 0.5,
      color: RetroTheme.accentBlue,
    );

    final full = List.filled(4, widget.text).join('  \u2022  ');

    return Container(
      height: 26,
      decoration: BoxDecoration(
        color: RetroTheme.panel,
        border: Border.all(color: RetroTheme.border, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _sc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: RetroSpacing.sm),
          child: Text(full, style: style, maxLines: 1),
        ),
      ),
    );
  }
}
