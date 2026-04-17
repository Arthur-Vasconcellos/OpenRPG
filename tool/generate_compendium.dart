import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

const _excludedFilePrefixes = <String>[
  'foundry-',
  'makebrew-',
  'converter',
  'renderdemo',
  'changelog',
];

const _excludedDirectories = <String>['generated'];

const _allowedObjectTypes = <String>{
  'action',
  'background',
  'class',
  'classFeature',
  'condition',
  'deity',
  'disease',
  'feat',
  'hazard',
  'item',
  'itemGroup',
  'itemMastery',
  'itemProperty',
  'itemType',
  'language',
  'magicvariant',
  'monster',
  'monsterfeatures',
  'object',
  'race',
  'reward',
  'sense',
  'skill',
  'spell',
  'status',
  'subclass',
  'subclassFeature',
  'subrace',
  'trap',
  'variantrule',
  'vehicle',
};

const _hiddenGeneratedFieldKeys = <String>{
  'source',
  'sourceFile',
  'edition',
  'page',
  'basicRules',
  'basicRules2024',
  'srd',
  'srd52',
  'referenceSources',
  'otherSources',
  'additionalSources',
  'parentSource',
  'fauxGroupSource',
  'classSource',
  'subclassSource',
  'raceSource',
};

const _supportCollectionKeys = <String>{
  '_meta',
  'backgroundFluff',
  'charoptionFluff',
  'classFluff',
  'conditionFluff',
  'data',
  'facilityFluff',
  'featFluff',
  'hazardFluff',
  'itemFluff',
  'languageFluff',
  'linkedLootTables',
  'monsterFluff',
  'objectFluff',
  'optionalfeatureFluff',
  'raceFluff',
  'raceFluffMeta',
  'recipeFluff',
  'reference',
  'rewardFluff',
  'spellFluff',
  'subclassFluff',
  'tableGroup',
  'trapFluff',
  'vehicleFluff',
};

const _legacyMixedBundledRulesetPath =
    'assets/rulesets/default_srd.ruleset.json';
const _starterBundledRulesetPath =
    'assets/rulesets/starter_2024_srd.ruleset.json';
const _browseManifestPath = 'assets/rulesets/browse_manifest.json';
const _browseDirectoryPath = 'assets/rulesets/browse';

const _linkTagMap = <String, String>{
  'action': 'action',
  'background': 'background',
  'book': 'book',
  'class': 'class',
  'classFeature': 'classFeature',
  'condition': 'condition',
  'creature': 'monster',
  'deity': 'deity',
  'feat': 'feat',
  'item': 'item',
  'object': 'object',
  'optfeature': 'optionalfeature',
  'optionalfeature': 'optionalfeature',
  'race': 'race',
  'reward': 'reward',
  'spell': 'spell',
  'status': 'status',
  'subclass': 'subclass',
  'subclassFeature': 'subclassFeature',
  'table': 'table',
  'trap': 'trap',
  'vehicle': 'vehicle',
  'variantrule': 'variantrule',
};

final _tagExpression = RegExp(r'\{@([a-zA-Z]+)\s+([^}]+)\}');

class _BundleProfile {
  final String id;
  final String name;
  final String description;
  final String license;
  final String assetPath;
  final bool includeOnlyExplicitSrd52;
  final bool preserveExtraCollections;

  const _BundleProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.license,
    required this.assetPath,
    required this.includeOnlyExplicitSrd52,
    required this.preserveExtraCollections,
  });
}

const _starterBundleProfile = _BundleProfile(
  id: 'starter_2024_srd',
  name: '2024 SRD Starter',
  description: 'Bundled starter content filtered to the legal shipping subset.',
  license: 'CC-BY-4.0',
  assetPath: _starterBundledRulesetPath,
  includeOnlyExplicitSrd52: true,
  preserveExtraCollections: false,
);

const _mixedDevBundleProfile = _BundleProfile(
  id: 'default_srd',
  name: 'OpenRPG Reference Compendium',
  description:
      'Bundled reference data generated from the local 5etools export.',
  license: 'Local 5etools import',
  assetPath: _legacyMixedBundledRulesetPath,
  includeOnlyExplicitSrd52: false,
  preserveExtraCollections: true,
);

