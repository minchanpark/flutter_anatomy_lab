import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../content/models/content_models.dart';
import '../../../content/repositories/content_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/layout/docs_app_shell.dart';
import '../../../shared/widgets/callout_box.dart';
import '../../../shared/widgets/source_reference_card.dart';
import '../../progress/application/track_progress_controller.dart';

class LessonPage extends ConsumerStatefulWidget {
  const LessonPage({
    super.key,
    required this.widgetId,
    this.anatomySectionId,
  });

  final String widgetId;
  final String? anatomySectionId;

  @override
  ConsumerState<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends ConsumerState<LessonPage> {
  static const String _trackId = 'core_widgets_foundation';

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    for (final sectionId in _requiredSectionIds) sectionId: GlobalKey(),
  };

  String _selectedSectionId = 'overview';
  String? _selectedAnatomyNodeId;
  bool _didApplyInitialRoute = false;
  bool _didRecordVisit = false;

  static const List<String> _requiredSectionIds = [
    'overview',
    'api',
    'anatomy',
    'source',
    'playground',
    'runtime',
    'semantics',
    'quiz',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAnatomyNodeId = widget.anatomySectionId;
    if (widget.anatomySectionId != null) {
      _selectedSectionId = 'anatomy';
    }
  }

  @override
  void didUpdateWidget(covariant LessonPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.anatomySectionId != widget.anatomySectionId) {
      _selectedAnatomyNodeId = widget.anatomySectionId;
      _selectedSectionId =
          widget.anatomySectionId == null ? 'overview' : 'anatomy';
      _didApplyInitialRoute = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bundleAsync = ref.watch(lessonBundleProvider(widget.widgetId));
    final progressAsync = ref.watch(trackProgressControllerProvider(_trackId));

    return bundleAsync.when(
      data: (bundle) => progressAsync.when(
        data: (progress) {
          _applyInitialRoute(bundle);
          _recordVisit();

          return DocsAppShell(
            scrollController: _scrollController,
            leftNav: _LessonLeftNav(
              bundle: bundle,
              selectedSectionId: _selectedSectionId,
              onSectionTap: _scrollToSection,
            ),
            contextRail: _LessonContextRail(
              bundle: bundle,
              selectedAnatomyNodeId: _selectedAnatomyNodeId,
              isCompleted: progress.isCompleted(widget.widgetId),
              onToggleCompleted: () async {
                final notifier = ref.read(
                  trackProgressControllerProvider(_trackId).notifier,
                );
                await notifier.setLessonCompleted(
                  widget.widgetId,
                  !progress.isCompleted(widget.widgetId),
                );
              },
            ),
            content: _LessonContent(
              bundle: bundle,
              sectionKeys: _sectionKeys,
              selectedAnatomyNodeId: _selectedAnatomyNodeId,
              onSelectSection: (sectionId) {
                setState(() {
                  _selectedSectionId = sectionId;
                });
              },
              onSelectAnatomyNode: (nodeId) {
                setState(() {
                  _selectedSectionId = 'anatomy';
                  _selectedAnatomyNodeId = nodeId;
                });
              },
              anatomySectionId: widget.anatomySectionId,
              isCompleted: progress.isCompleted(widget.widgetId),
              onToggleCompleted: () async {
                final notifier = ref.read(
                  trackProgressControllerProvider(_trackId).notifier,
                );
                await notifier.setLessonCompleted(
                  widget.widgetId,
                  !progress.isCompleted(widget.widgetId),
                );
              },
            ),
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stackTrace) => _LessonLoadError(error: error),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => _LessonLoadError(error: error),
    );
  }

  void _recordVisit() {
    if (_didRecordVisit) {
      return;
    }

    _didRecordVisit = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(trackProgressControllerProvider(_trackId).notifier)
          .setCurrentLesson(widget.widgetId);
    });
  }

  void _applyInitialRoute(LessonBundle bundle) {
    if (_didApplyInitialRoute) {
      return;
    }
    _didApplyInitialRoute = true;

    if (widget.anatomySectionId != null &&
        bundle.anatomy.nodeById(widget.anatomySectionId!) != null) {
      _selectedSectionId = 'anatomy';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSection('anatomy');
      });
      return;
    }

    if (widget.anatomySectionId != null) {
      _selectedSectionId = 'anatomy';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSection('anatomy');
      });
    }
  }

  void _scrollToSection(String sectionId) {
    final context = _sectionKeys[sectionId]?.currentContext;
    if (context == null) {
      return;
    }

    setState(() {
      _selectedSectionId = sectionId;
    });

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }
}

