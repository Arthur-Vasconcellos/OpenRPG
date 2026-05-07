import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/characters/creation/ability_score_generation.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_mode.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';
import 'package:openrpg/screens/characters/creation/widgets/builder_issue_card.dart';

class ReviewFinishStep extends StatelessWidget {
  final CharacterEditorController controller;
  final CharacterCreationProgress progress;
  final ValueChanged<CharacterBuilderStepId> onGoToStep;
  final VoidCallback onOpenSheet;

  const ReviewFinishStep({
    super.key,
    required this.controller,
    required this.progress,
    required this.onGoToStep,
    required this.onOpenSheet,
  });

  @override
  Widget build(BuildContext context) {
    final blockers = _issues(CharacterBuilderIssueSeverity.error);
    final warnings = _issues(CharacterBuilderIssueSeverity.warning);
    final notes = _issues(CharacterBuilderIssueSeverity.info);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ReviewHeaderCard(progress: progress, warningCount: warnings.length),
        const SizedBox(height: 16),
        _IssueSection(
          title: 'Blockers',
          emptyLabel: 'No blockers. Finish is available when you are ready.',
          issues: blockers,
          onGoToStep: onGoToStep,
        ),
        const SizedBox(height: 16),
        _IssueSection(
          title: 'Warnings',
          emptyLabel: 'No warnings.',
          issues: warnings,
          onGoToStep: onGoToStep,
        ),
        const SizedBox(height: 16),
        _IssueSection(
          title: 'Notes',
          emptyLabel: 'No notes.',
          issues: notes,
          onGoToStep: onGoToStep,
        ),
        const SizedBox(height: 16),
        _BuildSummaryCard(controller: controller),
        const SizedBox(height: 16),
        _FinishActionsCard(
          progress: progress,
          onFinish: () => _finish(context),
          onGoToStep: onGoToStep,
          onExport: () => _export(context),
        ),
      ],
    );
  }

  List<CharacterBuilderIssue> _issues(CharacterBuilderIssueSeverity severity) {
    return progress.issues
        .where((issue) => issue.severity == severity)
        .toList(growable: false);
  }

  Future<void> _finish(BuildContext context) async {
    if (progress.hasBlockingIssues) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Finish is blocked until checklist errors are resolved.',
          ),
        ),
      );
      return;
    }
    if (!await _flushOrShowSaveError(context)) {
      return;
    }
    await controller.markCreationComplete(
      mode: CharacterCreationMode.guided.storageValue,
    );
    if (!context.mounted) {
      return;
    }
    if (!await _flushOrShowSaveError(context)) {
      return;
    }
    onOpenSheet();
  }

  Future<bool> _flushOrShowSaveError(BuildContext context) async {
    await controller.flushPendingSave();
    final saveError = controller.saveError;
    if (saveError == null) {
      return true;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $saveError')));
    }
    return false;
  }

  Future<void> _export(BuildContext context) async {
    try {
      final result = await controller.exportCharacter();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to ${result.locationDescription}.')),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

class _ReviewHeaderCard extends StatelessWidget {
  final CharacterCreationProgress progress;
  final int warningCount;

  const _ReviewHeaderCard({required this.progress, required this.warningCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review & Finish',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              progress.hasBlockingIssues
                  ? '${progress.errorCount} blocker${progress.errorCount == 1 ? '' : 's'} need attention before finishing. You can still jump to any checklist step.'
                  : warningCount == 0
                  ? 'Checklist ready. Review the build summary, then finish to open the character sheet.'
                  : '$warningCount warning${warningCount == 1 ? '' : 's'} remain. Warnings do not block finishing.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress.completionRatio),
            const SizedBox(height: 8),
            Text(
              '${progress.completedVisibleSteps} of ${progress.totalVisibleSteps} visible steps complete',
            ),
          ],
        ),
      ),
    );
  }
}

class _IssueSection extends StatelessWidget {
  final String title;
  final String emptyLabel;
  final List<CharacterBuilderIssue> issues;
  final ValueChanged<CharacterBuilderStepId> onGoToStep;

