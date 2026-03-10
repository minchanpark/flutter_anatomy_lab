import 'package:flutter_anatomy_lab/content/models/content_models.dart';
import 'package:flutter_anatomy_lab/content/repositories/content_repository.dart';
import 'package:flutter_anatomy_lab/features/progress/data/shared_preferences_track_progress_repository.dart';

TrackManifest fakeTrackManifest() {
  return const TrackManifest(
    id: 'core_widgets_foundation',
    title: 'Core 5 Widgets Foundation Track',
    schemaVersion: 1,
    contentVersion: 1,
    orderedLessonIds: [
      'text',
      'container',
      'row',
      'gesture_detector',
      'list_view',
    ],
    recommendedEntryLessonId: 'text',
    estimatedMinutes: 55,
    learningOutcomes: [
      'Explain text, box, flex, gesture, and scrolling fundamentals',
      'Connect Widget, layout, and semantics decisions across lessons',
    ],
    lastReviewedAt: '2026-03-10',
  );
}

LessonDocument fakeLessonDocument() {
  return LessonDocument(
    id: 'text',
    kind: 'widget',
    title: 'Text',
    library: 'widgets',
    difficulty: 'foundation',
    trackIds: const ['core_widgets_foundation'],
    orderInTrack: 1,
    isCoreTrackLesson: true,
    recommendedNext: const ['container'],
    conceptCoverage: const [
      'text',
      'text_style',
      'default_text_style',
      'overflow',
      'semantics',
    ],
    sourceRefs: const [
      SourceReference(
        id: 'api:text',
        kind: 'api',
        title: 'Text class',
        url: 'https://api.flutter.dev/flutter/widgets/Text-class.html',
        lastVerifiedAt: '2026-03-10',
      ),
    ],
    contentVersion: 1,
    schemaVersion: 1,
    flutterVersion: '3.41.x',
    lastReviewedAt: '2026-03-10',
    sections: const [
      LessonSection(
        id: 'overview',
        title: 'Overview',
        body: 'Text overview',
      ),
      LessonSection(id: 'api', title: 'API', body: 'Text api'),
      LessonSection(id: 'anatomy', title: 'Anatomy', body: 'Text anatomy'),
      LessonSection(id: 'source', title: 'Source', body: 'Text source'),
      LessonSection(
        id: 'playground',
        title: 'Playground',
        body: 'Text playground',
      ),
      LessonSection(id: 'runtime', title: 'Runtime', body: 'Text runtime'),
      LessonSection(
        id: 'semantics',
        title: 'Semantics',
        body: 'Text semantics',
      ),
      LessonSection(id: 'quiz', title: 'Quiz', body: 'Text quiz'),
    ],
  );
}

AnatomyDocument fakeAnatomyDocument() {
  return const AnatomyDocument(
    lessonId: 'text',
    schemaVersion: 1,
    nodes: [
      AnatomyNode(
        id: 'text',
        kind: 'widget',
        title: 'Text',
        summary: 'Widget-level description of a paragraph of text.',
        relatedSectionIds: ['overview', 'api', 'anatomy'],
        sourceRefIds: ['api:text'],
      ),
      AnatomyNode(
        id: 'overflow',
        kind: 'layout_behavior',
        title: 'Overflow',
        summary: 'Wrapping and ellipsis depend on width constraints.',
        relatedSectionIds: ['api', 'runtime', 'anatomy'],
        sourceRefIds: ['api:text'],
      ),
    ],
    edges: [
      AnatomyEdge(
        from: 'text',
        to: 'overflow',
        relationship: 'responds_with',
      ),
    ],
  );
}

QuizDocument fakeQuizDocument() {
  return const QuizDocument(
    lessonId: 'text',
    schemaVersion: 1,
    questions: [
      QuizQuestion(
        id: 'text_q1',
        type: 'multiple_choice',
        prompt: 'Which object provides inherited fallback text styling?',
        choices: ['DefaultTextStyle', 'Container', 'Row'],
        answer: 'DefaultTextStyle',
        relatedSectionIds: ['overview'],
        explanation: 'DefaultTextStyle fills in missing values.',
      ),
    ],
  );
}

class FakeContentRepository implements ContentRepository {
  @override
  Future<TrackManifest> loadTrack(String trackId) async {
    return fakeTrackManifest();
  }

  @override
  Future<LessonDocument> loadLesson(String widgetId) async {
    return fakeLessonDocument();
  }

  @override
  Future<AnatomyDocument> loadAnatomy(String widgetId) async {
    return fakeAnatomyDocument();
  }

  @override
  Future<QuizDocument> loadQuiz(String widgetId) async {
    return fakeQuizDocument();
  }
}

class InMemoryTrackProgressRepository implements TrackProgressRepository {
  final Map<String, TrackProgressDocument> _storage = {};

  @override
  Future<TrackProgressDocument> load(String trackId) async {
    return _storage[trackId] ??
        TrackProgressDocument.initial(
          trackId: trackId,
          orderedLessonIds: fakeTrackManifest().orderedLessonIds,
        );
  }

  @override
  Future<void> save(TrackProgressDocument progress) async {
    _storage[progress.trackId] = progress;
  }

  @override
  Future<TrackProgressDocument> setCurrentLesson(
    String trackId,
    String lessonId,
  ) async {
    final current = await load(trackId);
    final next = current.copyWith(
      currentLessonId: lessonId,
      lastVisitedAt: DateTime.now().toUtc().toIso8601String(),
    ).normalizeForTrack(fakeTrackManifest().orderedLessonIds);
    _storage[trackId] = next;
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
    final next = current.copyWith(
      completedLessonIds: completed.toList()..sort(),
      lastVisitedAt: DateTime.now().toUtc().toIso8601String(),
    ).normalizeForTrack(fakeTrackManifest().orderedLessonIds);
    _storage[trackId] = next;
    return next;
  }
}
