import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/history_page/history_filter.dart';
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
        title: const Text("Default Filter Settings"),
      ),
      body: Column(
        children: <Widget>[
          HistoryFilterItem(
            initialValue: _filterState.onlyExpenses,
            title: "Only show expenses",
            onChanged: (b) {
              setState(() {
                _filterState.onlyExpenses = b;
              });
              _handleFilterState();
            },
          ),
          HistoryFilterItem(
            initialValue: _filterState.onlyIncomes,
            title: "Only show incomes",
            onChanged: (b) {
              setState(() {
                _filterState.onlyIncomes = b;
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
