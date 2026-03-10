import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class SourceReference {
  const SourceReference({
    required this.id,
    required this.kind,
    required this.title,
    required this.url,
    required this.lastVerifiedAt,
    this.licenseNote,
  });

  final String id;
  final String kind;
  final String title;
  final String url;
  final String lastVerifiedAt;
  final String? licenseNote;

  factory SourceReference.fromMap(Map<String, dynamic> map) {
    return SourceReference(
      id: map['id'] as String,
      kind: map['kind'] as String,
      title: map['title'] as String,
      url: map['url'] as String,
      lastVerifiedAt: map['lastVerifiedAt'] as String,
      licenseNote: map['licenseNote'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kind': kind,
      'title': title,
      'url': url,
      'lastVerifiedAt': lastVerifiedAt,
      'licenseNote': licenseNote,
    };
  }
}

@immutable
class LessonSection {
  const LessonSection({
    required this.id,
    required this.title,
    required this.body,
  });

  final String id;
  final String title;
  final String body;
}

@immutable
class LessonDocument {
  const LessonDocument({
    required this.id,
    required this.kind,
    required this.title,
    required this.library,
    required this.difficulty,
    required this.trackIds,
    required this.orderInTrack,
    required this.isCoreTrackLesson,
    required this.recommendedNext,
    required this.conceptCoverage,
    required this.sourceRefs,
    required this.contentVersion,
    required this.schemaVersion,
    required this.flutterVersion,
    required this.lastReviewedAt,
    required this.sections,
  });

  final String id;
  final String kind;
  final String title;
  final String library;
  final String difficulty;
  final List<String> trackIds;
  final int orderInTrack;
  final bool isCoreTrackLesson;
  final List<String> recommendedNext;
  final List<String> conceptCoverage;
  final List<SourceReference> sourceRefs;
  final int contentVersion;
  final int schemaVersion;
  final String flutterVersion;
  final String lastReviewedAt;
  final List<LessonSection> sections;

  List<String> get sectionIds => sections.map((section) => section.id).toList();

  LessonSection sectionById(String id) {
    return sections.firstWhere((section) => section.id == id);
  }

  SourceReference? sourceRefById(String id) {
    for (final sourceRef in sourceRefs) {
      if (sourceRef.id == id) {
        return sourceRef;
      }
    }
    return null;
  }
}

@immutable
class AnatomyNode {
  const AnatomyNode({
    required this.id,
    required this.kind,
    required this.title,
    required this.summary,
    required this.relatedSectionIds,
    required this.sourceRefIds,
  });

  final String id;
  final String kind;
  final String title;
  final String summary;
  final List<String> relatedSectionIds;
  final List<String> sourceRefIds;

  factory AnatomyNode.fromMap(Map<String, dynamic> map) {
    return AnatomyNode(
      id: map['id'] as String,
      kind: map['kind'] as String,
      title: map['title'] as String,
      summary: map['summary'] as String,
      relatedSectionIds: (map['relatedSectionIds'] as List<dynamic>)
          .cast<String>(),
      sourceRefIds: (map['sourceRefIds'] as List<dynamic>).cast<String>(),
    );
  }
}

@immutable
class AnatomyEdge {
  const AnatomyEdge({
    required this.from,
    required this.to,
    required this.relationship,
  });

  final String from;
  final String to;
  final String relationship;

  factory AnatomyEdge.fromMap(Map<String, dynamic> map) {
    return AnatomyEdge(
      from: map['from'] as String,
      to: map['to'] as String,
      relationship: map['relationship'] as String,
    );
  }
}

@immutable
class AnatomyDocument {
  const AnatomyDocument({
    required this.lessonId,
    required this.schemaVersion,
    required this.nodes,
    required this.edges,
  });

  final String lessonId;
  final int schemaVersion;
  final List<AnatomyNode> nodes;
  final List<AnatomyEdge> edges;

  AnatomyNode? nodeById(String id) {
    for (final node in nodes) {
      if (node.id == id) {
        return node;
      }
    }
    return null;
  }
}

@immutable
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    required this.choices,
    required this.answer,
    required this.relatedSectionIds,
    required this.explanation,
  });

  final String id;
  final String type;
  final String prompt;
  final List<String> choices;
  final Object answer;
  final List<String> relatedSectionIds;
  final String explanation;

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      id: map['id'] as String,
      type: map['type'] as String,
      prompt: map['prompt'] as String,
      choices: (map['choices'] as List<dynamic>).cast<String>(),
      answer: map['answer'] as Object,
      relatedSectionIds: (map['relatedSectionIds'] as List<dynamic>)
          .cast<String>(),
      explanation: map['explanation'] as String,
    );
  }
}

@immutable
class QuizDocument {
  const QuizDocument({
    required this.lessonId,
    required this.schemaVersion,
    required this.questions,
  });

  final String lessonId;
  final int schemaVersion;
  final List<QuizQuestion> questions;
}

