import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
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

    return StreamBuilder<List<SumTransactionsByCategoryResult>>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchSumOfTransactionsByCategories(settings),
      builder: (BuildContext context,
          AsyncSnapshot<List<SumTransactionsByCategoryResult>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              for (int i = 0; i < snapshot.data.length; i++)
                _buildCategoryListItem(snapshot.data[i].c.id,
                    snapshot.data[i].sumAmount, snapshot.data[i].c.name)
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
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    primary: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    LocaleKeys.ok.tr().toUpperCase(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
            tryTranslatePreset(categoryName),
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
            (context, AsyncSnapshot<List<TransactionWithDetails>> snapshot) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              for (final TransactionWithDetails tx in snapshot.data ?? [])
                _buildTransactionRow(tx),
            ],
          );
        },
      ),
    );
  }

  InformationRow _buildTransactionRow(TransactionWithDetails tx) {
    // Initialize date formatter for timestamp
    final formatter = DateFormat.yMMMEd(context.locale.toLanguageTag());

    return InformationRow(
      padding: const EdgeInsets.all(5),
      text: Expanded(
        child: Text.rich(
          TextSpan(
            text: tryTranslatePreset(tx.s),
            children: [
              if (tx.label.isNotEmpty)
                TextSpan(
                    text: "\n${tx.label}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    )),
              TextSpan(
                text: "\n${formatter.format(DateTime.parse(tx.date))}",
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.normal),
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
      value: AmountString(
        tx.amount * -1,
        colored: true,
        textStyle: const TextStyle(
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
        trailing: AmountString(
          amount * -1,
          colored: true,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        title: Text(categoryName),
      ),
    );
  }
}
