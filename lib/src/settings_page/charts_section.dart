import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/material.dart';

/// This class creates a [Section] which shows the chart
/// settings, like which chart to display first on the profile page.
class ChartsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Section(
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
          value: 1,
          style: TextStyle(color: Colors.black),
          isDense: true,
          onChanged: (val) {
            print(val);
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
