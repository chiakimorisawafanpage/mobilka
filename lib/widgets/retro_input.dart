import 'package:flutter/material.dart';

import '../theme.dart';

class RetroInput extends StatefulWidget {
  const RetroInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.keyboardType,
    this.multiline = false,
    this.obscureText = false,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool multiline;
  final bool obscureText;

  @override
  State<RetroInput> createState() => _RetroInputState();
}

class _RetroInputState extends State<RetroInput> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(RetroInput old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && _ctrl.text != widget.value) {
      _ctrl.text = widget.value;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RetroSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
              color: RetroTheme.bloodRed,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: RetroSpacing.xs),
          TextField(
            controller: _ctrl,
            onChanged: widget.onChanged,
            keyboardType: widget.multiline
                ? TextInputType.multiline
                : widget.keyboardType,
            maxLines: widget.multiline ? 4 : 1,
            obscureText: widget.obscureText,
            cursorColor: RetroTheme.bloodRed,
            style: const TextStyle(
              color: RetroTheme.text,
              fontFamily: 'monospace',
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                color: RetroTheme.text.withValues(alpha: 0.3),
                fontFamily: 'monospace',
                fontSize: 14,
              ),
              filled: true,
              fillColor: const Color(0xFF000000),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: RetroSpacing.sm, vertical: RetroSpacing.sm),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide:
                      BorderSide(color: RetroTheme.border, width: 2)),
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide:
                      BorderSide(color: RetroTheme.border, width: 2)),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide:
                      BorderSide(color: RetroTheme.bloodRed, width: 2)),
            ),
          ),
        ],
      ),
    );
  }
}
