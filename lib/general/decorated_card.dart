import 'package:flutter/material.dart';

class DecoratedCard extends StatelessWidget {
  const DecoratedCard(
      {Key key,
      this.child,
      this.borderRadius = BorderRadius.zero,
      this.decoration = const BoxDecoration(),
      this.padding = 10})
      : super(key: key);

  final Widget child;
  final BorderRadius borderRadius;
  final BoxDecoration decoration;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Container(
          decoration: decoration,
          padding: EdgeInsets.all(padding),
          child: child),
    );
  }
}
