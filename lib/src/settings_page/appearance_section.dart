import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class creates a [Section] which shows the appearance
/// settings, like Dark Mode.
class AppearanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Section(
      children: <SectionItem>[
        _buildDarkModeSwitch(context),
      ],
    );
  }

  static Widget _buildDarkModeSwitch(BuildContext context) {
    return SectionItem(
      title: "Dark Mode",
      trailing: Switch(
        value: false,
        onChanged: (val) {
          print("Toggle Dark Mode");
          Provider.of<ThemeNotifier>(context).switchTheme();
        },
      ),
    );
  }
}
