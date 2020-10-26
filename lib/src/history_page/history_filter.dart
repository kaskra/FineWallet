part of 'history_page.dart';

class HistoryFilter extends StatelessWidget {
  const HistoryFilter({Key key, this.items}) : super(key: key);

  final List<Widget> items;

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
          title: Text(LocaleKeys.history_page_filter_settings.tr()),
          leading: const Icon(Icons.filter_list),
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

class HistoryFilterTextField extends StatefulWidget {
  final IconData iconData;
  final Function(String) onChanged;
  final String initialData;

  const HistoryFilterTextField(
      {Key key, this.iconData, this.onChanged, this.initialData})
      : super(key: key);

  @override
  _HistoryFilterTextFieldState createState() => _HistoryFilterTextFieldState();
}

class _HistoryFilterTextFieldState extends State<HistoryFilterTextField> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.initialData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
            isDense: true,
            prefixIcon: Icon(widget.iconData),
            hintText: LocaleKeys.search.tr(),
            hintStyle: const TextStyle(color: Colors.grey)
            ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
