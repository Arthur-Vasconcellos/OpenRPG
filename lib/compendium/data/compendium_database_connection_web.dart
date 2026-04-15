import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openCompendiumDatabaseConnection() {
  return WebDatabase('openrpg_compendium');
}
