/*
 * Developed by Lukas Krauch 8.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/Datatypes/category.dart';
import 'package:finewallet/Datatypes/repeat_type.dart';
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/bottom_sheets.dart';
import 'package:finewallet/corner_triangle.dart';
import 'package:finewallet/general_widgets.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Resources/DBProvider.dart';

class AddPage extends StatefulWidget {
  AddPage(this.title, this.isExpense, {Key key}) : super(key: key);

  final String title;
  final int isExpense;

  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final double bottomSheetHeight = 265;
  final double topBorderHeight = 5;
  final TextEditingController _textEditingController = TextEditingController();

  // transactions
  double _expense;
  Category _subcategory;
  DateTime _date;
  double _keyboardHeight;

  // additional transaction parameters
  bool _isExpanded = false;
  DateTime _repeatUntil;
  int _typeIndex = 2;

  @override
  void initState() {
    super.initState();
    setState(() {
      _date = DateTime.now();
    });
  }

  Widget _expenseCards(IconData icon, String label, int value, Function onTap) {
    String valueString = "";
    IconData iconData = icon;
    switch (value) {
      case 0:
        valueString = _expense != null ? _expense.toStringAsFixed(2) : "-";
        break;
      case 1:
        valueString =
            _subcategory != null ? _subcategory.subcategoryLabel : "-";
        iconData = _subcategory != null ? _subcategory.icon : icon;
        break;
      case 2:
        if (_date != null) {
          var formatter = new DateFormat('dd.MM.yy');
          valueString = formatter.format(_date);
        } else {
          valueString = "-";
        }
    }

    return Expanded(
      child: Card(
        child: InkWell(
          onTap: () => onTap(),
          child: Container(
            padding: EdgeInsets.all(5),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(label,
                          style:
                              TextStyle(fontSize: 10, color: Colors.black54)),
                      Icon(iconData, size: constraint.biggest.width / 3),
                      FittedBox(
                        child: Text(valueString,
                            maxLines: 2,
                            softWrap: false,
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54)),
                      ),
                    ]);
              },
            ),
          ),
        ),
      ),
    );
  }

  void setExpense() {
    showModalBottomSheet(
        context: context,
        builder: (ctxt) {
          _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.orange, width: topBorderHeight))),
            padding: EdgeInsets.only(left: 10, right: 10),
            height: _keyboardHeight + (bottomSheetHeight - _keyboardHeight),
            child: TextField(
              decoration: InputDecoration(
                  labelText:
                      "Enter your ${widget.isExpense == 0 ? "income" : "expense"}",
                  contentPadding: EdgeInsets.all(4),
                  labelStyle: TextStyle(fontSize: 15, color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26)),
                  hintText: "0.00"),
              autofocus: true,
              onSubmitted: (s) {
                return Navigator.pop(context);
              },
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 25),
            ),
          );
        }).whenComplete(() {
      double value = 0;
      try {
        value = double.parse(_textEditingController.text);
      } catch (e) {
        if (_textEditingController.text != "") {
          String replaced = _textEditingController.text.replaceAll(',', '.');
          value = double.parse(replaced);
        } else {
          value = 0;
        }
      }
      setState(() {
        _expense = value;
      });
    });
  }

  void setCategory() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return CategoryBottomSheet(widget.isExpense, _subcategory);
        }).then((chosenCategory) {
      setState(() {
        _subcategory = chosenCategory ?? _subcategory;
      });
    });
  }

  void setDate() {
    showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return buildBottomPicker(
            CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _date ?? DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _date = newDateTime;
                });
              },
            ),
            bottomSheetHeight,
            topBorderHeight);
      },
    );
  }

  void setRepeatingDate() {
    showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return buildBottomPicker(
            CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _date ?? DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _repeatUntil = newDateTime;
                });
              },
            ),
            bottomSheetHeight,
            topBorderHeight);
      },
    );
  }

  void _showSnackBar(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Please fill out every panel!"),
    ));
  }

  Widget _buildRecurringCard() {
    return Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Card(
          color: Colors.white,
          child: CornerTriangle(
              size: Size(25, 25),
              icon: Icon(
                Icons.replay,
                color: Colors.white,
                size: 13,
              ),
              color: Colors.orange,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Repeat transaction",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        margin: EdgeInsets.only(left: 10),
                      ),
                      Switch(
                        value: _isExpanded,
                        onChanged: (v) {
                          setState(() {
                            _isExpanded = v;
                          });
                        },
                      )
                    ],
                  ),
                  growAnimation(
                      Container(
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              child: Divider(
                                height: 1,
                              ),
                              margin: EdgeInsets.only(bottom: 4),
                            ),
                            _repeatTypeChoice(),
                            // Divider(color: Colors.white,),
                            Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: _repeatUntilDate(),
                            )
                          ],
                        ),
                      ),
                      Container(),
                      _isExpanded,
                      Duration(milliseconds: 300))
                ],
              )),
        ));
  }

  Widget _repeatTypeChoice() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Every",
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        Container(
          width: 100,
          height: 35,
          alignment: Alignment.center,
          child: DropdownButton(
            isDense: true,
            isExpanded: true,
            style: TextStyle(color: Colors.black54, fontSize: 14),
            value: _typeIndex,
            items: [
              DropdownMenuItem(
                value: 0,
                child: Text(RepeatType.daily),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text(RepeatType.weekly),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text(RepeatType.monthly),
              ),
              DropdownMenuItem(value: 3, child: Text(RepeatType.yearly)),
            ],
            onChanged: (v) {
              setState(() {
                if (v != null) {
                  _typeIndex = v;
                }
              });
            },
          ),
        )
      ],
    );
  }

  Widget _repeatUntilDate() {
    var formatter = new DateFormat('dd.MM.yy');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          "Until",
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        Container(
          width: 100,
          height: 35,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12))),
          child: MaterialButton(
            onPressed: () {
              setRepeatingDate();
            },
            child: Text(
              _repeatUntil != null ? formatter.format(_repeatUntil) : "",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffd8e7ff),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            Container(
              width: 50,
              child: InkWell(
                onTap: () {
                  // TODO expand if by additional tx parameters (until date > date, and every parameter != null)
                  if (_expense != null &&
                      _date != null &&
                      _subcategory != null) {
                    TransactionModel tx = new TransactionModel(
                        amount: _expense,
                        isExpense: widget.isExpense,
                        date: dayInMillis(_date),
                        subcategory: _subcategory.index);
                    DBProvider.db.newTransaction(tx);
                    Navigator.pop(context);
                  } else {
                    return _showSnackBar(context);
                  }
                },
                child: Icon(Icons.save),
              ),
            )
          ],
          centerTitle: true,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              height: 100,
              margin: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _expenseCards(
                      Icons.euro_symbol,
                      "Amount ${widget.isExpense == 1 ? "Expense" : "Income"}",
                      0,
                      setExpense),
                  _expenseCards(Icons.local_offer, "Category", 1, setCategory),
                  _expenseCards(Icons.today, "Date", 2, setDate),
                ],
              ),
            ),
            _buildRecurringCard()
          ],
        ));
  }
}
