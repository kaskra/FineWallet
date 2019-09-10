/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:19:00 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

class Migration {
  static Map<int, List<String>> migrationScripts = {
    1: _migration_1_2,
    2: _migration_2_3,
  };

  static List<String> _migration_1_2 = [
    "ALTER TABLE transactions ADD COLUMN isRecurring INTEGER DEFAULT 0;",
    "ALTER TABLE transactions ADD COLUMN replayType INTEGER DEFAULT 0;",
    "ALTER TABLE transactions ADD COLUMN replayUntil INTEGER DEFAULT null;"
  ];

  static List<String> _migration_2_3 = [
    "CREATE TABLE months ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "savings REAL, "
        "currentMaxBudget REAL, "
        "firstOfMonth INTEGER,"
        "monthlyExpenses REAL"
        ")"
  ];
}
