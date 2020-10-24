import 'package:FineWallet/src/settings_page/parts/section.dart';
import 'package:flutter/material.dart';
import 'package:lumberdash/lumberdash.dart';

/// This class creates a [Section] which shows some remaining
/// settings, like exporting and importing the database.
class OthersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Other",
      children: <SectionItem>[
        _buildImportExport(),
      ],
    );
  }

  SectionItem _buildImportExport() {
    return SectionItem(
      title: "Transactions",
      trailing: Row(
        children: <Widget>[
          FlatButton(
            onPressed: () {
              logMessage("IMPORT!!");
            },
            child: const Text("IMPORT"),
          ),
          FlatButton(
            onPressed: () {
              logMessage("EXPORT!!");
            },
            child: const Text("EXPORT"),
          ),
        ],
      ),
    );
  }
}
