import 'package:flutter/services.dart';

import '../models/content_models.dart';
import '../parsers/json_parsers.dart';
import '../parsers/lesson_parser.dart';

abstract class TrackRepository {
  Future<TrackManifest> loadTrack(String trackId);
}

abstract class LessonRepository {
  Future<LessonDocument> loadLesson(String widgetId);
  Future<AnatomyDocument> loadAnatomy(String widgetId);
  Future<QuizDocument> loadQuiz(String widgetId);
}

abstract class ContentRepository implements TrackRepository, LessonRepository {}

class AssetContentRepository implements ContentRepository {
  AssetContentRepository({
    required AssetBundle assetBundle,
    LessonParser lessonParser = const LessonParser(),
    JsonParsers jsonParsers = const JsonParsers(),
  })  : _assetBundle = assetBundle,
        _lessonParser = lessonParser,
        _jsonParsers = jsonParsers;

  final AssetBundle _assetBundle;
  final LessonParser _lessonParser;
  final JsonParsers _jsonParsers;

  @override
  Future<TrackManifest> loadTrack(String trackId) async {
    final raw = await _assetBundle.loadString('content/tracks/$trackId/track.json');
    return _jsonParsers.parseTrackManifest(raw);
  }

  @override
  Future<LessonDocument> loadLesson(String widgetId) async {
    final raw = await _assetBundle.loadString('content/widgets/$widgetId/lesson.md');
    return _lessonParser.parse(raw);
  }

  @override
  Future<AnatomyDocument> loadAnatomy(String widgetId) async {
    final raw = await _assetBundle.loadString(
      'content/widgets/$widgetId/anatomy.json',
    );
    return _jsonParsers.parseAnatomyDocument(raw);
  }

  @override
  Future<QuizDocument> loadQuiz(String widgetId) async {
    final raw = await _assetBundle.loadString('content/widgets/$widgetId/quiz.json');
    return _jsonParsers.parseQuizDocument(raw);
  }
}
