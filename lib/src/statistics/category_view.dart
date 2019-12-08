import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/core/resources/category_icon.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/history_page/history_item_icon.dart';
import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// This class creates a widget that displays all categories for a month.
class CategoryListView extends StatelessWidget {
  final DateTime date;
  final MonthWithDetails model;
  final BuildContext context;

  CategoryListView({Key key, @required this.model, @required this.context})
      : this.date = DateTime.fromMillisecondsSinceEpoch(model.month.firstDate),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _buildCategoryListView(), //Text("No categories found!"),
      ),
    );
  }

  Widget _buildCategoryListView() {
    var settings = TransactionFilterSettings(
      dateInMonth: model.month.firstDate,
      expenses: true,
    );

    return StreamBuilder<List<Tuple3<int, String, double>>>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchSumOfTransactionsByCategories(settings),
      builder: (BuildContext context,
          AsyncSnapshot<List<Tuple3<int, String, double>>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: <Widget>[
              for (int i = 0; i < snapshot.data.length; i++)
                _buildCategoryListItem(snapshot.data[i].first,
                    snapshot.data[i].third, snapshot.data[i].second)
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  void _showTransactionsOfCategory(int id, String categoryName) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(CARD_RADIUS)),
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: <Widget>[
              _buildDialogHeader(id, categoryName),
              Expanded(child: _buildDialogTransactionList(id)),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.all(5),
                  textColor: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(int id, String categoryName) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(CARD_RADIUS),
          topRight: Radius.circular(CARD_RADIUS),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          IconWrapper(
            clipRadius: 45,
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerLeft,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.primary,
              child: Icon(
                CategoryIcon(id - 1).data,
                color: Theme.of(context).colorScheme.onSecondary,
                size: 45,
              ),
            ),
          ),
          Text(
            categoryName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              decoration: TextDecoration.none,
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: "roboto",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTransactionList(int id) {
    var settings = TransactionFilterSettings(
        dateInMonth: model.month.firstDate, category: id);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: StreamBuilder(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchTransactionsWithFilter(settings),
        builder: (context, snapshot) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              for (var tx in snapshot.data ?? []) _buildTransactionRow(tx),
            ],
          );
        },
      ),
    );
  }

  InformationRow _buildTransactionRow(TransactionsWithCategory tx) {
    // Initialize date formatter for timestamp
    var formatter = new DateFormat('E, dd.MM.yy');

    return InformationRow(
      padding: const EdgeInsets.all(5),
      text: Expanded(
        child: Text.rich(
          TextSpan(
            text: "${tx.subcategoryName}",
            children: [
              TextSpan(
                text:
                    "\n${formatter.format(DateTime.fromMillisecondsSinceEpoch(tx.date))}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              )
            ],
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              decoration: TextDecoration.none,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: "roboto",
            ),
          ),
        ),
      ),
      value: Text(
        "-${tx.amount.toStringAsFixed(2)}€",
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          decoration: TextDecoration.none,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "roboto",
        ),
      ),
    );
  }

  Widget _buildCategoryListItem(int id, double amount, String categoryName) {
    return ListTile(
      onTap: () {
        _showTransactionsOfCategory(id, categoryName);
      },
      leading: SizedBox(
        height: 50,
        width: 50,
        child: IconWrapper(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Theme.of(context).colorScheme.secondary,
            child: Icon(
              CategoryIcon(id - 1).data,
              color: Theme.of(context).colorScheme.onSecondary,
              size: 25,
            ),
          ),
        ),
      ),
      trailing: Text(
        "-${amount.toStringAsFixed(2)}€",
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 17),
      ),
      title: Text(categoryName),
    );
  }
}
