import 'package:flutter/material.dart';

class Category {
  Category(this.icon, this.subcategoryLabel, this.index, {this.selectedCategory});

  IconData icon;
  String subcategoryLabel;
  int index;
  int selectedCategory;
}