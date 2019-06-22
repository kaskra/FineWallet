/*
 * Developed by Lukas Krauch 22.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/DB_Access/transaction_list.dart';
import 'package:finewallet/DB_Access/transaction_provider.dart';
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/db_initilization.dart';
import 'package:finewallet/Statistics/monthly_overview.dart';
import 'package:finewallet/add_page.dart';
import 'package:finewallet/bottom_bar_app_item.dart';
import 'package:finewallet/color_themes.dart';
import 'package:finewallet/general_widgets.dart';
import 'package:finewallet/history.dart';
import 'package:finewallet/profile.dart';
import 'package:finewallet/sliding_fab_menu.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  // set mock values for testing/emulator
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{}; // set initial values here if desired
    }
    return null;
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: normalTheme2,
      home: MyHomePage(title: 'FineWallet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 4;
  bool _showBottomBar = true;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Widget _overviewBox(String title, double amount, bool last, Function onTap) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Theme.of(context).primaryColor),
            margin:
                EdgeInsets.only(right: last ? 4 : 2.5, left: last ? 2.5 : 4),
            child: Material(
                color: Theme.of(context).colorScheme.primary,
                child: InkWell(
                  onTap: () => onTap(),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "Spare budget",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "${amount.toStringAsFixed(2)}€",
                            style: TextStyle(
                                color: amount <= 0
                                    ? Theme.of(context)
                                        .accentTextTheme
                                        .body1
                                        .color
                                    : Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ))));
  }

  Widget _day(int day, double budget) {
    bool isToday = (day == DateTime.now().weekday);

    return generalCard(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            isToday
                ? Text("Today",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold))
                : Text(getDayName(day),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface)),
            Expanded(
                child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                "${budget.toStringAsFixed(2)}€",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ))
          ],
        ),
        isToday
            ? BoxDecoration(
                border: Border.all(
                    width: 2, color: Theme.of(context).colorScheme.secondary))
            : null);
  }

  Widget _days() {
    List<DateTime> days = getLastWeekAsDates();
    return FutureBuilder<List<SumOfTransactionModel>>(
      future: TransactionsProvider.db
          .getExpensesGroupedByDay(dayInMillis(DateTime.now())),
      initialData: List(),
      builder: (BuildContext context,
          AsyncSnapshot<List<SumOfTransactionModel>> snapshot) {
        if (snapshot.hasData) {
          List<Widget> listItems = List();
          for (DateTime date in days) {
            int index = snapshot.data
                .indexWhere((s) => s.hasSameValue(dayInMillis(date)));
            if (index >= 0) {
              listItems.add(_day(date.weekday, snapshot.data[index].amount));
            } else {
              listItems.add(_day(date.weekday, 0));
            }
          }
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: listItems,
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildFABs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
//        Spacer(
//          flex: 4,
//        ),
        FloatingActionButton(
          heroTag: null,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPage("Income", 0))),
          child:
              Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
        ),
//        Spacer(),
        FloatingActionButton(
          mini: true,
          heroTag: null,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HistoryPage("Transaction History",
                      day: dayInMillis(DateTime.now())))),
          child: Icon(Icons.list,
              color: Theme.of(context).colorScheme.onSecondary),
        ),
//        Spacer(),
        FloatingActionButton(
          heroTag: null,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPage("Expense", 1))),
          child: Icon(Icons.remove,
              color: Theme.of(context).colorScheme.onSecondary),
        ),
//        Spacer(
//          flex: 4,
//        ),
      ],
    );
  }

  void _onMonthTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MonthlyOverview(
                  initialMonth: DateTime.now(),
                )));
  }

  void _onDayTap() {}

  Widget _buildBody() {
    return Center(
        child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: FutureBuilder<TransactionList>(
                    future: TransactionsProvider.db
                        .getTransactionsOfMonth(dayInMillis(DateTime.now())),
                    initialData: TransactionList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<TransactionList> snapshot) {
                      if (snapshot.hasData) {
                        int dayOfMonth = DateTime.now().day;
                        int lastDayOfMonth = getLastDayOfMonth(DateTime.now());

                        double monthlyExpenses = snapshot.data
                            .where((TransactionModel txn) =>
                                txn.date != dayInMillis(DateTime.now()))
                            .sumExpenses();
                        double monthlyIncomes = snapshot.data.sumIncomes();
                        double expensesToday = snapshot.data
                            .byDayInMillis(dayInMillis(DateTime.now()))
                            .sumExpenses();

                        int remainingDaysInMonth =
                            lastDayOfMonth - dayOfMonth + 1;
                        double monthlySpareBudget =
                            monthlyIncomes - monthlyExpenses;
                        double budgetPerDay =
                            (monthlySpareBudget / remainingDaysInMonth) -
                                expensesToday;
                        double displayedMonthlySpareBudget =
                            monthlySpareBudget - expensesToday;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _overviewBox(
                                "TODAY", budgetPerDay, false, _onDayTap),
                            _overviewBox(
                                getMonthName(DateTime.now().month)
                                    .toUpperCase(),
                                displayedMonthlySpareBudget,
                                true,
                                _onMonthTap),
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            CircularProgressIndicator(),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Container(child: _days())
              ],
            )));
  }

  Widget _buildBottomBar() {
    return FABBottomAppBar(
      color: Theme.of(context).colorScheme.onSurface,
      selectedColor: Theme.of(context).colorScheme.secondary,
      items: [
        FABBottomAppBarItem(iconData: Icons.person, text: "Me"),
        FABBottomAppBarItem(iconData: Icons.equalizer, text: "Statistics"),
        FABBottomAppBarItem(disabled: true),
        FABBottomAppBarItem(
          iconData: Icons.list,
          text: "History",
        ),
        FABBottomAppBarItem(iconData: Icons.home, text: "Home"),
      ],
      onTabSelected: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      selectedIndex: _currentIndex,
      isVisible: _showBottomBar,
    );
  }

  void _addTransaction(int leftRight) {
    if (leftRight == -1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddPage("Income", 0)));
    } else if (leftRight == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddPage("Expense", 1)));
    }
    return;
  }

  void _navCallback(bool showNavBar) {
    setState(() {
      _showBottomBar = showNavBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      ProfilePage(
        showAppBar: false,
      ),
      MonthlyOverview(
        initialMonth: DateTime.now(),
        showAppBar: false,
      ),
      Container(),
      HistoryPage(
        "Transaction History",
        day: dayInMillis(DateTime.now()),
        showAppBar: false,
      ),
      _buildBody(),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: children[_currentIndex],
      floatingActionButton: SlidingFABMenu(
        onMenuFunction: _addTransaction,
        tapCallback: _navCallback,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
