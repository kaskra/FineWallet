/*
 * Project: FineWallet
 * Last Modified: Monday, 23rd September 2019 11:01:43 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/material.dart';

class Timestamp extends StatelessWidget {
  const Timestamp({
    Key key,
    @required this.today,
    this.size,
    this.color,
  }) : super(key: key);

  final String today;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.access_time,
          color: color,
          size: size,
        ),
        const SizedBox(width: 5),
        Text(
          today,
          style: TextStyle(
            fontSize: size,
            color: color,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}