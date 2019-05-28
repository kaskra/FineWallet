import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/DBProvider.dart';
import 'package:finewallet/Resources/db_initilization.dart';
import 'package:finewallet/add_page.dart';
import 'package:finewallet/general_widgets.dart';
import 'package:finewallet/history.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          textSelectionColor: Colors.black26,
          primarySwatch: Colors.orange,
          appBarTheme: AppBarTheme(
              actionsIconTheme: IconThemeData(color: Colors.white))),
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
  @override
  void initState() {
    super.initState();
    initDB();
  }

  Widget _overviewBox(String title, double amount, bool last) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0), color: Colors.orange),
          padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
          margin: EdgeInsets.only(right: last ? 4 : 2.5, left: last ? 2.5 : 4),
          // color: Colors.orange,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "Spare budget",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              Text(
                "${amount.toStringAsFixed(2)}€",
                style: TextStyle(
                    color: amount <= 0 ? Colors.red : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
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
                        color: Colors.black54, fontWeight: FontWeight.bold))
                : Text(getDayName(day),
                    style: TextStyle(color: Colors.black54)),
            Expanded(
                child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                "${budget.toStringAsFixed(2)}€",
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ))
          ],
        ),
        isToday
            ? BoxDecoration(border: Border.all(width: 2, color: Colors.orange))
            : null);
  }

  Widget _days() {
    List<DateTime> days = getLastWeekAsDates();
    return FutureBuilder<List<SumOfTransactionModel>>(
      future: DBProvider.db.getExpensesGroupedByDay(),
      initialData: List(),
      builder: (BuildContext context,
          AsyncSnapshot<List<SumOfTransactionModel>> snapshot) {
        if (snapshot.hasData) {
          List<Widget> listItems = List();
          for (DateTime date in days) {
            int index = snapshot.data
                .indexWhere((sotm) => sotm.hasSameValue(dayInMillis(date)));
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Spacer(
          flex: 4,
        ),
        FloatingActionButton(
          heroTag: null,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPage("Income", 0))),
          child: Icon(Icons.add, color: Colors.white),
        ),
        Spacer(),
        FloatingActionButton(
          mini: true,
          heroTag: null,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HistoryPage("Transaction History",
                      day: dayInMillis(DateTime.now())))),
          child: Icon(Icons.list, color: Colors.white),
        ),
        Spacer(),
        FloatingActionButton(
          heroTag: null,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPage("Expense", 1))),
          child: Icon(Icons.remove, color: Colors.white),
        ),
        Spacer(
          flex: 4,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Center(
        child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: FutureBuilder<List<TransactionModel>>(
                    future: DBProvider.db.getTransactionsOfMonth(
                        DateTime.now().millisecondsSinceEpoch),
                    initialData: List(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TransactionModel>> snapshot) {
                      if (snapshot.hasData) {
                        int dayOfMonth = DateTime.now().day;
                        int lastDayOfMonth = getLastDayOfMonth(DateTime.now());
                        List<TransactionModel> incomes = snapshot.data
                            .where((t) => t.isExpense == 0)
                            .toList();
                        List<TransactionModel> todayExpenses = snapshot.data
                            .where((t) => t.isExpense == 1)
                            .where((t) => t.date == dayInMillis(DateTime.now()))
                            .toList();
                        List<TransactionModel> notTodayExpenses = snapshot.data
                            .where((t) => t.isExpense == 1)
                            .where((t) => t.date != dayInMillis(DateTime.now()))
                            .toList();
                        double monthlyIncomes = incomes.fold(
                            0, (prev, element) => prev + element.amount);
                        double monthlyExpenses = notTodayExpenses.fold(
                            0, (prev, element) => prev + element.amount);
                        double todaysExpenses = todayExpenses.fold(
                            0, (prev, element) => prev + element.amount);

                        int remainingDaysInMonth =
                            lastDayOfMonth - dayOfMonth + 1;
                        double monthlySpareBudget =
                            monthlyIncomes - monthlyExpenses;
                        double budgetPerDay =
                            (monthlySpareBudget / remainingDaysInMonth) -
                                todaysExpenses;
                        double displayedMonthlySpareBudget =
                            monthlySpareBudget - todaysExpenses;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _overviewBox("TODAY", budgetPerDay, false),
                            _overviewBox(
                                getMonthName(DateTime.now().month)
                                    .toUpperCase(),
                                displayedMonthlySpareBudget,
                                true),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd8e7ff),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFABs(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
