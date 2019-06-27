/*
 * Developed by Lukas Krauch 29.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/Datatypes/category.dart';
import 'package:finewallet/Datatypes/repeat_type.dart';
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/bottom_sheets.dart';
import 'package:finewallet/corner_triangle.dart';
import 'package:finewallet/general_widgets.dart';
import 'package:finewallet/resources/db_provider.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSurface)),
                      Icon(
                        iconData,
                        size: constraint.biggest.width / 3,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      FittedBox(
                        child: Text(valueString,
                            maxLines: 2,
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 15,
                                color:
                                    Theme.of(context).colorScheme.onSurface)),
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
        builder: (context) {
          _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return WillPopScope(
            onWillPop: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              return Future.value(true);
            },
            child: Container(
              color: Color(0xFF636a75),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border.all(
                        color: Theme.of(context).canvasColor,
                        width: topBorderHeight / 2),
                    borderRadius:
                        BorderRadius.vertical(top: new Radius.circular(16))),
                padding: EdgeInsets.only(left: 10, right: 10),
                height: _keyboardHeight + (bottomSheetHeight - _keyboardHeight),
                child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: TextField(
                    decoration: InputDecoration(
                        labelText:
                            "Enter your ${widget.isExpense == 0 ? "income" : "expense"}",
                        contentPadding: EdgeInsets.all(4),
                        labelStyle: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).textTheme.body1.color),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onSurface)),
                        hintText: "0.00"),
                    autofocus: true,
                    onSubmitted: (s) {
                      return Navigator.pop(context);
                    },
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
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
          return Container(
            color: Color(0xFF636a75),
            child: CategoryBottomSheet(widget.isExpense, _subcategory),
          );
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
            topBorderHeight,
            context);
      },
    );
  }

  void setRepeatingDate() {
    showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color(0xFF636a75),
          child: buildBottomPicker(
              CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime:
                    _repeatUntil ?? DateTime.now().add(Duration(days: 1)),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    _repeatUntil = newDateTime;
                  });
                },
              ),
              bottomSheetHeight,
              topBorderHeight,
              context),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, [String text]) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text ?? "Please fill out every panel!"),
    ));
  }

  Widget _buildRecurringCard() {
    return Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Card(
          child: CornerTriangle(
              corner: Corner.TOP_LEFT,
              size: Size(25, 25),
              icon: CornerIcon(Icons.replay,
                  color: Theme.of(context).colorScheme.onSecondary),
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Repeat transaction",
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface),
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
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
        ),
        Container(
          width: 100,
          height: 35,
          alignment: Alignment.center,
          child: DropdownButton(
            isDense: true,
            isExpanded: true,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
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
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
        ),
        Container(
          width: 100,
          height: 35,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12))),
          child: MaterialButton(
            onPressed: () {
              setState(() {
                _repeatUntil =
                    _repeatUntil ?? DateTime.now().add(Duration(days: 1));
              });
              setRepeatingDate();
            },
            child: Text(
              _repeatUntil != null ? formatter.format(_repeatUntil) : "",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
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
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("SAVE",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            )),
        icon: Icon(
          Icons.save,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        onPressed: () {
          if (_expense != null &&
              _date != null &&
              _subcategory != null &&
              _typeIndex != null) {
            if (_repeatUntil != null) {
              if (_repeatUntil.isBefore(_date))
                return _showSnackBar(context,
                    "Please choose a date that is after the current date.");

              if (isRecurrencePossible(dayInMillis(_date),
                      dayInMillis(_repeatUntil), _typeIndex) ==
                  -1)
                return _showSnackBar(context,
                    "Your recurrence type does not fit inside the time frame.");
            }

            TransactionModel tx = new TransactionModel(
                amount: _expense,
                isExpense: widget.isExpense,
                date: dayInMillis(_date),
                subcategory: _subcategory.index,
                isRecurring: _isExpanded ? 1 : 0,
                replayType: _typeIndex,
                replayUntil:
                    _repeatUntil != null ? dayInMillis(_repeatUntil) : null);
            Provider.db.newTransaction(tx);
            Navigator.pop(context);
          } else {
            return _showSnackBar(context);
          }
        },
      ),
    );
  }
}
