part of 'settings_page.dart';

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
      title: LocaleKeys.settings_page_defaults.tr(),
      children: <SectionItem>[
        _buildDefaultProfileChart(),
        _buildDefaultFilterSettings(),
      ],
    );
  }

  SectionItem _buildDefaultProfileChart() {
    return SectionItem(
      title: LocaleKeys.settings_page_default_expense_chart.tr(),
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
          items: [
            DropdownMenuItem(
              value: 0,
              child: Text(LocaleKeys.profile_page_monthly.tr()),
            ),
            DropdownMenuItem(
              value: 1,
              child: Text(LocaleKeys.profile_page_lifetime.tr()),
            ),
          ],
        ),
      ),
    );
  }

  SectionItem _buildDefaultFilterSettings() {
    return SectionItem(
      title: LocaleKeys.settings_page_default_filter_settings.tr(),
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
