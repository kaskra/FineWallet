import 'package:moor/moor.dart';

import 'database/database_suite.dart';

void main() {
  moorRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  runDatabaseTests();
}
