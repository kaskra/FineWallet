import 'package:shared_preferences/shared_preferences.dart';

/// This class holds all keys needed to save and retrieve values
/// from the [SharedPreferences] memory.
///
class _Keys {
  static const DARK_MODE = "dark_mode";
  static const LANGUAGE = "language";
  static const CURRENCY = "currency";
  static const TX_SHARE = "tx_share";
  static const PROFILE_CHART = "default_profile_chart";
}

/// This class is used to save user settings/preferences to persistent
/// memory using the [SharedPreferences].
///
/// While application start up, a static reference to [SharedPreferences]
/// is established to simply future API calls on this class.
///
/// Due to the static reference every consecutive call should
/// not need to be async.
///
class UserSettings {
  /// A static reference to a [SharedPreferences] object.
  static SharedPreferences _store;

  // Initialize shared preferences to be not async for future API calls.
  static Future init() async {
    _store = await SharedPreferences.getInstance();
  }

  /// Sets the value whether dark mode is enabled or not.
  ///
  /// The default value is FALSE.
  ///
  /// Input
  /// -----
  /// Value as [bool] to save persistently.
  ///
  static setDarkMode(bool val) {
    _store.setBool(_Keys.DARK_MODE, val);
  }

  /// Returns the value whether dark mode is enabled or not.
  ///
  /// The default value is FALSE.
  ///
  /// Return
  /// -----
  /// True if dark mode is enabled, false otherwise.
  ///
  static bool getDarkMode() {
    return _store.getBool(_Keys.DARK_MODE) ?? false;
  }

  /// Sets the applications language code to the selected code and
  /// saves it persistently in the user settings.
  ///
  /// The default value is 'EN'.
  ///
  /// Input
  /// -----
  /// The selected language code.
  ///
  static setLanguage(String languageCode) {
    _store.setString(_Keys.LANGUAGE, languageCode);
  }

  /// Returns the applications language code saved in memory.
  ///
  /// The default value is 'EN'.
  ///
  /// Returns
  /// -----
  /// The retrieved language code from user settings memory.
  ///
  static String getLanguage() {
    return _store.getString(_Keys.LANGUAGE) ?? "en";
  }

  /// Sets the applications currency symbol to the selected symbol and
  /// saves it persistently in the user settings.
  ///
  /// The default value is '$'.
  ///
  /// Input
  /// -----
  /// The selected currency symbol.
  ///
  static setCurrency(String currencySymbol) {
    _store.setString(_Keys.CURRENCY, currencySymbol);
  }

  /// Returns the applications currency symbol saved in memory.
  ///
  /// The default value is '$'.
  ///
  /// Returns
  /// -----
  /// The retrieved currency symbol from user settings memory.
  ///
  static getCurrency() {
    return _store.getString(_Keys.CURRENCY) ?? "\$";
  }

  /// Sets the value whether TX SHARE is enabled or not.
  ///
  /// The default value is TRUE.
  ///
  /// Input
  /// -----
  /// Value as [bool] to save persistently.
  ///
  static setTXShare(bool val) {
    _store.setBool(_Keys.TX_SHARE, val);
  }

  /// Returns the value whether TX SHARE is enabled or not.
  ///
  /// The default value is TRUE.
  ///
  /// Return
  /// ------
  /// True if TX SHARE is enabled, false otherwise.
  static bool getTXShare() {
    return _store.getBool(_Keys.TX_SHARE) ?? true;
  }

  /// Sets the id of the default profile chart in the persistent store.
  ///
  /// The default profile chart is the chart that is shown first,
  /// when entering the profile page.
  ///
  /// Possible IDs:
  ///
  ///  - 1 = Categories
  ///
  ///  - 2 = Prediction
  ///
  /// Input
  /// ------
  /// Id as [int] of the profile chart.
  ///
  static setDefaultProfileChart(int chartId) {
    _store.setInt(_Keys.PROFILE_CHART, chartId);
  }

  /// Returns the id of the default profile chart.
  ///
  /// The default profile chart is the chart that is shown first,
  /// when entering the profile page.
  ///
  /// Possible IDs:
  ///
  ///  - 1 = Categories
  ///
  ///  - 2 = Prediction
  ///
  /// Return
  /// ------
  /// Id as [int] of the profile chart.
  ///
  static int getDefaultProfileChart() {
    // 1 = Categories
    // 2 = Prediction
    return _store.getInt(_Keys.PROFILE_CHART) ?? 1;
  }
}
