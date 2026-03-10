import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/layout/docs_app_shell.dart';
import '../shared/widgets/callout_box.dart';
import '../features/lesson/presentation/lesson_page.dart';
import '../features/track/presentation/track_page.dart';

GoRouter createAppRouter(
  WidgetRef ref, {
  String initialLocation = '/',
}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/tracks/core_widgets_foundation',
      ),
      GoRoute(
        path: '/tracks/:trackId',
        builder: (context, state) {
          return TrackPage(trackId: state.pathParameters['trackId']!);
        },
      ),
      GoRoute(
        path: '/widgets',
        builder: (context, state) => const _PlaceholderPage(
          title: 'Widget catalog',
          message:
              'The full catalog comes in the next slice. Start from the Core 5 track or open the text lesson directly.',
        ),
      ),
      GoRoute(
        path: '/widgets/:widgetId',
        builder: (context, state) {
          final widgetId = state.pathParameters['widgetId']!;
          if (widgetId == 'text') {
            return LessonPage(widgetId: widgetId);
          }
          return _PlaceholderPage(
            title: '$widgetId is scheduled next',
            message:
                'This route is reserved by the canonical router, but only the text lesson is live in the first milestone.',
          );
        },
      ),
      GoRoute(
        path: '/widgets/:widgetId/anatomy/:sectionId',
        builder: (context, state) {
          final widgetId = state.pathParameters['widgetId']!;
          final sectionId = state.pathParameters['sectionId']!;
          if (widgetId == 'text') {
            return LessonPage(
              widgetId: widgetId,
              anatomySectionId: sectionId,
            );
          }
          return _PlaceholderPage(
            title: '$widgetId anatomy route is not live yet',
            message:
                'Only `/widgets/text/anatomy/:sectionId` is active in the first implementation slice.',
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const _PlaceholderPage(
          title: 'Settings',
          message:
              'Language, accessibility, and experimental reader settings will be added after the track and lesson shell stabilize.',
        ),
      ),
    ],
    errorBuilder: (context, state) => _PlaceholderPage(
      title: 'Page not found',
      message: state.error?.toString() ?? 'Unknown route.',
    ),
  );
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return DocsAppShell(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          CalloutBox(
            tone: CalloutTone.note,
            title: 'Reserved route',
            message: message,
          ),
        ],
      ),
    );
  }
}
