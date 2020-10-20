import 'package:FineWallet/data/moor_database.dart';
import 'package:moor_flutter/moor_flutter.dart';

void migrate_1_2(Migrator migration, int from, int to, AppDatabase db) {
  if (from <= 2) {
    migration.createTable(db.userProfiles);
  }
}