class _LessonContent extends StatelessWidget {
  const _LessonContent({
    required this.bundle,
    required this.sectionKeys,
    required this.selectedAnatomyNodeId,
    required this.onSelectSection,
    required this.onSelectAnatomyNode,
    required this.anatomySectionId,
    required this.isCompleted,
    required this.onToggleCompleted,
  });

  final LessonBundle bundle;
  final Map<String, GlobalKey> sectionKeys;
  final String? selectedAnatomyNodeId;
  final ValueChanged<String> onSelectSection;
  final ValueChanged<String> onSelectAnatomyNode;
  final String? anatomySectionId;
  final bool isCompleted;
  final VoidCallback onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bundle.lesson.title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 12),
        Text(
          'A documentation-first reader for understanding how visible text becomes style, layout, and semantics.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(label: Text('Library: ${bundle.lesson.library}')),
            Chip(label: Text('Difficulty: ${bundle.lesson.difficulty}')),
            Chip(label: Text('Reviewed ${bundle.lesson.lastReviewedAt}')),
            if (isCompleted) const Chip(label: Text('Completed')),
          ],
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: onToggleCompleted,
          child: Text(isCompleted ? 'Mark as incomplete' : 'Mark lesson complete'),
        ),
        const SizedBox(height: 28),
        for (final section in bundle.lesson.sections) ...[
          Container(
            key: sectionKeys[section.id],
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _SectionBody(
                  section: section,
                  bundle: bundle,
                  selectedAnatomyNodeId: selectedAnatomyNodeId,
                  onSelectSection: onSelectSection,
                  onSelectAnatomyNode: onSelectAnatomyNode,
                  anatomySectionId: anatomySectionId,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionBody extends StatelessWidget {
  const _SectionBody({
    required this.section,
    required this.bundle,
    required this.selectedAnatomyNodeId,
    required this.onSelectSection,
    required this.onSelectAnatomyNode,
    required this.anatomySectionId,
  });

  final LessonSection section;
  final LessonBundle bundle;
  final String? selectedAnatomyNodeId;
  final ValueChanged<String> onSelectSection;
  final ValueChanged<String> onSelectAnatomyNode;
  final String? anatomySectionId;

  @override
  Widget build(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context))
        .copyWith(
      p: Theme.of(context).textTheme.bodyLarge,
      listBullet: Theme.of(context).textTheme.bodyLarge,
      code: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: 'monospace',
      ),
      blockquoteDecoration: BoxDecoration(
        color: AppThemeTokens.of(context).surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.body.isNotEmpty)
          MarkdownBody(
            data: section.body,
            styleSheet: markdownStyleSheet,
          ),
        if (section.id == 'source') ...[
          const SizedBox(height: 16),
          for (final sourceRef in bundle.lesson.sourceRefs) ...[
            SourceReferenceCard(sourceRef: sourceRef),
            const SizedBox(height: 12),
          ],
        ],
        if (section.id == 'playground') ...[
          const SizedBox(height: 16),
          const CalloutBox(
            tone: CalloutTone.note,
            title: 'Next slice',
            message:
                'The interactive playground will land in the next milestone. This section stays visible so the learning flow and content schema are already stable.',
          ),
        ],
        if (section.id == 'quiz') ...[
          const SizedBox(height: 16),
          const CalloutBox(
            tone: CalloutTone.note,
            title: 'Quiz seed ready',
            message:
                'Interactive quiz UI is deferred, but the parser and content contract already load the checkpoint questions.',
          ),
          const SizedBox(height: 16),
          for (final question in bundle.quiz.questions)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('• ${question.prompt}'),
            ),
        ],
        if (section.id == 'anatomy') ...[
          const SizedBox(height: 16),
          _AnatomyPanel(
            anatomy: bundle.anatomy,
            lesson: bundle.lesson,
            selectedNodeId: selectedAnatomyNodeId,
            onSelectNode: onSelectAnatomyNode,
            routeNodeId: anatomySectionId,
          ),
        ],
      ],
    );
  }
}

