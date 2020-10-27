part of 'history_page.dart';

class HistoryFilter extends StatelessWidget {
  const HistoryFilter({Key key, this.onTap}) : super(key: key);

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 0, color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.filter_alt),
        onTap: onTap,
        title: Text(LocaleKeys.history_page_filter_settings.tr()),
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
              activeColor: Theme.of(context).accentColor,
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
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(widget.iconData),
          hintText: LocaleKeys.search.tr(),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
