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
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          StreamBuilder<List<TransactionWithCategory>>(
            stream: Provider.of<AppDatabase>(context)
                .transactionDao
                .watchNLatestTransactions(NUMBER_OF_LATEST_TRANSACTIONS),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator(strokeWidth: 1));
              return SizedBox(
                height: 80,
                child: PageView(
                  controller: controller,
                  children: <Widget>[
                    for (var s in snapshot.data)
                      _buildLatestTransactionItem(context, s),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: PageViewIndicator(
              numberOfChildren: NUMBER_OF_LATEST_TRANSACTIONS,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestTransactionItem(
      BuildContext context, TransactionWithCategory snapshot) {
    return DecoratedCard(
      padding: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          await _showActions(context, snapshot);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildIcon(
                      context, CategoryIcon(snapshot.sub.categoryId - 1).data),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          snapshot.sub.name,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          snapshot.sub.name,
                          style: TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                "${snapshot.tx.isExpense && snapshot.tx.amount > 0 ? "-" : ""}"
                "${snapshot.tx.amount.toStringAsFixed(2)}"
                "${Provider.of<LocalizationNotifier>(context).currency}",
                style: TextStyle(
                  color: snapshot.tx.isExpense ? Colors.red : Colors.green,
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
