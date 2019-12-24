/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:16:49 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconWrapper extends StatelessWidget {
  const IconWrapper({
    Key key,
    @required this.child,
    this.alignment = Alignment.topLeft,
    this.padding = const EdgeInsets.only(right: 10),
    this.clipRadius = 25,
  }) : super(key: key);

  final Widget child;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;
  final double clipRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(clipRadius)),
          child: child,
        ),
      ),
    );
  }
}