void main(List<String> args) async {
  final projectRoot = Directory.current;
  final profile = _resolveBundleProfile(_readArg(args, '--profile'));
  final schemaFile = File(
    p.join(
      projectRoot.path,
      'assets',
      'rulesets',
      'ruleset_schema_catalog.json',
    ),
  );
  if (!await schemaFile.exists()) {
    stderr.writeln('Missing schema catalog at ${schemaFile.path}');
    exitCode = 1;
    return;
  }

  final schemaJson =
      jsonDecode(await schemaFile.readAsString()) as Map<String, dynamic>;
  final schemas =
      (schemaJson['schemas'] as List<dynamic>)
          .map((entry) => Map<String, dynamic>.from(entry as Map))
          .where(
            (schema) =>
                _allowedObjectTypes.contains(schema['objectType']?.toString()),
          )
          .map(_filteredSchema)
          .toList()
        ..sort(
          (left, right) => (left['objectType'] as String).compareTo(
            right['objectType'] as String,
          ),
        );

  final generatedDirectory = Directory(
    p.join(projectRoot.path, 'lib', 'compendium', 'generated'),
  );
  await generatedDirectory.create(recursive: true);

  final generatedFile = File(
    p.join(generatedDirectory.path, 'compendium_generated.dart'),
  );
  await generatedFile.writeAsString(_buildGeneratedRegistry(schemas));
  stdout.writeln('Wrote ${generatedFile.path}');

  final sourceRootArg = _readArg(args, '--source-root');
  final inputRulesetArg = _readArg(args, '--input-ruleset');
  final bundledRulesetArg = _readArg(args, '--bundled-ruleset');
  final bundledOutput = File(
    bundledRulesetArg?.trim().isNotEmpty == true
        ? _resolvePath(projectRoot, bundledRulesetArg!)
        : p.join(projectRoot.path, profile.assetPath),
  );

  if (sourceRootArg == null || sourceRootArg.trim().isEmpty) {
    final existingRulesetSource = await _resolveExistingRulesetSource(
      projectRoot: projectRoot,
      profile: profile,
      bundledOutput: bundledOutput,
      inputRulesetArg: inputRulesetArg,
    );
    if (existingRulesetSource != null && await existingRulesetSource.exists()) {
      final sourceRuleset =
          jsonDecode(await existingRulesetSource.readAsString())
              as Map<String, dynamic>;
      final bundledRuleset = _applyBundleProfile(
        baseRuleset: sourceRuleset,
        schemas: schemas,
        profile: profile,
      );
      await bundledOutput.writeAsString(
        const JsonEncoder.withIndent('  ').convert(bundledRuleset),
      );
      stdout.writeln('Wrote ${bundledOutput.path}');
      await _writeBrowseAssets(
        projectRoot: projectRoot,
        bundledOutput: bundledOutput,
        bundledRuleset: bundledRuleset,
        schemas: schemas,
      );
    } else if (await bundledOutput.exists()) {
      final bundledRuleset =
          jsonDecode(await bundledOutput.readAsString())
              as Map<String, dynamic>;
      await _writeBrowseAssets(
        projectRoot: projectRoot,
        bundledOutput: bundledOutput,
        bundledRuleset: bundledRuleset,
        schemas: schemas,
      );
    }
    return;
  }

  final sourceRoot = Directory(_resolvePath(projectRoot, sourceRootArg));
  if (!await sourceRoot.exists()) {
    stderr.writeln('Source root ${sourceRoot.path} does not exist.');
    exitCode = 2;
    return;
  }

  final schemaKeys = {
    for (final schema in schemas) schema['objectType'] as String,
  };
  final scannedKeys = await _scanSourceKeys(sourceRoot);
  final unknownKeys =
      scannedKeys
          .where(
            (key) =>
                !schemaKeys.contains(key) &&
                !_supportCollectionKeys.contains(key),
          )
          .toList()
        ..sort();
  if (unknownKeys.isNotEmpty) {
    stderr.writeln('Unmapped collection keys found: ${unknownKeys.join(', ')}');
    exitCode = 3;
    return;
  }

  final baseBundledRuleset = await _buildBundledRuleset(
    sourceRoot: sourceRoot,
    schemas: schemas,
  );
  final bundledRuleset = _applyBundleProfile(
    baseRuleset: baseBundledRuleset,
    schemas: schemas,
    profile: profile,
  );
  await bundledOutput.writeAsString(
    const JsonEncoder.withIndent('  ').convert(bundledRuleset),
  );
  stdout.writeln('Wrote ${bundledOutput.path}');
  await _writeBrowseAssets(
    projectRoot: projectRoot,
    bundledOutput: bundledOutput,
    bundledRuleset: bundledRuleset,
    schemas: schemas,
  );
}

String? _readArg(List<String> args, String name) {
  for (var index = 0; index < args.length; index++) {
    if (args[index] == name && index + 1 < args.length) {
      return args[index + 1];
    }
  }

  return null;
}

_BundleProfile _resolveBundleProfile(String? rawProfile) {
  switch (rawProfile?.trim()) {
    case null:
    case '':
    case 'starter':
    case 'starter_2024_srd':
      return _starterBundleProfile;
    case 'mixed_dev':
    case 'default_srd':
      return _mixedDevBundleProfile;
    default:
      stderr.writeln(
        'Unknown bundle profile "$rawProfile". Falling back to starter_2024_srd.',
      );
      return _starterBundleProfile;
  }
}

String _resolvePath(Directory projectRoot, String pathValue) {
  return p.isAbsolute(pathValue)
      ? pathValue
      : p.join(projectRoot.path, pathValue);
}

