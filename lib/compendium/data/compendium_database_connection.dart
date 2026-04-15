import 'package:drift/drift.dart';

import 'compendium_database_connection_stub.dart'
    if (dart.library.io) 'compendium_database_connection_native.dart'
    if (dart.library.html) 'compendium_database_connection_web.dart'
    as impl;

QueryExecutor openCompendiumDatabaseConnection() =>
    impl.openCompendiumDatabaseConnection();
