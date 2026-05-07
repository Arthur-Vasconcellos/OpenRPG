import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_build_resolver.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/saving_throw_grid.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';

class ProficienciesStep extends StatelessWidget {
  final CharacterEditorController controller;
  final ValueChanged<CharacterBuilderStepId>? onGoToStep;

  const ProficienciesStep({
    super.key,
    required this.controller,
    this.onGoToStep,
  });

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final resolved = controller.resolvedBuild;
    final classSummary = _ClassProficiencySummary.fromBuild(
      controller,
      resolved,
    );
    final backgroundSummary = _BackgroundProficiencySummary.fromBuild(
      controller,
      resolved,
    );
    final needsAdvancedReview =
        _hasUnsupportedClassChoices(resolved) ||
        backgroundSummary.hasUnsupportedChoices;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'D&D Proficiency Checklist',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Review what your class and background grant, then use the Advanced section only for table-approved manual adjustments.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (character.classes.isEmpty) ...[
          _PrerequisiteNudgeCard(
            title: 'Choose a class first',
            message:
                'Class & Level sets D&D saving throws and starting proficiency guidance. You can still look around, but this checklist item will make more sense after a class is selected.',
            actionLabel: 'Go to Class & Level',
            onPressed: onGoToStep == null
                ? null
                : () => onGoToStep!(CharacterBuilderStepId.classLevel),
          ),
          const SizedBox(height: 16),
        ] else if (controller.sheetSchema.skills.isEmpty) ...[
          _PrerequisiteNudgeCard(
            title: 'Choose a ruleset first',
            message:
                'A D&D ruleset provides the skill list used by this checklist item.',
            actionLabel: 'Go to Basics',
            onPressed: onGoToStep == null
                ? null
                : () => onGoToStep!(CharacterBuilderStepId.basics),
          ),
          const SizedBox(height: 16),
        ],
        _ClassProficiencyCard(summary: classSummary),
        const SizedBox(height: 16),
        _BackgroundProficiencyCard(summary: backgroundSummary),
        const SizedBox(height: 16),
        _CurrentSkillProficienciesCard(controller: controller),
        if (needsAdvancedReview) ...[
          const SizedBox(height: 16),
          const _AdvancedChoicesReviewCard(),
        ],
        const SizedBox(height: 16),
        Card(
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: const Text('Advanced: Manual Skill Editor'),
            subtitle: const Text(
              'Use this for D&D table overrides while full choice resolution is still being expanded.',
            ),
            children: [
              _SkillTrainingCard(controller: controller),
              const SizedBox(height: 16),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manual Saving Throw Overrides',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Class saving throws are shown above. Toggle these only for house rules or imported characters.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      SavingThrowGrid(
                        character: character,
                        controller: controller,
                        abilities: controller.sheetSchema.abilities,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClassProficiencySummary {
  final List<String> savingThrows;
  final List<String> armor;
  final List<String> weapons;
  final List<String> tools;

  const _ClassProficiencySummary({
    required this.savingThrows,
    required this.armor,
    required this.weapons,
    required this.tools,
  });

  factory _ClassProficiencySummary.fromBuild(
    CharacterEditorController controller,
    ResolvedCharacterBuild build,
  ) {
    return _ClassProficiencySummary(
      savingThrows: build.savingThrowDefaults.proficientAbilityIds
          .map(controller.sheetSchema.abilityLabel)
          .toList(growable: false),
      armor: build.armorProficiencies,
      weapons: build.weaponProficiencies,
      tools: build.toolProficiencies,
    );
  }

  bool get isEmpty =>
      savingThrows.isEmpty && armor.isEmpty && weapons.isEmpty && tools.isEmpty;
}

class _BackgroundProficiencySummary {
  final String backgroundName;
  final List<String> skills;
  final List<String> tools;
  final List<String> languages;
  final bool hasBackground;
  final bool hasUnsupportedChoices;

  const _BackgroundProficiencySummary({
    required this.backgroundName,
    required this.skills,
    required this.tools,
    required this.languages,
    required this.hasBackground,
    required this.hasUnsupportedChoices,
  });

  factory _BackgroundProficiencySummary.fromBuild(
    CharacterEditorController controller,
    ResolvedCharacterBuild build,
  ) {
    final background = build.background;
    final data = background?.detail.entity.data;
    return _BackgroundProficiencySummary(
      backgroundName:
          background?.detail.entity.displayName ??
          controller.character?.backgroundRef?.displayName ??
          'Background',
      skills: _proficiencyEntriesFromData(
        data?['skillProficiencies'],
        kind: 'skills',
      ),
      tools: _proficiencyEntriesFromData(
        data?['toolProficiencies'],
        kind: 'tools',
      ),
      languages:
          _proficiencyEntriesFromData(
            data?['languageProficiencies'],
            kind: 'languages',
          ) +
          _proficiencyEntriesFromData(data?['languages'], kind: 'languages'),
      hasBackground: background != null,
      hasUnsupportedChoices:
          _hasChoiceData(data?['skillProficiencies']) ||
          _hasChoiceData(data?['toolProficiencies']) ||
          _hasChoiceData(data?['languageProficiencies']) ||
          _hasChoiceData(data?['languages']),
    );
  }

  bool get isEmpty => skills.isEmpty && tools.isEmpty && languages.isEmpty;
}

class _ClassProficiencyCard extends StatelessWidget {
  final _ClassProficiencySummary summary;

  const _ClassProficiencyCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return _SourceProficiencyCard(
      icon: Icons.class_outlined,
      title: 'Class Proficiencies',
      description:
          'These come from the selected D&D class and are applied to the sheet when the rules data exposes them.',
      emptyLabel: 'Choose a class to see saving throws and training here.',
      groups: [
        _ProficiencyGroup('Saving Throws', summary.savingThrows),
        _ProficiencyGroup('Armor', summary.armor),
        _ProficiencyGroup('Weapons', summary.weapons),
        _ProficiencyGroup('Tools', summary.tools),
      ],
    );
  }
}

class _BackgroundProficiencyCard extends StatelessWidget {
  final _BackgroundProficiencySummary summary;

  const _BackgroundProficiencyCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return _SourceProficiencyCard(
      icon: Icons.work_outline,
      title: 'Background Proficiencies',
      description: summary.hasBackground
          ? '${summary.backgroundName} lists these D&D background proficiencies in the compendium data.'
          : 'Choose a background to see background skills, tools, and languages.',
      emptyLabel: summary.hasBackground
          ? 'This background does not list skills, tools, or languages the builder can summarize yet.'
          : 'No background selected yet.',
      groups: [
        _ProficiencyGroup('Skills', summary.skills),
        _ProficiencyGroup('Tools', summary.tools),
        _ProficiencyGroup('Languages', summary.languages),
      ],
    );
  }
}

class _ProficiencyGroup {
  final String label;
  final List<String> values;

