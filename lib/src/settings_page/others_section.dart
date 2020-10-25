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
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 100,
            child: FlatButton(
              onPressed: () {
                logMsg("IMPORT!!");
              },
              visualDensity: VisualDensity.compact,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  LocaleKeys.settings_page_import.tr().toUpperCase(),
                  maxLines: 1,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: FlatButton(
              onPressed: () {
                logMsg("EXPORT!!");
              },
              visualDensity: VisualDensity.compact,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  LocaleKeys.settings_page_export.tr().toUpperCase(),
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
