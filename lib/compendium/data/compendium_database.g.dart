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

abstract class _$CompendiumDatabase extends GeneratedDatabase {
  _$CompendiumDatabase(QueryExecutor e) : super(e);
  $CompendiumDatabaseManager get managers => $CompendiumDatabaseManager(this);
  late final $RulesetRecordsTable rulesetRecords = $RulesetRecordsTable(this);
  late final $EntityRecordsTable entityRecords = $EntityRecordsTable(this);
  late final $EntityLinksTable entityLinks = $EntityLinksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    rulesetRecords,
    entityRecords,
    entityLinks,
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

class $CompendiumDatabaseManager {
  final _$CompendiumDatabase _db;
  $CompendiumDatabaseManager(this._db);
  $$RulesetRecordsTableTableManager get rulesetRecords =>
      $$RulesetRecordsTableTableManager(_db, _db.rulesetRecords);
  $$EntityRecordsTableTableManager get entityRecords =>
      $$EntityRecordsTableTableManager(_db, _db.entityRecords);
  $$EntityLinksTableTableManager get entityLinks =>
      $$EntityLinksTableTableManager(_db, _db.entityLinks);
}
