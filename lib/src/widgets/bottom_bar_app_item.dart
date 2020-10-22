/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:15:54 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonBottomAppBarItem {
  FloatingActionButtonBottomAppBarItem(
      {this.iconData, this.text = "", this.disabled = false});

  final IconData iconData;
  final String text;
  final bool disabled;
}

class FloatingActionButtonBottomAppBar extends StatefulWidget {
  const FloatingActionButtonBottomAppBar(
      {@required this.items,
      @required this.onTabSelected,
      this.selectedIndex,
      this.selectedColor,
      this.unselectedColor,
      this.height = 50,
      this.iconSize = 24,
      this.isVisible});

  final List<FloatingActionButtonBottomAppBarItem> items;
  final ValueChanged<int> onTabSelected;
  final int selectedIndex;
  final Color selectedColor;
  final Color unselectedColor;
  final double height;
  final double iconSize;
  final bool isVisible;

  @override
  _FloatingActionButtonBottomAppBarState createState() =>
      _FloatingActionButtonBottomAppBarState();
}

class _FloatingActionButtonBottomAppBarState
    extends State<FloatingActionButtonBottomAppBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = widget.selectedIndex ?? 0;
    });
  }

  void _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didUpdateWidget(FloatingActionButtonBottomAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _selectedIndex = widget.selectedIndex ?? oldWidget.selectedIndex;
    });
  }

  Widget _buildTabItem({
    FloatingActionButtonBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
    bool isDisabled,
  }) {
    final color =
        _selectedIndex == index ? widget.selectedColor : widget.unselectedColor;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: !isDisabled
              ? InkWell(
                  onTap: () => onPressed(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(item.iconData, color: color, size: widget.iconSize),
                      if (_selectedIndex == index)
                        Text(item.text, style: TextStyle(color: color))
                      else
                        Container()
                    ],
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        index: index,
        item: widget.items[index],
        onPressed: _updateIndex,
        isDisabled: widget.items[index].disabled,
      );
    });

    return BottomAppBar(
      color: Theme.of(context).bottomAppBarColor,
      elevation: 20,
      shape: widget.isVisible ? const CircularNotchedRectangle() : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }
}
