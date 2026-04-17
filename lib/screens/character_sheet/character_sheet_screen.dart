import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/character_sheet/tabs/combat_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/core_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/equipment_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/features_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/notes_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/spells_tab.dart';
import 'package:openrpg/screens/magic_item_list_screen.dart';

class CharacterSheetScreen extends StatefulWidget {
  final String characterId;

  const CharacterSheetScreen({super.key, required this.characterId});

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 6,
    vsync: this,
  );
  late final CharacterEditorController _controller = CharacterEditorController(
    characterId: widget.characterId,
  )..initialize();

  @override
  void dispose() {
    _tabController.dispose();
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
        final saveLabel = _controller.isSaving
            ? 'Saving...'
            : _controller.saveError != null
            ? 'Save error'
            : 'Saved';

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
                Text(
                  '${character.totalLevel == 0 ? 'Level 0' : 'Level ${character.totalLevel}'}'
                  '${character.classes.isEmpty ? '' : ' • ${character.classes.map((entry) => '${entry.className} ${entry.level}').join(' / ')}'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
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
              IconButton(
                tooltip: 'Export character',
                onPressed: _exportCharacter,
                icon: const Icon(Icons.share_outlined),
              ),
              IconButton(
                tooltip: 'Magic items',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const MagicItemListScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome_outlined),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(icon: Icon(Icons.person_outline), text: 'Core'),
                Tab(icon: Icon(Icons.shield_outlined), text: 'Combat'),
                Tab(icon: Icon(Icons.backpack_outlined), text: 'Equipment'),
                Tab(icon: Icon(Icons.auto_awesome_outlined), text: 'Spells'),
                Tab(icon: Icon(Icons.star_outline), text: 'Features'),
                Tab(icon: Icon(Icons.notes_outlined), text: 'Notes'),
              ],
            ),
          ),
          body: Column(
            children: [
              if (character.primaryRulesetId.trim().isEmpty)
                MaterialBanner(
                  content: const Text(
                    'This character does not have a primary ruleset yet. Select one from the core tab before trusting derived build data.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => _tabController.animateTo(0),
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
                      onPressed: () => _tabController.animateTo(0),
                      child: const Text('Choose Ruleset'),
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
                  controller: _tabController,
                  children: [
                    CoreTab(controller: _controller),
                    CombatTab(
                      character: character,
                      resolvedBuild: _controller.resolvedBuild,
                      onCharacterUpdated: (updated) {
                        _controller.updateManual((_) => updated);
                      },
                    ),
                    EquipmentTab(
                      character: character,
                      onCharacterUpdated: (updated) {
                        _controller.updateManual((_) => updated);
                      },
                    ),
                    SpellsTab(controller: _controller),
                    FeaturesTab(controller: _controller),
                    NotesTab(
                      character: character,
                      onCharacterUpdated: (updated) {
                        _controller.updateManual((_) => updated);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
