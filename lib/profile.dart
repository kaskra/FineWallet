/*
 * Developed by Lukas Krauch 23.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/Models/month_model.dart';
import 'package:finewallet/general_widgets.dart';
import 'package:finewallet/resources/db_provider.dart';
import 'package:finewallet/resources/month_provider.dart';
import 'package:finewallet/resources/transaction_list.dart';
import 'package:finewallet/resources/transaction_provider.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.showAppBar: true});

  final bool showAppBar;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  double _currentMaxMonthlyBudget = 0;
  TextEditingController _textEditingController = TextEditingController();

  double _overallMaxBudget = 1600;

  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
        text: _currentMaxMonthlyBudget.toStringAsFixed(2));
    _syncDatabase();
  }

  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  void _syncDatabase() async {
    int numRecordedMonths = await MonthProvider.db.amountRecordedMonths();
    if (numRecordedMonths == 0) {
      Provider.db.newMonth(MonthModel(
        firstDayOfMonth:
            dayInMillis(DateTime(DateTime.now().year, DateTime.now().month, 1)),
        currentMaxBudget: 0,
        savings: 0,
      ));
    }

    TransactionList monthlyTransactions = await TransactionsProvider.db
        .getTransactionsOfMonth(dayInMillis(DateTime.now()));

    setState(() {
      _overallMaxBudget = monthlyTransactions.sumIncomes();
    });
  }

  Widget _toScreenWidth(Widget child) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width,
        child: child,
      );

  Widget _sliderBox() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text("Monthly available budget"),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Slider(
                    onChanged: (value) {
                      _setMaxMonthlyBudget(value);
                    },
                    onChangeStart: (value) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    value: _currentMaxMonthlyBudget,
                    min: 0,
                    max: _overallMaxBudget,
                    divisions: 100,
                  ),
                ),
//                Icon(
//                  Icons.euro_symbol,
//                  color: Theme.of(context).colorScheme.onBackground,
//                  size: 18,
//                ),
                Text(
                  "€ ",
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(border: InputBorder.none),
                  onSubmitted: (valueAsString) {
                    double value = double.parse(valueAsString);
                    _setMaxMonthlyBudget(value);
                  },
                  onTap: () {
                    _textEditingController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _textEditingController.text.length);
                  },
                  controller: _textEditingController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ))
              ],
            ))
      ],
    );
  }

  void _setMaxMonthlyBudget(double value) {
    setState(() {
      if (value >= _overallMaxBudget) {
        value = _overallMaxBudget;
      } else if (value < 0) {
        value = 0;
      }
      assert(value <= _overallMaxBudget);
      assert(value >= 0);

      _currentMaxMonthlyBudget = value;
      _textEditingController.text = value.toStringAsFixed(2);
    });
  }

  Widget _categoryBox() {
    return Container(
      height: 200,
    );
  }

  Widget _savingsBox() {
    return Column(
      children: <Widget>[
        Text(
          "Savings: ",
        ),
        Text("1345€",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primaryVariant))
      ],
    );
  }

  Widget _buildBody() {
    BorderRadius radius = BorderRadius.circular(4);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _toScreenWidth(generalCard(_sliderBox(), cardBorderRadius: radius)),
        _toScreenWidth(generalCard(_categoryBox(), cardBorderRadius: radius)),
        _toScreenWidth(
          generalCard(_savingsBox(), cardBorderRadius: radius),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffd8e7ff),
      resizeToAvoidBottomInset: true,
      appBar: widget.showAppBar
          ? AppBar(
              iconTheme: Theme.of(context).iconTheme,
              centerTitle: true,
              title: Text(
                "Profile",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            )
          : null,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _setMaxMonthlyBudget(
                double.parse(_textEditingController.value.text));
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }
}
