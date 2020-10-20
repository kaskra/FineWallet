import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/add_page/add_page.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
import 'package:FineWallet/src/widgets/standalone/action_bottom_sheet.dart';
import 'package:FineWallet/src/widgets/standalone/confirm_dialog.dart';
import 'package:FineWallet/src/widgets/standalone/page_view_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LatestTransactionItem extends StatefulWidget {
  @override
  _LatestTransactionItemState createState() => _LatestTransactionItemState();
}

class _LatestTransactionItemState extends State<LatestTransactionItem> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: StreamBuilder<List<TransactionWithCategory>>(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchNLatestTransactions(numLatestTransactions),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Found no transactions."));
          }
          if (snapshot.data.isEmpty) {
            return const Center(child: Text("Found no transactions."));
          }
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              SizedBox(
                height: 80,
                child: PageView(
                  controller: controller,
                  children: <Widget>[
                    for (var s in snapshot.data)
                      _buildLatestTransactionItem(context, s),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: PageViewIndicator(
                  numberOfChildren: snapshot.data.length,
                  controller: controller,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLatestTransactionItem(
      BuildContext context, TransactionWithCategory snapshotItem) {
    return DecoratedCard(
      padding: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          await _showActions(context, snapshotItem);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildIcon(context,
                      CategoryIcon(snapshotItem.sub.categoryId - 1).data),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          snapshotItem.sub.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          snapshotItem.sub.name,
                          style: const TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AmountString(
                    snapshotItem.tx.amount *
                        (snapshotItem.tx.isExpense ? -1 : 1),
                    colored: true,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder(
                    future: Provider.of<AppDatabase>(context)
                        .currencyDao
                        .getUserCurrency(),
                    builder: (context, AsyncSnapshot<Currency> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.id != snapshotItem.tx.currencyId
                            ? ForeignAmountString(
                                snapshotItem.tx.originalAmount *
                                    (snapshotItem.tx.isExpense ? -1 : 1),
                                currencyId: snapshotItem.tx.currencyId,
                                textStyle: TextStyle(
                                    fontSize: 10,
                                    color: snapshotItem.tx.isExpense
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container();
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData iconData) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Icon(
        iconData,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }

  /// Deletes the selected items from database. Close selection mode afterwards.
  ///
  /// Before deleting the transaction, a confirm dialog will show,
  /// requiring the user to authorize the deletion.
  ///
  Future _deleteItems(TransactionWithCategory tx) async {
    if (await showConfirmDialog(
        context, "Delete transaction?", "This will delete the transaction.")) {
      Provider.of<AppDatabase>(context, listen: false)
          .transactionDao
          .deleteTransactionById(tx.tx.originalId);
    }
  }

  Future _showActions(
      BuildContext context, TransactionWithCategory snapshot) async {
    await showModalBottomSheet<ActionBottomSheet>(
      context: context,
      builder: (context) => ActionBottomSheet(
        itemHeight: 73,
        actions: <Widget>[
          DecoratedCard(
            elevation: 0,
            padding: 2,
            color: Colors.red.shade400,
            child: ListTile(
              title: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
              onTap: () async {
                await _deleteItems(snapshot);
                Navigator.pop(context);
              },
            ),
          ),
          if (UserSettings.getTXShare())
            DecoratedCard(
              elevation: 0,
              padding: 2,
              child: ListTile(
                enabled: UserSettings.getTXShare(),
                title: const Text("Share"),
                leading: Icon(
                  Icons.share,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                onTap: () {
                  print("Tapped share");
                },
              ),
            ),
          DecoratedCard(
            padding: 2,
            elevation: 0,
            child: ListTile(
              title: const Text("Edit"),
              leading: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPage(
                        isExpense: snapshot.tx.isExpense,
                        transaction: snapshot),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
