import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

class RetroInput extends StatefulWidget {
  const RetroInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.multiline = false,
    this.keyboardType = TextInputType.text,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? placeholder;
  final bool multiline;
  final TextInputType keyboardType;

  @override
  State<RetroInput> createState() => _RetroInputState();
}

class _RetroInputState extends State<RetroInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(RetroInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
              color: RetroTheme.accentCyan,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: RetroSpacing.xs),
          TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                color: RetroTheme.text.withValues(alpha: 0.4),
                fontFamily: 'monospace',
                fontSize: 13,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: RetroSpacing.sm,
                vertical: RetroSpacing.sm,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: RetroTheme.accentBlue, width: 2),
                borderRadius: BorderRadius.zero,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: RetroTheme.border, width: 2),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: RetroTheme.accentCyan, width: 2),
                borderRadius: BorderRadius.zero,
              ),
              filled: true,
              fillColor: const Color(0xFF000000),
            ),
            style: const TextStyle(
              color: RetroTheme.text,
              fontFamily: 'monospace',
              fontSize: 14,
            ),
            cursorColor: RetroTheme.text,
            maxLines: widget.multiline ? 5 : 1,
            minLines: widget.multiline ? 3 : 1,
            keyboardType: widget.multiline
                ? TextInputType.multiline
                : widget.keyboardType,
            inputFormatters: widget.keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                : null,
          ),
        ],
      ),
    );
  }
}