class _AnatomyPanel extends StatelessWidget {
  const _AnatomyPanel({
    required this.anatomy,
    required this.lesson,
    required this.selectedNodeId,
    required this.onSelectNode,
    required this.routeNodeId,
  });

  final AnatomyDocument anatomy;
  final LessonDocument lesson;
  final String? selectedNodeId;
  final ValueChanged<String> onSelectNode;
  final String? routeNodeId;

  @override
  Widget build(BuildContext context) {
    final selectedNode =
        anatomy.nodeById(selectedNodeId ?? routeNodeId ?? anatomy.nodes.first.id) ??
            anatomy.nodes.first;
    final missingRouteNode =
        routeNodeId != null && anatomy.nodeById(routeNodeId!) == null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final nodeList = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            children: [
              for (final node in anatomy.nodes)
                ListTile(
                  title: Text(node.title),
                  subtitle: Text(node.kind),
                  selected: node.id == selectedNode.id,
                  onTap: () => onSelectNode(node.id),
                ),
            ],
          ),
        );

        final details = Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (missingRouteNode) ...[
                const CalloutBox(
                  tone: CalloutTone.caution,
                  title: 'Unknown anatomy node',
                  message:
                      'The requested anatomy deep link does not exist in the current lesson seed, so the page fell back to the default node.',
                ),
                const SizedBox(height: 12),
              ],
              Text(
                selectedNode.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                selectedNode.summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Related sections',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final relatedSectionId in selectedNode.relatedSectionIds)
                    ActionChip(
                      label: Text(relatedSectionId),
                      onPressed: () => onSelectNode(selectedNode.id),
                    ),
                ],
              ),
              if (selectedNode.sourceRefIds.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Source anchors',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final sourceRefId in selectedNode.sourceRefIds)
                  if (lesson.sourceRefById(sourceRefId) case final sourceRef?)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SourceReferenceCard(sourceRef: sourceRef),
                    ),
              ],
            ],
          ),
        );

        if (constraints.maxWidth >= 640) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: nodeList),
              const SizedBox(width: 16),
              Expanded(flex: 6, child: details),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            nodeList,
            const SizedBox(height: 16),
            details,
          ],
        );
      },
    );
  }
}

class _LessonLeftNav extends StatelessWidget {
  const _LessonLeftNav({
    required this.bundle,
    required this.selectedSectionId,
    required this.onSectionTap,
  });

  final LessonBundle bundle;
  final String selectedSectionId;
  final ValueChanged<String> onSectionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bundle.lesson.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Sections',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        for (final section in bundle.lesson.sections)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(section.title),
              selected: selectedSectionId == section.id,
              onTap: () => onSectionTap(section.id),
            ),
          ),
      ],
    );
  }
}

class _LessonContextRail extends StatelessWidget {
  const _LessonContextRail({
    required this.bundle,
    required this.selectedAnatomyNodeId,
    required this.isCompleted,
    required this.onToggleCompleted,
  });

  final LessonBundle bundle;
  final String? selectedAnatomyNodeId;
  final bool isCompleted;
  final VoidCallback onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    final selectedNode = selectedAnatomyNodeId == null
        ? null
        : bundle.anatomy.nodeById(selectedAnatomyNodeId!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reader status',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(isCompleted ? 'Lesson completed' : 'Lesson in progress'),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onToggleCompleted,
          child: Text(isCompleted ? 'Undo completion' : 'Mark complete'),
        ),
        const SizedBox(height: 24),
        Text(
          'Source refs',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        for (final sourceRef in bundle.lesson.sourceRefs)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SourceReferenceCard(sourceRef: sourceRef),
          ),
        if (selectedNode != null) ...[
          const SizedBox(height: 12),
          Text(
            'Active anatomy node',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(selectedNode.title),
          const SizedBox(height: 4),
          Text(
            selectedNode.summary,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _LessonLoadError extends StatelessWidget {
  const _LessonLoadError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return DocsAppShell(
      content: CalloutBox(
        tone: CalloutTone.caution,
        title: 'Lesson failed to load',
        message: error.toString(),
      ),
    );
  }
}
