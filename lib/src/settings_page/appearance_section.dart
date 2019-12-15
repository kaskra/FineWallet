import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/material.dart';

/// This class creates a [Section] which shows the appearance
/// settings, like Dark Mode.
class AppearanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Section(
      children: <SectionItem>[
        _buildDarkModeSwitch(),
      ],
    );
  }

  static Widget _buildDarkModeSwitch() {
    return SectionItem(
      title: "Dark Mode",
      trailing: Switch(
        value: false,
        onChanged: (val) {
          print("Toggle Dark Mode");
        },
      ),
    );
  }
}
