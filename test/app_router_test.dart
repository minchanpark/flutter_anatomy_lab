import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anatomy_lab/app/app.dart';
import 'package:flutter_anatomy_lab/content/repositories/content_providers.dart';
import 'package:flutter_anatomy_lab/features/progress/application/track_progress_controller.dart';

import 'test_support/fakes.dart';

void main() {
  testWidgets('router opens anatomy deep link for text lesson', (tester) async {
    final fakeProgressRepository = InMemoryTrackProgressRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentRepositoryProvider.overrideWith((ref) => FakeContentRepository()),
          trackProgressRepositoryProvider.overrideWith(
            (ref) async => fakeProgressRepository,
          ),
        ],
        child: const FlutterAnatomyLabApp(
          initialLocation: '/widgets/text/anatomy/overflow',
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Anatomy'), findsWidgets);
    expect(find.text('Overflow'), findsWidgets);
    expect(find.text('Wrapping and ellipsis depend on width constraints.'),
        findsOneWidget);
  });
}
