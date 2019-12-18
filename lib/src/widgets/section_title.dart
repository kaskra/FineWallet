import 'package:flutter/material.dart';

/// This class is used to create a text widget that is used in a column to
/// title the following section of rows.
class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 4),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
