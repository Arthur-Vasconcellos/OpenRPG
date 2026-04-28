import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/screens/character_sheet/tabs/combat_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/core_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/equipment_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/features_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/notes_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/spells_tab.dart';
import 'package:openrpg/screens/characters/creation/character_builder_screen.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';
import 'package:openrpg/screens/characters/creation/widgets/builder_issue_card.dart';
import 'package:openrpg/screens/rulesets/ruleset_detail_screen.dart';

class CharacterSheetScreen extends StatefulWidget {
  final String characterId;

  const CharacterSheetScreen({super.key, required this.characterId});

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late final CharacterEditorController _controller = CharacterEditorController(
    characterId: widget.characterId,
  )..initialize();

  @override
  void dispose() {
    _tabController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _exportCharacter() async {
    try {
      final result = await _controller.exportCharacter();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to ${result.locationDescription}.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _showCreationChecklist() {
    final progress = CharacterCreationProgressResolver(_controller).resolve();
    final issues = progress.issues
        .where((issue) => issue.severity != CharacterBuilderIssueSeverity.info)
        .toList(growable: false);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.82,
            ),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    const Icon(Icons.checklist_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Creation Checklist',
                        style: Theme.of(sheetContext).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  progress.hasBlockingIssues
                      ? '${progress.errorCount} blocking issue${progress.errorCount == 1 ? '' : 's'} need attention before this character is ready.'
                      : issues.isEmpty
                      ? 'No blocking creation issues remain.'
                      : '${issues.length} warning${issues.length == 1 ? '' : 's'} remain.',
                ),
                const SizedBox(height: 16),
                if (issues.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Class, species/race, background, abilities, and ruleset references are complete.',
                      ),
                    ),
                  )
                else
                  ...issues.map(
                    (issue) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: BuilderIssueCard(
                        issue: issue,
                        onAction: () {
                          Navigator.of(sheetContext).pop();
                          _openGuidedBuilder(initialStep: issue.stepId);
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    _openGuidedBuilder();
                  },
                  icon: const Icon(Icons.route_outlined),
                  label: const Text('Open Guided Builder'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openGuidedBuilder({
    CharacterBuilderStepId initialStep = CharacterBuilderStepId.basics,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CharacterBuilderScreen(
          characterId: widget.characterId,
          initialStep: initialStep,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (_controller.loadError != null || _controller.character == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Character Sheet')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 56),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load character.\n${_controller.loadError ?? 'Unknown error'}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _controller.reload,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final character = _controller.character!;
        final primaryRulesetMissing =
            character.primaryRulesetId.trim().isNotEmpty &&
            !_controller.installedRulesets.any(
              (ruleset) => ruleset.id == character.primaryRulesetId,
            );
        final matchingRulesets = _controller.installedRulesets.where(
          (ruleset) => ruleset.id == character.primaryRulesetId,
        );
        final rulesetName = matchingRulesets.isEmpty
            ? null
            : matchingRulesets.first.name;
        final unresolvedSelections = _controller.unresolvedSelectionCount;
        final creationProgress = CharacterCreationProgressResolver(
          _controller,
        ).resolve();
        final lastSavedAt = _controller.lastSavedAt;
        final saveLabel = _controller.isSaving
            ? 'Saving...'
            : _controller.saveError != null
            ? 'Save error'
            : 'Saved';
        final subtitle = character.classes.isEmpty
            ? (character.totalLevel == 0
                  ? 'Level 0'
                  : 'Level ${character.totalLevel}')
            : '${character.totalLevel == 0 ? 'Level 0' : 'Level ${character.totalLevel}'} - ${character.classes.map((entry) => '${entry.className} ${entry.level}').join(' / ')}';
        final sections = _controller.sheetSchema.sections;
        _configureTabController(sections.length);
        final tabController = _tabController!;
        final equipmentTabIndex = sections.indexWhere(
          (section) => section.id == 'equipment',
        );
        final spellsTabIndex = sections.indexWhere(
          (section) => section.id == 'spells',
        );

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name.trim().isEmpty
                      ? 'Unnamed Character'
                      : character.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Tooltip(
                    message: _controller.saveError != null
                        ? 'Character autosave hit an error. Use Retry Save in the banner below.'
                        : _controller.isSaving
                        ? 'Character changes are being saved in the background.'
                        : 'Character changes are saved automatically.',
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _controller.saveError != null
                            ? colorScheme.errorContainer
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        saveLabel,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: _controller.saveError != null
                              ? colorScheme.onErrorContainer
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: creationProgress.hasBlockingIssues
                    ? 'Creation checklist: ${creationProgress.errorCount} blocking issue${creationProgress.errorCount == 1 ? '' : 's'}'
                    : 'Creation checklist',
                onPressed: _showCreationChecklist,
                icon: Icon(
                  Icons.checklist_outlined,
                  color: creationProgress.hasBlockingIssues
                      ? colorScheme.error
                      : null,
                ),
              ),
              IconButton(
                tooltip: 'Export character',
                onPressed: _exportCharacter,
                icon: const Icon(Icons.share_outlined),
              ),
              IconButton(
                tooltip: 'Compendium items',
                onPressed: equipmentTabIndex < 0
                    ? null
                    : () => tabController.animateTo(equipmentTabIndex),
                icon: const Icon(Icons.backpack_outlined),
              ),
            ],
            bottom: TabBar(
              controller: tabController,
              isScrollable: true,
              tabs: sections.map(_buildSectionTab).toList(growable: false),
            ),
          ),
          body: Column(
            children: [
              Material(
                color: colorScheme.surfaceContainerLow,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Chip(
                        label: InkWell(
                          onTap: rulesetName == null
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => RulesetDetailScreen(
                                        rulesetId: character.primaryRulesetId,
                                      ),
                                    ),
                                  );
                                },
                          child: Text(
                            rulesetName ??
                                (character.primaryRulesetId.trim().isEmpty
                                    ? 'No primary ruleset'
                                    : character.primaryRulesetId),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message:
                            'These class entries drive level progression, hit dice, subclass availability, and many derived features.',
                        child: Chip(
                          label: Text(
                            '${character.classes.length} class selection${character.classes.length == 1 ? '' : 's'}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message:
                            'Derived features come from the current compendium-backed build and can be previewed from the Features and Combat tabs.',
                        child: Chip(
                          label: Text(
                            '${_controller.resolvedBuild.allFeatures.length} derived features',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message: unresolvedSelections == 0
                            ? 'Every current race, background, class, subclass, and spell reference resolves cleanly.'
                            : 'Some saved selections no longer resolve against the installed rulesets. Check Core, Spells, and Features.',
                        child: Chip(
                          label: Text(
                            unresolvedSelections == 0
                                ? 'All selections resolved'
                                : '$unresolvedSelections unresolved selections',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message:
                            'Tracked spells stay saved on the character and can preview nested compendium references from the Spells tab.',
                        child: Chip(
                          label: Text(
                            '${(character.spellcasting?.preparedSpells.length ?? 0) + (character.spellcasting?.knownSpells.length ?? 0)} tracked spells',
                          ),
                        ),
                      ),
                      if (_controller.isResolving) ...[
                        const SizedBox(width: 8),
                        const Chip(label: Text('Refreshing build')),
                      ],
                      if (lastSavedAt != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            'Saved ${lastSavedAt.toLocal().hour.toString().padLeft(2, '0')}:${lastSavedAt.toLocal().minute.toString().padLeft(2, '0')}',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (character.primaryRulesetId.trim().isEmpty)
                MaterialBanner(
                  content: const Text(
                    'This character does not have a primary ruleset yet. Select one from the core tab before trusting derived build data.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => tabController.animateTo(0),
                      child: const Text('Go to Core'),
                    ),
                  ],
                ),
              if (primaryRulesetMissing)
                MaterialBanner(
                  content: const Text(
                    'This character references a ruleset that is not installed on this device. Choose a replacement from the core tab to restore compendium-backed selections.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => tabController.animateTo(0),
                      child: const Text('Choose Ruleset'),
                    ),
                  ],
                ),
              if (unresolvedSelections > 0)
                MaterialBanner(
                  content: Text(
                    unresolvedSelections == 1
                        ? 'This build has 1 unresolved compendium selection. Derived combat, features, spells, or notes may be incomplete until it is replaced.'
                        : 'This build has $unresolvedSelections unresolved compendium selections. Derived combat, features, spells, or notes may be incomplete until they are replaced.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => tabController.animateTo(0),
                      child: const Text('Review Core'),
                    ),
                    if ((character.spellcasting?.allSpells.any(
                              (spell) =>
                                  spell.reference != null &&
                                  !spell.reference!.isResolved,
                            ) ??
                            false) &&
                        spellsTabIndex >= 0)
                      TextButton(
                        onPressed: () =>
                            tabController.animateTo(spellsTabIndex),
                        child: const Text('Review Spells'),
                      ),
                  ],
                ),
              if (_controller.saveError != null)
                MaterialBanner(
                  backgroundColor: colorScheme.errorContainer,
                  content: Text(_controller.saveError!),
                  actions: [
                    TextButton(
                      onPressed: _controller.flushPendingSave,
                      child: const Text('Retry Save'),
                    ),
                  ],
                ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: sections
                      .map((section) => _buildSectionBody(section.id))
                      .toList(growable: false),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _configureTabController(int length) {
    final normalizedLength = length <= 0 ? 1 : length;
    final current = _tabController;
    if (current != null && current.length == normalizedLength) {
      return;
    }

    final initialIndex = current == null
        ? 0
        : current.index.clamp(0, normalizedLength - 1);
    current?.dispose();
    _tabController = TabController(
      length: normalizedLength,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  Tab _buildSectionTab(CharacterSheetSectionDescriptor section) {
    return Tab(
      icon: Icon(_iconForSection(section.iconKey)),
      text: section.title,
    );
  }

  Widget _buildSectionBody(String sectionId) {
    return switch (sectionId) {
      'combat' => CombatTab(controller: _controller),
      'equipment' => EquipmentTab(controller: _controller),
      'spells' => SpellsTab(controller: _controller),
      'features' => FeaturesTab(controller: _controller),
      'notes' => NotesTab(controller: _controller),
      _ => CoreTab(controller: _controller),
    };
  }

  IconData _iconForSection(String iconKey) {
    return switch (iconKey) {
      'shield' => Icons.shield_outlined,
      'backpack' => Icons.backpack_outlined,
      'magic' => Icons.auto_awesome_outlined,
      'star' => Icons.star_outline,
      'notes' => Icons.notes_outlined,
      _ => Icons.person_outline,
    };
  }
}
