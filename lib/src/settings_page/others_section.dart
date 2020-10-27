part of 'settings_page.dart';

/// This class creates a [SettingSection] which shows some remaining
/// settings, like exporting and importing the database.
class OthersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingSection(
      title: LocaleKeys.settings_page_others.tr(),
      items: [
        SettingItem(
          title: LocaleKeys.settings_page_import.tr(),
          displayValue: LocaleKeys.settings_page_import_desc.tr(),
          onTap: () {
            logMsg("IMPORT!!");
          },
        ),
        SettingItem(
          title: LocaleKeys.settings_page_export.tr(),
          displayValue: LocaleKeys.settings_page_export_desc.tr(),
          onTap: () {
            logMsg("EXPORT!!");
          },
        )
      ],
    );
  }
}
