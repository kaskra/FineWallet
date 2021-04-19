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
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: icon),
            Expanded(flex: 5, child: Text(label)),
          ],
        ),
      ),
    );
  }
}
