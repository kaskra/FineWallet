/*
 * Developed by Lukas Krauch 27.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:FineWallet/general/general_widgets.dart';
import 'package:FineWallet/models/month_model.dart';
import 'package:FineWallet/resources/db_provider.dart';
import 'package:FineWallet/resources/month_provider.dart';
import 'package:FineWallet/resources/transaction_list.dart';
import 'package:FineWallet/resources/transaction_provider.dart';
import 'package:FineWallet/statistics/profile_chart.dart';
import 'package:FineWallet/statistics/spending_prediction_chart.dart';
import 'package:FineWallet/utils.dart';
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
  DateTime _today;

  double _overallMaxBudget = 0;
  double _savings = 0;
  MonthModel _currentMonth;

  int _chartType = ProfileChart.MONTHLY_CHART;
  bool _showPrediction = false;

  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      _today = DateTime.utc(now.year, now.month, now.day);
    });
    _syncDatabase();
    _textEditingController = TextEditingController(
        text: _currentMaxMonthlyBudget.toStringAsFixed(2));
  }

  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _updateDatabase();
  }

  void _updateDatabase() async {
    print("Update month in database!");
    _currentMonth.currentMaxBudget = _currentMaxMonthlyBudget;
    await MonthProvider.db.updateMonth(_currentMonth);
  }

  void _syncDatabase() async {
    TransactionList monthlyTransactions = await TransactionsProvider.db
        .getTransactionsOfMonth(dayInMillis(_today));

    List<MonthModel> allMonths = await MonthProvider.db.getAllRecordedMonths();
    MonthModel currentMonth = await MonthProvider.db.getCurrentMonth();

    await checkCurrentMonth(currentMonth, allMonths);

    await checkAllPreviousMonths(currentMonth, allMonths);

    allMonths = await MonthProvider.db.getAllRecordedMonths();

    double allSavings =
        allMonths.fold(0.0, (prev, next) => prev + next.savings);
    setState(() {
      _overallMaxBudget = monthlyTransactions.sumIncomes();
      _savings = allSavings;
      _currentMonth = allMonths.last;
    });
    _setMaxMonthlyBudget(_currentMonth.currentMaxBudget);
  }

  Future checkAllPreviousMonths(
      MonthModel currentMonth, List<MonthModel> all) async {
    MonthModel firstRecordedMonth = all.first;
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(firstRecordedMonth.firstDayOfMonth);
    DateTime currentMonthDate =
        DateTime.fromMillisecondsSinceEpoch(currentMonth.firstDayOfMonth);

    while (date.isBefore(currentMonthDate)) {
      if (all
              .where((MonthModel m) =>
                  m.firstDayOfMonth == date.millisecondsSinceEpoch)
              .length ==
          0) {
        MonthModel month = new MonthModel(
          monthlyExpenses: 0,
          savings: 0,
          currentMaxBudget: 0,
          firstDayOfMonth: date.millisecondsSinceEpoch,
        );
        await DatabaseProvider.db.newMonth(month);
      } else {
        MonthModel m = all.firstWhere((MonthModel month) =>
            month.firstDayOfMonth == date.millisecondsSinceEpoch);
        TransactionList prevMonthlyTransactions = await TransactionsProvider.db
            .getTransactionsOfMonth(m.firstDayOfMonth);
        m.monthlyExpenses = prevMonthlyTransactions.sumExpenses();
        m.savings = prevMonthlyTransactions.sumIncomes() - m.monthlyExpenses;
        MonthProvider.db.updateMonth(m);
      }

      date = getFirstDateOfNextMonth(date);
    }
  }

  Future checkCurrentMonth(
      MonthModel currentMonth, List<MonthModel> allMonths) async {
    if (currentMonth == null) {
      if (allMonths.length > 0) {
        MonthModel prevMonth = allMonths.last;
        TransactionList prevMonthlyTransactions = await TransactionsProvider.db
            .getTransactionsOfMonth(prevMonth.firstDayOfMonth);
        prevMonth.monthlyExpenses = prevMonthlyTransactions.sumExpenses();
        prevMonth.savings =
            prevMonthlyTransactions.sumIncomes() - prevMonth.monthlyExpenses;
        MonthProvider.db.updateMonth(prevMonth);
      }
      MonthModel month = new MonthModel(
        monthlyExpenses: 0,
        savings: 0,
        currentMaxBudget: 0,
        firstDayOfMonth: dayInMillis(DateTime(_today.year, _today.month, 1)),
      );
      await DatabaseProvider.db.newMonth(month);
    }
  }

  Widget _toScreenWidth(Widget child) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
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
            style: TextStyle(fontWeight: FontWeight.bold),
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
            )),
        Align(
          alignment: Alignment.center,
          child: Text(
              "Expected savings: ${(_overallMaxBudget - _currentMaxMonthlyBudget).toStringAsFixed(2)}€",
              style: TextStyle(fontSize: 14)),
        )
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

      _currentMaxMonthlyBudget = value;
      _textEditingController.text = value.toStringAsFixed(2);
    });
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
              padding: EdgeInsets.all(15),
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
                          padding: EdgeInsets.all(5),
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
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.repeat,
                        size: 16,
                        color: Colors.transparent,
                      )),
              InkWell(
                  child: Container(
                    margin: EdgeInsets.all(5),
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
        Text("${_savings.toStringAsFixed(2)}€",
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