@immutable
class TrackManifest {
  const TrackManifest({
    required this.id,
    required this.title,
    required this.schemaVersion,
    required this.contentVersion,
    required this.orderedLessonIds,
    required this.recommendedEntryLessonId,
    required this.estimatedMinutes,
    required this.learningOutcomes,
    required this.lastReviewedAt,
  });

  final String id;
  final String title;
  final int schemaVersion;
  final int contentVersion;
  final List<String> orderedLessonIds;
  final String recommendedEntryLessonId;
  final int estimatedMinutes;
  final List<String> learningOutcomes;
  final String lastReviewedAt;

  factory TrackManifest.fromMap(Map<String, dynamic> map) {
    return TrackManifest(
      id: map['id'] as String,
      title: map['title'] as String,
      schemaVersion: map['schemaVersion'] as int,
      contentVersion: map['contentVersion'] as int,
      orderedLessonIds: (map['orderedLessonIds'] as List<dynamic>)
          .cast<String>(),
      recommendedEntryLessonId: map['recommendedEntryLessonId'] as String,
      estimatedMinutes: map['estimatedMinutes'] as int,
      learningOutcomes: (map['learningOutcomes'] as List<dynamic>)
          .cast<String>(),
      lastReviewedAt: map['lastReviewedAt'] as String,
    );
  }
}

@immutable
class LessonBundle {
  const LessonBundle({
    required this.lesson,
    required this.anatomy,
    required this.quiz,
  });

  final LessonDocument lesson;
  final AnatomyDocument anatomy;
  final QuizDocument quiz;
}

@immutable
class TrackProgressDocument {
  const TrackProgressDocument({
    required this.schemaVersion,
    required this.trackId,
    required this.orderedLessonIds,
    required this.completedLessonIds,
    required this.currentLessonId,
    required this.completionPercent,
    required this.lastVisitedAt,
  });

  factory TrackProgressDocument.initial({
    required String trackId,
    required List<String> orderedLessonIds,
  }) {
    return TrackProgressDocument(
      schemaVersion: 1,
      trackId: trackId,
      orderedLessonIds: orderedLessonIds,
      completedLessonIds: const [],
      currentLessonId: orderedLessonIds.isEmpty ? null : orderedLessonIds.first,
      completionPercent: 0,
      lastVisitedAt: null,
    );
  }

  factory TrackProgressDocument.fromMap(Map<String, dynamic> map) {
    return TrackProgressDocument(
      schemaVersion: map['schemaVersion'] as int,
      trackId: map['trackId'] as String,
      orderedLessonIds: (map['orderedLessonIds'] as List<dynamic>)
          .cast<String>(),
      completedLessonIds: (map['completedLessonIds'] as List<dynamic>)
          .cast<String>(),
      currentLessonId: map['currentLessonId'] as String?,
      completionPercent: (map['completionPercent'] as num).toDouble(),
      lastVisitedAt: map['lastVisitedAt'] as String?,
    );
  }

  final int schemaVersion;
  final String trackId;
  final List<String> orderedLessonIds;
  final List<String> completedLessonIds;
  final String? currentLessonId;
  final double completionPercent;
  final String? lastVisitedAt;

  bool isCompleted(String lessonId) {
    return completedLessonIds.contains(lessonId);
  }

  TrackProgressDocument normalizeForTrack(List<String> orderedIds) {
    final filteredCompleted = completedLessonIds
        .where(orderedIds.contains)
        .toSet()
        .toList();
    final current = currentLessonId != null && orderedIds.contains(currentLessonId)
        ? currentLessonId
        : (orderedIds.isEmpty ? null : orderedIds.first);
    final percent = orderedIds.isEmpty
        ? 0.0
        : (filteredCompleted.length / orderedIds.length * 100);

    return TrackProgressDocument(
      schemaVersion: schemaVersion,
      trackId: trackId,
      orderedLessonIds: orderedIds,
      completedLessonIds: filteredCompleted,
      currentLessonId: current,
      completionPercent: percent,
      lastVisitedAt: lastVisitedAt,
    );
  }

  TrackProgressDocument copyWith({
    int? schemaVersion,
    String? trackId,
    List<String>? orderedLessonIds,
    List<String>? completedLessonIds,
    String? currentLessonId,
    bool clearCurrentLessonId = false,
    double? completionPercent,
    String? lastVisitedAt,
    bool clearLastVisitedAt = false,
  }) {
    return TrackProgressDocument(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      trackId: trackId ?? this.trackId,
      orderedLessonIds: orderedLessonIds ?? this.orderedLessonIds,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      currentLessonId:
          clearCurrentLessonId ? null : currentLessonId ?? this.currentLessonId,
      completionPercent: completionPercent ?? this.completionPercent,
      lastVisitedAt:
          clearLastVisitedAt ? null : lastVisitedAt ?? this.lastVisitedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schemaVersion': schemaVersion,
      'trackId': trackId,
      'orderedLessonIds': orderedLessonIds,
      'completedLessonIds': completedLessonIds,
      'currentLessonId': currentLessonId,
      'completionPercent': completionPercent,
      'lastVisitedAt': lastVisitedAt,
    };
  }

  String toJson() => jsonEncode(toMap());
}
