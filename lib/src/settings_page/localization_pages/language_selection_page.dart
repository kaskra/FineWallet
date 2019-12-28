import 'package:FineWallet/data/user_settings.dart';
import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatefulWidget {
  final int selectedIndex;

  const LanguageSelectionPage({Key key, this.selectedIndex}) : super(key: key);

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  int _selectedInd = -1;

  @override
  void initState() {
    if (widget.selectedIndex != null) {
      _selectedInd = widget.selectedIndex;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO add table to database
    var _list = {1: "ENG", 2: "GER"};
    List<Widget> items = [];
    for (var l in _list.keys) {
      items.add(_buildItem(l, _list[l], _selectedInd == l));
      items.add(_buildDivider());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Languages"),
      ),
      body: ListView(
        children: items,
      ),
    );
  }

  Widget _buildItem(int index, String title, bool isSelected) {
    return ListTile(
      title: Text(title),
      onTap: () {
        UserSettings.setLanguage(index);
        setState(() {
          _selectedInd = index;
        });
      },
      trailing: isSelected
          ? Icon(
              Icons.check,
              size: 20,
              color: Theme.of(context).colorScheme.secondary,
            )
          : null,
    );
  }

  Widget _buildDivider() {
    return Divider(
      endIndent: 12,
      indent: 12,
      height: 0,
    );
  }
}
