import 'package:drift/drift.dart';

import 'compendium_database_connection.dart';

part 'compendium_database.g.dart';

class RulesetRecords extends Table {
  TextColumn get rulesetId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get mode => text()();
  TextColumn get schemaVersion => text()();
  TextColumn get author => text().withDefault(const Constant(''))();
  TextColumn get version => text().withDefault(const Constant('1.0.0'))();
  TextColumn get license => text().withDefault(const Constant(''))();
  IntColumn get entityCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get filePath => text()();
  TextColumn get payloadJson => text().withDefault(const Constant('{}'))();
  TextColumn get extraJson => text().withDefault(const Constant('{}'))();

  @override
  Set<Column<Object>> get primaryKey => {rulesetId};
}

class EntityRecords extends Table {
  TextColumn get rulesetId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get collectionKey => text()();
  TextColumn get name => text()();
  TextColumn get source => text().withDefault(const Constant(''))();
  TextColumn get sourceFile => text().withDefault(const Constant(''))();
  TextColumn get edition => text().nullable()();
  TextColumn get sortName => text().withDefault(const Constant(''))();
  TextColumn get searchText => text().withDefault(const Constant(''))();
  TextColumn get payloadJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {rulesetId, entityType, entityId};
}

class EntityLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get rulesetId => text()();
  TextColumn get sourceEntityType => text()();
  TextColumn get sourceEntityId => text()();
  TextColumn get targetTag => text()();
  TextColumn get rawReference => text()();
  TextColumn get displayText => text()();
  TextColumn get sourceHint => text().nullable()();
  TextColumn get targetEntityType => text().nullable()();
}

class RulesetCollectionStats extends Table {
  TextColumn get rulesetId => text()();
  TextColumn get entityType => text()();
  TextColumn get collectionKey => text()();
  TextColumn get label => text()();
  IntColumn get entityCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {rulesetId, entityType};
}

class CompendiumBootstrapStates extends Table {
  TextColumn get rulesetId => text()();
  TextColumn get assetVersion => text().withDefault(const Constant(''))();
  TextColumn get state => text().withDefault(const Constant('idle'))();
  RealColumn get progress => real().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {rulesetId};
}

@DriftDatabase(
  tables: [
    RulesetRecords,
    EntityRecords,
    EntityLinks,
    RulesetCollectionStats,
    CompendiumBootstrapStates,
  ],
)
class CompendiumDatabase extends _$CompendiumDatabase {
  CompendiumDatabase({QueryExecutor? executor})
    : super(executor ?? openCompendiumDatabaseConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(rulesetRecords, rulesetRecords.payloadJson);
      }
      if (from < 3) {
        await migrator.createTable(rulesetCollectionStats);
        await migrator.createTable(compendiumBootstrapStates);
      }
    },
  );
}
