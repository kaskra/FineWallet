import 'package:flutter/material.dart';

/// This class is used to have recurring theme of column rows
/// of the add page.
class RowWrapper extends StatelessWidget {
  final bool _isChild;
  final Widget child;

  const RowWrapper({
    Key key,
    bool isChild = false,
    this.child,
  })  : assert(isChild != null),
        _isChild = isChild,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double leftInset = 10 * (_isChild ? 5.0 : 1.0);

    return Container(
      padding: EdgeInsets.fromLTRB(leftInset, 4, 10, 4),
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: <Widget>[
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Align(
          alignment: Alignment.centerRight,
          child: child,
        ),
      ),
    );
  }
}
