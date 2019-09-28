import 'package:flutter/material.dart';

/// This widget will increase the child width to fit
/// into the specified ratio of the screen width.
class ExpandToWidth extends StatelessWidget {
  const ExpandToWidth({
    Key key,
    @required this.child,
    this.ratio = 1,
    this.height,
    this.horizontalMargin = 5,
  }) : super(key: key);

  final Widget child;
  final double ratio;
  final double height;
  final double horizontalMargin;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        width: MediaQuery.of(context).size.width * ratio,
        height: height,
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
    this.width,
    this.verticalMargin = 5,
  }) : super(key: key);

  final Widget child;
  final double ratio;
  final double width;
  final double verticalMargin;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(vertical: verticalMargin),
        height: MediaQuery.of(context).size.height * ratio,
        width: width,
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
    this.margin,
  }) : super(key: key);

  final Widget child;
  final double widthRatio;
  final double heightRatio;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        height: MediaQuery.of(context).size.height * heightRatio,
        width: MediaQuery.of(context).size.width * widthRatio,
        child: child,
      );
}
