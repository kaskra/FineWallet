import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/settings_page/parts/section.dart';
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

  @override
  void initState() {
    setState(() {
      _isFilterSettings = UserSettings.getIsFilterSettings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Appearance",
      children: <SectionItem>[
        _buildDarkModeSwitch(context),
        _buildFilterSettingsSwitch(context)
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
          UserSettings.setIsFilterSettings(val: val);
          setState(() {
            _isFilterSettings = val;
          });
        },
      ),
    );
  }
}
