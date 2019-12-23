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
      color: Theme.of(context).colorScheme.onBackground,
      indent: 20,
      endIndent: 15,
      thickness: 0.2,
      height: 1,
    );
  }
}
