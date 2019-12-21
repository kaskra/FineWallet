import 'package:flutter/material.dart';

/// This class creates a [Divider] that is used to divide the row
/// parent from its children.
class RowChildDivider extends StatelessWidget {
  const RowChildDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: 24,
      endIndent: 24,
      thickness: 0.2,
      height: 1,
    );
  }
}

/// This class is used to create a specific [Text] widget right above the row.
class RowTitle extends StatelessWidget {
  const RowTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48),
      child: Text(
        title,
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}
