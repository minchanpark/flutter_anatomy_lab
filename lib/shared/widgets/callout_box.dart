import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

enum CalloutTone {
  info,
  note,
  caution,
}

class CalloutBox extends StatelessWidget {
  const CalloutBox({
    super.key,
    required this.title,
    required this.message,
    this.tone = CalloutTone.info,
  });

  final String title;
  final String message;
  final CalloutTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);
    final (background, border, icon) = switch (tone) {
      CalloutTone.info => (
          tokens.surfaceSubtle,
          tokens.border,
          Icons.info_outline_rounded,
        ),
      CalloutTone.note => (
          const Color(0xFFF3F8FF),
          tokens.accent.withValues(alpha: 0.22),
          Icons.menu_book_outlined,
        ),
      CalloutTone.caution => (
          const Color(0xFFFFF7E8),
          tokens.warning.withValues(alpha: 0.28),
          Icons.warning_amber_rounded,
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