Future<File?> _resolveExistingRulesetSource({
  required Directory projectRoot,
  required _BundleProfile profile,
  required File bundledOutput,
  required String? inputRulesetArg,
}) async {
  if (inputRulesetArg != null && inputRulesetArg.trim().isNotEmpty) {
    return File(_resolvePath(projectRoot, inputRulesetArg.trim()));
  }

  if (profile.includeOnlyExplicitSrd52) {
    final legacyMixed = File(
      p.join(projectRoot.path, _legacyMixedBundledRulesetPath),
    );
    if (await legacyMixed.exists()) {
      stdout.writeln(
        'Using ${legacyMixed.path} as the local development source for the starter profile.',
      );
      return legacyMixed;
    }
  }

  if (await bundledOutput.exists()) {
    return bundledOutput;
  }

  return null;
}

Map<String, dynamic> _applyBundleProfile({
  required Map<String, dynamic> baseRuleset,
  required List<Map<String, dynamic>> schemas,
  required _BundleProfile profile,
}) {
  final knownMetadataKeys = <String>{
    'schemaVersion',
    'id',
    'name',
    'description',
    'author',
    'version',
    'license',
    'mode',
    'createdAt',
    'updatedAt',
  };
  final schemaFieldKeys = {
    for (final schema in schemas) schema['fieldKey'] as String,
  };

  final collections = <String, List<Map<String, dynamic>>>{};
  final omittedCollections = <String>[];

  for (final schema in schemas) {
    final fieldKey = schema['fieldKey'] as String;
    final label = schema['label']?.toString() ?? _humanize(fieldKey);
    final rawCollection = baseRuleset[fieldKey];
    final normalizedItems = rawCollection is List
        ? rawCollection
              .whereType<Map>()
              .map((item) => item.cast<String, dynamic>())
              .map(_cloneJsonMap)
              .toList(growable: false)
        : const <Map<String, dynamic>>[];

    if (!profile.includeOnlyExplicitSrd52) {
      collections[fieldKey] = normalizedItems;
      continue;
    }

    final filteredItems = normalizedItems
        .where(_isExplicitSrd52Entity)
        .map(_cloneJsonMap)
        .map(
          (item) => _rewriteStarterEntity(
            entityType: schema['objectType']?.toString() ?? '',
            entity: item,
          ),
        )
        .toList(growable: false);
    if (normalizedItems.isNotEmpty && filteredItems.isEmpty) {
      omittedCollections.add(label);
    }
    collections[fieldKey] = filteredItems;
  }

  if (omittedCollections.isNotEmpty) {
    stdout.writeln(
      'Starter profile omitted collections without explicit srd52 support: ${omittedCollections.join(', ')}',
    );
  }

  final normalized = <String, dynamic>{
    'schemaVersion':
        baseRuleset['schemaVersion']?.toString().trim().isNotEmpty == true
        ? baseRuleset['schemaVersion'].toString()
        : '1.0.0',
    'id': profile.id,
    'name': profile.name,
    'description': profile.description,
    'author': baseRuleset['author']?.toString() ?? 'OpenRPG',
    'version': baseRuleset['version']?.toString() ?? '1.0.0',
    'license': profile.license,
    'mode': 'bundled',
    'createdAt':
        baseRuleset['createdAt']?.toString() ??
        DateTime.now().toUtc().toIso8601String(),
    'updatedAt': DateTime.now().toUtc().toIso8601String(),
    ...collections,
  };

  if (profile.preserveExtraCollections) {
    for (final entry in baseRuleset.entries) {
      if (knownMetadataKeys.contains(entry.key) ||
          schemaFieldKeys.contains(entry.key)) {
        continue;
      }

      normalized[entry.key] = _cloneJson(entry.value);
    }
  }

  return normalized;
}

bool _isExplicitSrd52Entity(Map<String, dynamic> entity) {
  if (entity['srd52'] == true) {
    return true;
  }

  final data = entity['data'];
  return data is Map && data['srd52'] == true;
}

Map<String, dynamic> _filteredSchema(Map<String, dynamic> schema) {
  final normalized = Map<String, dynamic>.from(schema);
  normalized['fields'] = _filteredSchemaFields(
    schema['fields'] as List<dynamic>?,
  );
  return normalized;
}

List<Map<String, dynamic>> _filteredSchemaFields(List<dynamic>? fields) {
  if (fields == null) {
    return const <Map<String, dynamic>>[];
  }

  return fields
      .whereType<Map>()
      .map((field) => Map<String, dynamic>.from(field))
      .where(
        (field) => !_hiddenGeneratedFieldKeys.contains(
          field['key']?.toString().trim(),
        ),
      )
      .map((field) {
        final normalized = Map<String, dynamic>.from(field);
        normalized['fields'] = _filteredSchemaFields(
          field['fields'] as List<dynamic>?,
        );
        final itemSchema = field['itemSchema'];
        if (itemSchema is Map) {
          normalized['itemSchema'] = _filteredSchemaField(
            Map<String, dynamic>.from(itemSchema),
          );
        }
        return normalized;
      })
      .whereType<Map<String, dynamic>>()
      .toList(growable: false);
}

