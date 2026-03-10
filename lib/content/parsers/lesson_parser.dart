import 'dart:convert';

import 'package:yaml/yaml.dart';

import '../models/content_models.dart';

class LessonParser {
  const LessonParser();

  static final RegExp _frontMatterPattern = RegExp(
    r'^---\s*\n([\s\S]*?)\n---\s*\n?',
  );
  static final RegExp _headingPattern = RegExp(r'^#\s+(.+)$');

  LessonDocument parse(String raw) {
    final frontMatterMatch = _frontMatterPattern.firstMatch(raw);
    if (frontMatterMatch == null) {
      throw const FormatException('lesson.md is missing YAML frontmatter.');
    }

    final frontMatter = _deepConvertYaml(loadYaml(frontMatterMatch.group(1)!));
    if (frontMatter is! Map<String, dynamic>) {
      throw const FormatException('lesson.md frontmatter must be a map.');
    }

    final body = raw.substring(frontMatterMatch.end);
    final parsedSections = _parseSections(body);
    final sectionOrder = _requiredStringList(frontMatter['sections'], 'sections');

    for (final requiredSectionId in sectionOrder) {
      if (!parsedSections.containsKey(requiredSectionId)) {
        throw FormatException(
          'lesson.md body is missing section "$requiredSectionId".',
        );
      }
    }

    return LessonDocument(
      id: frontMatter['id'] as String,
      kind: frontMatter['kind'] as String,
      title: frontMatter['title'] as String,
      library: frontMatter['library'] as String,
      difficulty: frontMatter['difficulty'] as String,
      trackIds: _requiredStringList(frontMatter['trackIds'], 'trackIds'),
      orderInTrack: (frontMatter['orderInTrack'] as num).toInt(),
      isCoreTrackLesson: frontMatter['isCoreTrackLesson'] as bool,
      recommendedNext: _requiredStringList(
        frontMatter['recommendedNext'],
        'recommendedNext',
      ),
      conceptCoverage: _requiredStringList(
        frontMatter['conceptCoverage'],
        'conceptCoverage',
      ),
      sourceRefs: _parseSourceRefs(frontMatter['sourceRefs']),
      contentVersion: (frontMatter['contentVersion'] as num).toInt(),
      schemaVersion: (frontMatter['schemaVersion'] as num).toInt(),
      flutterVersion: frontMatter['flutterVersion'] as String,
      lastReviewedAt: frontMatter['lastReviewedAt'] as String,
      sections: [
        for (final sectionId in sectionOrder) parsedSections[sectionId]!,
      ],
    );
  }

  Map<String, LessonSection> _parseSections(String body) {
    final lines = const LineSplitter().convert(body);
    final sections = <String, LessonSection>{};
    String? currentHeading;
    final buffer = StringBuffer();

    void commitSection() {
      if (currentHeading == null) {
        return;
      }

      final title = currentHeading.trim();
      final id = _normalizeSectionId(title);
      sections[id] = LessonSection(
        id: id,
        title: title,
        body: buffer.toString().trim(),
      );
      buffer.clear();
    }

    for (final line in lines) {
      final headingMatch = _headingPattern.firstMatch(line);
      if (headingMatch != null) {
        commitSection();
        currentHeading = headingMatch.group(1)!;
        continue;
      }
      buffer.writeln(line);
    }

    commitSection();
    return sections;
  }

  String _normalizeSectionId(String heading) {
    return heading.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }

  List<SourceReference> _parseSourceRefs(Object? value) {
    final items = value as List<dynamic>? ?? const [];
    return [
      for (final item in items)
        SourceReference.fromMap((item as Map<dynamic, dynamic>).cast<String, dynamic>()),
    ];
  }

  List<String> _requiredStringList(Object? value, String fieldName) {
    final list = value as List<dynamic>? ?? const [];
    final result = list.cast<String>();
    if (result.isEmpty && fieldName == 'sections') {
      throw const FormatException('lesson.md frontmatter must define sections.');
    }
    return result;
  }

  Object? _deepConvertYaml(Object? value) {
    if (value is YamlMap) {
      return value.map(
        (dynamic key, dynamic value) =>
            MapEntry(key as String, _deepConvertYaml(value)),
      );
    }
    if (value is YamlList) {
      return value.map(_deepConvertYaml).toList();
    }
    return value;
  }
}
