/*
 * Project: FineWallet
 * Last Modified: Tuesday, 29th October 2019 10:38:40 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/material.dart';

/// Simulate the title and trailing widgets of a [ListTile] without any vertical padding.
class InformationRow extends StatelessWidget {
  const InformationRow(
      {Key key,
      @required this.text,
      @required this.value,
      this.height = 35,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
      this.mainAxisSize = MainAxisSize.max,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.alignment = Alignment.centerLeft})
      : assert(text != null),
        assert(value != null),
        super(key: key);

  final Widget text;
  final Widget value;
  final double height;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        height: height,
        padding: padding,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: <Widget>[text, value],
        ),
      ),
    );
  }
}
