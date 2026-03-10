import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../content/models/content_models.dart';

abstract class TrackProgressRepository {
  Future<TrackProgressDocument> load(String trackId);
  Future<void> save(TrackProgressDocument progress);
  Future<TrackProgressDocument> setCurrentLesson(String trackId, String lessonId);
  Future<TrackProgressDocument> setLessonCompleted(
    String trackId,
    String lessonId,
    bool isCompleted,
  );
}

class SharedPreferencesTrackProgressRepository
    implements TrackProgressRepository {
  SharedPreferencesTrackProgressRepository({
    required SharedPreferences preferences,
    required Future<List<String>> Function(String trackId) loadOrderedLessonIds,
  })  : _preferences = preferences,
        _loadOrderedLessonIds = loadOrderedLessonIds;

  static const String storageKey = 'fal.trackProgress.v1';

  final SharedPreferences _preferences;
  final Future<List<String>> Function(String trackId) _loadOrderedLessonIds;

  @override
  Future<TrackProgressDocument> load(String trackId) async {
    final orderedLessonIds = await _loadOrderedLessonIds(trackId);
    final all = _readAll();
    final raw = all[trackId];
    if (raw == null) {
      return TrackProgressDocument.initial(
        trackId: trackId,
        orderedLessonIds: orderedLessonIds,
      );
    }

    final progress = TrackProgressDocument.fromMap(raw);
    return progress.normalizeForTrack(orderedLessonIds);
  }

  @override
  Future<void> save(TrackProgressDocument progress) async {
    final all = _readAll();
    all[progress.trackId] = progress.toMap();
    await _preferences.setString(storageKey, jsonEncode(all));
  }

  @override
  Future<TrackProgressDocument> setCurrentLesson(
    String trackId,
    String lessonId,
  ) async {
    final current = await load(trackId);
    final next = current
        .copyWith(
          currentLessonId: lessonId,
          lastVisitedAt: DateTime.now().toUtc().toIso8601String(),
        )
        .normalizeForTrack(current.orderedLessonIds);
    await save(next);
    return next;
  }

  @override
  Future<TrackProgressDocument> setLessonCompleted(
    String trackId,
    String lessonId,
    bool isCompleted,
  ) async {
    final current = await load(trackId);
    final completed = {...current.completedLessonIds};
    if (isCompleted) {
      completed.add(lessonId);
    } else {
      completed.remove(lessonId);
    }

    final next = current
        .copyWith(
          completedLessonIds: completed.toList()..sort(),
          lastVisitedAt: DateTime.now().toUtc().toIso8601String(),
        )
        .normalizeForTrack(current.orderedLessonIds);
    await save(next);
    return next;
  }

  Map<String, dynamic> _readAll() {
    final raw = _preferences.getString(storageKey);
    if (raw == null || raw.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return <String, dynamic>{};
    }
    return decoded;
  }
}