  const _ProficiencyGroup(this.label, this.values);
}

class _SourceProficiencyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String emptyLabel;
  final List<_ProficiencyGroup> groups;

  const _SourceProficiencyCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.emptyLabel,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    final nonEmptyGroups = groups
        .where((group) => group.values.isNotEmpty)
        .toList(growable: false);
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            if (nonEmptyGroups.isEmpty)
              Text(
                emptyLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              ...nonEmptyGroups.map(
                (group) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ProficiencyChipGroup(group: group),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProficiencyChipGroup extends StatelessWidget {
  final _ProficiencyGroup group;

  const _ProficiencyChipGroup({required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(group.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in group.values) Chip(label: Text(value)),
          ],
        ),
      ],
    );
  }
}

class _CurrentSkillProficienciesCard extends StatelessWidget {
  final CharacterEditorController controller;

  const _CurrentSkillProficienciesCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final trainedSkills = controller.sheetSchema.skills
        .where((skill) {
          return character.proficiencies.skills.proficiencyFor(skill.id) !=
              SkillTrainingLevel.none;
        })
        .toList(growable: false);
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Skill Proficiencies',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This is the skill training currently saved on the character sheet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            if (trainedSkills.isEmpty)
              Text(
                'No trained skills selected yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final skill in trainedSkills)
                    Chip(
                      label: Text(
                        '${skill.label} ${SkillTrainingLevel.shortLabel(character.proficiencies.skills.proficiencyFor(skill.id))}',
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedChoicesReviewCard extends StatelessWidget {
  const _AdvancedChoicesReviewCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: colorScheme.onTertiaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Advanced choices still need review',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Some D&D class or background entries contain choose-from proficiency options. Full choice resolution is not built here yet, so use the Advanced manual editor for table-approved picks.',
                    style: TextStyle(color: colorScheme.onTertiaryContainer),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrerequisiteNudgeCard extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onPressed;

  const _PrerequisiteNudgeCard({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.route_outlined, color: colorScheme.onSecondaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: TextStyle(color: colorScheme.onSecondaryContainer),
                  ),
                  if (onPressed != null) ...[
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: onPressed,
                      icon: const Icon(Icons.arrow_back),
                      label: Text(actionLabel),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool _hasUnsupportedClassChoices(ResolvedCharacterBuild build) {
  for (final entity in build.entityByKey.values) {
    if (entity.ref.entityType != 'class') {
      continue;
    }
    final starting = entity.detail.entity.data['startingProficiencies'];
    if (starting is Map &&
        (_hasChoiceData(starting['skills']) ||
            _hasChoiceData(starting['tools']) ||
            _hasChoiceData(starting['languages']))) {
      return true;
    }
  }
  return false;
}

List<String> _proficiencyEntriesFromData(dynamic raw, {required String kind}) {
  final results = <String>[];

  void addLabel(String value) {
    final label = _cleanProficiencyLabel(value);
    if (label.isNotEmpty && !results.contains(label)) {
      results.add(label);
    }
  }

  void parseEntry(dynamic entry) {
    if (entry == null) {
      return;
    }
    if (entry is String) {
      addLabel(entry);
      return;
    }
    if (entry is List) {
      for (final item in entry) {
        parseEntry(item);
      }
      return;
    }
    if (entry is! Map) {
      return;
    }
    final choose = entry['choose'];
    if (choose is Map) {
      final count = (choose['count'] as num?)?.toInt() ?? 1;
      final from = choose['from'];
      final choices = from is List
          ? from
                .map((value) => _cleanProficiencyLabel(value.toString()))
                .where((value) => value.isNotEmpty)
                .toList(growable: false)
          : const <String>[];
      results.add(
        choices.isEmpty
            ? 'Choose $count $kind'
            : 'Choose $count from ${choices.join(', ')}',
      );
      return;
    }
    for (final rawKey in entry.keys) {
      final key = rawKey.toString();
      final value = entry[rawKey];
      if (key == 'any' && value is num) {
        results.add('Choose ${value.toInt()} $kind');
        continue;
      }
      if (value == true || value is num || value is String || value is Map) {
        addLabel(key);
      }
    }
  }

  parseEntry(raw);
  return results;
}

bool _hasChoiceData(dynamic raw) {
  if (raw is List) {
    return raw.any(_hasChoiceData);
  }
  if (raw is Map) {
    if (raw.containsKey('choose') || raw.containsKey('any')) {
      return true;
    }
    return raw.values.any(_hasChoiceData);
  }
  return false;
}

String _cleanProficiencyLabel(String value) {
  final normalized = value
      .trim()
      .split('|')
      .first
      .replaceAll(RegExp(r'[_\\-]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
  if (normalized.isEmpty) {
    return '';
  }
  final abilityId = canonicalAbilityId(normalized);
  if (abilityId.isNotEmpty) {
    return switch (abilityId) {
      'str' => 'Strength',
      'dex' => 'Dexterity',
      'con' => 'Constitution',
      'int' => 'Intelligence',
      'wis' => 'Wisdom',
      'cha' => 'Charisma',
      _ => normalized,
    };
  }
  return _titleCase(normalized);
}

String _titleCase(String value) {
  final lowerWords = {'a', 'an', 'and', 'of', 'the'};
  final words = value.split(' ').where((word) => word.isNotEmpty).toList();
  return words
      .asMap()
      .entries
      .map((entry) {
        final word = entry.value;
        final lower = word.toLowerCase();
        if (entry.key > 0 && lowerWords.contains(lower)) {
          return lower;
        }
        return '${lower[0].toUpperCase()}${lower.substring(1)}';
      })
      .join(' ');
}

class _SkillTrainingCard extends StatelessWidget {
  final CharacterEditorController controller;

  const _SkillTrainingCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final skills = controller.sheetSchema.skills;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skill Training',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap a skill to cycle none, proficient, and expertise. Custom rules can still be adjusted by hand.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth < 620 ? 1 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 72,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: skills.length,
                  itemBuilder: (context, index) {
                    final skill = skills[index];
                    final proficiency = character.proficiencies.skills
                        .proficiencyFor(skill.id);
                    final modifier = controller.skillModifierFor(skill);
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => controller.cycleSkillTraining(skill.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: proficiency == SkillTrainingLevel.none
                                ? colorScheme.outlineVariant
                                : colorScheme.primary,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    skill.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                  Text(
                                    controller.sheetSchema.abilityAbbreviation(
                                      skill.abilityId,
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  modifier >= 0 ? '+$modifier' : '$modifier',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  SkillTrainingLevel.shortLabel(proficiency),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