Map<String, dynamic>? _filteredSchemaField(Map<String, dynamic> field) {
  if (_hiddenGeneratedFieldKeys.contains(field['key']?.toString().trim())) {
    return null;
  }

  final normalized = Map<String, dynamic>.from(field);
  normalized['fields'] = _filteredSchemaFields(
    field['fields'] as List<dynamic>?,
  );
  final itemSchema = field['itemSchema'];
  if (itemSchema is Map) {
    normalized['itemSchema'] = _filteredSchemaField(
      Map<String, dynamic>.from(itemSchema),
    );
  }
  return normalized;
}

Map<String, dynamic> _rewriteStarterEntity({
  required String entityType,
  required Map<String, dynamic> entity,
}) {
  final rewritten = _rewriteStarterValue(entity);
  final data = rewritten['data'] is Map
      ? Map<String, dynamic>.from(rewritten['data'] as Map)
      : <String, dynamic>{};
  final name = (rewritten['name']?.toString() ?? data['name']?.toString() ?? '')
      .trim();
  final generatedId = CompendiumIdBuilder.build(
    entityType: entityType,
    name: name,
    payload: data,
  );

  rewritten['id'] = generatedId;
  rewritten['name'] = name.isEmpty ? generatedId : name;
  if (data.isNotEmpty) {
    rewritten['data'] = data;
  }

  return rewritten;
}

Map<String, dynamic> _rewriteStarterValue(Map<String, dynamic> value) {
  final rewritten = <String, dynamic>{};
  for (final entry in value.entries) {
    if (_hiddenGeneratedFieldKeys.contains(entry.key)) {
      continue;
    }

    if (entry.value is Map<String, dynamic>) {
      rewritten[entry.key] = _rewriteStarterValue(
        entry.value as Map<String, dynamic>,
      );
      continue;
    }
    if (entry.value is Map) {
      rewritten[entry.key] = _rewriteStarterValue(
        (entry.value as Map).cast<String, dynamic>(),
      );
      continue;
    }
    if (entry.value is List) {
      rewritten[entry.key] = _rewriteStarterList(entry.value as List<dynamic>);
      continue;
    }
    if (entry.value is String) {
      rewritten[entry.key] = _rewriteStarterString(
        entry.key,
        entry.value as String,
      );
      continue;
    }
    rewritten[entry.key] = entry.value;
  }
  return rewritten;
}

List<dynamic> _rewriteStarterList(List<dynamic> values) {
  return values
      .map((value) {
        if (value is Map<String, dynamic>) {
          return _rewriteStarterValue(value);
        }
        if (value is Map) {
          return _rewriteStarterValue(value.cast<String, dynamic>());
        }
        if (value is List) {
          return _rewriteStarterList(value);
        }
        if (value is String) {
          return _rewriteStarterString('', value);
        }
        return value;
      })
      .toList(growable: false);
}

String _rewriteStarterString(String key, String value) {
  final withRewrittenHints = value.replaceAllMapped(_tagExpression, (match) {
    final tag = match.group(1)?.trim() ?? '';
    final body = match.group(2)?.trim() ?? '';
    final parts = body.split('|');
    if (tag == 'book' || tag == 'adventure' || tag == 'quickref') {
      return parts.length > 2 ? parts[2] : parts[0];
    }
    if (parts.length > 1 && _looksLikeSrd(parts[1])) {
      parts[1] = '';
    }
    return '{@$tag ${parts.join('|')}}';
  });

  final pipeParts = withRewrittenHints.split('|');
  if (pipeParts.length == 2 && _looksLikeSrd(pipeParts[1])) {
    return pipeParts[0].trim();
  }

  return withRewrittenHints
      .replaceAll(
        RegExp(r'\bSRD52\b', caseSensitive: false),
        '',
      )
      .replaceAll(
        RegExp(r'\bSRD\b', caseSensitive: false),
        '',
      )
      .replaceAll(RegExp(r'\s{2,}'), ' ')
      .trim();
}

bool _looksLikeSrd(String? value) {
  final normalized = value?.trim().toLowerCase();
  return normalized == 'srd' || normalized == 'srd52';
}

dynamic _cloneJson(dynamic value) {
  if (value is Map<String, dynamic>) {
    return _cloneJsonMap(value);
  }
  if (value is Map) {
    return _cloneJsonMap(value.cast<String, dynamic>());
  }
  if (value is List) {
    return value.map(_cloneJson).toList(growable: false);
  }
  return value;
}

Map<String, dynamic> _cloneJsonMap(Map<String, dynamic> value) {
  return value.map((key, entryValue) => MapEntry(key, _cloneJson(entryValue)));
}

Future<Set<String>> _scanSourceKeys(Directory sourceRoot) async {
  final keys = <String>{};
  await for (final entity in sourceRoot.list(
    recursive: true,
    followLinks: false,
  )) {
    if (entity is! File || !entity.path.toLowerCase().endsWith('.json')) {
      continue;
    }

    if (_isExcluded(entity)) {
      continue;
    }

    final decoded = jsonDecode(await entity.readAsString());
    if (decoded is! Map) {
      continue;
    }

    for (final entry in decoded.entries) {
      if (entry.value is! List) {
        continue;
      }

      final list = entry.value as List<dynamic>;
      if (list.isNotEmpty && list.first is! Map && list.first is! String) {
        continue;
      }

      keys.add(entry.key.toString());
    }
  }
  return keys;
}

