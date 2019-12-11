/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:15:40 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/category.dart';
import 'package:FineWallet/core/resources/category_icon.dart';
import 'package:FineWallet/data/moor_database.dart' as DB;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CategoryBottomSheet extends StatefulWidget {
  CategoryBottomSheet(this.isExpense, this.prevSubcategory);

  final int isExpense;
  final Category prevSubcategory;

  @override
  _CategoryBottomSheetState createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet>
    with SingleTickerProviderStateMixin {
  int _selectedCategory = 0;

  bool _initiated = false;

  Category _subcategory;
  ScrollController _subcategoryScrollController;
  ScrollController _categoryScrollController;

  final double categoryCardWidth = 80;
  final double subcategoryCardHeight = 40;
  final double bottomSheetHeight = 265;
  final double categoryListHeight = 60;
  final double dividerHeight = 2;
  final double topBorderHeight = 5;
  final double midOfCategories = 1.75;
  final double midOfSubcategories = 3;

  void initState() {
    super.initState();
    _subcategoryScrollController = new ScrollController();
    _categoryScrollController = new ScrollController();
    if (widget.prevSubcategory != null) {
      _selectedCategory =
          widget.isExpense == 1 ? widget.prevSubcategory.selectedCategory : 0;
      _subcategory = widget.prevSubcategory;
    }
  }

  void initScrollController() async {
    int index = await Provider.of<DB.AppDatabase>(context)
        .categoryDao
        .countSubcategoriesBeforeCategory(widget.prevSubcategory.index);

    _subcategoryScrollController = new ScrollController(
      initialScrollOffset:
          (_subcategory.index.toDouble() - (index + midOfSubcategories)) *
              subcategoryCardHeight,
    );
    _categoryScrollController = new ScrollController(
      initialScrollOffset:
          (_subcategory.selectedCategory.toDouble() - midOfCategories) *
              categoryCardWidth,
    );

    setState(() {
      _initiated = true;
    });
  }

  Widget _categoryCard(CategoryIcon iconData, String label, int index) {
    return Container(
        width: categoryCardWidth,
        child: Material(
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = index;
                _subcategoryScrollController.jumpTo(0);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: _selectedCategory == index
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              margin: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconData.data,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSecondary),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _subcategoryTile(int index, String name) {
    return Container(
        height: subcategoryCardHeight,
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: InkWell(
              child: Container(
                  decoration: BoxDecoration(
                      color: _subcategory?.index == index &&
                              _selectedCategory == _subcategory.selectedCategory
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.background,
                      border: Border.all(
                        color: Colors.black26,
                        width: 1,
                      )),
                  alignment: Alignment.center,
                  child: Text(name)),
              onTap: () {
                int iconIndex = widget.isExpense == 1
                    ? _selectedCategory
                    : CategoryIcon.amount - 1;
                _subcategory = new Category(
                    CategoryIcon(iconIndex).data, name, index,
                    selectedCategory: _selectedCategory);
                Navigator.pop(context, _subcategory);
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.prevSubcategory != null && !_initiated) {
      initScrollController();
    }

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(
                color: Theme.of(context).canvasColor,
                width: topBorderHeight / 2),
            borderRadius: BorderRadius.vertical(top: new Radius.circular(16))),
        height: bottomSheetHeight,
        child: GestureDetector(
            // Blocks taps from propagating to the modal sheet and popping.
            onTap: () {},
            child: SafeArea(
                top: false,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: new Radius.circular(16)),
                      child: Container(
                        height: categoryListHeight,
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder<List<DB.Category>>(
                          future: Provider.of<DB.AppDatabase>(context)
                              .categoryDao
                              .getAllCategoriesByType(widget.isExpense == 1),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                controller: _categoryScrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  int iconIndex = widget.isExpense == 1
                                      ? index
                                      : CategoryIcon.amount - 1;
                                  DB.Category item = snapshot.data[index];
                                  return _categoryCard(CategoryIcon(iconIndex),
                                      item.name, index);
                                },
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                    Divider(
                      height: dividerHeight,
                      color: Colors.black,
                    ),
                    Container(
                      height: bottomSheetHeight -
                          categoryListHeight -
                          topBorderHeight -
                          dividerHeight,
                      child: FutureBuilder<List<DB.Subcategory>>(
                        future: Provider.of<DB.AppDatabase>(context)
                            .categoryDao
                            .getAllSubcategoriesOf(widget.isExpense == 1
                                ? _selectedCategory + 1
                                : CategoryIcon.amount),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              controller: _subcategoryScrollController,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                DB.Subcategory item = snapshot.data[index];
                                return _subcategoryTile(item.id, item.name);
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ))));
  }
}

Widget buildBottomPicker(Widget picker, double bottomSheetHeight,
        double topBorderHeight, BuildContext context) =>
    Container(
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          border: Border.all(
              color: Theme.of(context).canvasColor, width: topBorderHeight / 2),
          borderRadius: BorderRadius.vertical(top: new Radius.circular(16))),
      height: bottomSheetHeight,
      padding: const EdgeInsets.only(top: 6.0, left: 2, right: 2),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
