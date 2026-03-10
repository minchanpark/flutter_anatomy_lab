import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class DocsAppShell extends StatelessWidget {
  const DocsAppShell({
    super.key,
    required this.content,
    this.leftNav,
    this.contextRail,
    this.scrollController,
  });

  final Widget content;
  final Widget? leftNav;
  final Widget? contextRail;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            _DocsTopBar(),
            const Divider(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 1280) {
                    return Row(
                      children: [
                        if (leftNav != null)
                          SizedBox(
                            width: 280,
                            child: _DocsPanel(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: leftNav,
                              ),
                            ),
                          ),
                        Expanded(
                          child: _buildScrollableContent(
                            context,
                            tokens,
                            extraBelowContent: null,
                          ),
                        ),
                        if (contextRail != null)
                          SizedBox(
                            width: 300,
                            child: _DocsPanel(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: contextRail,
                              ),
                            ),
                          ),
                      ],
                    );
                  }

                  if (constraints.maxWidth >= 840) {
                    return Row(
                      children: [
                        if (leftNav != null)
                          SizedBox(
                            width: 240,
                            child: _DocsPanel(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: leftNav,
                              ),
                            ),
                          ),
                        Expanded(
                          child: _buildScrollableContent(
                            context,
                            tokens,
                            extraBelowContent: contextRail,
                          ),
                        ),
                      ],
                    );
                  }

                  return _buildScrollableContent(
                    context,
                    tokens,
                    extraAboveContent: leftNav,
                    extraBelowContent: contextRail,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableContent(
    BuildContext context,
    AppThemeTokens tokens, {
    Widget? extraAboveContent,
    Widget? extraBelowContent,
  }) {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        child: SelectionArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (extraAboveContent != null) ...[
                    _DocsPanel(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: extraAboveContent,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  _DocsPanel(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: content,
                    ),
                  ),
                  if (extraBelowContent != null) ...[
                    const SizedBox(height: 24),
                    _DocsPanel(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: extraBelowContent,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DocsTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 68,
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            InkWell(
              onTap: () => context.go('/tracks/core_widgets_foundation'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  'Flutter Anatomy Lab',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
            const SizedBox(width: 24),
            TextButton(
              onPressed: () => context.go('/tracks/core_widgets_foundation'),
              child: const Text('Track'),
            ),
            TextButton(
              onPressed: () => context.go('/widgets/text'),
              child: const Text('Text'),
            ),
            TextButton(
              onPressed: () => context.go('/settings'),
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocsPanel extends StatelessWidget {
  const _DocsPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(
          right: BorderSide(color: tokens.border),
        ),
      ),
      child: child,
    );
  }
}
