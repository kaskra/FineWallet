part of 'settings_page.dart';

/// This class creates a [SettingSection] which shows the appearance
/// settings, like Dark Mode.
class AppearanceSection extends StatefulWidget {
  @override
  _AppearanceSectionState createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends State<AppearanceSection> {
  bool _isFilterSettings = true;
  bool _isDarkMode = true;

  @override
  void initState() {
    setState(() {
      _isFilterSettings = UserSettings.getShowFilterSettings();
      _isDarkMode = UserSettings.getDarkMode();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingSection(
      title: LocaleKeys.settings_page_appearance.tr(),
      items: [
        _buildDarkModeSwitch(),
        _buildFilterSettingsSwitch(),
        _buildLanguage(),
      ],
    );
  }

  Widget _buildDarkModeSwitch() {
    return SettingSwitchItem(
        title: LocaleKeys.settings_page_dark_mode.tr(),
        description: LocaleKeys.settings_page_dark_mode_desc.tr(),
        value: _isDarkMode,
        onChanged: (val) {
          Provider.of<ThemeNotifier>(context, listen: false)
              .switchTheme(dark: val);
          setState(() {
            _isDarkMode = val;
          });
        });
  }

  Widget _buildFilterSettingsSwitch() {
    return SettingSwitchItem(
        title: LocaleKeys.settings_page_enable_filter.tr(),
        description: LocaleKeys.settings_page_enable_filter_desc.tr(),
        value: _isFilterSettings,
        onChanged: (val) {
          UserSettings.setShowFilterSettings(val: val);
          setState(() {
            _isFilterSettings = val;
          });
        });
  }

  Widget _buildLanguage() {
    final items = context.supportedLocales.asMap();

    return SettingPageItem(
      title: LocaleKeys.settings_page_language.plural(1),
      displayValue: context.locale.getFullLanguageName(),
      onTap: () async {
        final int res = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SelectionPage(
                pageTitle: LocaleKeys.settings_page_language.plural(10),
                selectedIndex: context.supportedLocales.indexOf(context.locale),
                data: items.map((key, value) =>
                    MapEntry(key, value.getFullLanguageName()))),
          ),
        );
        if (res != null) {
          EasyLocalization.of(context).setLocale(items[res]);
        }
      },
    );
  }
}
