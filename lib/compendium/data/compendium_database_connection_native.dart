import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

QueryExecutor openCompendiumDatabaseConnection() {
  return LazyDatabase(() async {
    final root = await getApplicationSupportDirectory();
    final dbDirectory = Directory(p.join(root.path, 'openrpg_compendium'));
    await dbDirectory.create(recursive: true);
    final file = File(p.join(dbDirectory.path, 'compendium.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
