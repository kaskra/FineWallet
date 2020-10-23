import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/settings_page/parts/section.dart';
import 'package:FineWallet/src/widgets/simple_pages/selection_page.dart';
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
      title: "Appearance",
      children: <SectionItem>[
        _buildDarkModeSwitch(context),
        _buildFilterSettingsSwitch(context),
        _buildLanguage(),
      ],
    );
  }

  SectionItem _buildDarkModeSwitch(BuildContext context) {
    return SectionItem(
      title: "Enable Dark Mode",
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
      title: "Enable Filtering of History",
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
      title: "Language (UNUSED)",
      trailing: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final int res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SelectionPage(
                      pageTitle: "Languages",
                      selectedIndex: UserSettings.getLanguage(),
                      data: items,
                    )));
            if (res != null) {
              UserSettings.setLanguage(res);
              setState(() {
                _selectedLanguage = res;
              });
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
