import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/icon_wrapper.dart';
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
      : date = model.month.firstDate,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: _buildCategoryListView());
  }

  Widget _buildCategoryListView() {
    final settings = TransactionFilterSettings(
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
          return Column(
            children: <Widget>[
              for (int i = 0; i < snapshot.data.length; i++)
                _buildCategoryListItem(snapshot.data[i].first,
                    snapshot.data[i].third, snapshot.data[i].second)
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  // TODO refactor dialog
  void _showTransactionsOfCategory(int id, String categoryName) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(cardRadius)),
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: <Widget>[
              _buildDialogHeader(id, categoryName),
              Expanded(child: _buildDialogTransactionList(id)),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  padding: const EdgeInsets.all(5),
                  textColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(cardRadius),
          topRight: Radius.circular(cardRadius),
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
              color: Theme.of(context).colorScheme.secondary,
              child: Icon(
                CategoryIcon(id - 1).data,
                size: 45,
              ),
            ),
          ),
          Text(
            categoryName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
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
    final settings = TransactionFilterSettings(
        dateInMonth: model.month.firstDate, category: id);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: StreamBuilder(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchTransactionsWithFilter(settings),
        builder:
            (context, AsyncSnapshot<List<TransactionWithCategory>> snapshot) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              for (final TransactionWithCategory tx in snapshot.data ?? [])
                _buildTransactionRow(tx),
            ],
          );
        },
      ),
    );
  }

  InformationRow _buildTransactionRow(TransactionWithCategory tx) {
    // Initialize date formatter for timestamp
    final formatter = DateFormat('E, dd.MM.yy');

    return InformationRow(
      padding: const EdgeInsets.all(5),
      text: Expanded(
        child: Text.rich(
          TextSpan(
            text: "${tx.sub.name}",
            children: [
              TextSpan(
                text: "\n${formatter.format(tx.tx.date)}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              )
            ],
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              decoration: TextDecoration.none,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: "roboto",
            ),
          ),
        ),
      ),
      value: Text(
        "-${tx.tx.amount.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
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
    return DecoratedCard(
      elevation: 0,
      padding: 2,
      child: ListTile(
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
              padding: const EdgeInsets.all(4),
              color: Theme.of(context).colorScheme.secondary,
              child: Icon(
                CategoryIcon(id - 1).data,
                color: Theme.of(context).colorScheme.onSurface,
                size: 25,
              ),
            ),
          ),
        ),
        trailing: Text(
          "-${amount.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        title: Text(categoryName),
      ),
    );
  }
}