bool _isExcluded(File file) {
  final filename = p.basename(file.path).toLowerCase();
  if (_excludedFilePrefixes.any(filename.startsWith)) {
    return true;
  }

  final parts = p.split(file.path).map((part) => part.toLowerCase()).toList();
  if (parts.any(_excludedDirectories.contains)) {
    return true;
  }

  if (filename.endsWith('.html')) {
    return true;
  }

  return false;
}

String _slugify(String value) {
  final normalized = value.trim().toLowerCase();
  final collapsed = normalized.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  final sanitized = collapsed.replaceAll(RegExp(r'^_+|_+$'), '');
  return sanitized.isEmpty ? 'collection' : sanitized;
}

Future<Map<String, dynamic>> _buildBundledRuleset({
  required Directory sourceRoot,
  required List<Map<String, dynamic>> schemas,
}) async {
  final collections = <String, List<Map<String, dynamic>>>{
    for (final schema in schemas)
      schema['fieldKey'] as String: <Map<String, dynamic>>[],
  };

  final supportCollections = <String, List<dynamic>>{};

  await for (final entity in sourceRoot.list(
    recursive: true,
    followLinks: false,
  )) {
    if (entity is! File || !entity.path.toLowerCase().endsWith('.json')) {
      continue;
    }

    if (_isExcluded(entity)) {
      continue;
    }

    final decoded = jsonDecode(await entity.readAsString());
    if (decoded is! Map<String, dynamic>) {
      continue;
    }

    for (final schema in schemas) {
      final objectType = schema['objectType'] as String;
      final fieldKey = schema['fieldKey'] as String;
      final rawItems = decoded[objectType];
      if (rawItems is! List) {
        continue;
      }

      final targetCollection = collections[fieldKey]!;
      for (final rawItem in rawItems) {
        if (rawItem is! Map) {
          continue;
        }
        final item = Map<String, dynamic>.from(rawItem);
        final name = (item['name']?.toString() ?? '').trim();
        final id = CompendiumIdBuilder.build(
          entityType: objectType,
          name: name,
          payload: item,
        );
        targetCollection.add({
          'id': id,
          'name': name.isEmpty ? id : name,
          'data': _rewriteStarterValue(item),
        });
      }
    }

    for (final supportKey in _supportCollectionKeys) {
      final value = decoded[supportKey];
      if (value is List && value.isNotEmpty) {
        supportCollections
            .putIfAbsent(supportKey, () => <dynamic>[])
            .addAll(value);
      }
    }
  }

  return <String, dynamic>{
    'schemaVersion': '1.0.0',
    'id': 'default_srd',
    'name': 'OpenRPG Reference Compendium',
    'description':
        'Bundled reference data generated from the local 5etools export.',
    'author': 'OpenRPG',
    'version': '1.0.0',
    'license': 'Local 5etools import',
    'mode': 'bundled',
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
    ...collections,
    ...supportCollections,
  };
}

