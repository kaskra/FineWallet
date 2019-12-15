import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/material.dart';

/// This class creates a [Section] which shows some remaining
/// settings, like exporting and importing the database.
class OthersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Section(
      children: <SectionItem>[
        _buildPlaceHolder(),
        _buildPlaceHolder(),
        SectionItemDivider(),
        _buildImportExport(),
      ],
    );
  }

  Widget _buildPlaceHolder() {
    return SectionItem(
      title: "--- PLACEHOLDER",
      trailing: Text("---"),
    );
  }

  Widget _buildImportExport() {
    return SectionItem(
      title: "Transactions",
      trailing: Row(
        children: <Widget>[
          FlatButton(
            child: Text("IMPORT"),
            onPressed: () {
              print("IMPORT!!");
            },
          ),
          FlatButton(
            child: Text("EXPORT"),
            onPressed: () {
              print("EXPORT!!");
            },
          ),
        ],
      ),
    );
  }
}
