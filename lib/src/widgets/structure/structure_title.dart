import 'package:flutter/material.dart';

class StructureTitle extends StatelessWidget {
  final String text;

  const StructureTitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 8.0),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
