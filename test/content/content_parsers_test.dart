import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anatomy_lab/content/parsers/json_parsers.dart';
import 'package:flutter_anatomy_lab/content/parsers/lesson_parser.dart';

void main() {
  group('content parsers', () {
    test('track.json parses the Core 5 manifest', () {
      final raw = File(
        'content/tracks/core_widgets_foundation/track.json',
      ).readAsStringSync();
      final manifest = const JsonParsers().parseTrackManifest(raw);

      expect(manifest.id, 'core_widgets_foundation');
      expect(manifest.orderedLessonIds.first, 'text');
      expect(manifest.orderedLessonIds.length, 5);
    });

    test('lesson.md parses required sections and source refs', () {
      final raw = File('content/widgets/text/lesson.md').readAsStringSync();
      final lesson = const LessonParser().parse(raw);

      expect(lesson.id, 'text');
      expect(lesson.sectionIds, containsAll(<String>[
        'overview',
        'api',
        'anatomy',
        'source',
        'playground',
        'runtime',
        'semantics',
        'quiz',
      ]));
      expect(lesson.sourceRefs.first.id, 'api:text');
    });

    test('anatomy.json validates edge targets', () {
      final raw = File('content/widgets/text/anatomy.json').readAsStringSync();
      final anatomy = const JsonParsers().parseAnatomyDocument(raw);

      expect(anatomy.nodeById('overflow'), isNotNull);
      expect(anatomy.edges.first.to, 'text_style');
    });

    test('quiz.json parses related section ids', () {
      final raw = File('content/widgets/text/quiz.json').readAsStringSync();
      final quiz = const JsonParsers().parseQuizDocument(raw);

      expect(quiz.questions.length, greaterThanOrEqualTo(3));
      expect(quiz.questions.first.relatedSectionIds, contains('overview'));
    });
  });
}
