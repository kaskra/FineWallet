/*
 * Developed by Lukas Krauch 27.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'dart:async';

import 'package:FineWallet/general/general_widgets.dart';
import 'package:FineWallet/models/month_model.dart';
import 'package:FineWallet/resources/blocs/month_bloc.dart';
import 'package:FineWallet/resources/month_provider.dart';
import 'package:FineWallet/resources/transaction_list.dart';
import 'package:FineWallet/resources/transaction_provider.dart';
import 'package:FineWallet/statistics/profile_chart.dart';
import 'package:FineWallet/statistics/spending_prediction_chart.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.showAppBar: true});

  final bool showAppBar;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _textEditingController = TextEditingController();

  double _currentMaxMonthlyBudget = 0;
  double _overallMaxBudget = 0;
  MonthModel _currentMonth;

  int _chartType = ProfileChart.MONTHLY_CHART;
  bool _showPrediction = false;

  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
        text: _currentMaxMonthlyBudget.toStringAsFixed(2));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCurrentMonth();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  void deactivate() {
    super.deactivate();
    _onLeavingPage();
  }

  Future<bool> _onLeavingPage() async {
    _currentMonth?.currentMaxBudget = _currentMaxMonthlyBudget;
    Provider.of<MonthBloc>(context).updateMonth(_currentMonth);
    return true;
  }

  void _loadCurrentMonth() async {
    TransactionList monthlyTransactions = await TransactionsProvider.db
        .getTransactionsOfMonth(dayInMillis(DateTime.now()));

    MonthModel currentMonth = await MonthProvider.db.getCurrentMonth();
    setState(() {
      _overallMaxBudget = monthlyTransactions.sumIncomes();
      _currentMonth = currentMonth;
    });

    _setMaxMonthlyBudget(_currentMonth.currentMaxBudget);
  }

  void _setMaxMonthlyBudget(double value) {
    setState(() {
      if (value >= _overallMaxBudget) {
        value = _overallMaxBudget;
      } else if (value < 0) {
        value = 0;
      }

      _currentMaxMonthlyBudget = value;
      _textEditingController.text = value.toStringAsFixed(2);
    });
  }

  Widget _toScreenWidth(Widget child) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width,
        child: child,
      );

  Widget _buildSliderBox() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Monthly available budget",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
                Text(
                  "€ ",
                  style: const TextStyle(fontSize: 16),
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
            )),
        Align(
          alignment: Alignment.center,
          child: Text(
              "Expected savings: ${(_overallMaxBudget - _currentMaxMonthlyBudget).toStringAsFixed(2)}€",
              style: const TextStyle(fontSize: 14)),
        )
      ],
    );
  }

  Widget _categoryBox() {
    return Stack(
      children: <Widget>[
        Column(children: <Widget>[
          Text(
            _showPrediction
                ? "Spending prediction"
                : "${_chartType == ProfileChart.MONTHLY_CHART ? "Monthly" : "Lifetime"} expenses",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
              height: 200,
              padding: const EdgeInsets.all(15),
              child: _showPrediction
                  ? SpendingPredictionChart(
                      monthlyBudget: _currentMaxMonthlyBudget,
                    )
                  : ProfileChart(
                      type: _chartType,
                    )),
        ]),
        Align(
          alignment: Alignment.topRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              !_showPrediction
                  ? InkWell(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.repeat,
                            size: 16,
                            color: Theme.of(context).colorScheme.onBackground,
                          )),
                      onTap: () {
                        setState(() {
                          _chartType = _chartType == ProfileChart.MONTHLY_CHART
                              ? ProfileChart.LIFE_CHART
                              : ProfileChart.MONTHLY_CHART;
                        });
                      },
                    )
                  : Container(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        Icons.repeat,
                        size: 16,
                        color: Colors.transparent,
                      )),
              InkWell(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.show_chart,
                      size: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _showPrediction = !_showPrediction;
                    });
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _savingsBox() {
    return Column(
      children: <Widget>[
        Text(
          "Savings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Consumer<MonthBloc>(builder: (_, bloc, __) {
          bloc.getSavings();
          return StreamBuilder<double>(
              initialData: 0,
              stream: bloc.savings,
              builder: (context, snapshot) {
                return Text(
                    "${(snapshot.hasData ? snapshot.data : 0).toStringAsFixed(2)}€",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primaryVariant));
              });
        })
      ],
    );
  }

  Widget _buildBody() {
    BorderRadius radius = BorderRadius.circular(4);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _toScreenWidth(
            generalCard(_buildSliderBox(), cardBorderRadius: radius)),
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
      backgroundColor: const Color(0xffd8e7ff),
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
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }
}