Future<void> _writeBrowseAssets({
  required Directory projectRoot,
  required File bundledOutput,
  required Map<String, dynamic> bundledRuleset,
  required List<Map<String, dynamic>> schemas,
}) async {
  final browseDirectory = Directory(
    p.join(projectRoot.path, _browseDirectoryPath),
  );
  if (await browseDirectory.exists()) {
    await browseDirectory.delete(recursive: true);
  }
  await browseDirectory.create(recursive: true);

  final rulesetId =
      bundledRuleset['id']?.toString() ?? _starterBundleProfile.id;
  final bundledAssetPath = p
      .relative(bundledOutput.path, from: projectRoot.path)
      .replaceAll('\\', '/');

  final schemaByFieldKey = <String, Map<String, dynamic>>{
    for (final schema in schemas) schema['fieldKey'] as String: schema,
  };

  final collectionStats = <Map<String, dynamic>>[];
  final shards = <Map<String, dynamic>>[];
  var totalEntityCount = 0;

  for (final entry in schemaByFieldKey.entries) {
    final fieldKey = entry.key;
    final schema = entry.value;
    final rawCollection = bundledRuleset[fieldKey];
    final entityType = schema['objectType'] as String;
    final label = schema['label']?.toString() ?? _humanize(entityType);
    final entityRows = <Map<String, dynamic>>[];
    final linkRows = <Map<String, dynamic>>[];
    final rawItems = rawCollection is List ? rawCollection : const <dynamic>[];

    for (final rawItem in rawItems) {
      if (rawItem is! Map) {
        continue;
      }

      final item = Map<String, dynamic>.from(rawItem);
      final payloadJson = jsonEncode(item);
      final entityId = item['id']?.toString() ?? '';
      final entityName = item['name']?.toString() ?? entityId;
      final entityData = item['data'];

      entityRows.add({
        'entityId': entityId,
        'name': entityName,
        'source': '',
        'sourceFile': '',
        'edition': null,
        'sortName': entityName.trim().toLowerCase(),
        'searchText': _flattenedSearchText(item).toLowerCase(),
        'payloadJson': payloadJson,
      });

      linkRows.addAll(
        _extractLinkRows(
          entityType: entityType,
          entityId: entityId,
          value: entityData,
        ),
      );
    }

    entityRows.sort((left, right) {
      final leftSort = left['sortName']?.toString() ?? '';
      final rightSort = right['sortName']?.toString() ?? '';
      final nameCompare = leftSort.compareTo(rightSort);
      if (nameCompare != 0) {
        return nameCompare;
      }

      return (left['entityId']?.toString() ?? '').compareTo(
        right['entityId']?.toString() ?? '',
      );
    });

    totalEntityCount += entityRows.length;
    collectionStats.add({
      'entityType': entityType,
      'collectionKey': fieldKey,
      'label': label,
      'entityCount': entityRows.length,
    });

    if (entityRows.isEmpty) {
      continue;
    }

    final shardFileName = '${_slugify(rulesetId)}_${_slugify(fieldKey)}.json';
    final assetPath = 'assets/rulesets/browse/$shardFileName';
    final shardFile = File(p.join(browseDirectory.path, shardFileName));
    await shardFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'rulesetId': rulesetId,
        'entityType': entityType,
        'collectionKey': fieldKey,
        'entityRows': entityRows,
        'linkRows': linkRows,
      }),
    );

    shards.add({
      'entityType': entityType,
      'collectionKey': fieldKey,
      'assetPath': assetPath,
      'entityCount': entityRows.length,
      'linkCount': linkRows.length,
    });
    stdout.writeln('Wrote ${shardFile.path}');
  }

  final bundledStat = await bundledOutput.stat();
  final assetVersion =
      '${bundledStat.modified.toUtc().millisecondsSinceEpoch}-${bundledStat.size}';
  final manifestFile = File(p.join(projectRoot.path, _browseManifestPath));
  await manifestFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert({
      'assetVersion': assetVersion,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
      'rulesets': [
        {
          'rulesetId': rulesetId,
          'name': bundledRuleset['name']?.toString() ?? rulesetId,
          'description': bundledRuleset['description']?.toString() ?? '',
          'mode': bundledRuleset['mode']?.toString() ?? 'bundled',
          'schemaVersion':
              bundledRuleset['schemaVersion']?.toString() ?? '1.0.0',
          'author': bundledRuleset['author']?.toString() ?? '',
          'version': bundledRuleset['version']?.toString() ?? '1.0.0',
          'license': bundledRuleset['license']?.toString() ?? '',
          'entityCount': totalEntityCount,
          'createdAt': bundledRuleset['createdAt']?.toString(),
          'updatedAt': bundledRuleset['updatedAt']?.toString(),
          'filePath': bundledAssetPath,
          'collectionStats': collectionStats,
          'shards': shards,
        },
      ],
    }),
  );
  stdout.writeln('Wrote ${manifestFile.path}');
}

List<Map<String, dynamic>> _extractLinkRows({
  required String entityType,
  required String entityId,
  required dynamic value,
}) {
  final rows = <Map<String, dynamic>>[];

  void visit(dynamic node) {
    if (node is String) {
      for (final match in _tagExpression.allMatches(node)) {
        final tag = match.group(1)?.trim() ?? '';
        final body = match.group(2)?.trim() ?? '';
        if (tag.isEmpty || body.isEmpty) {
          continue;
        }

        final parts = body.split('|');
        rows.add({
          'sourceEntityType': entityType,
          'sourceEntityId': entityId,
          'targetTag': tag,
          'rawReference': body,
          'displayText': parts.first.trim(),
          'sourceHint': parts.length > 1 && parts[1].trim().isNotEmpty
              ? parts[1].trim().toUpperCase()
              : null,
          'targetEntityType': _linkTagMap[tag] ?? tag,
        });
      }
      return;
    }

    if (node is List) {
      for (final item in node) {
        visit(item);
      }
      return;
    }

    if (node is Map) {
      for (final item in node.values) {
        visit(item);
      }
    }
  }

  visit(value);
  return rows;
}

String _flattenedSearchText(dynamic value) {
  final buffer = StringBuffer();

  void append(dynamic node) {
    if (node == null) {
      return;
    }

    if (node is String || node is num || node is bool) {
      buffer.write(' ');
      buffer.write(node.toString());
      return;
    }

    if (node is List) {
      for (final item in node) {
        append(item);
      }
      return;
    }

    if (node is Map) {
      for (final item in node.values) {
        append(item);
      }
    }
  }

  append(value);
  return buffer.toString().trim().replaceAll(RegExp(r'\s+'), ' ');
}

