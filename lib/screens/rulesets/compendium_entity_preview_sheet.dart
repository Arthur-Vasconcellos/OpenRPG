import 'package:flutter/material.dart';
import 'package:openrpg/app_navigator_scope.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_summary_sections.dart';
import 'package:openrpg/screens/rulesets/compendium_rich_content_renderer.dart';
import 'package:openrpg/screens/rulesets/compendium_structured_attributes.dart';
import 'package:openrpg/screens/rulesets/compendium_type_badge.dart';

const double _compendiumPreviewCompactBreakpoint = 720;
const double _compendiumPreviewRailWidth = 420;
const double _compendiumAnchoredPreviewWidth = 360;

NavigatorState _rootNavigatorOf(BuildContext context) {
  final scopedKey = AppNavigatorScope.maybeNavigatorKeyOf(context);
  final scopedNavigator = scopedKey?.currentState;
  if (scopedNavigator != null) {
    return scopedNavigator;
  }

  return Navigator.of(context, rootNavigator: true);
}

class CompendiumPreviewRequest {
  final String rulesetId;
  final String entityType;
  final String entityId;
  final String? entityName;
  final CompendiumBrowseRepository? browseRepository;

  const CompendiumPreviewRequest({
    required this.rulesetId,
    required this.entityType,
    required this.entityId,
    this.entityName,
    this.browseRepository,
  });

  String get key => '$rulesetId:$entityType:$entityId';
  String get label =>
      entityName?.trim().isNotEmpty == true ? entityName!.trim() : entityId;
}

class CompendiumPreviewCache {
  final Map<String, Future<CompendiumPreviewData>> _cache =
      <String, Future<CompendiumPreviewData>>{};

  Future<CompendiumPreviewData> load(
    CompendiumPreviewRequest request,
    CompendiumBrowseRepository browseRepository,
  ) {
    return _cache.putIfAbsent(request.key, () async {
      final ruleset = await browseRepository.loadRulesetSummary(
        request.rulesetId,
      );
      final detail = await browseRepository.loadEntityDetail(
        rulesetId: request.rulesetId,
        entityType: request.entityType,
        entityId: request.entityId,
      );
      return CompendiumPreviewData(ruleset: ruleset, detail: detail);
    });
  }

  void invalidate(CompendiumPreviewRequest request) {
    _cache.remove(request.key);
  }
}

class CompendiumPreviewController extends ChangeNotifier {
  final CompendiumPreviewCache cache = CompendiumPreviewCache();

  final List<CompendiumPreviewRequest> _stack = <CompendiumPreviewRequest>[];
  LayerLink? _hoverLink;
  CompendiumPreviewRequest? _hoverRequest;
  int _selectedIndex = -1;

  List<CompendiumPreviewRequest> get stack => List.unmodifiable(_stack);
  bool get hasPinnedPreview => _stack.isNotEmpty;
  int get selectedIndex =>
      _selectedIndex.clamp(0, _stack.isEmpty ? 0 : _stack.length - 1);
  CompendiumPreviewRequest? get selectedRequest =>
      _stack.isEmpty ? null : _stack[selectedIndex];
  LayerLink? get hoverLink => _hoverLink;
  CompendiumPreviewRequest? get hoveredRequest => _hoverRequest;

  void open(
    BuildContext context, {
    required CompendiumPreviewRequest request,
    bool appendToStack = false,
  }) {
    _hoverLink = null;
    _hoverRequest = null;
    _pushRequest(request, append: appendToStack);
    notifyListeners();
  }

  void previewAnchor(
    BuildContext context, {
    required CompendiumPreviewRequest request,
    required LayerLink link,
  }) {
    if (_isCompact(context) || hasPinnedPreview) {
      return;
    }

    if (_sameRequest(_hoverRequest, request) && identical(_hoverLink, link)) {
      return;
    }

    _hoverLink = link;
    _hoverRequest = request;
    notifyListeners();
  }

  void clearHovered([LayerLink? link]) {
    if (link != null && !identical(link, _hoverLink)) {
      return;
    }

    if (_hoverLink == null && _hoverRequest == null) {
      return;
    }

    _hoverLink = null;
    _hoverRequest = null;
    notifyListeners();
  }

