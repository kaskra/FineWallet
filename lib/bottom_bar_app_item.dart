/*
 * Developed by Lukas Krauch 16.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({this.iconData, this.text});
  final IconData iconData;
  final String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar(
      {@required this.items,
      @required this.onTabSelected,
      this.selectedColor,
      this.color,
      this.height: 50,
      this.iconSize: 24});
  final List<FABBottomAppBarItem> items;
  final ValueChanged<int> onTabSelected;
  final Color selectedColor;
  final Color color;
  final double height;
  final double iconSize;

  @override
  _FABBottomAppBarState createState() => _FABBottomAppBarState();
}

class _FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: widget.iconSize),
                _selectedIndex == index
                    ? Text(
                        item.text,
                        style: TextStyle(color: color),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
          index: index, item: widget.items[index], onPressed: _updateIndex);
    });

    return BottomAppBar(
      elevation: 20,
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }
}
