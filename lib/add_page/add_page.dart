/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:15:33 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:async';

import 'package:FineWallet/add_page/bottom_sheets.dart';
import 'package:FineWallet/color_themes.dart';
import 'package:FineWallet/datatypes/category.dart';
import 'package:FineWallet/datatypes/repeat_type.dart';
import 'package:FineWallet/general/corner_triangle.dart';
import 'package:FineWallet/general/general_widgets.dart';
import 'package:FineWallet/models/transaction_model.dart';
import 'package:FineWallet/resources/blocs/month_bloc.dart';
import 'package:FineWallet/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/resources/category_list.dart';
import 'package:FineWallet/resources/category_provider.dart';
import 'package:FineWallet/resources/category_icon.dart';
import 'package:FineWallet/resources/transaction_list.dart';
import 'package:FineWallet/resources/transaction_provider.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  AddPage(this.title, this.isExpense, {Key key, this.transaction})
      : super(key: key);

  final String title;
  final int isExpense;
  final TransactionModel transaction;

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
  bool _isEditMode = false;
  int _editTxId = -1;

  @override
  void initState() {
    super.initState();

    _date = DateTime.now();
    checkForEditMode();
  }

  // TODO rework this
  void checkForEditMode() async {
    if (widget.transaction != null) {
      CategoryList categories = await CategoryProvider.db.getAllCategories();
      int selectedCategory = widget.transaction.category;
      if (widget.transaction.isExpense != 1) {
        selectedCategory -= categories.length;
      } else {
        selectedCategory -= 1;
      }

      _editTxId = widget.transaction.id;
      _isEditMode = true;
      _expense = widget.transaction.amount;
      _textEditingController.text = _expense.toStringAsFixed(2);
      _date = DateTime.fromMillisecondsSinceEpoch(widget.transaction.date);
      _subcategory = Category(CategoryIcon(widget.transaction.category - 1).data,
          widget.transaction.subcategoryName, widget.transaction.subcategory,
          selectedCategory: selectedCategory);

      if (widget.transaction.isRecurring == 1) {
        if (widget.transaction.replayUntil != null) {
          _repeatUntil = DateTime.fromMillisecondsSinceEpoch(
              widget.transaction.replayUntil);
        }
        _typeIndex = widget.transaction.replayType;
        _isExpanded = widget.transaction.isRecurring == 1;

        // If recurring, set the date to the first of the recurrence.
        // With that every recurring instance is changed
        TransactionList txs = await TransactionsProvider.db
            .getAllTrans(dayInMillis(DateTime.now()));
        txs = txs.where((tx) => tx.id == _editTxId);
        _date = DateTime.fromMillisecondsSinceEpoch(txs.toList().last.date);
      }
      setState(() {});
    }
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
            padding: const EdgeInsets.all(5),
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
              color: const Color(0xFF636a75),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border.all(
                        color: Theme.of(context).canvasColor,
                        width: topBorderHeight / 2),
                    borderRadius:
                        BorderRadius.vertical(top: const Radius.circular(16))),
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: _keyboardHeight + (bottomSheetHeight - _keyboardHeight),
                child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: TextField(
                    decoration: InputDecoration(
                        labelText:
                            "Enter your ${widget.isExpense == 0 ? "income" : "expense"}",
                        contentPadding: const EdgeInsets.all(4),
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

  void _showMissingValueSnackBar(BuildContext context, [String text]) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(text ?? "Please fill out every panel!"),
    ));
  }

  Widget _buildRecurringCard() {
    return Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        child: Card(
          child: CornerTriangle(
              corner: Corner.TOP_LEFT,
              size: const Size(25, 25),
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
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              child: Divider(
                                height: 1,
                              ),
                              margin: const EdgeInsets.only(bottom: 4),
                            ),
                            _repeatTypeChoice(),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: _repeatUntilDate(),
                            )
                          ],
                        ),
                      ),
                      Container(),
                      _isExpanded,
                      const Duration(milliseconds: 300))
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
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: centerAppBar,
        elevation: appBarElevation,
        backgroundColor:
            Theme.of(context).primaryColor.withOpacity(appBarOpacity),
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
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
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
                return _showMissingValueSnackBar(context,
                    "Please choose a date that is after the current date.");

              if (isRecurrencePossible(dayInMillis(_date),
                      dayInMillis(_repeatUntil), _typeIndex) ==
                  -1)
                return _showMissingValueSnackBar(context,
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

            if (_isEditMode) {
              tx.id = _editTxId;
              Provider.of<TransactionBloc>(context).updateTransaction(tx);
            } else {
              Provider.of<TransactionBloc>(context).add(tx);
            }
            Provider.of<MonthBloc>(context).syncMonths();
            Navigator.pop(context);
          } else {
            return _showMissingValueSnackBar(context);
          }
        });
  }
}
