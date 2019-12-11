/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:15:27 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/material.dart';

class Category {
  Category(this.icon, this.subcategoryLabel, this.index,
      {this.selectedCategory});

  IconData icon;
  String subcategoryLabel;
  int index;
  int selectedCategory;

  @override
  String toString() {
    return 'Category{icon: $icon, subcategoryLabel: $subcategoryLabel, index: $index, selectedCategory: $selectedCategory}';
  }
}
