import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../content/models/content_models.dart';
import '../../../content/repositories/content_providers.dart';
import '../data/shared_preferences_track_progress_repository.dart';

part 'track_progress_controller.g.dart';

@Riverpod(keepAlive: true)
Future<TrackProgressRepository> trackProgressRepository(Ref ref) async {
  final preferences = await SharedPreferences.getInstance();
  final contentRepository = ref.watch(contentRepositoryProvider);

  return SharedPreferencesTrackProgressRepository(
    preferences: preferences,
    loadOrderedLessonIds: (trackId) async {
      final manifest = await contentRepository.loadTrack(trackId);
      return manifest.orderedLessonIds;
    },
  );
}

@riverpod
class TrackProgressController extends _$TrackProgressController {
  @override
  FutureOr<TrackProgressDocument> build(String trackId) async {
    final repository = await ref.watch(trackProgressRepositoryProvider.future);
    return repository.load(trackId);
  }

  Future<void> setCurrentLesson(String lessonId) async {
    final repository = await ref.read(trackProgressRepositoryProvider.future);
    final next = await repository.setCurrentLesson(trackId, lessonId);
    state = AsyncData(next);
  }

  Future<void> setLessonCompleted(String lessonId, bool isCompleted) async {
    final repository = await ref.read(trackProgressRepositoryProvider.future);
    final next = await repository.setLessonCompleted(
      trackId,
      lessonId,
      isCompleted,
    );
    state = AsyncData(next);
  }
}
