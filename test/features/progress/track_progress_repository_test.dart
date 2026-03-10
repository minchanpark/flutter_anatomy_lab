import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anatomy_lab/features/progress/data/shared_preferences_track_progress_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPreferencesTrackProgressRepository', () {
    late SharedPreferences preferences;
    late SharedPreferencesTrackProgressRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      repository = SharedPreferencesTrackProgressRepository(
        preferences: preferences,
        loadOrderedLessonIds: (_) async => const [
          'text',
          'container',
          'row',
          'gesture_detector',
          'list_view',
        ],
      );
    });

    test('hydrates initial progress from ordered lessons', () async {
      final progress = await repository.load('core_widgets_foundation');

      expect(progress.currentLessonId, 'text');
      expect(progress.completionPercent, 0);
    });

    test('persists completion percent and current lesson', () async {
      await repository.setCurrentLesson('core_widgets_foundation', 'text');
      final updated = await repository.setLessonCompleted(
        'core_widgets_foundation',
        'text',
        true,
      );

      expect(updated.completedLessonIds, contains('text'));
      expect(updated.currentLessonId, 'text');
      expect(updated.completionPercent, 20.0);

      final reloaded = await repository.load('core_widgets_foundation');
      expect(reloaded.completedLessonIds, contains('text'));
      expect(reloaded.completionPercent, 20.0);
    });
  });
}
