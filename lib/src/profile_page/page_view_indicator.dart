import 'package:flutter/material.dart';

class PageViewIndicator extends StatelessWidget {
  final int selectedPage;
  final int initialPage;
  final int numberOfChildren;

  const PageViewIndicator(
      {Key key,
      @required this.numberOfChildren,
      this.selectedPage,
      this.initialPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];
    for (int i = 0; i < numberOfChildren; i++) {
      items.add(_buildDot((selectedPage ?? initialPage) == i));
      items.add(SizedBox(width: 1.5));
    }

    return Container(
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: items,
      ),
    );
  }

  Widget _buildDot(bool selected) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? Colors.orange : Colors.white,
      ),
    );
  }
}
