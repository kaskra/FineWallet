import 'package:flutter/material.dart';

class SectionButton extends StatelessWidget {
  final String label;
  final Icon icon;
  final void Function() onPressed;

  const SectionButton({
    Key key,
    this.label = "",
    this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: Theme.of(context).accentColor,
        elevation: 4,
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}
