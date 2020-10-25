import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/history_page/history_filter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DefaultFilterSettingsPage extends StatefulWidget {
  final HistoryFilterState state;

  const DefaultFilterSettingsPage({Key key, this.state}) : super(key: key);

  @override
  _DefaultFilterSettingsPageState createState() =>
      _DefaultFilterSettingsPageState();
}

class _DefaultFilterSettingsPageState extends State<DefaultFilterSettingsPage> {
  HistoryFilterState _filterState;

  @override
  void initState() {
    _filterState ??= widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_page_default_filter_settings.tr()),
      ),
      body: Column(
        children: <Widget>[
          HistoryFilterItem(
            initialValue: _filterState.onlyExpenses,
            title: LocaleKeys.history_page_show_expenses.tr(),
            onChanged: (b) {
              setState(() {
                _filterState.onlyExpenses = b;
              });
              _handleFilterState();
            },
          ),
          HistoryFilterItem(
            initialValue: _filterState.onlyIncomes,
            title: LocaleKeys.history_page_show_incomes.tr(),
            onChanged: (b) {
              setState(() {
                _filterState.onlyIncomes = b;
              });
              _handleFilterState();
            },
          ),
          HistoryFilterItem(
            initialValue: _filterState.showFuture,
            title: LocaleKeys.history_page_show_future.tr(),
            onChanged: (b) {
              setState(() {
                _filterState.showFuture = b;
              });
              _handleFilterState();
            },
          )
        ],
      ),
    );
  }

  void _handleFilterState() {
    UserSettings.setDefaultFilterSettings(_filterState);
  }
}
