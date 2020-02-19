import 'package:flutter/material.dart';

class RowItem extends StatelessWidget {
  final Widget child;
  final String footerText;
  final EdgeInsetsGeometry padding;

  const RowItem(
      {Key key,
      @required this.footerText,
      @required this.child,
      this.padding = const EdgeInsets.fromLTRB(20, 10, 20, 4)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
              padding: padding,
              child: child,
            ),
          ),
          Text(
            footerText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
