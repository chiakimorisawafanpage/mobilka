import 'package:flutter/material.dart';

import '../theme.dart';

class RetroSelectOption<T> {
  const RetroSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

class RetroSelect<T> extends StatelessWidget {
  const RetroSelect({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<RetroSelectOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final current = options.firstWhere(
      (o) => o.value == value,
      orElse: () => options.first,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: RetroSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              color: RetroTheme.text,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () async {
              final picked = await showDialog<T>(
                context: context,
                builder: (ctx) {
                  return SimpleDialog(
                    title: const Text(
                      'SELECT',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                        color: RetroTheme.text,
                        fontSize: 14,
                      ),
                    ),
                    children: options.map((o) {
                      final selected = o.value == value;
                      return SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, o.value),
                        child: Text(
                          selected ? '> ${o.label}' : '  ${o.label}',
                          style: TextStyle(
                            fontWeight: selected
                                ? FontWeight.w800
                                : FontWeight.w500,
                            fontFamily: 'monospace',
                            color: selected
                                ? RetroTheme.accentBlue
                                : RetroTheme.text,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
              if (picked != null) onChanged(picked);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: RetroSpacing.sm, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: RetroTheme.win98Dark, width: 1),
                  left: BorderSide(color: RetroTheme.win98Dark, width: 1),
                  right: BorderSide(color: RetroTheme.win98Light, width: 1),
                  bottom: BorderSide(color: RetroTheme.win98Light, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      current.label,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: RetroTheme.text,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down,
                      size: 18, color: RetroTheme.muted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