  void pinHoveredPreview() {
    final hoveredRequest = _hoverRequest;
    if (hoveredRequest == null) {
      return;
    }

    _pushRequest(hoveredRequest, append: false);
    _hoverLink = null;
    _hoverRequest = null;
    notifyListeners();
  }

  void focusIndex(int index) {
    if (index < 0 || index >= _stack.length || index == _selectedIndex) {
      return;
    }

    _selectedIndex = index;
    notifyListeners();
  }

  void pop() {
    if (_stack.isEmpty) {
      return;
    }

    _stack.removeLast();
    if (_stack.isEmpty) {
      _selectedIndex = -1;
    } else if (_selectedIndex >= _stack.length) {
      _selectedIndex = _stack.length - 1;
    }
    notifyListeners();
  }

  void close() {
    if (_stack.isEmpty && _hoverRequest == null && _hoverLink == null) {
      return;
    }

    _stack.clear();
    _hoverRequest = null;
    _hoverLink = null;
    _selectedIndex = -1;
    notifyListeners();
  }

  bool isCurrent(CompendiumPreviewRequest request) {
    return _sameRequest(selectedRequest, request);
  }

  bool _isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < _compendiumPreviewCompactBreakpoint;

  void _pushRequest(CompendiumPreviewRequest request, {required bool append}) {
    if (_sameRequest(selectedRequest, request)) {
      return;
    }

    if (!append) {
      final existingIndex = _stack.indexWhere(
        (candidate) => candidate.key == request.key,
      );
      if (existingIndex >= 0) {
        _selectedIndex = existingIndex;
        return;
      }

      _stack
        ..clear()
        ..add(request);
      _selectedIndex = 0;
      return;
    }

    if (_stack.any((candidate) => candidate.key == request.key)) {
      _selectedIndex = _stack.indexWhere(
        (candidate) => candidate.key == request.key,
      );
      return;
    }

    _stack.add(request);
    _selectedIndex = _stack.length - 1;
  }

  bool _sameRequest(
    CompendiumPreviewRequest? left,
    CompendiumPreviewRequest? right,
  ) {
    if (left == null || right == null) {
      return false;
    }
    return left.key == right.key;
  }
}

class CompendiumPreviewControllerScope
    extends InheritedNotifier<CompendiumPreviewController> {
  const CompendiumPreviewControllerScope({
    super.key,
    required CompendiumPreviewController controller,
    required super.child,
  }) : super(notifier: controller);

  static CompendiumPreviewController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CompendiumPreviewControllerScope>()
        ?.notifier;
  }
}

class CompendiumPreviewHost extends StatelessWidget {
  final Widget child;
  final CompendiumPreviewController controller;

