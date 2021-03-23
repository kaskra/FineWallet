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

class HistoryFilterSwitchItem extends StatefulWidget {
  const HistoryFilterSwitchItem({
    Key key,
    this.title,
    this.onChanged,
    @required this.initialValue,
    this.enabled = true,
  }) : super(key: key);

  @override
  HistoryFilterSwitchItemState createState() => HistoryFilterSwitchItemState();

  final String title;
  final Function(bool) onChanged;
  final bool initialValue;
  final bool enabled;
}

class HistoryFilterSwitchItemState extends State<HistoryFilterSwitchItem> {
  bool _active;
  bool _enabled;

  @override
  void initState() {
    _active = widget.initialValue;
    _enabled = widget.enabled;
    super.initState();
  }

  void setEnabled({bool value}) {
    setState(() {
      _enabled = value;
    });
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
              onChanged: _enabled
                  ? (s) {
                      widget.onChanged(s);
                      setState(() {
                        _active = s;
                      });
                    }
                  : null)
        ],
      ),
    );
  }
}

class HistoryFilterCheckboxItem extends StatefulWidget {
  const HistoryFilterCheckboxItem(
      {Key key, this.title, this.onChanged, @required this.initialValue})
      : super(key: key);

  @override
  _HistoryFilterCheckboxItemState createState() =>
      _HistoryFilterCheckboxItemState();

  final String title;
  final Function(bool) onChanged;
  final bool initialValue;
}

class _HistoryFilterCheckboxItemState extends State<HistoryFilterCheckboxItem> {
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
          Checkbox(
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
  final textFieldFocusNode = FocusNode();
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
        focusNode: textFieldFocusNode,
        controller: _textEditingController,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(widget.iconData),
          hintText: LocaleKeys.search.tr(),
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            splashRadius: 0.1,
            onPressed: () {
              if (textFieldFocusNode.hasFocus) {
                _clearTextField();
              } else {
                textFieldFocusNode.canRequestFocus = false;

                _clearTextField();

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  textFieldFocusNode.canRequestFocus = true;
                });
              }
            },
            icon: const Icon(Icons.clear),
          ),
          suffixStyle: const TextStyle(color: Colors.grey),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }

  void _clearTextField() {
    _textEditingController.clear();
    widget.onChanged(_textEditingController.text);
  }
}
