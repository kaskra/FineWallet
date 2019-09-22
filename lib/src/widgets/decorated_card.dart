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
      this.borderRadius = BorderRadius.zero,
      this.color = Colors.white,
      this.borderColor = Colors.white,
      this.borderWidth = 1,
      this.padding = 10})
      : super(key: key);

  final Widget child;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color borderColor;
  final double padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(width: borderWidth, color: borderColor)),
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}
