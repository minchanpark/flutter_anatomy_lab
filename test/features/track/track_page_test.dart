import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anatomy_lab/core/theme/app_theme.dart';
import 'package:flutter_anatomy_lab/content/repositories/content_providers.dart';
import 'package:flutter_anatomy_lab/features/progress/application/track_progress_controller.dart';
import 'package:flutter_anatomy_lab/features/track/presentation/track_page.dart';

import '../../test_support/fakes.dart';

void main() {
  testWidgets('track page renders docs shell on desktop and mobile', (
    tester,
  ) async {
    final fakeProgressRepository = InMemoryTrackProgressRepository();
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1.0;

    Future<void> pumpWithWidth(double width) async {
      tester.view.physicalSize = Size(width, 1200);
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
            home: const TrackPage(trackId: 'core_widgets_foundation'),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pumpWithWidth(1440);
    expect(find.text('Core 5 Widgets Foundation Track'), findsWidgets);
    expect(find.text('Why this track exists'), findsOneWidget);
    expect(find.text('Ordered lessons'), findsOneWidget);

    await pumpWithWidth(700);
    expect(find.text('Core 5 Widgets Foundation Track'), findsWidgets);
    expect(find.text('Why this track exists'), findsOneWidget);
    expect(find.text('Ordered lessons'), findsOneWidget);
  });
}
