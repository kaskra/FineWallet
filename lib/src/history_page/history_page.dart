import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/history_page/indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  final TransactionFilterSettings filterSettings;

  const HistoryPage({Key key, this.filterSettings}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TransactionFilterSettings _filterSettings;

  @override
  void initState() {
    _filterSettings = widget.filterSettings;
    if (widget.filterSettings == null) {
      _filterSettings = TransactionFilterSettings.beforeDate(DateTime.now());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: _buildHistoryList(),
    );
  }

  Widget _buildHistoryList() {
    return StreamBuilder<List<TransactionsWithCategory>>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchTransactionsWithFilter(_filterSettings),
      builder: (BuildContext context,
          AsyncSnapshot<List<TransactionsWithCategory>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _buildItems(snapshot.data);
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildItems(List<TransactionsWithCategory> data) {
    List<Widget> items = [];

    DateTime lastDate = DateTime.fromMillisecondsSinceEpoch(data.first.date);
    items.add(_buildDateString(lastDate));
    for (var d in data) {
      var date = DateTime.fromMillisecondsSinceEpoch(d.date);

      // Visually divide transactions when the month changes.
      if (date.month != lastDate.month) {
        items.add(_buildMonthDivider());
      }

      // Add a date string to indicate to which day the transactions belong.
      if (date != lastDate) {
        items.add(_buildDateString(date));
      }

      items.add(_buildTxItem(d));
      lastDate = date;
    }

    return ListView(
      children: items,
      shrinkWrap: true,
    );
  }

  Widget _buildMonthDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Divider(
        endIndent: 10,
        indent: 10,
      ),
    );
  }

  Widget _buildDateString(DateTime lastDate) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 8.0),
      child: Text(
        _getDateString(lastDate),
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget _buildTxItem(TransactionsWithCategory d) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: CustomPaint(
        foregroundPainter: IndicatorPainter(
          color: d.isExpense ? Colors.red : Colors.green,
          thickness: 6,
          side: d.isExpense ? IndicatorSide.RIGHT : IndicatorSide.LEFT,
        ),
        child: Material(
          elevation: Theme.of(context).cardTheme.elevation,
          child: ListTile(
            title: Text(
              d.subcategoryName,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(d.subcategoryName),
            trailing: _buildAmountText(d),
            leading: _buildItemIcon(d),
          ),
        ),
      ),
    );
  }

  CircleAvatar _buildItemIcon(TransactionsWithCategory d) {
    return CircleAvatar(
      child: Icon(
        CategoryIcon(d.categoryId - 1).data,
        color: Theme.of(context).iconTheme.color,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildAmountText(TransactionsWithCategory d) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        d.isExpense
            ? Icon(
                Icons.replay,
                color: Theme.of(context).colorScheme.secondary,
                size: 18,
              )
            : SizedBox(),
        Text(
          " ${d.isExpense ? "-" : ""}${d.amount.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
          style: TextStyle(
              fontSize: 16,
              color: d.isExpense ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _getDateString(DateTime date) {
    intl.DateFormat d = intl.DateFormat.MMMEd();
    return d.format(date).toUpperCase();
  }
}
