import 'package:flutter/material.dart';

class SelectionPage extends StatelessWidget {
  final int selectedIndex;
  final Map<int, String> data;

  const SelectionPage({Key key, this.selectedIndex, @required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (var l in data.keys) {
      items.add(_buildItem(context, l, data[l]));
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

  Widget _buildItem(BuildContext context, int index, String name) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.of(context).pop(index);
      },
      trailing: index == selectedIndex
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
