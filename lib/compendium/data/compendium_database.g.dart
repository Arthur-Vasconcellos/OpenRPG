// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compendium_database.dart';

// ignore_for_file: type=lint
class $RulesetRecordsTable extends RulesetRecords
    with TableInfo<$RulesetRecordsTable, RulesetRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RulesetRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rulesetIdMeta = const VerificationMeta(
    'rulesetId',
  );
  @override
  late final GeneratedColumn<String> rulesetId = GeneratedColumn<String>(
    'ruleset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<String> schemaVersion = GeneratedColumn<String>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1.0.0'),
  );
  static const VerificationMeta _licenseMeta = const VerificationMeta(
    'license',
  );
  @override
  late final GeneratedColumn<String> license = GeneratedColumn<String>(
    'license',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _entityCountMeta = const VerificationMeta(
    'entityCount',
  );
  @override
  late final GeneratedColumn<int> entityCount = GeneratedColumn<int>(
    'entity_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _extraJsonMeta = const VerificationMeta(
    'extraJson',
  );
  @override
  late final GeneratedColumn<String> extraJson = GeneratedColumn<String>(
    'extra_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rulesetId,
    name,
    description,
    mode,
    schemaVersion,
    author,
    version,
    license,
    entityCount,
    createdAt,
    updatedAt,
    filePath,
    payloadJson,
    extraJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ruleset_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<RulesetRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ruleset_id')) {
      context.handle(
        _rulesetIdMeta,
        rulesetId.isAcceptableOrUnknown(data['ruleset_id']!, _rulesetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rulesetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('license')) {
      context.handle(
        _licenseMeta,
        license.isAcceptableOrUnknown(data['license']!, _licenseMeta),
      );
    }
    if (data.containsKey('entity_count')) {
      context.handle(
        _entityCountMeta,
        entityCount.isAcceptableOrUnknown(
          data['entity_count']!,
          _entityCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    }
    if (data.containsKey('extra_json')) {
      context.handle(
        _extraJsonMeta,
        extraJson.isAcceptableOrUnknown(data['extra_json']!, _extraJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rulesetId};
  @override
  RulesetRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RulesetRecord(
      rulesetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruleset_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schema_version'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      license: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license'],
      )!,
      entityCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      extraJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_json'],
      )!,
    );
  }

  @override
  $RulesetRecordsTable createAlias(String alias) {
    return $RulesetRecordsTable(attachedDatabase, alias);
  }
}

class RulesetRecord extends DataClass implements Insertable<RulesetRecord> {
  final String rulesetId;
  final String name;
  final String description;
  final String mode;
  final String schemaVersion;
  final String author;
  final String version;
  final String license;
  final int entityCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String filePath;
  final String payloadJson;
  final String extraJson;
  const RulesetRecord({
    required this.rulesetId,
    required this.name,
    required this.description,
    required this.mode,
    required this.schemaVersion,
    required this.author,
    required this.version,
    required this.license,
    required this.entityCount,
    this.createdAt,
    this.updatedAt,
    required this.filePath,
    required this.payloadJson,
    required this.extraJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ruleset_id'] = Variable<String>(rulesetId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['mode'] = Variable<String>(mode);
    map['schema_version'] = Variable<String>(schemaVersion);
    map['author'] = Variable<String>(author);
    map['version'] = Variable<String>(version);
    map['license'] = Variable<String>(license);
    map['entity_count'] = Variable<int>(entityCount);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['file_path'] = Variable<String>(filePath);
    map['payload_json'] = Variable<String>(payloadJson);
    map['extra_json'] = Variable<String>(extraJson);
    return map;
  }

  RulesetRecordsCompanion toCompanion(bool nullToAbsent) {
    return RulesetRecordsCompanion(
      rulesetId: Value(rulesetId),
      name: Value(name),
      description: Value(description),
      mode: Value(mode),
      schemaVersion: Value(schemaVersion),
      author: Value(author),
      version: Value(version),
      license: Value(license),
      entityCount: Value(entityCount),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      filePath: Value(filePath),
      payloadJson: Value(payloadJson),
      extraJson: Value(extraJson),
    );
  }

  factory RulesetRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RulesetRecord(
      rulesetId: serializer.fromJson<String>(json['rulesetId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      mode: serializer.fromJson<String>(json['mode']),
      schemaVersion: serializer.fromJson<String>(json['schemaVersion']),
      author: serializer.fromJson<String>(json['author']),
      version: serializer.fromJson<String>(json['version']),
      license: serializer.fromJson<String>(json['license']),
      entityCount: serializer.fromJson<int>(json['entityCount']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      filePath: serializer.fromJson<String>(json['filePath']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      extraJson: serializer.fromJson<String>(json['extraJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rulesetId': serializer.toJson<String>(rulesetId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'mode': serializer.toJson<String>(mode),
      'schemaVersion': serializer.toJson<String>(schemaVersion),
      'author': serializer.toJson<String>(author),
      'version': serializer.toJson<String>(version),
      'license': serializer.toJson<String>(license),
      'entityCount': serializer.toJson<int>(entityCount),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'filePath': serializer.toJson<String>(filePath),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'extraJson': serializer.toJson<String>(extraJson),
    };
  }

  RulesetRecord copyWith({
    String? rulesetId,
    String? name,
    String? description,
    String? mode,
    String? schemaVersion,
    String? author,
    String? version,
    String? license,
    int? entityCount,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    String? filePath,
    String? payloadJson,
    String? extraJson,
  }) => RulesetRecord(
    rulesetId: rulesetId ?? this.rulesetId,
    name: name ?? this.name,
    description: description ?? this.description,
    mode: mode ?? this.mode,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    author: author ?? this.author,
    version: version ?? this.version,
    license: license ?? this.license,
    entityCount: entityCount ?? this.entityCount,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    filePath: filePath ?? this.filePath,
    payloadJson: payloadJson ?? this.payloadJson,
    extraJson: extraJson ?? this.extraJson,
  );
  RulesetRecord copyWithCompanion(RulesetRecordsCompanion data) {
    return RulesetRecord(
      rulesetId: data.rulesetId.present ? data.rulesetId.value : this.rulesetId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      mode: data.mode.present ? data.mode.value : this.mode,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      author: data.author.present ? data.author.value : this.author,
      version: data.version.present ? data.version.value : this.version,
      license: data.license.present ? data.license.value : this.license,
      entityCount: data.entityCount.present
          ? data.entityCount.value
          : this.entityCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      extraJson: data.extraJson.present ? data.extraJson.value : this.extraJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RulesetRecord(')
          ..write('rulesetId: $rulesetId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('mode: $mode, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('author: $author, ')
          ..write('version: $version, ')
          ..write('license: $license, ')
          ..write('entityCount: $entityCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('filePath: $filePath, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('extraJson: $extraJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rulesetId,
    name,
    description,
    mode,
    schemaVersion,
    author,
    version,
    license,
    entityCount,
    createdAt,
    updatedAt,
    filePath,
    payloadJson,
    extraJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RulesetRecord &&
          other.rulesetId == this.rulesetId &&
          other.name == this.name &&
          other.description == this.description &&
          other.mode == this.mode &&
          other.schemaVersion == this.schemaVersion &&
          other.author == this.author &&
          other.version == this.version &&
          other.license == this.license &&
          other.entityCount == this.entityCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.filePath == this.filePath &&
          other.payloadJson == this.payloadJson &&
          other.extraJson == this.extraJson);
}

class RulesetRecordsCompanion extends UpdateCompanion<RulesetRecord> {
  final Value<String> rulesetId;
  final Value<String> name;
  final Value<String> description;
  final Value<String> mode;
  final Value<String> schemaVersion;
  final Value<String> author;
  final Value<String> version;
  final Value<String> license;
  final Value<int> entityCount;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> filePath;
  final Value<String> payloadJson;
  final Value<String> extraJson;
  final Value<int> rowid;
  const RulesetRecordsCompanion({
    this.rulesetId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.mode = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.author = const Value.absent(),
    this.version = const Value.absent(),
    this.license = const Value.absent(),
    this.entityCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.filePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.extraJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RulesetRecordsCompanion.insert({
    required String rulesetId,
    required String name,
    this.description = const Value.absent(),
    required String mode,
    required String schemaVersion,
    this.author = const Value.absent(),
    this.version = const Value.absent(),
    this.license = const Value.absent(),
    this.entityCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String filePath,
    this.payloadJson = const Value.absent(),
    this.extraJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : rulesetId = Value(rulesetId),
       name = Value(name),
       mode = Value(mode),
       schemaVersion = Value(schemaVersion),
       filePath = Value(filePath);
  static Insertable<RulesetRecord> custom({
    Expression<String>? rulesetId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? mode,
    Expression<String>? schemaVersion,
    Expression<String>? author,
    Expression<String>? version,
    Expression<String>? license,
    Expression<int>? entityCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? filePath,
    Expression<String>? payloadJson,
    Expression<String>? extraJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rulesetId != null) 'ruleset_id': rulesetId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (mode != null) 'mode': mode,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (author != null) 'author': author,
      if (version != null) 'version': version,
      if (license != null) 'license': license,
      if (entityCount != null) 'entity_count': entityCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (filePath != null) 'file_path': filePath,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (extraJson != null) 'extra_json': extraJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RulesetRecordsCompanion copyWith({
    Value<String>? rulesetId,
    Value<String>? name,
    Value<String>? description,
    Value<String>? mode,
    Value<String>? schemaVersion,
    Value<String>? author,
    Value<String>? version,
    Value<String>? license,
    Value<int>? entityCount,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? filePath,
    Value<String>? payloadJson,
    Value<String>? extraJson,
    Value<int>? rowid,
  }) {
    return RulesetRecordsCompanion(
      rulesetId: rulesetId ?? this.rulesetId,
      name: name ?? this.name,
      description: description ?? this.description,
      mode: mode ?? this.mode,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      author: author ?? this.author,
      version: version ?? this.version,
      license: license ?? this.license,
      entityCount: entityCount ?? this.entityCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      filePath: filePath ?? this.filePath,
      payloadJson: payloadJson ?? this.payloadJson,
      extraJson: extraJson ?? this.extraJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rulesetId.present) {
      map['ruleset_id'] = Variable<String>(rulesetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<String>(schemaVersion.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (license.present) {
      map['license'] = Variable<String>(license.value);
    }
    if (entityCount.present) {
      map['entity_count'] = Variable<int>(entityCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (extraJson.present) {
      map['extra_json'] = Variable<String>(extraJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RulesetRecordsCompanion(')
          ..write('rulesetId: $rulesetId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('mode: $mode, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('author: $author, ')
          ..write('version: $version, ')
          ..write('license: $license, ')
          ..write('entityCount: $entityCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('filePath: $filePath, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('extraJson: $extraJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntityRecordsTable extends EntityRecords
    with TableInfo<$EntityRecordsTable, EntityRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntityRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rulesetIdMeta = const VerificationMeta(
    'rulesetId',
  );
  @override
  late final GeneratedColumn<String> rulesetId = GeneratedColumn<String>(
    'ruleset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectionKeyMeta = const VerificationMeta(
    'collectionKey',
  );
  @override
  late final GeneratedColumn<String> collectionKey = GeneratedColumn<String>(
    'collection_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sourceFileMeta = const VerificationMeta(
    'sourceFile',
  );
  @override
  late final GeneratedColumn<String> sourceFile = GeneratedColumn<String>(
    'source_file',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _editionMeta = const VerificationMeta(
    'edition',
  );
  @override
  late final GeneratedColumn<String> edition = GeneratedColumn<String>(
    'edition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortNameMeta = const VerificationMeta(
    'sortName',
  );
  @override
  late final GeneratedColumn<String> sortName = GeneratedColumn<String>(
    'sort_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _searchTextMeta = const VerificationMeta(
    'searchText',
  );
  @override
  late final GeneratedColumn<String> searchText = GeneratedColumn<String>(
    'search_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rulesetId,
    entityType,
    entityId,
    collectionKey,
    name,
    source,
    sourceFile,
    edition,
    sortName,
    searchText,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntityRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ruleset_id')) {
      context.handle(
        _rulesetIdMeta,
        rulesetId.isAcceptableOrUnknown(data['ruleset_id']!, _rulesetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rulesetIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('collection_key')) {
      context.handle(
        _collectionKeyMeta,
        collectionKey.isAcceptableOrUnknown(
          data['collection_key']!,
          _collectionKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionKeyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('source_file')) {
      context.handle(
        _sourceFileMeta,
        sourceFile.isAcceptableOrUnknown(data['source_file']!, _sourceFileMeta),
      );
    }
    if (data.containsKey('edition')) {
      context.handle(
        _editionMeta,
        edition.isAcceptableOrUnknown(data['edition']!, _editionMeta),
      );
    }
    if (data.containsKey('sort_name')) {
      context.handle(
        _sortNameMeta,
        sortName.isAcceptableOrUnknown(data['sort_name']!, _sortNameMeta),
      );
    }
    if (data.containsKey('search_text')) {
      context.handle(
        _searchTextMeta,
        searchText.isAcceptableOrUnknown(data['search_text']!, _searchTextMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rulesetId, entityType, entityId};
  @override
  EntityRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityRecord(
      rulesetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruleset_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      collectionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection_key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceFile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_file'],
      )!,
      edition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition'],
      ),
      sortName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_name'],
      )!,
      searchText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_text'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $EntityRecordsTable createAlias(String alias) {
    return $EntityRecordsTable(attachedDatabase, alias);
  }
}

class EntityRecord extends DataClass implements Insertable<EntityRecord> {
  final String rulesetId;
  final String entityType;
  final String entityId;
  final String collectionKey;
  final String name;
  final String source;
  final String sourceFile;
  final String? edition;
  final String sortName;
  final String searchText;
  final String payloadJson;
  const EntityRecord({
    required this.rulesetId,
    required this.entityType,
    required this.entityId,
    required this.collectionKey,
    required this.name,
    required this.source,
    required this.sourceFile,
    this.edition,
    required this.sortName,
    required this.searchText,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ruleset_id'] = Variable<String>(rulesetId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['collection_key'] = Variable<String>(collectionKey);
    map['name'] = Variable<String>(name);
    map['source'] = Variable<String>(source);
    map['source_file'] = Variable<String>(sourceFile);
    if (!nullToAbsent || edition != null) {
      map['edition'] = Variable<String>(edition);
    }
    map['sort_name'] = Variable<String>(sortName);
    map['search_text'] = Variable<String>(searchText);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  EntityRecordsCompanion toCompanion(bool nullToAbsent) {
    return EntityRecordsCompanion(
      rulesetId: Value(rulesetId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      collectionKey: Value(collectionKey),
      name: Value(name),
      source: Value(source),
      sourceFile: Value(sourceFile),
      edition: edition == null && nullToAbsent
          ? const Value.absent()
          : Value(edition),
      sortName: Value(sortName),
      searchText: Value(searchText),
      payloadJson: Value(payloadJson),
    );
  }

  factory EntityRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityRecord(
      rulesetId: serializer.fromJson<String>(json['rulesetId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      collectionKey: serializer.fromJson<String>(json['collectionKey']),
      name: serializer.fromJson<String>(json['name']),
      source: serializer.fromJson<String>(json['source']),
      sourceFile: serializer.fromJson<String>(json['sourceFile']),
      edition: serializer.fromJson<String?>(json['edition']),
      sortName: serializer.fromJson<String>(json['sortName']),
      searchText: serializer.fromJson<String>(json['searchText']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rulesetId': serializer.toJson<String>(rulesetId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'collectionKey': serializer.toJson<String>(collectionKey),
      'name': serializer.toJson<String>(name),
      'source': serializer.toJson<String>(source),
      'sourceFile': serializer.toJson<String>(sourceFile),
      'edition': serializer.toJson<String?>(edition),
      'sortName': serializer.toJson<String>(sortName),
      'searchText': serializer.toJson<String>(searchText),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  EntityRecord copyWith({
    String? rulesetId,
    String? entityType,
    String? entityId,
    String? collectionKey,
    String? name,
    String? source,
    String? sourceFile,
    Value<String?> edition = const Value.absent(),
    String? sortName,
    String? searchText,
    String? payloadJson,
  }) => EntityRecord(
    rulesetId: rulesetId ?? this.rulesetId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    collectionKey: collectionKey ?? this.collectionKey,
    name: name ?? this.name,
    source: source ?? this.source,
    sourceFile: sourceFile ?? this.sourceFile,
    edition: edition.present ? edition.value : this.edition,
    sortName: sortName ?? this.sortName,
    searchText: searchText ?? this.searchText,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  EntityRecord copyWithCompanion(EntityRecordsCompanion data) {
    return EntityRecord(
      rulesetId: data.rulesetId.present ? data.rulesetId.value : this.rulesetId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      collectionKey: data.collectionKey.present
          ? data.collectionKey.value
          : this.collectionKey,
      name: data.name.present ? data.name.value : this.name,
      source: data.source.present ? data.source.value : this.source,
      sourceFile: data.sourceFile.present
          ? data.sourceFile.value
          : this.sourceFile,
      edition: data.edition.present ? data.edition.value : this.edition,
      sortName: data.sortName.present ? data.sortName.value : this.sortName,
      searchText: data.searchText.present
          ? data.searchText.value
          : this.searchText,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityRecord(')
          ..write('rulesetId: $rulesetId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('collectionKey: $collectionKey, ')
          ..write('name: $name, ')
          ..write('source: $source, ')
          ..write('sourceFile: $sourceFile, ')
          ..write('edition: $edition, ')
          ..write('sortName: $sortName, ')
          ..write('searchText: $searchText, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rulesetId,
    entityType,
    entityId,
    collectionKey,
    name,
    source,
    sourceFile,
    edition,
    sortName,
    searchText,
    payloadJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityRecord &&
          other.rulesetId == this.rulesetId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.collectionKey == this.collectionKey &&
          other.name == this.name &&
          other.source == this.source &&
          other.sourceFile == this.sourceFile &&
          other.edition == this.edition &&
          other.sortName == this.sortName &&
          other.searchText == this.searchText &&
          other.payloadJson == this.payloadJson);
}

class EntityRecordsCompanion extends UpdateCompanion<EntityRecord> {
  final Value<String> rulesetId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> collectionKey;
  final Value<String> name;
  final Value<String> source;
  final Value<String> sourceFile;
  final Value<String?> edition;
  final Value<String> sortName;
  final Value<String> searchText;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const EntityRecordsCompanion({
    this.rulesetId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.collectionKey = const Value.absent(),
    this.name = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceFile = const Value.absent(),
    this.edition = const Value.absent(),
    this.sortName = const Value.absent(),
    this.searchText = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntityRecordsCompanion.insert({
    required String rulesetId,
    required String entityType,
    required String entityId,
    required String collectionKey,
    required String name,
    this.source = const Value.absent(),
    this.sourceFile = const Value.absent(),
    this.edition = const Value.absent(),
    this.sortName = const Value.absent(),
    this.searchText = const Value.absent(),
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : rulesetId = Value(rulesetId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       collectionKey = Value(collectionKey),
       name = Value(name),
       payloadJson = Value(payloadJson);
  static Insertable<EntityRecord> custom({
    Expression<String>? rulesetId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? collectionKey,
    Expression<String>? name,
    Expression<String>? source,
    Expression<String>? sourceFile,
    Expression<String>? edition,
    Expression<String>? sortName,
    Expression<String>? searchText,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rulesetId != null) 'ruleset_id': rulesetId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (collectionKey != null) 'collection_key': collectionKey,
      if (name != null) 'name': name,
      if (source != null) 'source': source,
      if (sourceFile != null) 'source_file': sourceFile,
      if (edition != null) 'edition': edition,
      if (sortName != null) 'sort_name': sortName,
      if (searchText != null) 'search_text': searchText,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntityRecordsCompanion copyWith({
    Value<String>? rulesetId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? collectionKey,
    Value<String>? name,
    Value<String>? source,
    Value<String>? sourceFile,
    Value<String?>? edition,
    Value<String>? sortName,
    Value<String>? searchText,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return EntityRecordsCompanion(
      rulesetId: rulesetId ?? this.rulesetId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      collectionKey: collectionKey ?? this.collectionKey,
      name: name ?? this.name,
      source: source ?? this.source,
      sourceFile: sourceFile ?? this.sourceFile,
      edition: edition ?? this.edition,
      sortName: sortName ?? this.sortName,
      searchText: searchText ?? this.searchText,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rulesetId.present) {
      map['ruleset_id'] = Variable<String>(rulesetId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (collectionKey.present) {
      map['collection_key'] = Variable<String>(collectionKey.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceFile.present) {
      map['source_file'] = Variable<String>(sourceFile.value);
    }
    if (edition.present) {
      map['edition'] = Variable<String>(edition.value);
    }
    if (sortName.present) {
      map['sort_name'] = Variable<String>(sortName.value);
    }
    if (searchText.present) {
      map['search_text'] = Variable<String>(searchText.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntityRecordsCompanion(')
          ..write('rulesetId: $rulesetId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('collectionKey: $collectionKey, ')
          ..write('name: $name, ')
          ..write('source: $source, ')
          ..write('sourceFile: $sourceFile, ')
          ..write('edition: $edition, ')
          ..write('sortName: $sortName, ')
          ..write('searchText: $searchText, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntityLinksTable extends EntityLinks
    with TableInfo<$EntityLinksTable, EntityLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntityLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _rulesetIdMeta = const VerificationMeta(
    'rulesetId',
  );
  @override
  late final GeneratedColumn<String> rulesetId = GeneratedColumn<String>(
    'ruleset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceEntityTypeMeta = const VerificationMeta(
    'sourceEntityType',
  );
  @override
  late final GeneratedColumn<String> sourceEntityType = GeneratedColumn<String>(
    'source_entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceEntityIdMeta = const VerificationMeta(
    'sourceEntityId',
  );
  @override
  late final GeneratedColumn<String> sourceEntityId = GeneratedColumn<String>(
    'source_entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTagMeta = const VerificationMeta(
    'targetTag',
  );
  @override
  late final GeneratedColumn<String> targetTag = GeneratedColumn<String>(
    'target_tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawReferenceMeta = const VerificationMeta(
    'rawReference',
  );
  @override
  late final GeneratedColumn<String> rawReference = GeneratedColumn<String>(
    'raw_reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayTextMeta = const VerificationMeta(
    'displayText',
  );
  @override
  late final GeneratedColumn<String> displayText = GeneratedColumn<String>(
    'display_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceHintMeta = const VerificationMeta(
    'sourceHint',
  );
  @override
  late final GeneratedColumn<String> sourceHint = GeneratedColumn<String>(
    'source_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetEntityTypeMeta = const VerificationMeta(
    'targetEntityType',
  );
  @override
  late final GeneratedColumn<String> targetEntityType = GeneratedColumn<String>(
    'target_entity_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rulesetId,
    sourceEntityType,
    sourceEntityId,
    targetTag,
    rawReference,
    displayText,
    sourceHint,
    targetEntityType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntityLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ruleset_id')) {
      context.handle(
        _rulesetIdMeta,
        rulesetId.isAcceptableOrUnknown(data['ruleset_id']!, _rulesetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rulesetIdMeta);
    }
    if (data.containsKey('source_entity_type')) {
      context.handle(
        _sourceEntityTypeMeta,
        sourceEntityType.isAcceptableOrUnknown(
          data['source_entity_type']!,
          _sourceEntityTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceEntityTypeMeta);
    }
    if (data.containsKey('source_entity_id')) {
      context.handle(
        _sourceEntityIdMeta,
        sourceEntityId.isAcceptableOrUnknown(
          data['source_entity_id']!,
          _sourceEntityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceEntityIdMeta);
    }
    if (data.containsKey('target_tag')) {
      context.handle(
        _targetTagMeta,
        targetTag.isAcceptableOrUnknown(data['target_tag']!, _targetTagMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTagMeta);
    }
    if (data.containsKey('raw_reference')) {
      context.handle(
        _rawReferenceMeta,
        rawReference.isAcceptableOrUnknown(
          data['raw_reference']!,
          _rawReferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawReferenceMeta);
    }
    if (data.containsKey('display_text')) {
      context.handle(
        _displayTextMeta,
        displayText.isAcceptableOrUnknown(
          data['display_text']!,
          _displayTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayTextMeta);
    }
    if (data.containsKey('source_hint')) {
      context.handle(
        _sourceHintMeta,
        sourceHint.isAcceptableOrUnknown(data['source_hint']!, _sourceHintMeta),
      );
    }
    if (data.containsKey('target_entity_type')) {
      context.handle(
        _targetEntityTypeMeta,
        targetEntityType.isAcceptableOrUnknown(
          data['target_entity_type']!,
          _targetEntityTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntityLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityLink(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      rulesetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruleset_id'],
      )!,
      sourceEntityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_entity_type'],
      )!,
      sourceEntityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_entity_id'],
      )!,
      targetTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_tag'],
      )!,
      rawReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_reference'],
      )!,
      displayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_text'],
      )!,
      sourceHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_hint'],
      ),
      targetEntityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_entity_type'],
      ),
    );
  }

  @override
  $EntityLinksTable createAlias(String alias) {
    return $EntityLinksTable(attachedDatabase, alias);
  }
}

class EntityLink extends DataClass implements Insertable<EntityLink> {
  final int id;
  final String rulesetId;
  final String sourceEntityType;
  final String sourceEntityId;
  final String targetTag;
  final String rawReference;
  final String displayText;
  final String? sourceHint;
  final String? targetEntityType;
  const EntityLink({
    required this.id,
    required this.rulesetId,
    required this.sourceEntityType,
    required this.sourceEntityId,
    required this.targetTag,
    required this.rawReference,
    required this.displayText,
    this.sourceHint,
    this.targetEntityType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ruleset_id'] = Variable<String>(rulesetId);
    map['source_entity_type'] = Variable<String>(sourceEntityType);
    map['source_entity_id'] = Variable<String>(sourceEntityId);
    map['target_tag'] = Variable<String>(targetTag);
    map['raw_reference'] = Variable<String>(rawReference);
    map['display_text'] = Variable<String>(displayText);
    if (!nullToAbsent || sourceHint != null) {
      map['source_hint'] = Variable<String>(sourceHint);
    }
    if (!nullToAbsent || targetEntityType != null) {
      map['target_entity_type'] = Variable<String>(targetEntityType);
    }
    return map;
  }

  EntityLinksCompanion toCompanion(bool nullToAbsent) {
    return EntityLinksCompanion(
      id: Value(id),
      rulesetId: Value(rulesetId),
      sourceEntityType: Value(sourceEntityType),
      sourceEntityId: Value(sourceEntityId),
      targetTag: Value(targetTag),
      rawReference: Value(rawReference),
      displayText: Value(displayText),
      sourceHint: sourceHint == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceHint),
      targetEntityType: targetEntityType == null && nullToAbsent
          ? const Value.absent()
          : Value(targetEntityType),
    );
  }

  factory EntityLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityLink(
      id: serializer.fromJson<int>(json['id']),
      rulesetId: serializer.fromJson<String>(json['rulesetId']),
      sourceEntityType: serializer.fromJson<String>(json['sourceEntityType']),
      sourceEntityId: serializer.fromJson<String>(json['sourceEntityId']),
      targetTag: serializer.fromJson<String>(json['targetTag']),
      rawReference: serializer.fromJson<String>(json['rawReference']),
      displayText: serializer.fromJson<String>(json['displayText']),
      sourceHint: serializer.fromJson<String?>(json['sourceHint']),
      targetEntityType: serializer.fromJson<String?>(json['targetEntityType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rulesetId': serializer.toJson<String>(rulesetId),
      'sourceEntityType': serializer.toJson<String>(sourceEntityType),
      'sourceEntityId': serializer.toJson<String>(sourceEntityId),
      'targetTag': serializer.toJson<String>(targetTag),
      'rawReference': serializer.toJson<String>(rawReference),
      'displayText': serializer.toJson<String>(displayText),
      'sourceHint': serializer.toJson<String?>(sourceHint),
      'targetEntityType': serializer.toJson<String?>(targetEntityType),
    };
  }

  EntityLink copyWith({
    int? id,
    String? rulesetId,
    String? sourceEntityType,
    String? sourceEntityId,
    String? targetTag,
    String? rawReference,
    String? displayText,
    Value<String?> sourceHint = const Value.absent(),
    Value<String?> targetEntityType = const Value.absent(),
  }) => EntityLink(
    id: id ?? this.id,
    rulesetId: rulesetId ?? this.rulesetId,
    sourceEntityType: sourceEntityType ?? this.sourceEntityType,
    sourceEntityId: sourceEntityId ?? this.sourceEntityId,
    targetTag: targetTag ?? this.targetTag,
    rawReference: rawReference ?? this.rawReference,
    displayText: displayText ?? this.displayText,
    sourceHint: sourceHint.present ? sourceHint.value : this.sourceHint,
    targetEntityType: targetEntityType.present
        ? targetEntityType.value
        : this.targetEntityType,
  );
  EntityLink copyWithCompanion(EntityLinksCompanion data) {
    return EntityLink(
      id: data.id.present ? data.id.value : this.id,
      rulesetId: data.rulesetId.present ? data.rulesetId.value : this.rulesetId,
      sourceEntityType: data.sourceEntityType.present
          ? data.sourceEntityType.value
          : this.sourceEntityType,
      sourceEntityId: data.sourceEntityId.present
          ? data.sourceEntityId.value
          : this.sourceEntityId,
      targetTag: data.targetTag.present ? data.targetTag.value : this.targetTag,
      rawReference: data.rawReference.present
          ? data.rawReference.value
          : this.rawReference,
      displayText: data.displayText.present
          ? data.displayText.value
          : this.displayText,
      sourceHint: data.sourceHint.present
          ? data.sourceHint.value
          : this.sourceHint,
      targetEntityType: data.targetEntityType.present
          ? data.targetEntityType.value
          : this.targetEntityType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityLink(')
          ..write('id: $id, ')
          ..write('rulesetId: $rulesetId, ')
          ..write('sourceEntityType: $sourceEntityType, ')
          ..write('sourceEntityId: $sourceEntityId, ')
          ..write('targetTag: $targetTag, ')
          ..write('rawReference: $rawReference, ')
          ..write('displayText: $displayText, ')
          ..write('sourceHint: $sourceHint, ')
          ..write('targetEntityType: $targetEntityType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rulesetId,
    sourceEntityType,
    sourceEntityId,
    targetTag,
    rawReference,
    displayText,
    sourceHint,
    targetEntityType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityLink &&
          other.id == this.id &&
          other.rulesetId == this.rulesetId &&
          other.sourceEntityType == this.sourceEntityType &&
          other.sourceEntityId == this.sourceEntityId &&
          other.targetTag == this.targetTag &&
          other.rawReference == this.rawReference &&
          other.displayText == this.displayText &&
          other.sourceHint == this.sourceHint &&
          other.targetEntityType == this.targetEntityType);
}

class EntityLinksCompanion extends UpdateCompanion<EntityLink> {
  final Value<int> id;
  final Value<String> rulesetId;
  final Value<String> sourceEntityType;
  final Value<String> sourceEntityId;
  final Value<String> targetTag;
  final Value<String> rawReference;
  final Value<String> displayText;
  final Value<String?> sourceHint;
  final Value<String?> targetEntityType;
  const EntityLinksCompanion({
    this.id = const Value.absent(),
    this.rulesetId = const Value.absent(),
    this.sourceEntityType = const Value.absent(),
    this.sourceEntityId = const Value.absent(),
    this.targetTag = const Value.absent(),
    this.rawReference = const Value.absent(),
    this.displayText = const Value.absent(),
    this.sourceHint = const Value.absent(),
    this.targetEntityType = const Value.absent(),
  });
  EntityLinksCompanion.insert({
    this.id = const Value.absent(),
    required String rulesetId,
    required String sourceEntityType,
    required String sourceEntityId,
    required String targetTag,
    required String rawReference,
    required String displayText,
    this.sourceHint = const Value.absent(),
    this.targetEntityType = const Value.absent(),
  }) : rulesetId = Value(rulesetId),
       sourceEntityType = Value(sourceEntityType),
       sourceEntityId = Value(sourceEntityId),
       targetTag = Value(targetTag),
       rawReference = Value(rawReference),
       displayText = Value(displayText);
  static Insertable<EntityLink> custom({
    Expression<int>? id,
    Expression<String>? rulesetId,
    Expression<String>? sourceEntityType,
    Expression<String>? sourceEntityId,
    Expression<String>? targetTag,
    Expression<String>? rawReference,
    Expression<String>? displayText,
    Expression<String>? sourceHint,
    Expression<String>? targetEntityType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rulesetId != null) 'ruleset_id': rulesetId,
      if (sourceEntityType != null) 'source_entity_type': sourceEntityType,
      if (sourceEntityId != null) 'source_entity_id': sourceEntityId,
      if (targetTag != null) 'target_tag': targetTag,
      if (rawReference != null) 'raw_reference': rawReference,
      if (displayText != null) 'display_text': displayText,
      if (sourceHint != null) 'source_hint': sourceHint,
      if (targetEntityType != null) 'target_entity_type': targetEntityType,
    });
  }

  EntityLinksCompanion copyWith({
    Value<int>? id,
    Value<String>? rulesetId,
    Value<String>? sourceEntityType,
    Value<String>? sourceEntityId,
    Value<String>? targetTag,
    Value<String>? rawReference,
    Value<String>? displayText,
    Value<String?>? sourceHint,
    Value<String?>? targetEntityType,
  }) {
    return EntityLinksCompanion(
      id: id ?? this.id,
      rulesetId: rulesetId ?? this.rulesetId,
      sourceEntityType: sourceEntityType ?? this.sourceEntityType,
      sourceEntityId: sourceEntityId ?? this.sourceEntityId,
      targetTag: targetTag ?? this.targetTag,
      rawReference: rawReference ?? this.rawReference,
      displayText: displayText ?? this.displayText,
      sourceHint: sourceHint ?? this.sourceHint,
      targetEntityType: targetEntityType ?? this.targetEntityType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rulesetId.present) {
      map['ruleset_id'] = Variable<String>(rulesetId.value);
    }
    if (sourceEntityType.present) {
      map['source_entity_type'] = Variable<String>(sourceEntityType.value);
    }
    if (sourceEntityId.present) {
      map['source_entity_id'] = Variable<String>(sourceEntityId.value);
    }
    if (targetTag.present) {
      map['target_tag'] = Variable<String>(targetTag.value);
    }
    if (rawReference.present) {
      map['raw_reference'] = Variable<String>(rawReference.value);
    }
    if (displayText.present) {
      map['display_text'] = Variable<String>(displayText.value);
    }
    if (sourceHint.present) {
      map['source_hint'] = Variable<String>(sourceHint.value);
    }
    if (targetEntityType.present) {
      map['target_entity_type'] = Variable<String>(targetEntityType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntityLinksCompanion(')
          ..write('id: $id, ')
          ..write('rulesetId: $rulesetId, ')
          ..write('sourceEntityType: $sourceEntityType, ')
          ..write('sourceEntityId: $sourceEntityId, ')
          ..write('targetTag: $targetTag, ')
          ..write('rawReference: $rawReference, ')
          ..write('displayText: $displayText, ')
          ..write('sourceHint: $sourceHint, ')
          ..write('targetEntityType: $targetEntityType')
          ..write(')'))
        .toString();
  }
}

class $RulesetCollectionStatsTable extends RulesetCollectionStats
    with TableInfo<$RulesetCollectionStatsTable, RulesetCollectionStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RulesetCollectionStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rulesetIdMeta = const VerificationMeta(
    'rulesetId',
  );
  @override
  late final GeneratedColumn<String> rulesetId = GeneratedColumn<String>(
    'ruleset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectionKeyMeta = const VerificationMeta(
    'collectionKey',
  );
  @override
  late final GeneratedColumn<String> collectionKey = GeneratedColumn<String>(
    'collection_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityCountMeta = const VerificationMeta(
    'entityCount',
  );
  @override
  late final GeneratedColumn<int> entityCount = GeneratedColumn<int>(
    'entity_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rulesetId,
    entityType,
    collectionKey,
    label,
    entityCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ruleset_collection_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<RulesetCollectionStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ruleset_id')) {
      context.handle(
        _rulesetIdMeta,
        rulesetId.isAcceptableOrUnknown(data['ruleset_id']!, _rulesetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rulesetIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('collection_key')) {
      context.handle(
        _collectionKeyMeta,
        collectionKey.isAcceptableOrUnknown(
          data['collection_key']!,
          _collectionKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionKeyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('entity_count')) {
      context.handle(
        _entityCountMeta,
        entityCount.isAcceptableOrUnknown(
          data['entity_count']!,
          _entityCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rulesetId, entityType};
  @override
  RulesetCollectionStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RulesetCollectionStat(
      rulesetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruleset_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      collectionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection_key'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      entityCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_count'],
      )!,
    );
  }

  @override
  $RulesetCollectionStatsTable createAlias(String alias) {
    return $RulesetCollectionStatsTable(attachedDatabase, alias);
  }
}

class RulesetCollectionStat extends DataClass
    implements Insertable<RulesetCollectionStat> {
  final String rulesetId;
  final String entityType;
  final String collectionKey;
  final String label;
  final int entityCount;
  const RulesetCollectionStat({
    required this.rulesetId,
    required this.entityType,
    required this.collectionKey,
    required this.label,
    required this.entityCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ruleset_id'] = Variable<String>(rulesetId);
    map['entity_type'] = Variable<String>(entityType);
    map['collection_key'] = Variable<String>(collectionKey);
    map['label'] = Variable<String>(label);
    map['entity_count'] = Variable<int>(entityCount);
    return map;
  }

  RulesetCollectionStatsCompanion toCompanion(bool nullToAbsent) {
    return RulesetCollectionStatsCompanion(
      rulesetId: Value(rulesetId),
      entityType: Value(entityType),
      collectionKey: Value(collectionKey),
      label: Value(label),
      entityCount: Value(entityCount),
    );
  }

  factory RulesetCollectionStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RulesetCollectionStat(
      rulesetId: serializer.fromJson<String>(json['rulesetId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      collectionKey: serializer.fromJson<String>(json['collectionKey']),
      label: serializer.fromJson<String>(json['label']),
      entityCount: serializer.fromJson<int>(json['entityCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rulesetId': serializer.toJson<String>(rulesetId),
      'entityType': serializer.toJson<String>(entityType),
      'collectionKey': serializer.toJson<String>(collectionKey),
      'label': serializer.toJson<String>(label),
      'entityCount': serializer.toJson<int>(entityCount),
    };
  }

  RulesetCollectionStat copyWith({
    String? rulesetId,
    String? entityType,
    String? collectionKey,
    String? label,
    int? entityCount,
  }) => RulesetCollectionStat(
    rulesetId: rulesetId ?? this.rulesetId,
    entityType: entityType ?? this.entityType,
    collectionKey: collectionKey ?? this.collectionKey,
    label: label ?? this.label,
    entityCount: entityCount ?? this.entityCount,
  );
  RulesetCollectionStat copyWithCompanion(
    RulesetCollectionStatsCompanion data,
  ) {
    return RulesetCollectionStat(
      rulesetId: data.rulesetId.present ? data.rulesetId.value : this.rulesetId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      collectionKey: data.collectionKey.present
          ? data.collectionKey.value
          : this.collectionKey,
      label: data.label.present ? data.label.value : this.label,
      entityCount: data.entityCount.present
          ? data.entityCount.value
          : this.entityCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RulesetCollectionStat(')
          ..write('rulesetId: $rulesetId, ')
          ..write('entityType: $entityType, ')
          ..write('collectionKey: $collectionKey, ')
          ..write('label: $label, ')
          ..write('entityCount: $entityCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(rulesetId, entityType, collectionKey, label, entityCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RulesetCollectionStat &&
          other.rulesetId == this.rulesetId &&
          other.entityType == this.entityType &&
          other.collectionKey == this.collectionKey &&
          other.label == this.label &&
          other.entityCount == this.entityCount);
}

class RulesetCollectionStatsCompanion
    extends UpdateCompanion<RulesetCollectionStat> {
  final Value<String> rulesetId;
  final Value<String> entityType;
  final Value<String> collectionKey;
  final Value<String> label;
  final Value<int> entityCount;
  final Value<int> rowid;
  const RulesetCollectionStatsCompanion({
    this.rulesetId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.collectionKey = const Value.absent(),
    this.label = const Value.absent(),
    this.entityCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RulesetCollectionStatsCompanion.insert({
    required String rulesetId,
    required String entityType,
    required String collectionKey,
    required String label,
    this.entityCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : rulesetId = Value(rulesetId),
       entityType = Value(entityType),
       collectionKey = Value(collectionKey),
       label = Value(label);
  static Insertable<RulesetCollectionStat> custom({
    Expression<String>? rulesetId,
    Expression<String>? entityType,
    Expression<String>? collectionKey,
    Expression<String>? label,
    Expression<int>? entityCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rulesetId != null) 'ruleset_id': rulesetId,
      if (entityType != null) 'entity_type': entityType,
      if (collectionKey != null) 'collection_key': collectionKey,
      if (label != null) 'label': label,
      if (entityCount != null) 'entity_count': entityCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RulesetCollectionStatsCompanion copyWith({
    Value<String>? rulesetId,
    Value<String>? entityType,
    Value<String>? collectionKey,
    Value<String>? label,
    Value<int>? entityCount,
    Value<int>? rowid,
  }) {
    return RulesetCollectionStatsCompanion(
      rulesetId: rulesetId ?? this.rulesetId,
      entityType: entityType ?? this.entityType,
      collectionKey: collectionKey ?? this.collectionKey,
      label: label ?? this.label,
      entityCount: entityCount ?? this.entityCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rulesetId.present) {
      map['ruleset_id'] = Variable<String>(rulesetId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (collectionKey.present) {
      map['collection_key'] = Variable<String>(collectionKey.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (entityCount.present) {
      map['entity_count'] = Variable<int>(entityCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RulesetCollectionStatsCompanion(')
          ..write('rulesetId: $rulesetId, ')
          ..write('entityType: $entityType, ')
          ..write('collectionKey: $collectionKey, ')
          ..write('label: $label, ')
          ..write('entityCount: $entityCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompendiumBootstrapStatesTable extends CompendiumBootstrapStates
    with TableInfo<$CompendiumBootstrapStatesTable, CompendiumBootstrapState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompendiumBootstrapStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rulesetIdMeta = const VerificationMeta(
    'rulesetId',
  );
  @override
  late final GeneratedColumn<String> rulesetId = GeneratedColumn<String>(
    'ruleset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetVersionMeta = const VerificationMeta(
    'assetVersion',
  );
  @override
  late final GeneratedColumn<String> assetVersion = GeneratedColumn<String>(
    'asset_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('idle'),
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rulesetId,
    assetVersion,
    state,
    progress,
    lastError,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compendium_bootstrap_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompendiumBootstrapState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ruleset_id')) {
      context.handle(
        _rulesetIdMeta,
        rulesetId.isAcceptableOrUnknown(data['ruleset_id']!, _rulesetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rulesetIdMeta);
    }
    if (data.containsKey('asset_version')) {
      context.handle(
        _assetVersionMeta,
        assetVersion.isAcceptableOrUnknown(
          data['asset_version']!,
          _assetVersionMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rulesetId};
  @override
  CompendiumBootstrapState map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompendiumBootstrapState(
      rulesetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruleset_id'],
      )!,
      assetVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_version'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $CompendiumBootstrapStatesTable createAlias(String alias) {
    return $CompendiumBootstrapStatesTable(attachedDatabase, alias);
  }
}

class CompendiumBootstrapState extends DataClass
    implements Insertable<CompendiumBootstrapState> {
  final String rulesetId;
  final String assetVersion;
  final String state;
  final double progress;
  final String? lastError;
  final DateTime? updatedAt;
  const CompendiumBootstrapState({
    required this.rulesetId,
    required this.assetVersion,
    required this.state,
    required this.progress,
    this.lastError,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ruleset_id'] = Variable<String>(rulesetId);
    map['asset_version'] = Variable<String>(assetVersion);
    map['state'] = Variable<String>(state);
    map['progress'] = Variable<double>(progress);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CompendiumBootstrapStatesCompanion toCompanion(bool nullToAbsent) {
    return CompendiumBootstrapStatesCompanion(
      rulesetId: Value(rulesetId),
      assetVersion: Value(assetVersion),
      state: Value(state),
      progress: Value(progress),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory CompendiumBootstrapState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompendiumBootstrapState(
      rulesetId: serializer.fromJson<String>(json['rulesetId']),
      assetVersion: serializer.fromJson<String>(json['assetVersion']),
      state: serializer.fromJson<String>(json['state']),
      progress: serializer.fromJson<double>(json['progress']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rulesetId': serializer.toJson<String>(rulesetId),
      'assetVersion': serializer.toJson<String>(assetVersion),
      'state': serializer.toJson<String>(state),
      'progress': serializer.toJson<double>(progress),
      'lastError': serializer.toJson<String?>(lastError),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  CompendiumBootstrapState copyWith({
    String? rulesetId,
    String? assetVersion,
    String? state,
    double? progress,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => CompendiumBootstrapState(
    rulesetId: rulesetId ?? this.rulesetId,
    assetVersion: assetVersion ?? this.assetVersion,
    state: state ?? this.state,
    progress: progress ?? this.progress,
    lastError: lastError.present ? lastError.value : this.lastError,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  CompendiumBootstrapState copyWithCompanion(
    CompendiumBootstrapStatesCompanion data,
  ) {
    return CompendiumBootstrapState(
      rulesetId: data.rulesetId.present ? data.rulesetId.value : this.rulesetId,
      assetVersion: data.assetVersion.present
          ? data.assetVersion.value
          : this.assetVersion,
      state: data.state.present ? data.state.value : this.state,
      progress: data.progress.present ? data.progress.value : this.progress,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompendiumBootstrapState(')
          ..write('rulesetId: $rulesetId, ')
          ..write('assetVersion: $assetVersion, ')
          ..write('state: $state, ')
          ..write('progress: $progress, ')
          ..write('lastError: $lastError, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rulesetId,
    assetVersion,
    state,
    progress,
    lastError,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompendiumBootstrapState &&
          other.rulesetId == this.rulesetId &&
          other.assetVersion == this.assetVersion &&
          other.state == this.state &&
          other.progress == this.progress &&
          other.lastError == this.lastError &&
          other.updatedAt == this.updatedAt);
}

class CompendiumBootstrapStatesCompanion
    extends UpdateCompanion<CompendiumBootstrapState> {
  final Value<String> rulesetId;
  final Value<String> assetVersion;
  final Value<String> state;
  final Value<double> progress;
  final Value<String?> lastError;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const CompendiumBootstrapStatesCompanion({
    this.rulesetId = const Value.absent(),
    this.assetVersion = const Value.absent(),
    this.state = const Value.absent(),
    this.progress = const Value.absent(),
    this.lastError = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompendiumBootstrapStatesCompanion.insert({
    required String rulesetId,
    this.assetVersion = const Value.absent(),
    this.state = const Value.absent(),
    this.progress = const Value.absent(),
    this.lastError = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : rulesetId = Value(rulesetId);
  static Insertable<CompendiumBootstrapState> custom({
    Expression<String>? rulesetId,
    Expression<String>? assetVersion,
    Expression<String>? state,
    Expression<double>? progress,
    Expression<String>? lastError,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rulesetId != null) 'ruleset_id': rulesetId,
      if (assetVersion != null) 'asset_version': assetVersion,
      if (state != null) 'state': state,
      if (progress != null) 'progress': progress,
      if (lastError != null) 'last_error': lastError,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompendiumBootstrapStatesCompanion copyWith({
    Value<String>? rulesetId,
    Value<String>? assetVersion,
    Value<String>? state,
    Value<double>? progress,
    Value<String?>? lastError,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return CompendiumBootstrapStatesCompanion(
      rulesetId: rulesetId ?? this.rulesetId,
      assetVersion: assetVersion ?? this.assetVersion,
      state: state ?? this.state,
      progress: progress ?? this.progress,
      lastError: lastError ?? this.lastError,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rulesetId.present) {
      map['ruleset_id'] = Variable<String>(rulesetId.value);
    }
    if (assetVersion.present) {
      map['asset_version'] = Variable<String>(assetVersion.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompendiumBootstrapStatesCompanion(')
          ..write('rulesetId: $rulesetId, ')
          ..write('assetVersion: $assetVersion, ')
          ..write('state: $state, ')
          ..write('progress: $progress, ')
          ..write('lastError: $lastError, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterRecordsTable extends CharacterRecords
    with TableInfo<$CharacterRecordsTable, CharacterRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryRulesetIdMeta = const VerificationMeta(
    'primaryRulesetId',
  );
  @override
  late final GeneratedColumn<String> primaryRulesetId = GeneratedColumn<String>(
    'primary_ruleset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
    'last_opened_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    characterId,
    name,
    primaryRulesetId,
    payloadJson,
    createdAt,
    updatedAt,
    lastOpenedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('primary_ruleset_id')) {
      context.handle(
        _primaryRulesetIdMeta,
        primaryRulesetId.isAcceptableOrUnknown(
          data['primary_ruleset_id']!,
          _primaryRulesetIdMeta,
        ),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {characterId};
  @override
  CharacterRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterRecord(
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      primaryRulesetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_ruleset_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened_at'],
      ),
    );
  }

  @override
  $CharacterRecordsTable createAlias(String alias) {
    return $CharacterRecordsTable(attachedDatabase, alias);
  }
}

class CharacterRecord extends DataClass implements Insertable<CharacterRecord> {
  final String characterId;
  final String name;
  final String primaryRulesetId;
  final String payloadJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastOpenedAt;
  const CharacterRecord({
    required this.characterId,
    required this.name,
    required this.primaryRulesetId,
    required this.payloadJson,
    required this.createdAt,
    required this.updatedAt,
    this.lastOpenedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['character_id'] = Variable<String>(characterId);
    map['name'] = Variable<String>(name);
    map['primary_ruleset_id'] = Variable<String>(primaryRulesetId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    return map;
  }

  CharacterRecordsCompanion toCompanion(bool nullToAbsent) {
    return CharacterRecordsCompanion(
      characterId: Value(characterId),
      name: Value(name),
      primaryRulesetId: Value(primaryRulesetId),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastOpenedAt: lastOpenedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedAt),
    );
  }

  factory CharacterRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterRecord(
      characterId: serializer.fromJson<String>(json['characterId']),
      name: serializer.fromJson<String>(json['name']),
      primaryRulesetId: serializer.fromJson<String>(json['primaryRulesetId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'characterId': serializer.toJson<String>(characterId),
      'name': serializer.toJson<String>(name),
      'primaryRulesetId': serializer.toJson<String>(primaryRulesetId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
    };
  }

  CharacterRecord copyWith({
    String? characterId,
    String? name,
    String? primaryRulesetId,
    String? payloadJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastOpenedAt = const Value.absent(),
  }) => CharacterRecord(
    characterId: characterId ?? this.characterId,
    name: name ?? this.name,
    primaryRulesetId: primaryRulesetId ?? this.primaryRulesetId,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastOpenedAt: lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
  );
  CharacterRecord copyWithCompanion(CharacterRecordsCompanion data) {
    return CharacterRecord(
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      name: data.name.present ? data.name.value : this.name,
      primaryRulesetId: data.primaryRulesetId.present
          ? data.primaryRulesetId.value
          : this.primaryRulesetId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterRecord(')
          ..write('characterId: $characterId, ')
          ..write('name: $name, ')
          ..write('primaryRulesetId: $primaryRulesetId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    characterId,
    name,
    primaryRulesetId,
    payloadJson,
    createdAt,
    updatedAt,
    lastOpenedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterRecord &&
          other.characterId == this.characterId &&
          other.name == this.name &&
          other.primaryRulesetId == this.primaryRulesetId &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastOpenedAt == this.lastOpenedAt);
}

class CharacterRecordsCompanion extends UpdateCompanion<CharacterRecord> {
  final Value<String> characterId;
  final Value<String> name;
  final Value<String> primaryRulesetId;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastOpenedAt;
  final Value<int> rowid;
  const CharacterRecordsCompanion({
    this.characterId = const Value.absent(),
    this.name = const Value.absent(),
    this.primaryRulesetId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacterRecordsCompanion.insert({
    required String characterId,
    required String name,
    this.primaryRulesetId = const Value.absent(),
    required String payloadJson,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastOpenedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : characterId = Value(characterId),
       name = Value(name),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CharacterRecord> custom({
    Expression<String>? characterId,
    Expression<String>? name,
    Expression<String>? primaryRulesetId,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastOpenedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (characterId != null) 'character_id': characterId,
      if (name != null) 'name': name,
      if (primaryRulesetId != null) 'primary_ruleset_id': primaryRulesetId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacterRecordsCompanion copyWith({
    Value<String>? characterId,
    Value<String>? name,
    Value<String>? primaryRulesetId,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastOpenedAt,
    Value<int>? rowid,
  }) {
    return CharacterRecordsCompanion(
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      primaryRulesetId: primaryRulesetId ?? this.primaryRulesetId,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (primaryRulesetId.present) {
      map['primary_ruleset_id'] = Variable<String>(primaryRulesetId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterRecordsCompanion(')
          ..write('characterId: $characterId, ')
          ..write('name: $name, ')
          ..write('primaryRulesetId: $primaryRulesetId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CompendiumDatabase extends GeneratedDatabase {
  _$CompendiumDatabase(QueryExecutor e) : super(e);
  $CompendiumDatabaseManager get managers => $CompendiumDatabaseManager(this);
  late final $RulesetRecordsTable rulesetRecords = $RulesetRecordsTable(this);
  late final $EntityRecordsTable entityRecords = $EntityRecordsTable(this);
  late final $EntityLinksTable entityLinks = $EntityLinksTable(this);
  late final $RulesetCollectionStatsTable rulesetCollectionStats =
      $RulesetCollectionStatsTable(this);
  late final $CompendiumBootstrapStatesTable compendiumBootstrapStates =
      $CompendiumBootstrapStatesTable(this);
  late final $CharacterRecordsTable characterRecords = $CharacterRecordsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    rulesetRecords,
    entityRecords,
    entityLinks,
    rulesetCollectionStats,
    compendiumBootstrapStates,
    characterRecords,
  ];
}

typedef $$RulesetRecordsTableCreateCompanionBuilder =
    RulesetRecordsCompanion Function({
      required String rulesetId,
      required String name,
      Value<String> description,
      required String mode,
      required String schemaVersion,
      Value<String> author,
      Value<String> version,
      Value<String> license,
      Value<int> entityCount,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      required String filePath,
      Value<String> payloadJson,
      Value<String> extraJson,
      Value<int> rowid,
    });
typedef $$RulesetRecordsTableUpdateCompanionBuilder =
    RulesetRecordsCompanion Function({
      Value<String> rulesetId,
      Value<String> name,
      Value<String> description,
      Value<String> mode,
      Value<String> schemaVersion,
      Value<String> author,
      Value<String> version,
      Value<String> license,
      Value<int> entityCount,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<String> filePath,
      Value<String> payloadJson,
      Value<String> extraJson,
      Value<int> rowid,
    });

class $$RulesetRecordsTableFilterComposer
    extends Composer<_$CompendiumDatabase, $RulesetRecordsTable> {
  $$RulesetRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get license => $composableBuilder(
    column: $table.license,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityCount => $composableBuilder(
    column: $table.entityCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraJson => $composableBuilder(
    column: $table.extraJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RulesetRecordsTableOrderingComposer
    extends Composer<_$CompendiumDatabase, $RulesetRecordsTable> {
  $$RulesetRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get license => $composableBuilder(
    column: $table.license,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityCount => $composableBuilder(
    column: $table.entityCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraJson => $composableBuilder(
    column: $table.extraJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RulesetRecordsTableAnnotationComposer
    extends Composer<_$CompendiumDatabase, $RulesetRecordsTable> {
  $$RulesetRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get rulesetId =>
      $composableBuilder(column: $table.rulesetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get license =>
      $composableBuilder(column: $table.license, builder: (column) => column);

  GeneratedColumn<int> get entityCount => $composableBuilder(
    column: $table.entityCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extraJson =>
      $composableBuilder(column: $table.extraJson, builder: (column) => column);
}

class $$RulesetRecordsTableTableManager
    extends
        RootTableManager<
          _$CompendiumDatabase,
          $RulesetRecordsTable,
          RulesetRecord,
          $$RulesetRecordsTableFilterComposer,
          $$RulesetRecordsTableOrderingComposer,
          $$RulesetRecordsTableAnnotationComposer,
          $$RulesetRecordsTableCreateCompanionBuilder,
          $$RulesetRecordsTableUpdateCompanionBuilder,
          (
            RulesetRecord,
            BaseReferences<
              _$CompendiumDatabase,
              $RulesetRecordsTable,
              RulesetRecord
            >,
          ),
          RulesetRecord,
          PrefetchHooks Function()
        > {
  $$RulesetRecordsTableTableManager(
    _$CompendiumDatabase db,
    $RulesetRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RulesetRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RulesetRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RulesetRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> rulesetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> schemaVersion = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> license = const Value.absent(),
                Value<int> entityCount = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> extraJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RulesetRecordsCompanion(
                rulesetId: rulesetId,
                name: name,
                description: description,
                mode: mode,
                schemaVersion: schemaVersion,
                author: author,
                version: version,
                license: license,
                entityCount: entityCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                filePath: filePath,
                payloadJson: payloadJson,
                extraJson: extraJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String rulesetId,
                required String name,
                Value<String> description = const Value.absent(),
                required String mode,
                required String schemaVersion,
                Value<String> author = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> license = const Value.absent(),
                Value<int> entityCount = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required String filePath,
                Value<String> payloadJson = const Value.absent(),
                Value<String> extraJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RulesetRecordsCompanion.insert(
                rulesetId: rulesetId,
                name: name,
                description: description,
                mode: mode,
                schemaVersion: schemaVersion,
                author: author,
                version: version,
                license: license,
                entityCount: entityCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                filePath: filePath,
                payloadJson: payloadJson,
                extraJson: extraJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RulesetRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$CompendiumDatabase,
      $RulesetRecordsTable,
      RulesetRecord,
      $$RulesetRecordsTableFilterComposer,
      $$RulesetRecordsTableOrderingComposer,
      $$RulesetRecordsTableAnnotationComposer,
      $$RulesetRecordsTableCreateCompanionBuilder,
      $$RulesetRecordsTableUpdateCompanionBuilder,
      (
        RulesetRecord,
        BaseReferences<
          _$CompendiumDatabase,
          $RulesetRecordsTable,
          RulesetRecord
        >,
      ),
      RulesetRecord,
      PrefetchHooks Function()
    >;
typedef $$EntityRecordsTableCreateCompanionBuilder =
    EntityRecordsCompanion Function({
      required String rulesetId,
      required String entityType,
      required String entityId,
      required String collectionKey,
      required String name,
      Value<String> source,
      Value<String> sourceFile,
      Value<String?> edition,
      Value<String> sortName,
      Value<String> searchText,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$EntityRecordsTableUpdateCompanionBuilder =
    EntityRecordsCompanion Function({
      Value<String> rulesetId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> collectionKey,
      Value<String> name,
      Value<String> source,
      Value<String> sourceFile,
      Value<String?> edition,
      Value<String> sortName,
      Value<String> searchText,
      Value<String> payloadJson,
      Value<int> rowid,
    });

class $$EntityRecordsTableFilterComposer
    extends Composer<_$CompendiumDatabase, $EntityRecordsTable> {
  $$EntityRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collectionKey => $composableBuilder(
    column: $table.collectionKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceFile => $composableBuilder(
    column: $table.sourceFile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get edition => $composableBuilder(
    column: $table.edition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortName => $composableBuilder(
    column: $table.sortName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntityRecordsTableOrderingComposer
    extends Composer<_$CompendiumDatabase, $EntityRecordsTable> {
  $$EntityRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collectionKey => $composableBuilder(
    column: $table.collectionKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceFile => $composableBuilder(
    column: $table.sourceFile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get edition => $composableBuilder(
    column: $table.edition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortName => $composableBuilder(
    column: $table.sortName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntityRecordsTableAnnotationComposer
    extends Composer<_$CompendiumDatabase, $EntityRecordsTable> {
  $$EntityRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get rulesetId =>
      $composableBuilder(column: $table.rulesetId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get collectionKey => $composableBuilder(
    column: $table.collectionKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceFile => $composableBuilder(
    column: $table.sourceFile,
    builder: (column) => column,
  );

  GeneratedColumn<String> get edition =>
      $composableBuilder(column: $table.edition, builder: (column) => column);

  GeneratedColumn<String> get sortName =>
      $composableBuilder(column: $table.sortName, builder: (column) => column);

  GeneratedColumn<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$EntityRecordsTableTableManager
    extends
        RootTableManager<
          _$CompendiumDatabase,
          $EntityRecordsTable,
          EntityRecord,
          $$EntityRecordsTableFilterComposer,
          $$EntityRecordsTableOrderingComposer,
          $$EntityRecordsTableAnnotationComposer,
          $$EntityRecordsTableCreateCompanionBuilder,
          $$EntityRecordsTableUpdateCompanionBuilder,
          (
            EntityRecord,
            BaseReferences<
              _$CompendiumDatabase,
              $EntityRecordsTable,
              EntityRecord
            >,
          ),
          EntityRecord,
          PrefetchHooks Function()
        > {
  $$EntityRecordsTableTableManager(
    _$CompendiumDatabase db,
    $EntityRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntityRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntityRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntityRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> rulesetId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> collectionKey = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> sourceFile = const Value.absent(),
                Value<String?> edition = const Value.absent(),
                Value<String> sortName = const Value.absent(),
                Value<String> searchText = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntityRecordsCompanion(
                rulesetId: rulesetId,
                entityType: entityType,
                entityId: entityId,
                collectionKey: collectionKey,
                name: name,
                source: source,
                sourceFile: sourceFile,
                edition: edition,
                sortName: sortName,
                searchText: searchText,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String rulesetId,
                required String entityType,
                required String entityId,
                required String collectionKey,
                required String name,
                Value<String> source = const Value.absent(),
                Value<String> sourceFile = const Value.absent(),
                Value<String?> edition = const Value.absent(),
                Value<String> sortName = const Value.absent(),
                Value<String> searchText = const Value.absent(),
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => EntityRecordsCompanion.insert(
                rulesetId: rulesetId,
                entityType: entityType,
                entityId: entityId,
                collectionKey: collectionKey,
                name: name,
                source: source,
                sourceFile: sourceFile,
                edition: edition,
                sortName: sortName,
                searchText: searchText,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntityRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$CompendiumDatabase,
      $EntityRecordsTable,
      EntityRecord,
      $$EntityRecordsTableFilterComposer,
      $$EntityRecordsTableOrderingComposer,
      $$EntityRecordsTableAnnotationComposer,
      $$EntityRecordsTableCreateCompanionBuilder,
      $$EntityRecordsTableUpdateCompanionBuilder,
      (
        EntityRecord,
        BaseReferences<_$CompendiumDatabase, $EntityRecordsTable, EntityRecord>,
      ),
      EntityRecord,
      PrefetchHooks Function()
    >;
typedef $$EntityLinksTableCreateCompanionBuilder =
    EntityLinksCompanion Function({
      Value<int> id,
      required String rulesetId,
      required String sourceEntityType,
      required String sourceEntityId,
      required String targetTag,
      required String rawReference,
      required String displayText,
      Value<String?> sourceHint,
      Value<String?> targetEntityType,
    });
typedef $$EntityLinksTableUpdateCompanionBuilder =
    EntityLinksCompanion Function({
      Value<int> id,
      Value<String> rulesetId,
      Value<String> sourceEntityType,
      Value<String> sourceEntityId,
      Value<String> targetTag,
      Value<String> rawReference,
      Value<String> displayText,
      Value<String?> sourceHint,
      Value<String?> targetEntityType,
    });

class $$EntityLinksTableFilterComposer
    extends Composer<_$CompendiumDatabase, $EntityLinksTable> {
  $$EntityLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceEntityType => $composableBuilder(
    column: $table.sourceEntityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceEntityId => $composableBuilder(
    column: $table.sourceEntityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTag => $composableBuilder(
    column: $table.targetTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawReference => $composableBuilder(
    column: $table.rawReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayText => $composableBuilder(
    column: $table.displayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceHint => $composableBuilder(
    column: $table.sourceHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetEntityType => $composableBuilder(
    column: $table.targetEntityType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntityLinksTableOrderingComposer
    extends Composer<_$CompendiumDatabase, $EntityLinksTable> {
  $$EntityLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceEntityType => $composableBuilder(
    column: $table.sourceEntityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceEntityId => $composableBuilder(
    column: $table.sourceEntityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTag => $composableBuilder(
    column: $table.targetTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawReference => $composableBuilder(
    column: $table.rawReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayText => $composableBuilder(
    column: $table.displayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceHint => $composableBuilder(
    column: $table.sourceHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetEntityType => $composableBuilder(
    column: $table.targetEntityType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntityLinksTableAnnotationComposer
    extends Composer<_$CompendiumDatabase, $EntityLinksTable> {
  $$EntityLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rulesetId =>
      $composableBuilder(column: $table.rulesetId, builder: (column) => column);

  GeneratedColumn<String> get sourceEntityType => $composableBuilder(
    column: $table.sourceEntityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceEntityId => $composableBuilder(
    column: $table.sourceEntityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetTag =>
      $composableBuilder(column: $table.targetTag, builder: (column) => column);

  GeneratedColumn<String> get rawReference => $composableBuilder(
    column: $table.rawReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayText => $composableBuilder(
    column: $table.displayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceHint => $composableBuilder(
    column: $table.sourceHint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetEntityType => $composableBuilder(
    column: $table.targetEntityType,
    builder: (column) => column,
  );
}

class $$EntityLinksTableTableManager
    extends
        RootTableManager<
          _$CompendiumDatabase,
          $EntityLinksTable,
          EntityLink,
          $$EntityLinksTableFilterComposer,
          $$EntityLinksTableOrderingComposer,
          $$EntityLinksTableAnnotationComposer,
          $$EntityLinksTableCreateCompanionBuilder,
          $$EntityLinksTableUpdateCompanionBuilder,
          (
            EntityLink,
            BaseReferences<_$CompendiumDatabase, $EntityLinksTable, EntityLink>,
          ),
          EntityLink,
          PrefetchHooks Function()
        > {
  $$EntityLinksTableTableManager(
    _$CompendiumDatabase db,
    $EntityLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntityLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntityLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntityLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> rulesetId = const Value.absent(),
                Value<String> sourceEntityType = const Value.absent(),
                Value<String> sourceEntityId = const Value.absent(),
                Value<String> targetTag = const Value.absent(),
                Value<String> rawReference = const Value.absent(),
                Value<String> displayText = const Value.absent(),
                Value<String?> sourceHint = const Value.absent(),
                Value<String?> targetEntityType = const Value.absent(),
              }) => EntityLinksCompanion(
                id: id,
                rulesetId: rulesetId,
                sourceEntityType: sourceEntityType,
                sourceEntityId: sourceEntityId,
                targetTag: targetTag,
                rawReference: rawReference,
                displayText: displayText,
                sourceHint: sourceHint,
                targetEntityType: targetEntityType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String rulesetId,
                required String sourceEntityType,
                required String sourceEntityId,
                required String targetTag,
                required String rawReference,
                required String displayText,
                Value<String?> sourceHint = const Value.absent(),
                Value<String?> targetEntityType = const Value.absent(),
              }) => EntityLinksCompanion.insert(
                id: id,
                rulesetId: rulesetId,
                sourceEntityType: sourceEntityType,
                sourceEntityId: sourceEntityId,
                targetTag: targetTag,
                rawReference: rawReference,
                displayText: displayText,
                sourceHint: sourceHint,
                targetEntityType: targetEntityType,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntityLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$CompendiumDatabase,
      $EntityLinksTable,
      EntityLink,
      $$EntityLinksTableFilterComposer,
      $$EntityLinksTableOrderingComposer,
      $$EntityLinksTableAnnotationComposer,
      $$EntityLinksTableCreateCompanionBuilder,
      $$EntityLinksTableUpdateCompanionBuilder,
      (
        EntityLink,
        BaseReferences<_$CompendiumDatabase, $EntityLinksTable, EntityLink>,
      ),
      EntityLink,
      PrefetchHooks Function()
    >;
typedef $$RulesetCollectionStatsTableCreateCompanionBuilder =
    RulesetCollectionStatsCompanion Function({
      required String rulesetId,
      required String entityType,
      required String collectionKey,
      required String label,
      Value<int> entityCount,
      Value<int> rowid,
    });
typedef $$RulesetCollectionStatsTableUpdateCompanionBuilder =
    RulesetCollectionStatsCompanion Function({
      Value<String> rulesetId,
      Value<String> entityType,
      Value<String> collectionKey,
      Value<String> label,
      Value<int> entityCount,
      Value<int> rowid,
    });

class $$RulesetCollectionStatsTableFilterComposer
    extends Composer<_$CompendiumDatabase, $RulesetCollectionStatsTable> {
  $$RulesetCollectionStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collectionKey => $composableBuilder(
    column: $table.collectionKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityCount => $composableBuilder(
    column: $table.entityCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RulesetCollectionStatsTableOrderingComposer
    extends Composer<_$CompendiumDatabase, $RulesetCollectionStatsTable> {
  $$RulesetCollectionStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collectionKey => $composableBuilder(
    column: $table.collectionKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityCount => $composableBuilder(
    column: $table.entityCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RulesetCollectionStatsTableAnnotationComposer
    extends Composer<_$CompendiumDatabase, $RulesetCollectionStatsTable> {
  $$RulesetCollectionStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get rulesetId =>
      $composableBuilder(column: $table.rulesetId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get collectionKey => $composableBuilder(
    column: $table.collectionKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get entityCount => $composableBuilder(
    column: $table.entityCount,
    builder: (column) => column,
  );
}

class $$RulesetCollectionStatsTableTableManager
    extends
        RootTableManager<
          _$CompendiumDatabase,
          $RulesetCollectionStatsTable,
          RulesetCollectionStat,
          $$RulesetCollectionStatsTableFilterComposer,
          $$RulesetCollectionStatsTableOrderingComposer,
          $$RulesetCollectionStatsTableAnnotationComposer,
          $$RulesetCollectionStatsTableCreateCompanionBuilder,
          $$RulesetCollectionStatsTableUpdateCompanionBuilder,
          (
            RulesetCollectionStat,
            BaseReferences<
              _$CompendiumDatabase,
              $RulesetCollectionStatsTable,
              RulesetCollectionStat
            >,
          ),
          RulesetCollectionStat,
          PrefetchHooks Function()
        > {
  $$RulesetCollectionStatsTableTableManager(
    _$CompendiumDatabase db,
    $RulesetCollectionStatsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RulesetCollectionStatsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RulesetCollectionStatsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RulesetCollectionStatsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> rulesetId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> collectionKey = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> entityCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RulesetCollectionStatsCompanion(
                rulesetId: rulesetId,
                entityType: entityType,
                collectionKey: collectionKey,
                label: label,
                entityCount: entityCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String rulesetId,
                required String entityType,
                required String collectionKey,
                required String label,
                Value<int> entityCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RulesetCollectionStatsCompanion.insert(
                rulesetId: rulesetId,
                entityType: entityType,
                collectionKey: collectionKey,
                label: label,
                entityCount: entityCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RulesetCollectionStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$CompendiumDatabase,
      $RulesetCollectionStatsTable,
      RulesetCollectionStat,
      $$RulesetCollectionStatsTableFilterComposer,
      $$RulesetCollectionStatsTableOrderingComposer,
      $$RulesetCollectionStatsTableAnnotationComposer,
      $$RulesetCollectionStatsTableCreateCompanionBuilder,
      $$RulesetCollectionStatsTableUpdateCompanionBuilder,
      (
        RulesetCollectionStat,
        BaseReferences<
          _$CompendiumDatabase,
          $RulesetCollectionStatsTable,
          RulesetCollectionStat
        >,
      ),
      RulesetCollectionStat,
      PrefetchHooks Function()
    >;
typedef $$CompendiumBootstrapStatesTableCreateCompanionBuilder =
    CompendiumBootstrapStatesCompanion Function({
      required String rulesetId,
      Value<String> assetVersion,
      Value<String> state,
      Value<double> progress,
      Value<String?> lastError,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$CompendiumBootstrapStatesTableUpdateCompanionBuilder =
    CompendiumBootstrapStatesCompanion Function({
      Value<String> rulesetId,
      Value<String> assetVersion,
      Value<String> state,
      Value<double> progress,
      Value<String?> lastError,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$CompendiumBootstrapStatesTableFilterComposer
    extends Composer<_$CompendiumDatabase, $CompendiumBootstrapStatesTable> {
  $$CompendiumBootstrapStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetVersion => $composableBuilder(
    column: $table.assetVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompendiumBootstrapStatesTableOrderingComposer
    extends Composer<_$CompendiumDatabase, $CompendiumBootstrapStatesTable> {
  $$CompendiumBootstrapStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get rulesetId => $composableBuilder(
    column: $table.rulesetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetVersion => $composableBuilder(
    column: $table.assetVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompendiumBootstrapStatesTableAnnotationComposer
    extends Composer<_$CompendiumDatabase, $CompendiumBootstrapStatesTable> {
  $$CompendiumBootstrapStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get rulesetId =>
      $composableBuilder(column: $table.rulesetId, builder: (column) => column);

  GeneratedColumn<String> get assetVersion => $composableBuilder(
    column: $table.assetVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CompendiumBootstrapStatesTableTableManager
    extends
        RootTableManager<
          _$CompendiumDatabase,
          $CompendiumBootstrapStatesTable,
          CompendiumBootstrapState,
          $$CompendiumBootstrapStatesTableFilterComposer,
          $$CompendiumBootstrapStatesTableOrderingComposer,
          $$CompendiumBootstrapStatesTableAnnotationComposer,
          $$CompendiumBootstrapStatesTableCreateCompanionBuilder,
          $$CompendiumBootstrapStatesTableUpdateCompanionBuilder,
          (
            CompendiumBootstrapState,
            BaseReferences<
              _$CompendiumDatabase,
              $CompendiumBootstrapStatesTable,
              CompendiumBootstrapState
            >,
          ),
          CompendiumBootstrapState,
          PrefetchHooks Function()
        > {
  $$CompendiumBootstrapStatesTableTableManager(
    _$CompendiumDatabase db,
    $CompendiumBootstrapStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompendiumBootstrapStatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CompendiumBootstrapStatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CompendiumBootstrapStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> rulesetId = const Value.absent(),
                Value<String> assetVersion = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompendiumBootstrapStatesCompanion(
                rulesetId: rulesetId,
                assetVersion: assetVersion,
                state: state,
                progress: progress,
                lastError: lastError,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String rulesetId,
                Value<String> assetVersion = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompendiumBootstrapStatesCompanion.insert(
                rulesetId: rulesetId,
                assetVersion: assetVersion,
                state: state,
                progress: progress,
                lastError: lastError,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompendiumBootstrapStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$CompendiumDatabase,
      $CompendiumBootstrapStatesTable,
      CompendiumBootstrapState,
      $$CompendiumBootstrapStatesTableFilterComposer,
      $$CompendiumBootstrapStatesTableOrderingComposer,
      $$CompendiumBootstrapStatesTableAnnotationComposer,
      $$CompendiumBootstrapStatesTableCreateCompanionBuilder,
      $$CompendiumBootstrapStatesTableUpdateCompanionBuilder,
      (
        CompendiumBootstrapState,
        BaseReferences<
          _$CompendiumDatabase,
          $CompendiumBootstrapStatesTable,
          CompendiumBootstrapState
        >,
      ),
      CompendiumBootstrapState,
      PrefetchHooks Function()
    >;
typedef $$CharacterRecordsTableCreateCompanionBuilder =
    CharacterRecordsCompanion Function({
      required String characterId,
      required String name,
      Value<String> primaryRulesetId,
      required String payloadJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> lastOpenedAt,
      Value<int> rowid,
    });
typedef $$CharacterRecordsTableUpdateCompanionBuilder =
    CharacterRecordsCompanion Function({
      Value<String> characterId,
      Value<String> name,
      Value<String> primaryRulesetId,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastOpenedAt,
      Value<int> rowid,
    });

class $$CharacterRecordsTableFilterComposer
    extends Composer<_$CompendiumDatabase, $CharacterRecordsTable> {
  $$CharacterRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get characterId => $composableBuilder(
    column: $table.characterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryRulesetId => $composableBuilder(
    column: $table.primaryRulesetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CharacterRecordsTableOrderingComposer
    extends Composer<_$CompendiumDatabase, $CharacterRecordsTable> {
  $$CharacterRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get characterId => $composableBuilder(
    column: $table.characterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryRulesetId => $composableBuilder(
    column: $table.primaryRulesetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CharacterRecordsTableAnnotationComposer
    extends Composer<_$CompendiumDatabase, $CharacterRecordsTable> {
  $$CharacterRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get characterId => $composableBuilder(
    column: $table.characterId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get primaryRulesetId => $composableBuilder(
    column: $table.primaryRulesetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );
}

class $$CharacterRecordsTableTableManager
    extends
        RootTableManager<
          _$CompendiumDatabase,
          $CharacterRecordsTable,
          CharacterRecord,
          $$CharacterRecordsTableFilterComposer,
          $$CharacterRecordsTableOrderingComposer,
          $$CharacterRecordsTableAnnotationComposer,
          $$CharacterRecordsTableCreateCompanionBuilder,
          $$CharacterRecordsTableUpdateCompanionBuilder,
          (
            CharacterRecord,
            BaseReferences<
              _$CompendiumDatabase,
              $CharacterRecordsTable,
              CharacterRecord
            >,
          ),
          CharacterRecord,
          PrefetchHooks Function()
        > {
  $$CharacterRecordsTableTableManager(
    _$CompendiumDatabase db,
    $CharacterRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> characterId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> primaryRulesetId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterRecordsCompanion(
                characterId: characterId,
                name: name,
                primaryRulesetId: primaryRulesetId,
                payloadJson: payloadJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastOpenedAt: lastOpenedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String characterId,
                required String name,
                Value<String> primaryRulesetId = const Value.absent(),
                required String payloadJson,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> lastOpenedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterRecordsCompanion.insert(
                characterId: characterId,
                name: name,
                primaryRulesetId: primaryRulesetId,
                payloadJson: payloadJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastOpenedAt: lastOpenedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CharacterRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$CompendiumDatabase,
      $CharacterRecordsTable,
      CharacterRecord,
      $$CharacterRecordsTableFilterComposer,
      $$CharacterRecordsTableOrderingComposer,
      $$CharacterRecordsTableAnnotationComposer,
      $$CharacterRecordsTableCreateCompanionBuilder,
      $$CharacterRecordsTableUpdateCompanionBuilder,
      (
        CharacterRecord,
        BaseReferences<
          _$CompendiumDatabase,
          $CharacterRecordsTable,
          CharacterRecord
        >,
      ),
      CharacterRecord,
      PrefetchHooks Function()
    >;

class $CompendiumDatabaseManager {
  final _$CompendiumDatabase _db;
  $CompendiumDatabaseManager(this._db);
  $$RulesetRecordsTableTableManager get rulesetRecords =>
      $$RulesetRecordsTableTableManager(_db, _db.rulesetRecords);
  $$EntityRecordsTableTableManager get entityRecords =>
      $$EntityRecordsTableTableManager(_db, _db.entityRecords);
  $$EntityLinksTableTableManager get entityLinks =>
      $$EntityLinksTableTableManager(_db, _db.entityLinks);
  $$RulesetCollectionStatsTableTableManager get rulesetCollectionStats =>
      $$RulesetCollectionStatsTableTableManager(
        _db,
        _db.rulesetCollectionStats,
      );
  $$CompendiumBootstrapStatesTableTableManager get compendiumBootstrapStates =>
      $$CompendiumBootstrapStatesTableTableManager(
        _db,
        _db.compendiumBootstrapStates,
      );
  $$CharacterRecordsTableTableManager get characterRecords =>
      $$CharacterRecordsTableTableManager(_db, _db.characterRecords);
}
