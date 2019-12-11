/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:18:36 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/material.dart';

class CategoryIcon {
  // Income icon always has to be the last one
  final List<IconData> icons = const [
    Icons.blur_on,
    Icons.person,
    Icons.restaurant,
    Icons.home,
    Icons.rowing,
    Icons.time_to_leave,
    Icons.healing,
    Icons.local_mall,
    Icons.cake,
    Icons.attach_money
  ];

  const CategoryIcon(int id) : this.id = id;

  final int id;

  IconData get data => icons[id];

  static int get amount => CategoryIcon(0).icons.length;
}
