/*
 * Developed by Lukas Krauch 8.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

class Category {
  Category(this.icon, this.subcategoryLabel, this.index,
      {this.selectedCategory});

  IconData icon;
  String subcategoryLabel;
  int index;
  int selectedCategory;
}
