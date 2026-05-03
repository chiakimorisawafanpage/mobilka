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
      await _sc.animateTo(
        _sc.position.maxScrollExtent,
        duration: Duration(
            milliseconds: (_sc.position.maxScrollExtent * 35).floor()),
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
      fontWeight: FontWeight.w900,
      fontFamily: 'monospace',
      fontSize: 13,
      letterSpacing: 1.1,
      color: RetroTheme.bloodRed,
      shadows: [
        Shadow(
            offset: Offset(1, 1), color: Color(0xFF000000), blurRadius: 0),
        Shadow(
            offset: Offset(0, 0), color: Color(0xFFFF0000), blurRadius: 6),
      ],
    );

    final sep = ' \u2620 ';
    final full = List.filled(4, widget.text).join(sep);

    return Container(
      height: 28,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0000), Color(0xFF1A0000), Color(0xFF0A0000)],
        ),
        border: Border.symmetric(
          horizontal: BorderSide(color: RetroTheme.darkRed, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x44FF0000),
            offset: Offset(0, 0),
            blurRadius: 4,
          ),
        ],
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
