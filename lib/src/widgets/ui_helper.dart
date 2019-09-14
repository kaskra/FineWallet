import 'package:flutter/material.dart';

/// This widget will increase the child width to fit 
/// into the specified ratio of the screen width.
class ExpandToWidth extends StatelessWidget {
  const ExpandToWidth({
    Key key,
    @required this.child,
    this.ratio = 1,
  }) : super(key: key);

  final Widget child;
  final double ratio;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width * ratio,
        child: child,
      );
}

/// This widget will increase the child height to fit 
/// into the specified ratio of the screen height.
class ExpandToHeight extends StatelessWidget {
  const ExpandToHeight({
    Key key,
    @required this.child, 
    this.ratio = 1,
  }) : super(key: key);

  final Widget child;
  final double ratio;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: MediaQuery.of(context).size.height * ratio,
        child: child,
      );
}

/// This widget will increase the child size to fit 
/// into the specified ratio of the screen height and width.
class ExpandToScreenRatio extends StatelessWidget {
  const ExpandToScreenRatio({
    Key key,
    @required this.child, 
    this.widthRatio = 0.5,
    this.heightRatio = 0.5,
  }) : super(key: key);

  final Widget child;
  final double widthRatio;
  final double heightRatio;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: MediaQuery.of(context).size.height * heightRatio,
        width: MediaQuery.of(context).size.width * widthRatio,
        child: child,
      );
}
