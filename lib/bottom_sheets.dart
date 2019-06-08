/*
 * Developed by Lukas Krauch 08.06.19 11:44.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/Datatypes/category.dart';
import 'package:finewallet/Models/category_model.dart';
import 'package:finewallet/Models/subcategory_model.dart';
import 'package:finewallet/Resources/DBProvider.dart';
import 'package:finewallet/Resources/internal_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  final double midOfsubcategories = 3;

  void initState() {
    super.initState();
    _subcategoryScrollController = new ScrollController();
    _categoryScrollController = new ScrollController();
    if (widget.prevSubcategory != null) {
      _selectedCategory =
          widget.isExpense == 1 ? widget.prevSubcategory.selectedCategory : 0;
      _subcategory = widget.prevSubcategory;
      setScrollController();
    }
  }

  void setScrollController() async {
    await DBProvider.db
        .getIndexInCategory(widget.prevSubcategory.index)
        .then((idx) {
      _subcategoryScrollController = new ScrollController(
        initialScrollOffset:
            (_subcategory.index.toDouble() - (idx + midOfsubcategories)) *
                subcategoryCardHeight,
      );
      _categoryScrollController = new ScrollController(
        initialScrollOffset:
            (_subcategory.selectedCategory.toDouble() - midOfCategories) *
                categoryCardWidth,
      );
      // _categoryScrollController.addListener(_listen);
    });
  }

  Widget _categoryCard(IconData iconData, String label, int index) {
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
                color: _selectedCategory == index ? Colors.orange : Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              margin: EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconData,
                    color: Colors.white,
                  ),
                  Text(
                    label,
                    style: TextStyle(fontSize: 10, color: Colors.white),
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
                          ? Colors.orange
                          : Colors.white,
                      border: Border.all(
                        color: Colors.black26,
                        width: 1,
                      )),
                  alignment: Alignment.center,
                  child: Text(name)),
              onTap: () {
                int iconIndex = widget.isExpense == 1
                    ? _selectedCategory
                    : icons.length - 1;
                _subcategory = new Category(icons[iconIndex], name, index,
                    selectedCategory: _selectedCategory);
                Navigator.pop(context, _subcategory);
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: Colors.orange, width: topBorderHeight))),
        height: bottomSheetHeight,
        child: GestureDetector(
            // Blocks taps from propagating to the modal sheet and popping.
            onTap: () {},
            child: SafeArea(
                top: false,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: categoryListHeight,
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder(
                        future: widget.isExpense == 1
                            ? DBProvider.db.getExpenseCategories()
                            : DBProvider.db.getIncomeCategory(),
                        builder: (ctxt, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              controller: _categoryScrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                int iconIndex = widget.isExpense == 1
                                    ? index
                                    : icons.length - 1;
                                CategoryModel item = snapshot.data[index];
                                return _categoryCard(
                                    icons[iconIndex], item.name, index);
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
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
                      child: FutureBuilder(
                        future: DBProvider.db.getSubcategoriesOfCategory(
                            widget.isExpense == 1
                                ? _selectedCategory + 1
                                : icons.length),
                        builder: (ctxt, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              controller: _subcategoryScrollController,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                SubcategoryModel item = snapshot.data[index];
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

Widget buildBottomPicker(
        Widget picker, double bottomSheetHeight, double topBorderHeight) =>
    Container(
      decoration: BoxDecoration(
          color: CupertinoColors.white,
          border: Border(
              top: BorderSide(color: Colors.orange, width: topBorderHeight))),
      height: bottomSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
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
