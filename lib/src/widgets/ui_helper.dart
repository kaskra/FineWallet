import 'package:flutter/material.dart';

class ExpandToWidth extends StatelessWidget {
  const ExpandToWidth({
    Key key,
    @required this.context,
    @required this.child,
    this.ratio = 1,
  }) : super(key: key);

  final Widget child;
  final BuildContext context;
  final double ratio;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width * ratio,
        child: child,
      );
}

class ExpandToHeight extends StatelessWidget {
  const ExpandToHeight({
    Key key,
    @required this.context,
    @required this.child, 
    this.ratio = 1,
  }) : super(key: key);

  final Widget child;
  final BuildContext context;
  final double ratio;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: MediaQuery.of(context).size.height * ratio,
        child: child,
      );
}
