import 'package:shared_preferences/shared_preferences.dart';

class _Keys {
  static const DARK_MODE = "dark_mode";
  static const LANGUAGE = "language";
  static const CURRENCY = "currency";
  static const TX_SHARE = "tx_share";
  static const PROFILE_CHART = "default_profile_chart";
}

class UserSettings {
  static SharedPreferences store;
  static Future init() async {
    store = await SharedPreferences.getInstance();
  }

  static setDarkMode(bool val) {
    store.setBool(_Keys.DARK_MODE, val);
  }

  static bool getDarkMode() {
    return store.getBool(_Keys.DARK_MODE) ?? false;
  }
}
