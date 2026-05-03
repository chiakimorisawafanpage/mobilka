import 'package:flutter/material.dart';

import '../theme.dart';
import 'retro_button.dart';

class RetroSelectOption<T> {
  const RetroSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

class RetroSelect<T> extends StatelessWidget {
  const RetroSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<RetroSelectOption<T>> options;
  final ValueChanged<T> onChanged;

  String _labelFor(T v) {
    return options
        .firstWhere((o) => o.value == v, orElse: () => options.first)
        .label;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RetroSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
              color: RetroTheme.accentCyan,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: RetroSpacing.xs),
          InkWell(
            onTap: () async {
              await showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (ctx) {
                  return AlertDialog(
                    backgroundColor: RetroTheme.bg,
                    shape: const RoundedRectangleBorder(
                      side:
                          BorderSide(color: RetroTheme.accentBlue, width: 3),
                      borderRadius: BorderRadius.zero,
                    ),
                    title: const Text(
                      '\u2605 SELECT \u2605',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: RetroTheme.accentYellow,
                      ),
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (final o in options)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: RetroSpacing.sm),
                              child: Material(
                                color: const Color(0xFF000000),
                                child: InkWell(
                                  onTap: () {
                                    onChanged(o.value);
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding:
                                        const EdgeInsets.all(RetroSpacing.sm),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: RetroTheme.border, width: 2),
                                    ),
                                    child: Text(
                                      '> ${o.label}',
                                      style: const TextStyle(
                                        color: RetroTheme.link,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'monospace',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    actions: [
                      RetroButton(
                          title: '[X] CLOSE',
                          onPressed: () => Navigator.of(ctx).pop()),
                    ],
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: RetroSpacing.sm, vertical: RetroSpacing.sm),
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                border: Border.all(color: RetroTheme.border, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _labelFor(value),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                        color: RetroTheme.text,
                      ),
                    ),
                  ),
                  const Text('[v]',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: RetroTheme.accentCyan,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
