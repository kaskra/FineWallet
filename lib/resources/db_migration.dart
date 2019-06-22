/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

class Migration {
  static Map<int, List<String>> migrationScripts = {
    1: _migration_1_2,
  };

  static List<String> _migration_1_2 = [
    "ALTER TABLE transactions ADD COLUMN isRecurring INTEGER DEFAULT 0;",
    "ALTER TABLE transactions ADD COLUMN replayType INTEGER DEFAULT 0;",
    "ALTER TABLE transactions ADD COLUMN replayUntil INTEGER DEFAULT null;"
  ];
}
