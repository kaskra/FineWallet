import 'package:flutter/material.dart';

class HistoryFilterState {
  bool onlyExpenses = true;
  bool onlyIncomes = true;
  bool showFuture = false;

  @override
  String toString() {
    return 'HistoryFilterState{'
        'onlyExpenses: $onlyExpenses, '
        'onlyIncomes: $onlyIncomes, '
        'showFuture: $showFuture'
        '}';
  }
}

class HistoryFilter extends StatelessWidget {
  const HistoryFilter({Key key, this.items}) : super(key: key);

  final List<HistoryFilterItem> items;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Theme.of(context).colorScheme.onBackground,
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).colorScheme.secondary, width: 0))),
        child: ExpansionTile(
          title: const Text("Filter Settings"),
          leading: Icon(Icons.filter_list),
          children: items,
        ),
      ),
    );
  }
}

class HistoryFilterItem extends StatefulWidget {
  const HistoryFilterItem(
      {Key key, this.title, this.onChanged, @required this.initialValue})
      : super(key: key);

  @override
  _HistoryFilterItemState createState() => _HistoryFilterItemState();

  final String title;
  final Function(bool) onChanged;
  final bool initialValue;
}

class _HistoryFilterItemState extends State<HistoryFilterItem> {
  bool _active;

  @override
  void initState() {
    _active = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(widget.title ?? "EMPTY"),
          Switch(
              value: _active,
              onChanged: (s) {
                widget.onChanged(s);
                setState(() {
                  _active = s;
                });
              })
        ],
      ),
    );
  }
}
