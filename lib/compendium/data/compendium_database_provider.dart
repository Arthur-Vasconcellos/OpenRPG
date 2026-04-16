import 'package:openrpg/compendium/data/compendium_database.dart';

/// Provides the single shared compendium database instance used by the app.
///
/// Opening multiple Drift database instances against the same on-device SQLite
/// file can race during startup and migrations, which is especially visible on
/// Android as "database is locked" errors. Keeping one shared instance avoids
/// that class of failure.
final CompendiumDatabase sharedCompendiumDatabase = CompendiumDatabase();
