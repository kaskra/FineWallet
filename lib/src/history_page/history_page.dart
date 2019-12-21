import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/transaction_dao.dart';
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
          return _buildItems(snapshot.data);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildItems(List<TransactionsWithCategory> data) {
    List<Widget> items = [];

    DateTime lastDate = DateTime.fromMillisecondsSinceEpoch(data.first.date);
    items.add(Text(
      _getDateString(lastDate),
      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
    ));
    for (var d in data) {
      var date = DateTime.fromMillisecondsSinceEpoch(d.date);

      if (date.month != lastDate.month) {
        items.add(Divider());
      }

      if (date != lastDate) {
        items.add(Text(
          _getDateString(date),
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
        ));
      }

      items.add(_buildTxItem(d));
    }

    return ListView(
      children: items,
      shrinkWrap: true,
    );
  }

  Widget _buildTxItem(TransactionsWithCategory d) {
    return CustomPaint(
      foregroundPainter:
          IndicatorPainter(d.isExpense ? Colors.red : Colors.green),
      child: ListTile(
        title: Text(
          d.subcategoryName,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(d.subcategoryName),
        trailing: Text(
          " ${d.isExpense ? "-" : ""}${d.amount.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
          style: TextStyle(
              fontSize: 16,
              color: d.isExpense ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _getDateString(DateTime date) {
    intl.DateFormat d = intl.DateFormat.MMMEd();
    return d.format(date).toUpperCase();
  }
}

class IndicatorPainter extends CustomPainter {
  final Color _color;

  IndicatorPainter(this._color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = _color;

    Rect rect = Rect.fromLTWH(0, 0, 6, size.height);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
