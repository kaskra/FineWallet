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

  int _userCurrencyId = 1;

  Future loadUserCurrency() async {
    _userCurrencyId = (await Provider.of<AppDatabase>(context, listen: false)
            .currencyDao
            .getUserCurrency())
        ?.id;
  }

  @override
  void initState() {
    loadUserCurrency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: StreamBuilder<List<TransactionWithCategoryAndCurrency>>(
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
      BuildContext context, TransactionWithCategoryAndCurrency snapshotItem) {
    return DecoratedCard(
      padding: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          await _showActions(context, snapshotItem);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: <Widget>[
              _buildIcon(
                  context, CategoryIcon(snapshotItem.sub.categoryId - 1).data),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        snapshotItem.sub.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      if (snapshotItem.tx.label.isNotEmpty)
                        const SizedBox(height: 4),
                      if (snapshotItem.tx.label.isNotEmpty)
                        Text(
                          snapshotItem.tx.label,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 13),
                        )
                    ],
                  ),
                ),
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
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_userCurrencyId != snapshotItem.tx.currencyId)
                    ForeignAmountString(
                      snapshotItem.tx.originalAmount *
                          (snapshotItem.tx.isExpense ? -1 : 1),
                      currencySymbol: snapshotItem.currency.symbol,
                      textStyle: TextStyle(
                          fontSize: 10,
                          color: snapshotItem.tx.isExpense
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold),
                    )
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
  Future _deleteItems(TransactionWithCategoryAndCurrency tx) async {
    if (await showConfirmDialog(
        context, "Delete transaction?", "This will delete the transaction.")) {
      Provider.of<AppDatabase>(context, listen: false)
          .transactionDao
          .deleteTransactionById(tx.tx.originalId);
    }
  }

  Future _showActions(
      BuildContext context, TransactionWithCategoryAndCurrency snapshot) async {
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
