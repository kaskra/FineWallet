import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/src/settings_page/parts/section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// This class creates a [Section] which shows some remaining
/// settings, like exporting and importing the database.
class OthersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Section(
      title: LocaleKeys.settings_page_others.tr(),
      children: <SectionItem>[
        _buildImportExport(),
      ],
    );
  }

  SectionItem _buildImportExport() {
    return SectionItem(
      title: LocaleKeys.settings_page_your_data.tr(),
      trailing: Row(
        children: <Widget>[
          // TODO in uppercase, there is overflow
          FlatButton(
            onPressed: () {
              logMsg("IMPORT!!");
            },
            child: Text(LocaleKeys.settings_page_import.tr()),
          ),
          FlatButton(
            onPressed: () {
              logMsg("EXPORT!!");
            },
            child: Text(LocaleKeys.settings_page_export.tr()),
          ),
        ],
      ),
    );
  }
}
