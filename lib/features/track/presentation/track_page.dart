import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../content/models/content_models.dart';
import '../../../content/repositories/content_providers.dart';
import '../../../shared/layout/docs_app_shell.dart';
import '../../../shared/widgets/callout_box.dart';
import '../../progress/application/track_progress_controller.dart';

class TrackPage extends ConsumerWidget {
  const TrackPage({
    super.key,
    required this.trackId,
  });

  final String trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackAsync = ref.watch(trackManifestProvider(trackId));
    final progressAsync = ref.watch(trackProgressControllerProvider(trackId));

    return trackAsync.when(
      data: (track) => progressAsync.when(
        data: (progress) => DocsAppShell(
          leftNav: _TrackLeftNav(track: track, progress: progress),
          contextRail: _TrackContextRail(track: track, progress: progress),
          content: _TrackContent(track: track, progress: progress),
        ),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stackTrace) => _TrackLoadError(error: error),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => _TrackLoadError(error: error),
    );
  }
}

class _TrackContent extends StatelessWidget {
  const _TrackContent({
    required this.track,
    required this.progress,
  });

  final TrackManifest track;
  final TrackProgressDocument progress;

  @override
  Widget build(BuildContext context) {
    final continueLessonId = progress.currentLessonId ?? track.recommendedEntryLessonId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          track.title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 12),
        Text(
          'Understand Flutter as text, box, flex, gesture, and viewport.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(label: Text('${track.estimatedMinutes} min')),
            Chip(label: Text('Reviewed ${track.lastReviewedAt}')),
            Chip(label: Text('${track.orderedLessonIds.length} lessons')),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            FilledButton(
              onPressed: () => context.go('/widgets/$continueLessonId'),
              child: Text(
                progress.completedLessonIds.isEmpty ? 'Start track' : 'Continue',
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () => context.go('/widgets/text'),
              child: const Text('Open text lesson'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        CalloutBox(
          tone: CalloutTone.note,
          title: 'Phase 1 milestone',
          message:
              'This first slice opens the docs shell, track landing, text lesson reader, and local progress. The other four lessons stay visible as scheduled next steps.',
        ),
        const SizedBox(height: 32),
        Text(
          'Learning outcomes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        for (final outcome in track.learningOutcomes)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('• $outcome'),
          ),
        const SizedBox(height: 32),
        Text(
          'Lessons',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        for (final lessonId in track.orderedLessonIds)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TrackLessonCard(
              lessonId: lessonId,
              isAvailable: lessonId == 'text',
              isCompleted: progress.isCompleted(lessonId),
            ),
          ),
      ],
    );
  }
}

class _TrackLessonCard extends StatelessWidget {
  const _TrackLessonCard({
    required this.lessonId,
    required this.isAvailable,
    required this.isCompleted,
  });

  final String lessonId;
  final bool isAvailable;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _labelForLesson(lessonId),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  isAvailable
                      ? 'Basic reader route is live.'
                      : 'Scheduled for the next wave.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (isCompleted) const Chip(label: Text('Done')),
          const SizedBox(width: 12),
          if (isAvailable)
            FilledButton(
              onPressed: () => context.go('/widgets/$lessonId'),
              child: const Text('Open'),
            )
          else
            const Chip(label: Text('Coming next')),
        ],
      ),
    );
  }

  String _labelForLesson(String lessonId) {
    return switch (lessonId) {
      'gesture_detector' => 'GestureDetector',
      'list_view' => 'ListView',
      _ => lessonId[0].toUpperCase() + lessonId.substring(1),
    };
  }
}

class _TrackLeftNav extends StatelessWidget {
  const _TrackLeftNav({
    required this.track,
    required this.progress,
  });

  final TrackManifest track;
  final TrackProgressDocument progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Track',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text(
          track.title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Text(
          'Progress',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text('${progress.completionPercent.toStringAsFixed(0)}% complete'),
        const SizedBox(height: 24),
        Text(
          'Ordered lessons',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        for (final lessonId in track.orderedLessonIds)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${track.orderedLessonIds.indexOf(lessonId) + 1}. ${lessonId == 'gesture_detector' ? 'GestureDetector' : lessonId == 'list_view' ? 'ListView' : lessonId[0].toUpperCase() + lessonId.substring(1)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _TrackContextRail extends StatelessWidget {
  const _TrackContextRail({
    required this.track,
    required this.progress,
  });

  final TrackManifest track;
  final TrackProgressDocument progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue from',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(progress.currentLessonId ?? track.recommendedEntryLessonId),
        const SizedBox(height: 24),
        Text(
          'Why this track exists',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Phase 1 builds a reliable mental model before higher-level Material and app-shell lessons.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _TrackLoadError extends StatelessWidget {
  const _TrackLoadError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return DocsAppShell(
      content: CalloutBox(
        tone: CalloutTone.caution,
        title: 'Track failed to load',
        message: error.toString(),
      ),
    );
  }
}
