import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/content_models.dart';
import 'content_repository.dart';

part 'content_providers.g.dart';

@Riverpod(keepAlive: true)
ContentRepository contentRepository(Ref ref) {
  return AssetContentRepository(assetBundle: rootBundle);
}

@riverpod
Future<TrackManifest> trackManifest(Ref ref, String trackId) {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.loadTrack(trackId);
}

@riverpod
Future<LessonBundle> lessonBundle(Ref ref, String widgetId) async {
  final repository = ref.watch(contentRepositoryProvider);
  final lesson = await repository.loadLesson(widgetId);
  final anatomy = await repository.loadAnatomy(widgetId);
  final quiz = await repository.loadQuiz(widgetId);

  _validateLessonBundle(
    lesson: lesson,
    anatomy: anatomy,
    quiz: quiz,
  );

  return LessonBundle(
    lesson: lesson,
    anatomy: anatomy,
    quiz: quiz,
  );
}

void _validateLessonBundle({
  required LessonDocument lesson,
  required AnatomyDocument anatomy,
  required QuizDocument quiz,
}) {
  if (lesson.id != anatomy.lessonId || lesson.id != quiz.lessonId) {
    throw FormatException(
      'Lesson id "${lesson.id}" does not match anatomy/quiz lesson ids.',
    );
  }

  final sectionIds = lesson.sectionIds.toSet();
  final sourceRefIds = lesson.sourceRefs.map((sourceRef) => sourceRef.id).toSet();

  for (final node in anatomy.nodes) {
    for (final relatedSectionId in node.relatedSectionIds) {
      if (!sectionIds.contains(relatedSectionId)) {
        throw FormatException(
          'Anatomy node "${node.id}" references unknown section "$relatedSectionId".',
        );
      }
    }
    for (final sourceRefId in node.sourceRefIds) {
      if (!sourceRefIds.contains(sourceRefId)) {
        throw FormatException(
          'Anatomy node "${node.id}" references unknown source "$sourceRefId".',
        );
      }
    }
  }

  for (final question in quiz.questions) {
    for (final relatedSectionId in question.relatedSectionIds) {
      if (!sectionIds.contains(relatedSectionId)) {
        throw FormatException(
          'Quiz question "${question.id}" references unknown section "$relatedSectionId".',
        );
      }
    }
  }
}
