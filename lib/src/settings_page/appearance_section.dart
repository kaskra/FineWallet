part of 'settings_page.dart';

/// This class creates a [Section] which shows the appearance
/// settings, like Dark Mode.
class AppearanceSection extends StatefulWidget {
  @override
  _AppearanceSectionState createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends State<AppearanceSection> {
  bool _isFilterSettings = true;

  @override
  void initState() {
    setState(() {
      _isFilterSettings = UserSettings.getShowFilterSettings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      title: LocaleKeys.settings_page_appearance.tr(),
      children: <SectionItem>[
        _buildDarkModeSwitch(context),
        _buildFilterSettingsSwitch(context),
        _buildLanguage(),
      ],
    );
  }

  SectionItem _buildDarkModeSwitch(BuildContext context) {
    return SectionItem(
      title: LocaleKeys.settings_page_dark_mode.tr(),
      trailing: Switch(
        activeColor: Theme.of(context).accentColor,
        value: UserSettings.getDarkMode(),
        onChanged: (val) async {
          Provider.of<ThemeNotifier>(context, listen: false)
              .switchTheme(dark: val);
        },
      ),
    );
  }

  SectionItem _buildFilterSettingsSwitch(BuildContext context) {
    return SectionItem(
      title: LocaleKeys.settings_page_enable_filter.tr(),
      trailing: Switch(
        activeColor: Theme.of(context).accentColor,
        value: _isFilterSettings,
        onChanged: (val) async {
          UserSettings.setShowFilterSettings(val: val);
          setState(() {
            _isFilterSettings = val;
          });
        },
      ),
    );
  }

  SectionItem _buildLanguage() {
    final items = context.supportedLocales.asMap();

    return SectionItem(
      title: LocaleKeys.settings_page_language.plural(1),
      trailing: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final int res = await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SelectionPage(
                        pageTitle: LocaleKeys.settings_page_language.plural(2),
                        selectedIndex:
                            context.supportedLocales.indexOf(context.locale),
                        data: items.map((key, value) =>
                            MapEntry(key, value.getFullLanguageName())),
                      )),
            );
            if (res != null) {
              EasyLocalization.of(context).locale = items[res];
            }
          },
          child: Row(
            children: <Widget>[
              Text(context.locale.getFullLanguageName()),
              Icon(
                Icons.keyboard_arrow_right,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
