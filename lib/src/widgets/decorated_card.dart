/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:16:08 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/material.dart';

class DecoratedCard extends StatelessWidget {
  const DecoratedCard(
      {Key key,
      this.child,
      this.color,
      this.shape,
      this.padding = 10,
      this.elevation = 4})
      : super(key: key);

  final Widget child;
  final ShapeBorder shape;
  final double padding;
  final Color color;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color ?? Theme.of(context).cardTheme.color,
      shape: shape ?? Theme.of(context).cardTheme.shape,
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}
