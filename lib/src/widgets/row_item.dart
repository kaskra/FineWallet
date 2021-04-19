import 'package:flutter/material.dart';

class RowItem extends StatelessWidget {
  final Widget child;
  final String footerText;
  final Color footerTextColor;
  final EdgeInsetsGeometry amountPadding;
  final EdgeInsetsGeometry padding;
  final int flex;

  const RowItem(
      {Key key,
      @required this.footerText,
      @required this.child,
      this.flex = 1,
      this.amountPadding = const EdgeInsets.fromLTRB(20, 10, 20, 4),
      this.footerTextColor,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: padding,
        child: Column(
          children: <Widget>[
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                padding: amountPadding,
                child: child,
              ),
            ),
            Text(
              footerText,
              style: Theme.of(context).textTheme.caption.copyWith(
                  color: footerTextColor ??
                      Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
