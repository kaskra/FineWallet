import 'package:FineWallet/core/datatypes/history_filter_state.dart';
import 'package:FineWallet/data/extensions/string_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class holds all keys needed to save and retrieve values
/// from the [SharedPreferences] memory.
///
class _KEYS {
  static const darkMode = "dark_mode";
  static const currency = "currency";
  static const txShare = "tx_share";
  static const profileChart = "default_profile_chart";
  static const showFilterSettings = "show_filter_settings";
  static const filterSettings = "default_filter_settings";
  static const initialized = "initialized";
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

  /// Sets the value whether the user has gone through the intro pages.
  ///
  /// The default value is FALSE.
  ///
  /// Input
  /// -----
  /// Value as [bool] to save persistently.
  ///
  static void setInitialized({bool val}) {
    _store.setBool(_KEYS.initialized, val);
  }

  /// Returns the value whether the user has gone through the intro pages.
  ///
  /// The default value is FALSE.
  ///
  /// Return
  /// -----
  /// True if dark mode is enabled, false otherwise.
  ///
  static bool getInitialized() {
    return _store.getBool(_KEYS.initialized) ?? false;
  }

  /// Sets the value whether dark mode is enabled or not.
  ///
  /// The default value is FALSE.
  ///
  /// Input
  /// -----
  /// Value as [bool] to save persistently.
  ///
  static void setDarkMode({bool val}) {
    _store.setBool(_KEYS.darkMode, val);
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
    return _store.getBool(_KEYS.darkMode) ?? false;
  }

  /// Sets the applications currency id to the selected symbol and
  /// saves it persistently in the user settings.
  ///
  /// The default currency is USD.
  ///
  /// Input
  /// -----
  /// The selected currency id.
  ///
  static void setInputCurrency(int currencyId) {
    _store.setInt(_KEYS.currency, currencyId);
  }

  /// Returns the applications currency id saved in memory.
  ///
  /// The default currency is USD.
  ///
  /// Returns
  /// -----
  /// The retrieved currency id from user settings memory.
  ///
  static int getInputCurrency() {
    return _store.getInt(_KEYS.currency) ?? 1;
  }

  /// Sets the value whether TX SHARE is enabled or not.
  ///
  /// The default value is TRUE.
  ///
  /// Input
  /// -----
  /// Value as [bool] to save persistently.
  ///
  static void setTXShare({bool val}) {
    _store.setBool(_KEYS.txShare, val);
  }

  /// Returns the value whether TX SHARE is enabled or not.
  ///
  /// The default value is TRUE.
  ///
  /// Return
  /// ------
  /// True if TX SHARE is enabled, false otherwise.
  static bool getTXShare() {
    return _store.getBool(_KEYS.txShare) ?? true;
  }

  /// Sets the id of the default profile chart in the persistent store.
  ///
  /// The default profile chart is the chart that is shown first,
  /// when entering the profile page.
  ///
  /// Possible IDs:
  ///
  ///  - 0 = Monthly expenses
  ///
  ///  - 1 = Lifetime expenses
  ///
  /// Input
  /// ------
  /// Id as [int] of the profile chart.
  ///
  static void setDefaultProfileChart(int chartId) {
    _store.setInt(_KEYS.profileChart, chartId);
  }

  /// Returns the id of the default profile chart.
  ///
  /// The default profile chart is the chart that is shown first,
  /// when entering the profile page.
  ///
  /// Possible IDs:
  ///
  ///  - 0 = Monthly expenses
  ///
  ///  - 1 = Lifetime expenses
  ///
  /// Return
  /// ------
  /// Id as [int] of the profile chart.
  ///
  static int getDefaultProfileChart() {
    // 1 = Categories
    // 2 = Prediction
    return _store.getInt(_KEYS.profileChart) ?? 0;
  }

  /// Sets the value whether Filter Settings are enabled or not.
  ///
  /// The default value is TRUE.
  ///
  /// Input
  /// -----
  /// Value as [bool] to save persistently.
  ///
  static void setShowFilterSettings({bool val}) {
    _store.setBool(_KEYS.showFilterSettings, val);
  }

  /// Returns the value whether Filter Settings are enabled or not.
  ///
  /// The default value is TRUE.
  ///
  /// Return
  /// ------
  /// True if Filter Settings are enabled, false otherwise.
  static bool getShowFilterSettings() {
    return _store.getBool(_KEYS.showFilterSettings) ?? true;
  }

  /// Sets the default history filter values in the persistent store.
  ///
  /// The default history filter values are the values by which the history
  /// is filtered by default when entering the page.
  ///
  /// Fields:
  ///
  ///  - only Expenses (by default: true)
  ///
  ///  - only Incomes (by default: true)
  ///
  ///  - show Future (by default : false)
  ///
  /// Input
  /// ------
  /// [HistoryFilterState] to save.
  ///
  static void setDefaultFilterSettings(HistoryFilterState state) {
    final onlyExp = state.onlyExpenses.toString();
    final onlyInc = state.onlyIncomes.toString();
    final showFuture = state.showFuture.toString();

    _store.setStringList(_KEYS.filterSettings, [onlyExp, onlyInc, showFuture]);
  }

  /// Returns the the default history filter values.
  ///
  /// The default history filter values are the values by which the history
  /// is filtered by default when entering the page.
  ///
  /// Fields:
  ///
  ///  - only Expenses (by default: true)
  ///
  ///  - only Incomes (by default: true)
  ///
  ///  - show Future (by default : false)
  ///
  /// Return
  /// ------
  /// [HistoryFilterState] read from persistent storage.
  ///
  static HistoryFilterState getDefaultFilterSettings() {
    final values = _store.getStringList(_KEYS.filterSettings);

    if (values != null) {
      final onlyExp = values[0].toBool();
      final onlyInc = values[1].toBool();
      final showFuture = values[2].toBool();
      final filterState = HistoryFilterState()
        ..onlyIncomes = onlyInc
        ..onlyExpenses = onlyExp
        ..showFuture = showFuture;
      return filterState;
    }
    return HistoryFilterState();
  }
}
