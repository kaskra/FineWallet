/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:15:54 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonBottomAppItem {
  FloatingActionButtonBottomAppItem(
      {this.iconData, this.text = "", this.disabled = false});

  final IconData iconData;
  final String text;
  final bool disabled;
}

class FloatingActionButtonBottomBar extends StatefulWidget {
  const FloatingActionButtonBottomBar(
      {@required this.items,
      @required this.onTabSelected,
      this.selectedIndex,
      this.selectedColor,
      this.unselectedColor,
      this.height = 50,
      this.iconSize = 24,
      this.isVisible});

  final List<FloatingActionButtonBottomAppItem> items;
  final ValueChanged<int> onTabSelected;
  final int selectedIndex;
  final Color selectedColor;
  final Color unselectedColor;
  final double height;
  final double iconSize;
  final bool isVisible;

  @override
  _FloatingActionButtonBottomBarState createState() =>
      _FloatingActionButtonBottomBarState();
}

class _FloatingActionButtonBottomBarState
    extends State<FloatingActionButtonBottomBar> {
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
  void didUpdateWidget(FloatingActionButtonBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _selectedIndex = widget.selectedIndex ?? oldWidget.selectedIndex;
    });
  }

  Widget _buildTabItem({
    FloatingActionButtonBottomAppItem item,
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
                        FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              item.text,
                              style: TextStyle(color: color),
                            ))
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
      shape: widget.isVisible ? const CircularNotchedRectangle() : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }
}
