import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/character_compendium_picker.dart';
import 'package:openrpg/screens/character_sheet/widget/character_entity_summary_card.dart';
import 'package:openrpg/screens/character_sheet/widget/feature_item.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';

class NotesTab extends StatefulWidget {
  final CharacterEditorController controller;

  const NotesTab({super.key, required this.controller});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  late final TextEditingController _personalityTraitsController;
  late final TextEditingController _idealsController;
  late final TextEditingController _bondsController;
  late final TextEditingController _flawsController;
  late final TextEditingController _alliesController;
  late final TextEditingController _backstoryController;
  late final TextEditingController _appearanceController;
  late final TextEditingController _inventoryNotesController;
  late final TextEditingController _languagesNotesController;
  late final TextEditingController _otherNotesController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _eyesController;
  late final TextEditingController _skinController;
  late final TextEditingController _hairController;
  late final TextEditingController _deityController;
  CharacterEntityRef? _selectedDeityRef;

  bool _syncing = false;

  Character get _character => widget.controller.character!;

  @override
  void initState() {
    super.initState();
    _personalityTraitsController = TextEditingController();
    _idealsController = TextEditingController();
    _bondsController = TextEditingController();
    _flawsController = TextEditingController();
    _alliesController = TextEditingController();
    _backstoryController = TextEditingController();
    _appearanceController = TextEditingController();
    _inventoryNotesController = TextEditingController();
    _languagesNotesController = TextEditingController();
    _otherNotesController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _eyesController = TextEditingController();
    _skinController = TextEditingController();
    _hairController = TextEditingController();
    _deityController = TextEditingController();

    _syncFromCharacter(_character);
    _bindListeners();
  }