String _buildGeneratedRegistry(List<Map<String, dynamic>> schemas) {
  final buffer = StringBuffer()
    ..writeln(
      "import 'package:openrpg/compendium/models/compendium_editor.dart';",
    )
    ..writeln(
      "import 'package:openrpg/compendium/models/compendium_entity.dart';",
    )
    ..writeln()
    ..writeln(
      'Map<String, dynamic> _generatedEntityExtra(Map<String, dynamic> json) {',
    )
    ..writeln(
      "  const knownKeys = <String>{'id', 'name', 'data'};",
    )
    ..writeln('  final extra = <String, dynamic>{};')
    ..writeln('  for (final entry in json.entries) {')
    ..writeln('    if (knownKeys.contains(entry.key)) {')
    ..writeln('      continue;')
    ..writeln('    }')
    ..writeln(
      '    extra[entry.key] = CompendiumJsonUtils.deepCopy(entry.value);',
    )
    ..writeln('  }')
    ..writeln('  return extra;')
    ..writeln('}')
    ..writeln();

  for (final schema in schemas) {
    final objectType = schema['objectType'] as String;
    final fieldKey = schema['fieldKey'] as String;
    final className = '${_pascalCase(objectType)}Entity';
    buffer
      ..writeln('class $className extends GeneratedCompendiumEntityBase {')
      ..writeln("  static const String entityTypeValue = '$objectType';")
      ..writeln("  static const String collectionKeyValue = '$fieldKey';")
      ..writeln()
      ..writeln('  const $className({')
      ..writeln('    required super.id,')
      ..writeln('    required super.name,')
      ..writeln('    required super.data,')
      ..writeln('    super.extra,')
      ..writeln('  });')
      ..writeln()
      ..writeln('  factory $className.fromJson(Map<String, dynamic> json) {')
      ..writeln(
        '    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);',
      )
      ..writeln(
        "    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);",
      )
      ..writeln('    final payload = <String, dynamic>{')
      ..writeln("      'id': sanitized['id'],")
      ..writeln("      'name': sanitized['name'],")
      ..writeln("      'data': data,")
      ..writeln('    };')
      ..writeln(
        "    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();",
      )
      ..writeln('    return $className(')
      ..writeln('      id: sanitized[\'id\']?.toString() ??')
      ..writeln('          CompendiumJsonUtils.stableEntityId(')
      ..writeln('            entityType: entityTypeValue,')
      ..writeln('            payload: payload,')
      ..writeln('          ),')
      ..writeln(
        '      name: name.isEmpty ? sanitized[\'id\']?.toString() ?? \'untitled\' : name,',
      )
      ..writeln('      data: data,')
      ..writeln('      extra: _generatedEntityExtra(sanitized),')
      ..writeln('    );')
      ..writeln('  }')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  String get entityType => entityTypeValue;')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  String get collectionKey => collectionKeyValue;')
      ..writeln('}')
      ..writeln();
  }

  buffer.writeln(
    'final List<CompendiumEntityDescriptor<CompendiumEntity>> compendiumEntityDescriptors = [',
  );
  for (final schema in schemas) {
    final objectType = schema['objectType'] as String;
    final fieldKey = schema['fieldKey'] as String;
    final label = _escape(schema['label']?.toString() ?? _humanize(objectType));
    final className = '${_pascalCase(objectType)}Entity';
    buffer
      ..writeln('  CompendiumEntityDescriptor(')
      ..writeln('    collection: CompendiumCollectionDefinition(')
      ..writeln("      entityType: '$objectType',")
      ..writeln("      collectionKey: '$fieldKey',")
      ..writeln("      label: '$label',")
      ..writeln('    ),')
      ..writeln('    fromJson: $className.fromJson,')
      ..writeln('  ),');
  }
  buffer.writeln('];');
  buffer.writeln();

  buffer
    ..writeln(
      'CompendiumEntityDescriptor<CompendiumEntity>? descriptorForType(String entityType) {',
    )
    ..writeln('  for (final descriptor in compendiumEntityDescriptors) {')
    ..writeln('    if (descriptor.collection.entityType == entityType) {')
    ..writeln('      return descriptor;')
    ..writeln('    }')
    ..writeln('  }')
    ..writeln('  return null;')
    ..writeln('}')
    ..writeln()
    ..writeln(
      'CompendiumEntity? parseEntityJson(String entityType, Map<String, dynamic> json) {',
    )
    ..writeln('  switch (entityType) {');
  for (final schema in schemas) {
    final objectType = schema['objectType'] as String;
    final className = '${_pascalCase(objectType)}Entity';
    buffer.writeln("    case '$objectType': return $className.fromJson(json);");
  }
  buffer
    ..writeln('    default:')
    ..writeln('      return null;')
    ..writeln('  }')
    ..writeln('}')
    ..writeln();

  buffer.writeln(
    'final Map<String, CompendiumEditorDescriptor> compendiumEditorDescriptors = {',
  );
  for (final schema in schemas) {
    final objectType = schema['objectType'] as String;
    final fieldKey = schema['fieldKey'] as String;
    final label = _escape(schema['label']?.toString() ?? _humanize(objectType));
    buffer
      ..writeln("  '$objectType': CompendiumEditorDescriptor(")
      ..writeln("    entityType: '$objectType',")
      ..writeln("    collectionKey: '$fieldKey',")
      ..writeln("    label: '$label',")
      ..writeln('    fields: [');
    for (final field in (schema['fields'] as List<dynamic>)) {
      buffer.writeln(
        '${_emitFieldDescriptor(Map<String, dynamic>.from(field as Map), 3)},',
      );
    }
    buffer
      ..writeln('    ],')
      ..writeln('  ),');
  }
  buffer
    ..writeln('};')
    ..writeln()
    ..writeln(
      'CompendiumEditorDescriptor? editorDescriptorForType(String entityType) {',
    )
    ..writeln('  return compendiumEditorDescriptors[entityType];')
    ..writeln('}');

  return buffer.toString();
}

