import 'dart:math';

import 'package:finewallet/Blocs/transaction_bloc.dart';
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/internal_data.dart';
import 'package:finewallet/general_widgets.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class HistoryPage extends StatefulWidget {
  HistoryPage(this.title, {Key key}) : super(key: key);

  final String title;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _txBloc = TransactionBloc();

  Widget _transactionContent(TransactionModel item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Icon(icons[item.category - 1]),
        ),
        Expanded(
          flex: 4,
          child: Text(item.subcategoryName),
        ),
        Expanded(
            flex: 3,
            child: Text(
              "${item.amount.toStringAsFixed(2)}€",
              style: TextStyle(
                  color: item.isExpense == 1 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
              textDirection: TextDirection.rtl,
            )),
        InkWell(
          child: Icon(Icons.delete_outline),
          onTap: () {
            _txBloc.delete(item.id);
          },
        )
      ],
    );
  }

  Widget _seperator(bool isToday, String dateString) {
    return Center(
        child: Container(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0x22000000),
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Text(
              isToday ? "TODAY" : dateString,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal),
            )));
  }

  Widget _historyItem(TransactionModel item) {
    return Row(
      children: <Widget>[
        (item.isExpense == 1)
            ? Spacer(
                flex: 1,
              )
            : Container(),
        Expanded(
          flex: 3,
          child: generalCard(_transactionContent(item)),
        ),
        (item.isExpense == 0)
            ? Spacer(
                flex: 1,
              )
            : Container(),
      ],
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<TransactionModel>>(
        stream: _txBloc.transactions,
        builder: (BuildContext context,
            AsyncSnapshot<List<TransactionModel>> snapshot) {
          if (snapshot.hasData) {
            int prevDate = -1;
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                if (snapshot.data[index].date != prevDate) {
                  prevDate = snapshot.data[index].date;
                  intl.DateFormat d = intl.DateFormat.MMMEd();
                  String dateString =
                      d.format(DateTime.fromMillisecondsSinceEpoch(prevDate));
                  bool isToday = prevDate == dayInMillis(DateTime.now());
                  return Column(
                    children: <Widget>[
                      _seperator(isToday, dateString),
                      _historyItem(snapshot.data[index])
                    ],
                  );
                }
                return _historyItem(snapshot.data[index]);
              },
            );
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd8e7ff),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TransactionModel tx = new TransactionModel(
              subcategory: Random.secure().nextInt(60) + 1,
              amount: Random().nextDouble() * 100,
              date: dayInMillis(
                  DateTime.now().add(Duration(days: -Random().nextInt(3)))),
              isExpense: 1);
          _txBloc.add(tx);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}