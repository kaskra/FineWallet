part of 'settings_page.dart';

/// This class creates a [SettingSection] which shows the chart
/// settings, like which chart to display first on the profile page.
class DefaultsSection extends StatefulWidget {
  @override
  _DefaultsSectionState createState() => _DefaultsSectionState();
}

class _DefaultsSectionState extends State<DefaultsSection> {
  int _selectedId;

  @override
  void initState() {
    setState(() {
      _selectedId = UserSettings.getDefaultProfileChart();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingSection(
      title: LocaleKeys.settings_page_defaults.tr(),
      items: [
        _buildDefaultProfileChart(),
        _buildDefaultFilterSettings(),
      ],
    );
  }

  Widget _buildDefaultProfileChart() {
    return Theme(
      data: Theme.of(context).copyWith(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Theme.of(context).accentColor,
          ),
        ),
      ),
      child: SettingRadioItem<int>(
        title: LocaleKeys.settings_page_default_expense_chart.tr(),
        cancelText: LocaleKeys.cancel.tr(),
        selectedValue: _selectedId,
        displayValue: [
          LocaleKeys.profile_page_monthly.tr(),
          LocaleKeys.profile_page_lifetime.tr()
        ][_selectedId],
        items: [
          SettingRadioValue(LocaleKeys.profile_page_monthly.tr(), 0),
          SettingRadioValue(LocaleKeys.profile_page_lifetime.tr(), 1),
        ],
        onChanged: (val) {
          UserSettings.setDefaultProfileChart(val);
          setState(() {
            _selectedId = val;
          });
        },
      ),
    );
  }

  Widget _buildDefaultFilterSettings() {
    return SettingPageItem(
      title: LocaleKeys.settings_page_default_filter_settings.tr(),
      displayValue: LocaleKeys.settings_page_default_filter_settings_desc.tr(),
      onTap: () {
        Navigator.pushNamed(context, "/filter_settings");
      },
    );
  }
}
