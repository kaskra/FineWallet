import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class creates a [Section] which shows the appearance
/// settings, like Dark Mode.
class AppearanceSection extends StatefulWidget {
  @override
  _AppearanceSectionState createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends State<AppearanceSection> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return Section(
      children: <SectionItem>[
        _buildDarkModeSwitch(context),
      ],
    );
  }

  Widget _buildDarkModeSwitch(BuildContext context) {
    return SectionItem(
      title: "Dark Mode",
      trailing: Switch(
        value: _isDark,
        onChanged: (val) {
          Provider.of<ThemeNotifier>(context).switchTheme();
          setState(() {
            _isDark = !_isDark;
          });
        },
      ),
    );
  }
}