  const _IssueSection({
    required this.title,
    required this.emptyLabel,
    required this.issues,
    required this.onGoToStep,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text('${issues.length}'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (issues.isEmpty)
              Text(emptyLabel)
            else
              ...issues.map(
                (issue) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BuilderIssueCard(
                    issue: issue,
                    onAction: () => onGoToStep(issue.stepId),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BuildSummaryCard extends StatelessWidget {
  final CharacterEditorController controller;

  const _BuildSummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final rulesetName = _rulesetName(controller, character);
    final abilities = controller.sheetSchema.abilities.isEmpty
        ? _fallbackAbilities
        : controller.sheetSchema.abilities;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Build Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'A compact readout of the D&D character this checklist will open on the sheet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _SummaryGroup(
              title: 'Identity',
              rows: [
                _SummaryRow(
                  'Name',
                  character.name.trim().isEmpty
                      ? 'Unnamed Character'
                      : character.name,
                ),
                _SummaryRow('Ruleset / Content Pack', rulesetName),
                _SummaryRow('Class / Level', _classSummary(character)),
                _SummaryRow(
                  'Species / Race',
                  character.raceRef?.displayName ?? 'Not selected',
                ),
                _SummaryRow(
                  'Background',
                  character.backgroundRef?.displayName ?? 'Not selected',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _AbilitySummaryGrid(abilities: abilities, character: character),
            const SizedBox(height: 16),
            _SummaryGroup(
              title: 'Key Proficiencies',
              rows: _proficiencyRows(character, controller),
            ),
            if (_hasSpellSummary(character, controller)) ...[
              const SizedBox(height: 16),
              _SummaryGroup(
                title: 'Spells',
                rows: [
                  _SummaryRow(
                    'Spell Counts',
                    _spellSummary(character, controller),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            _SummaryGroup(
              title: 'Equipment / Loadout',
              rows: _equipmentRows(character),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);
}

class _SummaryGroup extends StatelessWidget {
  final String title;
  final List<_SummaryRow> rows;

  const _SummaryGroup({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      row.label,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Expanded(child: Text(row.value)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AbilitySummaryGrid extends StatelessWidget {
  final List<CharacterAbilityDescriptor> abilities;
  final Character character;

  const _AbilitySummaryGrid({required this.abilities, required this.character});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ability Scores', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth < 520
                ? 2
                : constraints.maxWidth < 820
                ? 3
                : 6;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisExtent: 76,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: abilities.length,
              itemBuilder: (context, index) {
                final ability = abilities[index];
                final score = character.abilityScores.scoreFor(ability.id);
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ability.abbreviation,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$score (${_formatModifier(abilityModifierForScore(score))})',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _FinishActionsCard extends StatelessWidget {
  final CharacterCreationProgress progress;
  final VoidCallback onFinish;
  final ValueChanged<CharacterBuilderStepId> onGoToStep;
  final VoidCallback onExport;

  const _FinishActionsCard({
    required this.progress,
    required this.onFinish,
    required this.onGoToStep,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final nextBlocker = progress.nextBlockingIssue;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (progress.hasBlockingIssues) ...[
              Text(
                'Finish is blocked until checklist errors are resolved.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: progress.hasBlockingIssues ? null : onFinish,
                  icon: Icon(
                    progress.hasBlockingIssues
                        ? Icons.error_outline
                        : Icons.check_circle_outline,
                  ),
                  label: Text(
                    progress.hasBlockingIssues
                        ? 'Finish Blocked'
                        : 'Finish Guided Builder',
                  ),
                ),
                if (nextBlocker != null)
                  OutlinedButton.icon(
                    onPressed: () => onGoToStep(nextBlocker.stepId),
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(nextBlocker.actionLabel),
                  ),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Character is saved in the builder.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Stay in Builder'),
                ),
                OutlinedButton.icon(
                  onPressed: onExport,
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Export Character'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const _fallbackAbilities = <CharacterAbilityDescriptor>[
  CharacterAbilityDescriptor(id: 'str', label: 'Strength', abbreviation: 'STR'),
  CharacterAbilityDescriptor(
    id: 'dex',
    label: 'Dexterity',
    abbreviation: 'DEX',
  ),
  CharacterAbilityDescriptor(
    id: 'con',
    label: 'Constitution',
    abbreviation: 'CON',
  ),
  CharacterAbilityDescriptor(
    id: 'int',
    label: 'Intelligence',
    abbreviation: 'INT',
  ),
  CharacterAbilityDescriptor(id: 'wis', label: 'Wisdom', abbreviation: 'WIS'),
  CharacterAbilityDescriptor(id: 'cha', label: 'Charisma', abbreviation: 'CHA'),
];

String _rulesetName(CharacterEditorController controller, Character character) {
  for (final ruleset in controller.installedRulesets) {
    if (ruleset.id == character.primaryRulesetId) {
      return ruleset.name;
    }
  }
  return character.primaryRulesetId.trim().isEmpty
      ? 'Not selected'
      : character.primaryRulesetId;
}

String _classSummary(Character character) {
  if (character.classes.isEmpty) {
    return 'Not selected';
  }
  return character.classes
      .map((entry) {
        final subclass = entry.subclassName;
        return subclass == null || subclass.trim().isEmpty
            ? '${entry.className} ${entry.level}'
            : '${entry.className} ${entry.level} ($subclass)';
      })
      .join(' / ');
}

List<_SummaryRow> _proficiencyRows(
  Character character,
  CharacterEditorController controller,
) {
  final savingThrows =
      character.proficiencies.savingThrows.proficientAbilityIds
          .map(controller.sheetSchema.abilityLabel)
          .toList(growable: false)
        ..sort();
  final skills =
      character.proficiencies.skills.proficiencies.entries
          .where(
            (entry) =>
                SkillTrainingLevel.normalize(entry.value) !=
                SkillTrainingLevel.none,
          )
          .map((entry) {
            final label =
                controller.sheetSchema.skillFor(entry.key)?.label ??
                _labelFromId(entry.key);
            final level = SkillTrainingLevel.normalize(entry.value);
            return level == SkillTrainingLevel.expertise
                ? '$label (Expertise)'
                : label;
          })
          .toList(growable: false)
        ..sort();

  return [
    _SummaryRow(
      'Proficiency Bonus',
      '+${character.proficiencies.proficiencyBonus}',
    ),
    _SummaryRow('Saving Throws', _joinOrNone(savingThrows)),
    _SummaryRow('Skills', _joinOrNone(skills)),
    _SummaryRow('Armor', _joinOrNone(character.proficiencies.armor)),
    _SummaryRow('Weapons', _joinOrNone(character.proficiencies.weapons)),
    _SummaryRow('Tools', _joinOrNone(character.proficiencies.tools)),
  ];
}

bool _hasSpellSummary(
  Character character,
  CharacterEditorController controller,
) {
  final spellcasting = character.spellcasting;
  return controller.resolvedBuild.hasSpellcasting ||
      (spellcasting?.allSpells.isNotEmpty ?? false);
}

String _spellSummary(
  Character character,
  CharacterEditorController controller,
) {
  final spellcasting = character.spellcasting;
  final cantripCount =
      spellcasting?.allSpells.where((spell) => spell.level == 0).length ?? 0;
  final knownCount =
      spellcasting?.knownSpells.where((spell) => spell.level > 0).length ?? 0;
  final preparedCount =
      spellcasting?.preparedSpells.where((spell) => spell.level > 0).length ??
      0;
  return [
    'Cantrips ${_countWithCapacity(cantripCount, controller.resolvedBuild.cantripCapacity)}',
    'Known ${_countWithCapacity(knownCount, controller.resolvedBuild.knownSpellCapacity)}',
    'Prepared ${_countWithCapacity(preparedCount, controller.resolvedBuild.preparedSpellCapacity)}',
  ].join(' | ');
}

List<_SummaryRow> _equipmentRows(Character character) {
  final equipment = character.equipment;
  final loadout = equipment.loadout;
  return [
    _SummaryRow(
      'Inventory',
      '${equipment.entries.length} item${equipment.entries.length == 1 ? '' : 's'}',
    ),
    _SummaryRow(
      'Armor',
      _entryById(equipment.entries, loadout.armorEntryId)?.displayName ??
          'Not assigned',
    ),
    _SummaryRow(
      'Melee Weapon',
      _entryById(equipment.entries, loadout.meleeEntryId)?.displayName ??
          'Not assigned',
    ),
    _SummaryRow(
      'Ranged Weapon',
      _entryById(equipment.entries, loadout.rangedEntryId)?.displayName ??
          'Not assigned',
    ),
  ];
}

CharacterInventoryEntry? _entryById(
  List<CharacterInventoryEntry> entries,
  String? id,
) {
  if (id == null) {
    return null;
  }
  for (final entry in entries) {
    if (entry.id == id) {
      return entry;
    }
  }
  return null;
}

String _countWithCapacity(int count, int? capacity) {
  return capacity == null ? '$count' : '$count/$capacity';
}

String _joinOrNone(Iterable<String> values) {
  final normalized = values
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList(growable: false);
  return normalized.isEmpty ? 'None' : normalized.join(', ');
}

String _labelFromId(String value) {
  final raw = value.contains(':') ? value.split(':').last : value;
  return raw
      .replaceAll('-', ' ')
      .replaceAll('_', ' ')
      .split(RegExp(r'\s+'))
      .where((part) => part.trim().isNotEmpty)
      .map((part) {
        if (part.length == 1) {
          return part.toUpperCase();
        }
        return '${part.substring(0, 1).toUpperCase()}${part.substring(1).toLowerCase()}';
      })
      .join(' ');
}

String _formatModifier(int modifier) {
  return modifier >= 0 ? '+$modifier' : '$modifier';
}
