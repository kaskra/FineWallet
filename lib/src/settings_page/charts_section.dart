import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/material.dart';

/// This class creates a [Section] which shows the chart
/// settings, like which chart to display first on the profile page.
class ChartsSection extends StatefulWidget {
  @override
  _ChartsSectionState createState() => _ChartsSectionState();
}

class _ChartsSectionState extends State<ChartsSection> {
  int _selectedId = UserSettings.getDefaultProfileChart();

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Charts",
      children: <SectionItem>[
        _buildDefaultProfileChart(),
      ],
    );
  }

  Widget _buildDefaultProfileChart() {
    return SectionItem(
      title: "Default Profile Chart",
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _selectedId,
          isDense: true,
          onChanged: (val) {
            UserSettings.setDefaultProfileChart(val);
            setState(() {
              _selectedId = val;
            });
          },
          items: [
            DropdownMenuItem(
              child: Text("Categories"),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text("Prediction"),
              value: 2,
            ),
          ],
        ),
      ),
    );
  }
}
