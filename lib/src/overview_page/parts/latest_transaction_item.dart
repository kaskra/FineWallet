import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/add_page/add_page.dart';
import 'package:FineWallet/src/overview_page/parts/action_bottom_sheet.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/standalone/page_view_indicator.dart';
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
              Text(
                "${snapshotItem.tx.isExpense && snapshotItem.tx.amount > 0 ? "-" : ""}"
                "${snapshotItem.tx.amount.toStringAsFixed(2)}"
                "${Provider.of<LocalizationNotifier>(context).currency}",
                style: TextStyle(
                  color: snapshotItem.tx.isExpense ? Colors.red : Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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

  Future _showActions(
      BuildContext context, TransactionWithCategory snapshot) async {
    await showModalBottomSheet<ActionBottomSheet>(
      context: context,
      builder: (context) => ActionBottomSheet(
        actions: <Widget>[
          ListTile(
            enabled: UserSettings.getTXShare(),
            title: const Text("Share"),
            leading: Icon(
              Icons.share,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () {
              print("Tapped share");
            },
          ),
          ListTile(
            title: const Text("Edit"),
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