  @override
  void didUpdateWidget(covariant NotesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller.character != widget.controller.character &&
        widget.controller.character != null) {
      _syncFromCharacter(widget.controller.character!);
    }
  }

  @override
  void dispose() {
    _personalityTraitsController.dispose();
    _idealsController.dispose();
    _bondsController.dispose();
    _flawsController.dispose();
    _alliesController.dispose();
    _backstoryController.dispose();
    _appearanceController.dispose();
    _inventoryNotesController.dispose();
    _languagesNotesController.dispose();
    _otherNotesController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _eyesController.dispose();
    _skinController.dispose();
    _hairController.dispose();
    _deityController.dispose();
    super.dispose();
  }

  void _bindListeners() {
    _personalityTraitsController.addListener(_persistTraits);
    _idealsController.addListener(_persistTraits);
    _bondsController.addListener(_persistTraits);
    _flawsController.addListener(_persistTraits);
    _alliesController.addListener(_persistTraits);

    _backstoryController.addListener(_persistNotes);
    _appearanceController.addListener(_persistNotes);
    _inventoryNotesController.addListener(_persistNotes);
    _languagesNotesController.addListener(_persistNotes);
    _otherNotesController.addListener(_persistNotes);

    _ageController.addListener(_persistPhysicalDescription);
    _heightController.addListener(_persistPhysicalDescription);
    _weightController.addListener(_persistPhysicalDescription);
    _eyesController.addListener(_persistPhysicalDescription);
    _skinController.addListener(_persistPhysicalDescription);
    _hairController.addListener(_persistPhysicalDescription);
    _deityController.addListener(_handleDeityChanged);
  }

  void _syncFromCharacter(Character character) {
    _syncing = true;
    _setControllerValue(
      _personalityTraitsController,
      character.traits.personalityTraits,
    );
    _setControllerValue(_idealsController, character.traits.ideals);
    _setControllerValue(_bondsController, character.traits.bonds);
    _setControllerValue(_flawsController, character.traits.flaws);
    _setControllerValue(
      _alliesController,
      character.traits.alliesAndOrganizations.join('\n'),
    );

    _setControllerValue(_backstoryController, character.notes.backstory);
    _setControllerValue(_appearanceController, character.notes.appearance);
    _setControllerValue(
      _inventoryNotesController,
      character.notes.inventoryNotes,
    );
    _setControllerValue(
      _languagesNotesController,
      character.notes.languagesNotes,
    );
    _setControllerValue(_otherNotesController, character.notes.otherNotes);

    _setControllerValue(
      _ageController,
      character.physicalDescription.age == 0
          ? ''
          : character.physicalDescription.age.toString(),
    );
    _setControllerValue(
      _heightController,
      character.physicalDescription.height,
    );
    _setControllerValue(
      _weightController,
      character.physicalDescription.weight,
    );
    _setControllerValue(_eyesController, character.physicalDescription.eyes);
    _setControllerValue(_skinController, character.physicalDescription.skin);
    _setControllerValue(_hairController, character.physicalDescription.hair);
    _setControllerValue(_deityController, character.physicalDescription.deity);
    _selectedDeityRef = character.physicalDescription.deityRef;
    _syncing = false;
  }

  void _setControllerValue(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void _persistTraits() {
    if (_syncing) {
      return;
    }
    final allies = _alliesController.text
        .split('\n')
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .toList(growable: false);
    widget.controller.updateManual(
      (character) => character.copyWith(
        traits: Traits(
          personalityTraits: _personalityTraitsController.text,
          ideals: _idealsController.text,
          bonds: _bondsController.text,
          flaws: _flawsController.text,
          alliesAndOrganizations: allies,
        ),
      ),
    );
  }

  void _persistNotes() {
    if (_syncing) {
      return;
    }
    widget.controller.updateManual(
      (character) => character.copyWith(
        notes: Notes(
          backstory: _backstoryController.text,
          appearance: _appearanceController.text,
          inventoryNotes: _inventoryNotesController.text,
          languagesNotes: _languagesNotesController.text,
          otherNotes: _otherNotesController.text,
        ),
      ),
    );
  }

  void _persistPhysicalDescription() {
    if (_syncing) {
      return;
    }
    final deityName = _deityController.text.trim();
    final deityRef =
        _selectedDeityRef != null && _selectedDeityRef!.displayName == deityName
        ? _selectedDeityRef
        : null;
    widget.controller.updateManual(
      (character) => character.copyWith(
        physicalDescription: PhysicalDescription(
          age: int.tryParse(_ageController.text) ?? 0,
          height: _heightController.text,
          weight: _weightController.text,
          eyes: _eyesController.text,
          skin: _skinController.text,
          hair: _hairController.text,
          deity: deityName,
          deityRef: deityRef,
        ),
      ),
    );
  }

  void _handleDeityChanged() {
    if (_syncing) {
      return;
    }
    final deityName = _deityController.text.trim();
    if (_selectedDeityRef != null &&
        _selectedDeityRef!.displayName != deityName) {
      setState(() {
        _selectedDeityRef = null;
      });
    }
    _persistPhysicalDescription();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCompendiumAnchorsCard(context, colorScheme),
            const SizedBox(height: 20),
            _buildPersonalityCard(colorScheme),
            const SizedBox(height: 20),
            _buildStoryCard(colorScheme),
            const SizedBox(height: 20),
            _buildPhysicalDescriptionCard(colorScheme),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCompendiumAnchorsCard(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final selectedReferences = <({String title, CharacterEntityRef ref})>[
      if (_character.raceRef != null)
        (title: 'Race anchor', ref: _character.raceRef!),
      if (_character.backgroundRef != null)
        (title: 'Background anchor', ref: _character.backgroundRef!),
      for (final entry in _character.classes)
        if (entry.classRef != null)
          (title: 'Class anchor', ref: entry.classRef!),
      for (final entry in _character.classes)
        if (entry.subclassRef != null)
          (title: 'Subclass anchor', ref: entry.subclassRef!),
    ];

    final roleplayFeatures = [
      ...widget.controller.resolvedBuild.raceTraits,
      ...widget.controller.resolvedBuild.backgroundFeatures,
    ];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              'ROLEPLAY ANCHORS',
              Icons.link_outlined,
              colorScheme,
            ),
            const SizedBox(height: 12),
            Text(
              'Your notes can stay grounded in the same compendium selections driving the build. Preview race, background, class, subclass, and trait entries from here while you write.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (selectedReferences.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...selectedReferences.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CharacterEntitySummaryCard(
                    title: entry.title,
                    reference: entry.ref,
                    service: widget.controller.compendium,
                  ),
                ),
              ),
            ],
            if (roleplayFeatures.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Previewable trait entries',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              ...roleplayFeatures.map(
                (feature) => FeatureItem(
                  feature: feature,
                  browseRepository:
                      widget.controller.compendium.browseRepository,
                  onOpenReference: feature.reference == null
                      ? null
                      : () => _openReference(feature.reference!),
                  onLinkTap: (candidate) => openCompendiumLinkPreview(
                    context,
                    browseRepository:
                        widget.controller.compendium.browseRepository,
                    candidate: candidate,
                    preferredRulesetId:
                        feature.reference?.rulesetId ??
                        _character.primaryRulesetId,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalityCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              'PERSONALITY',
              Icons.psychology_outlined,
              colorScheme,
            ),
            const SizedBox(height: 20),
            _buildLargeTextField(
              label: 'Personality Traits',
              controller: _personalityTraitsController,
            ),
            const SizedBox(height: 16),
            _buildLargeTextField(
              label: 'Ideals',
              controller: _idealsController,
            ),
            const SizedBox(height: 16),
            _buildLargeTextField(label: 'Bonds', controller: _bondsController),
            const SizedBox(height: 16),
            _buildLargeTextField(label: 'Flaws', controller: _flawsController),
            const SizedBox(height: 16),
            _buildLargeTextField(
              label: 'Allies and Organizations',
              hintText: 'One entry per line',
              controller: _alliesController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              'STORY AND NOTES',
              Icons.history_outlined,
              colorScheme,
            ),
            const SizedBox(height: 20),
            _buildLargeTextField(
              label: 'Backstory',
              controller: _backstoryController,
            ),
            const SizedBox(height: 16),
            _buildLargeTextField(
              label: 'Appearance',
              controller: _appearanceController,
            ),
            const SizedBox(height: 16),
            _buildLargeTextField(
              label: 'Languages Notes',
              controller: _languagesNotesController,
            ),
            const SizedBox(height: 16),
            _buildLargeTextField(
              label: 'Inventory Notes',
              controller: _inventoryNotesController,
            ),
            const SizedBox(height: 16),
            _buildLargeTextField(
              label: 'Other Notes',
              controller: _otherNotesController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalDescriptionCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              'PHYSICAL DESCRIPTION',
              Icons.person_outline_outlined,
              colorScheme,
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDescriptionField(
                  label: 'Age',
                  controller: _ageController,
                ),
                _buildDescriptionField(
                  label: 'Height',
                  controller: _heightController,
                ),
                _buildDescriptionField(
                  label: 'Weight',
                  controller: _weightController,
                ),
                _buildDescriptionField(
                  label: 'Eyes',
                  controller: _eyesController,
                ),
                _buildDescriptionField(
                  label: 'Skin',
                  controller: _skinController,
                ),
                _buildDescriptionField(
                  label: 'Hair',
                  controller: _hairController,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDescriptionField(
              label: 'Deity',
              controller: _deityController,
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    tooltip: 'Choose deity from compendium',
                    onPressed: _pickDeity,
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    tooltip: 'Preview deity if it resolves',
                    onPressed: _previewDeityByName,
                    icon: const Icon(Icons.visibility_outlined),
                  ),
                ],
              ),
            ),
            if (_selectedDeityRef != null) ...[
              const SizedBox(height: 16),
              CharacterEntitySummaryCard(
                title: 'Deity anchor',
                reference: _selectedDeityRef,
                service: widget.controller.compendium,
              ),
            ] else if (_deityController.text.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'This deity name is currently freeform. Use the search action to link it to a compendium entry and keep previews available here.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLargeTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
          ),
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildDescriptionField({
    required String label,
    required TextEditingController controller,
    Widget? trailing,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing],
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  void _openReference(CharacterEntityRef ref) {
    showCompendiumEntityPreviewSurface(
      context,
      rulesetId: ref.rulesetId,
      entityType: ref.entityType,
      entityId: ref.entityId,
      browseRepository: widget.controller.compendium.browseRepository,
    );
  }

  Future<void> _pickDeity() async {
    final primaryRulesetId = _character.primaryRulesetId;
    if (primaryRulesetId.trim().isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Choose a primary ruleset first so deity references can come from the compendium.',
          ),
        ),
      );
      return;
    }

    final result = await showCharacterCompendiumPicker(
      context,
      service: widget.controller.compendium,
      installedRulesets: widget.controller.installedRulesets,
      primaryRulesetId: primaryRulesetId,
      entityTypes: const ['deity'],
      title: 'Choose Deity',
    );
    if (result != null) {
      setState(() {
        _selectedDeityRef = result.ref;
      });
      _deityController.text = result.ref.displayName;
    }
  }

  Future<void> _previewDeityByName() async {
    final deityName = _deityController.text.trim();
    final primaryRulesetId = _character.primaryRulesetId;
    if (deityName.isEmpty || primaryRulesetId.trim().isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a deity name and choose a primary ruleset before previewing.',
          ),
        ),
      );
      return;
    }

    final selected = _selectedDeityRef;
    final resolved = selected != null && selected.displayName == deityName
        ? selected
        : await widget.controller.compendium.resolveEntityByName(
            rulesetId: primaryRulesetId,
            entityType: 'deity',
            name: deityName,
          );
    if (!mounted) {
      return;
    }
    if (resolved == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preview unavailable for this deity.')),
      );
      return;
    }

    if (_selectedDeityRef?.entityId != resolved.entityId ||
        _selectedDeityRef?.rulesetId != resolved.rulesetId) {
      setState(() {
        _selectedDeityRef = resolved;
      });
      _persistPhysicalDescription();
    }
    _openReference(resolved);
  }
}
