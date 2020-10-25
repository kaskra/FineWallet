import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/settings_page/parts/section.dart';
import 'package:FineWallet/src/widgets/simple_pages/selection_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class creates a [Section] which shows the appearance
/// settings, like Dark Mode.
class AppearanceSection extends StatefulWidget {
  @override
  _AppearanceSectionState createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends State<AppearanceSection> {
  bool _isFilterSettings = true;

  int _selectedLanguage = 2;

  @override
  void initState() {
    setState(() {
      _isFilterSettings = UserSettings.getShowFilterSettings();
      _selectedLanguage = UserSettings.getLanguage();
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
    // TODO remove, just placeholders
    final items = <int, String>{};
    items.putIfAbsent(1, () => "ENG");
    items.putIfAbsent(2, () => "GER");

    return SectionItem(
      title: LocaleKeys.settings_page_language.plural(1),
      trailing: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final int res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SelectionPage(
                      pageTitle: LocaleKeys.settings_page_language.plural(2),
                      selectedIndex: UserSettings.getLanguage(),
                      data: items,
                    )));
            if (res != null) {
              UserSettings.setLanguage(res);
              setState(() {
                _selectedLanguage = res;
              });
              final langs = ["en", "de"];
              EasyLocalization.of(context).locale =
                  Locale(langs[_selectedLanguage - 1]);
            }
          },
          child: Row(
            children: <Widget>[
              Text(items[_selectedLanguage]),
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
