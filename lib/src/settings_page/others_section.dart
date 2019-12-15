import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/material.dart';

class OthersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Section(
      children: <SectionItem>[
        _buildImport(),
        _buildExport(),
      ],
    );
  }

  Widget _buildImport() {
    return SectionItem(
      title: "Import your data",
      trailing: FlatButton(
        child: Text("IMPORT"),
        onPressed: () {
          print("IMPORT!!");
        },
      ),
    );
  }

  Widget _buildExport() {
    return SectionItem(
      title: "Export your data",
      trailing: FlatButton(
        child: Text("EXPORT"),
        onPressed: () {
          print("EXPORT!!");
        },
      ),
    );
  }
}
