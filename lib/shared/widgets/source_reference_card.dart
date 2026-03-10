import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../content/models/content_models.dart';
import '../../core/theme/app_theme.dart';

class SourceReferenceCard extends StatelessWidget {
  const SourceReferenceCard({
    super.key,
    required this.sourceRef,
  });

  final SourceReference sourceRef;

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                sourceRef.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Chip(label: Text(sourceRef.kind.toUpperCase())),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            sourceRef.url,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (sourceRef.licenseNote != null) ...[
            const SizedBox(height: 8),
            Text(
              sourceRef.licenseNote!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Verified ${sourceRef.lastVerifiedAt}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              TextButton(
                onPressed: () async {
                  final uri = Uri.parse(sourceRef.url);
                  await launchUrl(uri);
                },
                child: const Text('Open source'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