String _emitFieldDescriptor(Map<String, dynamic> field, int indentLevel) {
  final indent = '  ' * indentLevel;
  final childIndent = '  ' * (indentLevel + 1);
  final label = _escape(_humanize(field['key']?.toString() ?? 'field'));
  final kind = _fieldKind(field['kind']?.toString() ?? 'dynamic');
  final buffer = StringBuffer()
    ..writeln('${indent}CompendiumFieldDescriptor(')
    ..writeln(
      "${childIndent}key: '${_escape(field['key']?.toString() ?? 'field')}',",
    )
    ..writeln("${childIndent}label: '$label',")
    ..writeln('${childIndent}kind: CompendiumFieldKind.$kind,')
    ..writeln('${childIndent}required: ${field['required'] == true},')
    ..writeln('${childIndent}nullable: ${field['nullable'] != false},')
    ..writeln('${childIndent}isArray: ${field['isArray'] == true},')
    ..writeln('${childIndent}choices: [');
  for (final choice in (field['choices'] as List<dynamic>? ?? const [])) {
    buffer.writeln("$childIndent  '${_escape(choice.toString())}',");
  }
  buffer
    ..writeln('$childIndent],')
    ..writeln('${childIndent}fields: [');
  for (final nested in (field['fields'] as List<dynamic>? ?? const [])) {
    buffer.writeln(
      '${_emitFieldDescriptor(Map<String, dynamic>.from(nested as Map), indentLevel + 2)},',
    );
  }
  buffer
    ..writeln('$childIndent],')
    ..writeln(
      '${childIndent}itemDescriptor: ${_emitItemDescriptor(field['itemSchema'], indentLevel + 1)},',
    )
    ..writeln('${childIndent}sampleCount: ${field['sampleCount'] ?? 0},')
    ..write('$indent)');
  return buffer.toString();
}

String _emitItemDescriptor(dynamic itemSchema, int indentLevel) {
  if (itemSchema is! Map) {
    return 'null';
  }
  return _emitFieldDescriptor(
    Map<String, dynamic>.from(itemSchema),
    indentLevel,
  );
}

String _fieldKind(String raw) {
  switch (raw) {
    case 'string':
      return 'string';
    case 'integer':
      return 'integer';
    case 'number':
      return 'number';
    case 'boolean':
      return 'boolean';
    case 'object':
      return 'object';
    case 'list':
      return 'list';
    default:
      return 'dynamic';
  }
}

String _pascalCase(String value) {
  final normalized = value.replaceAllMapped(
    RegExp(r'[^A-Za-z0-9]+'),
    (_) => ' ',
  );
  return normalized
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join();
}

String _humanize(String value) {
  final spaced = value
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)} ${match.group(2)}',
      )
      .replaceAll('_', ' ')
      .trim();
  if (spaced.isEmpty) {
    return value;
  }

  final words = spaced.split(RegExp(r'\s+'));
  return words
      .map((word) {
        if (word.length <= 2 && word.toUpperCase() == word) {
          return word;
        }
        return '${word[0].toUpperCase()}${word.substring(1)}';
      })
      .join(' ');
}

String _escape(String value) {
  return value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
}

class CompendiumIdBuilder {
  static String build({
    required String entityType,
    required String name,
    required Map<String, dynamic> payload,
  }) {
    final normalizedType = _slugify(entityType);
    final normalizedName = _slugify(name.isEmpty ? 'untitled' : name);
    final data = payload['data'] is Map
        ? Map<String, dynamic>.from(payload['data'] as Map)
        : Map<String, dynamic>.from(payload);
    final extraSegments = switch (entityType) {
      'classFeature' => <String>[
          data['className']?.toString() ?? '',
          data['level']?.toString() ?? '',
        ],
      'subclass' => <String>[data['className']?.toString() ?? ''],
      'subclassFeature' => <String>[
          data['className']?.toString() ?? '',
          data['subclassShortName']?.toString() ?? '',
          data['level']?.toString() ?? '',
        ],
      'subrace' => <String>[data['raceName']?.toString() ?? ''],
      _ => const <String>[],
    };
    return <String>[
      normalizedType,
      normalizedName,
      ...extraSegments.map(_slugify).where((segment) => segment.isNotEmpty),
    ].join(':');
  }

  static String _slugify(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
