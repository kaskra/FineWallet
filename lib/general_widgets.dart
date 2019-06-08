/*
 * Developed by Lukas Krauch 8.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

Widget generalCard(Widget child,
    [BoxDecoration decoration, double padding = 10]) {
  return Container(
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          color: Colors.white,
          child: Container(
              decoration: decoration,
              padding: EdgeInsets.all(padding),
              child: child)));
}

Widget growAnimation(
    Widget first, Widget second, bool isExpanded, Duration duration) {
  return AnimatedCrossFade(
    firstChild: first,
    secondChild: second,
    duration: duration,
    crossFadeState:
        isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
  );
}
