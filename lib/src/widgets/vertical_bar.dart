/*
 * Project: FineWallet
 * Last Modified: Saturday, 28th September 2019 11:16:10 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/material.dart';

class VerticalBar extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final double horizontalMargin;

  const VerticalBar({
    Key key,
    this.height,
    this.width,
    this.color, this.horizontalMargin = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        width: width,
        color: color,
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      ),
    );
  }
}
