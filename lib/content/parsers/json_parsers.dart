import 'dart:convert';

import '../models/content_models.dart';

class JsonParsers {
  const JsonParsers();

  TrackManifest parseTrackManifest(String raw) {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return TrackManifest.fromMap(decoded);
  }

  AnatomyDocument parseAnatomyDocument(String raw) {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final nodes = (decoded['nodes'] as List<dynamic>)
        .map((node) => AnatomyNode.fromMap((node as Map).cast<String, dynamic>()))
        .toList();
    final edges = (decoded['edges'] as List<dynamic>)
        .map((edge) => AnatomyEdge.fromMap((edge as Map).cast<String, dynamic>()))
        .toList();

    final nodeIds = nodes.map((node) => node.id).toSet();
    for (final edge in edges) {
      if (!nodeIds.contains(edge.from) || !nodeIds.contains(edge.to)) {
        throw FormatException(
          'Anatomy edge "${edge.from} -> ${edge.to}" references missing nodes.',
        );
      }
    }

    return AnatomyDocument(
      lessonId: decoded['lessonId'] as String,
      schemaVersion: (decoded['schemaVersion'] as num).toInt(),
      nodes: nodes,
      edges: edges,
    );
  }

  QuizDocument parseQuizDocument(String raw) {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return QuizDocument(
      lessonId: decoded['lessonId'] as String,
      schemaVersion: (decoded['schemaVersion'] as num).toInt(),
      questions: (decoded['questions'] as List<dynamic>)
          .map((question) =>
              QuizQuestion.fromMap((question as Map).cast<String, dynamic>()))
          .toList(),
    );
  }
}
