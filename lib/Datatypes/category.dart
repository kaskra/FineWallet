/*
 * Developed by Lukas Krauch 08.06.19 11:35.
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
