import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/settings_page/pages/filter_settings_page.dart';
import 'package:FineWallet/src/settings_page/parts/section.dart';
import 'package:flutter/material.dart';

/// This class creates a [Section] which shows the chart
/// settings, like which chart to display first on the profile page.
class DefaultsSection extends StatefulWidget {
  @override
  _DefaultsSectionState createState() => _DefaultsSectionState();
}

class _DefaultsSectionState extends State<DefaultsSection> {
  int _selectedId = UserSettings.getDefaultProfileChart();

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Defaults",
      children: <SectionItem>[
        _buildDefaultProfileChart(),
        _buildDefaultFilterSettings(),
      ],
    );
  }

  SectionItem _buildDefaultProfileChart() {
    return SectionItem(
      title: "Default Expense Chart",
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _selectedId,
          isDense: true,
          onChanged: (int val) {
            UserSettings.setDefaultProfileChart(val);
            setState(() {
              _selectedId = val;
            });
          },
          items: const [
            DropdownMenuItem(
              value: 0,
              child: Text("Monthly"),
            ),
            DropdownMenuItem(
              value: 1,
              child: Text("Lifetime"),
            ),
          ],
        ),
      ),
    );
  }

  SectionItem _buildDefaultFilterSettings() {
    return SectionItem(
      title: "Default Filter Settings",
      trailing: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => DefaultFilterSettingsPage(
                      state: UserSettings.getDefaultFilterSettings())),
            );
          },
          child: Icon(
            Icons.keyboard_arrow_right,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
