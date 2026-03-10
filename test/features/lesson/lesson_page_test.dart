import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anatomy_lab/content/repositories/content_providers.dart';
import 'package:flutter_anatomy_lab/core/theme/app_theme.dart';
import 'package:flutter_anatomy_lab/features/lesson/presentation/lesson_page.dart';
import 'package:flutter_anatomy_lab/features/progress/application/track_progress_controller.dart';

import '../../test_support/fakes.dart';

void main() {
  testWidgets('lesson page renders metadata, source refs, and completion toggle', (
    tester,
  ) async {
    final fakeProgressRepository = InMemoryTrackProgressRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentRepositoryProvider.overrideWith((ref) => FakeContentRepository()),
          trackProgressRepositoryProvider.overrideWith(
            (ref) async => fakeProgressRepository,
          ),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const LessonPage(widgetId: 'text'),
          ),
        ),
      );

    await tester.pumpAndSettle();

    expect(find.text('Text'), findsWidgets);
    expect(find.text('Text class'), findsWidgets);
    expect(find.text('Overview'), findsWidgets);
    expect(find.text('Mark lesson complete'), findsWidgets);

    await tester.ensureVisible(find.text('Mark lesson complete').first);
    await tester.tap(find.text('Mark lesson complete').first);
    await tester.pumpAndSettle();

    expect(find.text('Completed'), findsOneWidget);
  });
}
