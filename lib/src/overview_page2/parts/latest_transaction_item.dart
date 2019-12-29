import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/add_page/add_page.dart';
import 'package:FineWallet/src/overview_page/action_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LatestTransactionItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TransactionWithCategory>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchLatestTransaction(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator(strokeWidth: 1));
        return Container(
          height: 65,
          child: ListTile(
            leading: _buildIcon(
                context, CategoryIcon(snapshot.data.sub.categoryId - 1).data),
            title: Text(snapshot.data.sub.name),
            subtitle: Text(snapshot.data.sub.name),
            trailing: Text(
              "${snapshot.data.tx.isExpense && snapshot.data.tx.amount > 0 ? "-" : ""}"
              "${snapshot.data.tx.amount.toStringAsFixed(2)}"
              "${Provider.of<LocalizationNotifier>(context).currency}",
              style: TextStyle(
                color: snapshot.data.tx.isExpense ? Colors.red : Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              if (snapshot.hasData) {
                await _showActions(context, snapshot);
              }
            },
          ),
        );
      },
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

  Future _showActions(BuildContext context,
      AsyncSnapshot<TransactionWithCategory> snapshot) async {
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
                      isExpense: snapshot.data.tx.isExpense,
                      transaction: snapshot.data),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
