import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/add_page/add_page.dart';
import 'package:FineWallet/src/overview_page/action_bottom_sheet.dart';
import 'package:FineWallet/src/widgets/page_view_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LatestTransactionItem extends StatefulWidget {
  @override
  _LatestTransactionItemState createState() => _LatestTransactionItemState();
}

class _LatestTransactionItemState extends State<LatestTransactionItem> {
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: StreamBuilder<List<TransactionWithCategory>>(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchNLatestTransactions(NUMBER_OF_LATEST_TRANSACTIONS),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator(strokeWidth: 1));
          return Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              PageView(
                controller: controller,
                children: <Widget>[
                  for (var s in snapshot.data)
                    _buildLatestTransactionItem(context, s),
                ],
              ),
              PageViewIndicator(
                numberOfChildren: NUMBER_OF_LATEST_TRANSACTIONS,
                controller: controller,
              )
            ],
          );
        },
      ),
    );
  }

  Container _buildLatestTransactionItem(
      BuildContext context, TransactionWithCategory snapshot) {
    return Container(
      height: 65,
      child: ListTile(
        leading:
            _buildIcon(context, CategoryIcon(snapshot.sub.categoryId - 1).data),
        title: Text(snapshot.sub.name),
        subtitle: Text(snapshot.sub.name),
        trailing: Text(
          "${snapshot.tx.isExpense && snapshot.tx.amount > 0 ? "-" : ""}"
          "${snapshot.tx.amount.toStringAsFixed(2)}"
          "${Provider.of<LocalizationNotifier>(context).currency}",
          style: TextStyle(
            color: snapshot.tx.isExpense ? Colors.red : Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () async {
          await _showActions(context, snapshot);
        },
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData iconData) {
    return CircleAvatar(
      child: Icon(
        iconData,
        color: Theme.of(context).iconTheme.color,
      ),
      radius: 20,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Future _showActions(
      BuildContext context, TransactionWithCategory snapshot) async {
    await showModalBottomSheet<ActionBottomSheet>(
      context: context,
      builder: (context) => ActionBottomSheet(
        actions: <Widget>[
          ListTile(
            enabled: UserSettings.getTXShare(),
            title: Text("Share"),
            leading: Icon(
              Icons.share,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () {
              print("Tapped share");
            },
          ),
          ListTile(
            title: Text("Edit"),
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPage(
                      isExpense: snapshot.tx.isExpense, transaction: snapshot),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
