import 'package:finewallet/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:finewallet/Resources/db_initilization.dart';

import 'add_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textSelectionColor: Colors.black26,
        primarySwatch: Colors.orange,
        appBarTheme: AppBarTheme(actionsIconTheme: IconThemeData(color: Colors.white))
        
      ),
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
  void initState(){ 
    super.initState();
    initDB();
  }

  Widget _overviewBox(String title, double amount, bool last) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
          margin: EdgeInsets.only(right: last ? 0 : 2.5, left: last ? 2.5 : 0),
          color: Colors.orange,
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
                "€$amount",
                style: TextStyle(color: Colors.white),
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
            isToday? Text("Today", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))
            : Text( getDayName(day), style: TextStyle(color: Colors.black54)),
            Expanded(
                child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                "$budget €",
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ))
          ],
        ),
        isToday? BoxDecoration(border: Border.all(width: 2, color: Colors.orange)) 
        : null);
  }

  Widget _days() {
    List<Widget> days = List();
    for (var i = 0; i < 7; i++) {
      DateTime futureDay = DateTime.now().add(Duration(days: -i));
      days.add(_day(futureDay.weekday, 32));
    }

    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: days,
    );
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
      body: Center(
          child: Container(
              constraints: BoxConstraints.expand(),
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _overviewBox("TODAY", 103.0, false),
                        _overviewBox("MAY", 1293.0, true),
                      ],
                    ),
                  ),
                  Container(child: _days())
                ],
              ))),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: 4,),
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
                    builder: (context) => HistoryPage("Transaction History"))),
            child: Icon(Icons.list, color: Colors.white),
          ),
          Spacer(),
          FloatingActionButton(
            heroTag: null,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddPage("Expense", 1))),
            child: Icon(Icons.remove, color: Colors.white),
          ),
          Spacer(flex: 4,),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}