  const CompendiumPreviewHost({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final compact =
            MediaQuery.sizeOf(context).width <
            _compendiumPreviewCompactBreakpoint;
        final selectedRequest = controller.selectedRequest;
        final hoveredRequest = controller.hoveredRequest;

        return Stack(
          children: [
            child,
            if (!compact &&
                !controller.hasPinnedPreview &&
                hoveredRequest != null &&
                controller.hoverLink != null)
              Positioned.fill(
                child: CompositedTransformFollower(
                  link: controller.hoverLink!,
                  targetAnchor: Alignment.topRight,
                  followerAnchor: Alignment.topLeft,
                  offset: const Offset(12, 0),
                  showWhenUnlinked: false,
                  child: Material(
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _compendiumAnchoredPreviewWidth,
                          maxHeight: 560,
                        ),
                        child: _CompendiumAnchoredPreviewCard(
                          controller: controller,
                          request: hoveredRequest,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (!compact &&
                controller.hasPinnedPreview &&
                selectedRequest != null)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  minimum: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: SizedBox(
                    width: _compendiumPreviewRailWidth,
                    child: _CompendiumPinnedPreviewRail(
                      controller: controller,
                      request: selectedRequest,
                    ),
                  ),
                ),
              ),
            if (compact &&
                controller.hasPinnedPreview &&
                selectedRequest != null) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: controller.close,
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.38),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  minimum: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 0.9,
                    child: _CompendiumCompactPreviewSheet(
                      controller: controller,
                      request: selectedRequest,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class CompendiumReferenceAnchor extends StatefulWidget {
  final Widget child;
  final String rulesetId;
  final String entityType;
  final String entityId;
  final String? entityName;
  final CompendiumBrowseRepository? browseRepository;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool previewOnHover;
  final bool previewOnLongPress;

  const CompendiumReferenceAnchor({
    super.key,
    required this.child,
    required this.rulesetId,
    required this.entityType,
    required this.entityId,
    this.entityName,
    this.browseRepository,
    this.onTap,
    this.onLongPress,
    this.previewOnHover = true,
    this.previewOnLongPress = true,
  });

  @override
  State<CompendiumReferenceAnchor> createState() =>
      _CompendiumReferenceAnchorState();
}

class _CompendiumReferenceAnchorState extends State<CompendiumReferenceAnchor> {
  final LayerLink _layerLink = LayerLink();

  CompendiumPreviewRequest get _request => CompendiumPreviewRequest(
    rulesetId: widget.rulesetId,
    entityType: widget.entityType,
    entityId: widget.entityId,
    entityName: widget.entityName,
    browseRepository: widget.browseRepository,
  );

  @override
  Widget build(BuildContext context) {
    final controller = CompendiumPreviewControllerScope.maybeOf(context);
    final wide =
        MediaQuery.sizeOf(context).width >= _compendiumPreviewCompactBreakpoint;

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: controller == null || !widget.previewOnHover || !wide
            ? null
            : (_) => controller.previewAnchor(
                context,
                request: _request,
                link: _layerLink,
              ),
        onExit: controller == null || !widget.previewOnHover || !wide
            ? null
            : (_) => controller.clearHovered(_layerLink),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onLongPress:
              widget.onLongPress ??
              (!widget.previewOnLongPress
                  ? null
                  : () {
                      showCompendiumEntityPreviewSurface(
                        context,
                        rulesetId: widget.rulesetId,
                        entityType: widget.entityType,
                        entityId: widget.entityId,
                        entityName: widget.entityName,
                        browseRepository: widget.browseRepository,
                      );
                    }),
          child: widget.child,
        ),
      ),
    );
  }
}

Future<void> showCompendiumEntityPreviewSurface(
  BuildContext context, {
  required String rulesetId,
  required String entityType,
  required String entityId,
  String? entityName,
  CompendiumBrowseRepository? browseRepository,
  bool appendToPreviewStack = false,
  List<CompendiumPreviewRequest>? navigationTrail,
}) {
  final rootNavigator = _rootNavigatorOf(context);
  final request = CompendiumPreviewRequest(
    rulesetId: rulesetId,
    entityType: entityType,
    entityId: entityId,
    entityName: entityName,
    browseRepository: browseRepository,
  );
  final controller = CompendiumPreviewControllerScope.maybeOf(context);
  if (controller != null) {
    controller.open(
      context,
      request: request,
      appendToStack: appendToPreviewStack,
    );
    return Future<void>.value();
  }

  final width = MediaQuery.sizeOf(context).width;
  final compact = width < _compendiumPreviewCompactBreakpoint;

  if (compact) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => KeyedSubtree(
        key: const Key('compendium-preview-sheet'),
        child: KeyedSubtree(
          key: ValueKey(request.key),
          child: CompendiumEntityPreviewPanel(
            rulesetId: rulesetId,
            entityType: entityType,
            entityId: entityId,
            browseRepository: browseRepository,
            navigationTrail: navigationTrail,
            compact: true,
            onClosePreview: () => Navigator.of(sheetContext).pop(),
            onOpenFullEntry: (detail) async {
              Navigator.of(sheetContext).pop();
              await Future<void>.delayed(Duration.zero);
              await rootNavigator.push(
                MaterialPageRoute<void>(
                  builder: (_) => CompendiumEntityDetailScreen(
                    rulesetId: rulesetId,
                    entityType: detail.entity.entityType,
                    entityId: detail.entity.id,
                    browseRepository: browseRepository,
                    navigationTrail: [
                      ...?navigationTrail,
                      CompendiumPreviewRequest(
                        rulesetId: rulesetId,
                        entityType: detail.entity.entityType,
                        entityId: detail.entity.id,
                        entityName: detail.entity.displayName,
                        browseRepository: browseRepository,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        key: const Key('compendium-preview-dialog'),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 760,
            maxHeight: MediaQuery.sizeOf(context).height * 0.88,
          ),
          child: CompendiumEntityPreviewPanel(
            key: ValueKey(request.key),
            rulesetId: rulesetId,
            entityType: entityType,
            entityId: entityId,
            browseRepository: browseRepository,
            navigationTrail: navigationTrail,
            compact: false,
            onClosePreview: () => Navigator.of(dialogContext).pop(),
            onOpenFullEntry: (detail) async {
              Navigator.of(dialogContext).pop();
              await Future<void>.delayed(Duration.zero);
              await rootNavigator.push(
                MaterialPageRoute<void>(
                  builder: (_) => CompendiumEntityDetailScreen(
                    rulesetId: rulesetId,
                    entityType: detail.entity.entityType,
                    entityId: detail.entity.id,
                    browseRepository: browseRepository,
                    navigationTrail: [
                      ...?navigationTrail,
                      CompendiumPreviewRequest(
                        rulesetId: rulesetId,
                        entityType: detail.entity.entityType,
                        entityId: detail.entity.id,
                        entityName: detail.entity.displayName,
                        browseRepository: browseRepository,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

Future<void> showCompendiumEntityPreviewSheet(
  BuildContext context, {
  required String rulesetId,
  required String entityType,
  required String entityId,
  String? entityName,
  CompendiumBrowseRepository? browseRepository,
  List<CompendiumPreviewRequest>? navigationTrail,
}) {
  return showCompendiumEntityPreviewSurface(
    context,
    rulesetId: rulesetId,
    entityType: entityType,
    entityId: entityId,
    entityName: entityName,
    browseRepository: browseRepository,
    navigationTrail: navigationTrail,
  );
}

Future<void> openCompendiumLinkPreview(
  BuildContext context, {
  required CompendiumBrowseRepository browseRepository,
  required CompendiumLinkCandidate candidate,
  required String preferredRulesetId,
  String? currentRulesetId,
  String? currentEntityType,
  String? currentEntityId,
  List<CompendiumPreviewRequest>? navigationTrail,
}) async {
  final resolved = await browseRepository.resolveLink(
    candidate,
    preferredRulesetId: preferredRulesetId,
  );

  if (!context.mounted) {
    return;
  }

  if (resolved == null) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(content: Text('Preview unavailable for this reference.')),
    );
    return;
  }

  if (resolved.preview.rulesetId == currentRulesetId &&
      resolved.preview.entityType == currentEntityType &&
      resolved.preview.entityId == currentEntityId) {
    return;
  }

  await showCompendiumEntityPreviewSurface(
    context,
    rulesetId: resolved.preview.rulesetId,
    entityType: resolved.preview.entityType,
    entityId: resolved.preview.entityId,
    entityName: resolved.preview.name,
    browseRepository: browseRepository,
    appendToPreviewStack: true,
    navigationTrail: navigationTrail,
  );
}

class CompendiumEntityPreviewPanel extends StatefulWidget {
  final String rulesetId;
  final String entityType;
  final String entityId;
  final CompendiumBrowseRepository? browseRepository;
  final CompendiumPreviewCache? cache;
  final List<CompendiumPreviewRequest>? navigationTrail;
  final bool compact;
  final VoidCallback? onClosePreview;
  final Future<void> Function(CompendiumEntityDetail detail)? onOpenFullEntry;

  const CompendiumEntityPreviewPanel({
    super.key,
    required this.rulesetId,
    required this.entityType,
    required this.entityId,
    this.browseRepository,
    this.cache,
    this.navigationTrail,
    required this.compact,
    this.onClosePreview,
    this.onOpenFullEntry,
  });

  @override
  State<CompendiumEntityPreviewPanel> createState() =>
      _CompendiumEntityPreviewPanelState();
}

class _CompendiumEntityPreviewPanelState
    extends State<CompendiumEntityPreviewPanel> {
  late final CompendiumBrowseRepository _fallbackBrowseRepository =
      CompendiumBrowseRepository();
  late Future<CompendiumPreviewData> _futureState;

  CompendiumBrowseRepository get _browseRepository =>
      widget.browseRepository ?? _fallbackBrowseRepository;

  @override
  void initState() {
    super.initState();
    _futureState = _loadState();
  }

  @override
  void didUpdateWidget(covariant CompendiumEntityPreviewPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rulesetId != widget.rulesetId ||
        oldWidget.entityType != widget.entityType ||
        oldWidget.entityId != widget.entityId ||
        oldWidget.cache != widget.cache ||
        oldWidget.browseRepository != widget.browseRepository ||
        oldWidget.navigationTrail != widget.navigationTrail) {
      _futureState = _loadState();
    }
  }

  Future<CompendiumPreviewData> _loadState() {
    final request = CompendiumPreviewRequest(
      rulesetId: widget.rulesetId,
      entityType: widget.entityType,
      entityId: widget.entityId,
      browseRepository: widget.browseRepository,
    );
    final cache = widget.cache;
    if (cache != null) {
      return cache.load(request, _browseRepository);
    }

    return CompendiumPreviewCache().load(request, _browseRepository);
  }

  Future<void> _handleLinkTap(CompendiumLinkCandidate candidate) async {
    await openCompendiumLinkPreview(
      context,
      browseRepository: _browseRepository,
      candidate: candidate,
      preferredRulesetId: widget.rulesetId,
      currentRulesetId: widget.rulesetId,
      currentEntityType: widget.entityType,
      currentEntityId: widget.entityId,
      navigationTrail: widget.navigationTrail,
    );
  }

  Future<void> _openFullEntry(CompendiumEntityDetail detail) async {
    final customOpen = widget.onOpenFullEntry;
    if (customOpen != null) {
      await customOpen(detail);
      return;
    }

    final navigator = _rootNavigatorOf(context);
    final route = MaterialPageRoute<void>(
      builder: (_) => CompendiumEntityDetailScreen(
        rulesetId: widget.rulesetId,
        entityType: detail.entity.entityType,
        entityId: detail.entity.id,
        browseRepository: _browseRepository,
        navigationTrail: [
          ...?widget.navigationTrail,
          CompendiumPreviewRequest(
            rulesetId: widget.rulesetId,
            entityType: detail.entity.entityType,
            entityId: detail.entity.id,
            entityName: detail.entity.displayName,
            browseRepository: _browseRepository,
          ),
        ],
      ),
    );

    widget.onClosePreview?.call();
    await Future<void>.delayed(Duration.zero);
    await navigator.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompendiumPreviewData>(
      future: _futureState,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'Failed to load preview.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final state = snapshot.data!;
        final entity = state.detail.entity;
        final data = entity.data;
        final narrativeContent =
            data['entries'] ??
            data['entry'] ??
            data['items'] ??
            data['description'];
        final summaryHiddenKeys = compendiumSummaryHiddenKeysFor(
          entity.entityType,
        );
        final accent = CompendiumTypeStyle.colorFor(entity.entityType);
        final bodyPadding = widget.compact ? 20.0 : 24.0;

        return Column(
          key: const Key('compendium-preview-panel'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(bodyPadding, 16, bodyPadding, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.18),
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.compact && widget.onClosePreview != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: BackButton(onPressed: widget.onClosePreview),
                    ),
                  Text(
                    entity.displayName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      CompendiumTypeBadge(entityType: entity.entityType),
                      if (state.ruleset.name.trim().isNotEmpty)
                        Chip(label: Text(state.ruleset.name)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(bodyPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (narrativeContent != null)
                      CompendiumRichContentRenderer(
                        content: narrativeContent,
                        onLinkTap: _handleLinkTap,
                      ),
                    if (narrativeContent != null) const SizedBox(height: 12),
                    CompendiumEntitySummarySections(
                      entityType: entity.entityType,
                      data: data,
                      compact: widget.compact,
                      onLinkTap: _handleLinkTap,
                    ),
                    if (narrativeContent == null) ...[
                      Text(
                        'Narrative text is unavailable for this entry. Showing structured attributes instead.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      CompendiumStructuredAttributesView(
                        entityType: entity.entityType,
                        data: data,
                        onLinkTap: _handleLinkTap,
                        compact: widget.compact,
                        hiddenKeys: const {
                          'name',
                          'entries',
                          'entry',
                          'items',
                          'description',
                        }.union(summaryHiddenKeys),
                        emptyText: 'No structured attributes are available.',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(bodyPadding, 0, bodyPadding, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _openFullEntry(state.detail),
                  child: const Text('Open Full Entry'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CompendiumAnchoredPreviewCard extends StatelessWidget {
  final CompendiumPreviewController controller;
  final CompendiumPreviewRequest request;

  const _CompendiumAnchoredPreviewCard({
    required this.controller,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final rootNavigator = _rootNavigatorOf(context);

    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Preview',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Pin preview',
                  onPressed: controller.pinHoveredPreview,
                  icon: const Icon(Icons.push_pin_outlined),
                ),
                IconButton(
                  tooltip: 'Dismiss preview',
                  onPressed: controller.clearHovered,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: CompendiumEntityPreviewPanel(
              key: ValueKey(request.key),
              rulesetId: request.rulesetId,
              entityType: request.entityType,
              entityId: request.entityId,
              browseRepository: request.browseRepository,
              cache: controller.cache,
              compact: true,
              onOpenFullEntry: (detail) async {
                controller.clearHovered();
                await Future<void>.delayed(Duration.zero);
                await rootNavigator.push(
                  MaterialPageRoute<void>(
                    builder: (_) => CompendiumEntityDetailScreen(
                      rulesetId: request.rulesetId,
                      entityType: detail.entity.entityType,
                      entityId: detail.entity.id,
                      browseRepository: request.browseRepository,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CompendiumPinnedPreviewRail extends StatelessWidget {
  final CompendiumPreviewController controller;
  final CompendiumPreviewRequest request;

  const _CompendiumPinnedPreviewRail({
    required this.controller,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final rootNavigator = _rootNavigatorOf(context);

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Preview Stack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Close preview rail',
                  onPressed: controller.close,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          if (controller.stack.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (
                      var index = 0;
                      index < controller.stack.length;
                      index++
                    )
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(controller.stack[index].label),
                          selected: index == controller.selectedIndex,
                          onSelected: (_) => controller.focusIndex(index),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: CompendiumEntityPreviewPanel(
              key: ValueKey(request.key),
              rulesetId: request.rulesetId,
              entityType: request.entityType,
              entityId: request.entityId,
              browseRepository: request.browseRepository,
              cache: controller.cache,
              compact: false,
              onOpenFullEntry: (detail) async {
                controller.close();
                await Future<void>.delayed(Duration.zero);
                await rootNavigator.push(
                  MaterialPageRoute<void>(
                    builder: (_) => CompendiumEntityDetailScreen(
                      rulesetId: request.rulesetId,
                      entityType: detail.entity.entityType,
                      entityId: detail.entity.id,
                      browseRepository: request.browseRepository,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CompendiumCompactPreviewSheet extends StatelessWidget {
  final CompendiumPreviewController controller;
  final CompendiumPreviewRequest request;

  const _CompendiumCompactPreviewSheet({
    required this.controller,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final rootNavigator = _rootNavigatorOf(context);
    final canPop = controller.stack.length > 1;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
            child: Row(
              children: [
                if (canPop)
                  IconButton(
                    tooltip: 'Back',
                    onPressed: controller.pop,
                    icon: const Icon(Icons.arrow_back_outlined),
                  ),
                Expanded(
                  child: Text(
                    canPop ? 'Nested Preview' : 'Preview',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Close preview',
                  onPressed: controller.close,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          if (controller.stack.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (
                      var index = 0;
                      index < controller.stack.length;
                      index++
                    )
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(controller.stack[index].label),
                          selected: index == controller.selectedIndex,
                          onSelected: (_) => controller.focusIndex(index),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: CompendiumEntityPreviewPanel(
              key: ValueKey(request.key),
              rulesetId: request.rulesetId,
              entityType: request.entityType,
              entityId: request.entityId,
              browseRepository: request.browseRepository,
              cache: controller.cache,
              compact: true,
              onClosePreview: controller.close,
              onOpenFullEntry: (detail) async {
                controller.close();
                await Future<void>.delayed(Duration.zero);
                await rootNavigator.push(
                  MaterialPageRoute<void>(
                    builder: (_) => CompendiumEntityDetailScreen(
                      rulesetId: request.rulesetId,
                      entityType: detail.entity.entityType,
                      entityId: detail.entity.id,
                      browseRepository: request.browseRepository,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CompendiumPreviewData {
  final RulesetSummary ruleset;
  final CompendiumEntityDetail detail;

  const CompendiumPreviewData({required this.ruleset, required this.detail});
}
