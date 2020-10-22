import 'package:flutter/material.dart';

/// Creates a small indicator for a limited amount of pages in a [PageView].
///
class PageViewIndicator extends StatefulWidget {
  final int numberOfChildren;
  final PageController controller;

  const PageViewIndicator(
      {Key key, @required this.numberOfChildren, @required this.controller})
      : super(key: key);

  @override
  _PageViewIndicatorState createState() => _PageViewIndicatorState();
}

class _PageViewIndicatorState extends State<PageViewIndicator> {
  int selectedPage = 0;

  @override
  void initState() {
    // Add listener to page controller to change the selected dot when
    // switching between pages
    widget.controller.addListener(() {
      setState(() {
        selectedPage = widget.controller.page.round();
      });
    });
    selectedPage = widget.controller.initialPage ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (int i = 0; i < widget.numberOfChildren; i++) {
      items.add(_buildDot(selectedPage == i));
      items.add(const SizedBox(width: 2));
    }

    return SizedBox(
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items,
      ),
    );
  }

  Widget _buildDot(bool selected) {
    return Container(
      height: 7,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? Theme.of(context).colorScheme.secondary : Colors.grey,
      ),
    );
  }
}
