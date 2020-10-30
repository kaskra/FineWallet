import 'package:FineWallet/core/datatypes/history_filter_state.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/history_page/page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DefaultFilterSettingsPage extends StatefulWidget {
  const DefaultFilterSettingsPage({Key key}) : super(key: key);

  @override
  _DefaultFilterSettingsPageState createState() =>
      _DefaultFilterSettingsPageState();
}

class _DefaultFilterSettingsPageState extends State<DefaultFilterSettingsPage> {
  HistoryFilterState _filterState;

  final showExpenseKey = GlobalKey<HistoryFilterSwitchItemState>();
  final showIncomeKey = GlobalKey<HistoryFilterSwitchItemState>();
  final showFutureKey = GlobalKey<HistoryFilterSwitchItemState>();

  @override
  void initState() {
    setState(() {
      _filterState = UserSettings.getDefaultFilterSettings();
    });
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
          HistoryFilterSwitchItem(
            key: showExpenseKey,
            initialValue: _filterState.onlyExpenses,
            title: LocaleKeys.history_page_show_expenses.tr(),
            enabled: !_filterState.showRecurrent,
            onChanged: (b) {
              setState(() {
                _filterState = _filterState.copyWith(onlyExpenses: b);
              });
              _handleFilterState();
            },
          ),
          HistoryFilterSwitchItem(
            key: showIncomeKey,
            initialValue: _filterState.onlyIncomes,
            title: LocaleKeys.history_page_show_incomes.tr(),
            enabled: !_filterState.showRecurrent,
            onChanged: (b) {
              setState(() {
                _filterState = _filterState.copyWith(onlyIncomes: b);
              });
              _handleFilterState();
            },
          ),
          HistoryFilterSwitchItem(
            key: showFutureKey,
            initialValue: _filterState.showFuture,
            title: LocaleKeys.history_page_show_future.tr(),
            enabled: !_filterState.showRecurrent,
            onChanged: (b) {
              setState(() {
                _filterState = _filterState.copyWith(showFuture: b);
              });
              _handleFilterState();
            },
          ),
          HistoryFilterCheckboxItem(
            initialValue: _filterState.showRecurrent,
            title: LocaleKeys.history_page_show_recurrent.tr(),
            onChanged: (b) {
              setState(() {
                _filterState = _filterState.copyWith(showRecurrent: b);
                _toggleSwitches(value: !b);
              });
              _handleFilterState();
            },
          ),
        ],
      ),
    );
  }

  void _toggleSwitches({bool value}) {
    showExpenseKey.currentState.setEnabled(value: value);
    showIncomeKey.currentState.setEnabled(value: value);
    showFutureKey.currentState.setEnabled(value: value);
  }

  void _handleFilterState() {
    UserSettings.setDefaultFilterSettings(_filterState);
  }
}
