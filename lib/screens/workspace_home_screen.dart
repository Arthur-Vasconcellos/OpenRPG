import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_repository.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/character_sheet/character_sheet_screen.dart';
import 'package:openrpg/screens/characters/character_creation_flow.dart';
import 'package:openrpg/screens/characters/character_library_screen.dart';
import 'package:openrpg/screens/rulesets/ruleset_detail_screen.dart';
import 'package:openrpg/screens/rulesets/ruleset_library_screen.dart';

class WorkspaceHomeScreen extends StatefulWidget {
  const WorkspaceHomeScreen({super.key});

  @override
  State<WorkspaceHomeScreen> createState() => _WorkspaceHomeScreenState();
}

class _WorkspaceHomeScreenState extends State<WorkspaceHomeScreen> {
  final CompendiumBrowseRepository _browseRepository =
      CompendiumBrowseRepository();
  final CharacterRepository _characterRepository = CharacterRepository();

  late Future<_WorkspaceSnapshot> _futureSnapshot = _loadSnapshot();

  Future<_WorkspaceSnapshot> _loadSnapshot() async {
    final rulesets = await _browseRepository.loadInstalledRulesets();
    final characters = await _characterRepository.loadCharacters();
    final recentRulesets = [...rulesets]
      ..sort((left, right) {
        final rightDate = right.updatedAt ?? right.createdAt ?? DateTime(0);
        final leftDate = left.updatedAt ?? left.createdAt ?? DateTime(0);
        return rightDate.compareTo(leftDate);
      });
    return _WorkspaceSnapshot(
      recentRulesets: recentRulesets.take(3).toList(growable: false),
      recentCharacters: characters.take(3).toList(growable: false),
    );
  }

  Future<void> _openRulesetLibrary() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => RulesetLibraryScreen()));
    if (!mounted) {
      return;
    }
    setState(() {
      _futureSnapshot = _loadSnapshot();
    });
  }

  Future<void> _openCharacterLibrary() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CharacterLibraryScreen()));
    if (!mounted) {
      return;
    }
    setState(() {
      _futureSnapshot = _loadSnapshot();
    });
  }

  Future<void> _openRuleset(String rulesetId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RulesetDetailScreen(rulesetId: rulesetId),
      ),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _futureSnapshot = _loadSnapshot();
    });
  }

  Future<void> _openCharacter(String characterId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CharacterSheetScreen(characterId: characterId),
      ),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _futureSnapshot = _loadSnapshot();
    });
  }

  Future<void> _createCharacterFromRuleset({String? rulesetId}) async {
    await createCharacterFromRulesetFlow(
      context,
      repository: _characterRepository,
      preselectedRulesetId: rulesetId,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _futureSnapshot = _loadSnapshot();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<_WorkspaceSnapshot>(
            future: _futureSnapshot,
            builder: (context, snapshot) {
              final data = snapshot.data;
              final recentRulesets =
                  data?.recentRulesets ?? const <RulesetSummary>[];
              final recentCharacters =
                  data?.recentCharacters ?? const <CharacterSummary>[];

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primaryContainer,
                          colorScheme.secondaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OpenRPG',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Build an offline workspace where rulesets and characters feed each other instead of living in separate silos.',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            FilledButton.icon(
                              onPressed: () => _createCharacterFromRuleset(),
                              icon: const Icon(Icons.auto_awesome_outlined),
                              label: const Text('Create Character'),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: _openRulesetLibrary,
                              icon: const Icon(Icons.auto_stories_outlined),
                              label: const Text('Browse Rulesets'),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: _openCharacterLibrary,
                              icon: const Icon(Icons.shield_outlined),
                              label: const Text('Open Character Library'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _WorkspaceCard(
                    title: 'Compendium',
                    subtitle:
                        'Browse bundled reference data, create homebrew rulesets, and import or export portable JSON.',
                    accent: colorScheme.primary,
                    icon: Icons.auto_stories_outlined,
                    helperText:
                        'Use rules references for classes, races, spells, items, and quick previews.',
                    tooltip: 'Rulesets provide the rules your characters use.',
                    onTap: _openRulesetLibrary,
                    secondaryAction: TextButton(
                      onPressed: recentRulesets.isEmpty
                          ? null
                          : () => _openRuleset(recentRulesets.first.id),
                      child: const Text('Continue authoring ruleset'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _WorkspaceCard(
                    title: 'Characters',
                    subtitle:
                        'Open saved characters, continue editing sheets, and import or export portable JSON.',
                    accent: colorScheme.tertiary,
                    icon: Icons.shield_outlined,
                    helperText:
                        'Character choices stay linked to their rules reference, so features, spells, and items stay easy to inspect.',
                    tooltip:
                        'Saved characters keep references to installed rulesets.',
                    onTap: _openCharacterLibrary,
                    secondaryAction: TextButton(
                      onPressed: recentCharacters.isEmpty
                          ? null
                          : () => _openCharacter(recentCharacters.first.id),
                      child: const Text('Open last character'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _RecentSection<RulesetSummary>(
                    title: 'Recent Rulesets',
                    emptyLabel:
                        'No recent rulesets yet. Import or create one to start a connected workspace.',
                    items: recentRulesets,
                    itemBuilder: (ruleset) => _RecentTile(
                      title: ruleset.name,
                      subtitle:
                          '${ruleset.mode} • ${ruleset.entityCount} entries',
                      onTap: () => _openRuleset(ruleset.id),
                      trailing: TextButton(
                        onPressed: () =>
                            _createCharacterFromRuleset(rulesetId: ruleset.id),
                        child: const Text('Use for Character'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _RecentSection<CharacterSummary>(
                    title: 'Recent Characters',
                    emptyLabel:
                        'No recent characters yet. Use Create Character to start from an installed ruleset.',
                    items: recentCharacters,
                    itemBuilder: (character) => _RecentTile(
                      title: character.name,
                      subtitle:
                          character.primaryRulesetName ??
                          character.primaryRulesetId,
                      onTap: () => _openCharacter(character.id),
                      trailing: TextButton(
                        onPressed: character.primaryRulesetId.trim().isEmpty
                            ? null
                            : () => _openRuleset(character.primaryRulesetId),
                        child: const Text('Open Ruleset'),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WorkspaceSnapshot {
  final List<RulesetSummary> recentRulesets;
  final List<CharacterSummary> recentCharacters;

  const _WorkspaceSnapshot({
    required this.recentRulesets,
    required this.recentCharacters,
  });
}

class _WorkspaceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String helperText;
  final Color accent;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? secondaryAction;
  final String? tooltip;

  const _WorkspaceCard({
    required this.title,
    required this.subtitle,
    required this.helperText,
    required this.accent,
    required this.icon,
    required this.onTap,
    this.secondaryAction,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      helperText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (secondaryAction != null) ...[
                      const SizedBox(height: 6),
                      secondaryAction!,
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
    if (tooltip == null || tooltip!.trim().isEmpty) {
      return card;
    }
    return Tooltip(message: tooltip!, child: card);
  }
}

class _RecentSection<T> extends StatelessWidget {
  final String title;
  final String emptyLabel;
  final List<T> items;
  final Widget Function(T item) itemBuilder;

  const _RecentSection({
    required this.title,
    required this.emptyLabel,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (items.isEmpty) Text(emptyLabel) else ...items.map(itemBuilder),
          ],
        ),
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _RecentTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
