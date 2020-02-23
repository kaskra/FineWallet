import 'package:flutter/material.dart';

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
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
