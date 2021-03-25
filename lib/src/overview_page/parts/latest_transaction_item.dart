import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
import 'package:FineWallet/src/widgets/standalone/action_bottom_sheet.dart';
import 'package:FineWallet/src/widgets/standalone/confirm_dialog.dart';
import 'package:FineWallet/src/widgets/standalone/page_view_indicator.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
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
      child: StreamBuilder<List<NLatestTransactionsResult>>(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchNLatestTransactions(numLatestTransactions),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text(LocaleKeys.found_no_transactions.tr()));
          }
          if (snapshot.data.isEmpty) {
            return Center(child: Text(LocaleKeys.found_no_transactions.tr()));
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
      BuildContext context, NLatestTransactionsResult snapshotItem) {
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
              _buildIcon(context, IconData(snapshotItem.cc.iconCodePoint)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tryTranslatePreset(snapshotItem.s),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      if (snapshotItem.t.label.isNotEmpty)
                        const SizedBox(height: 4),
                      if (snapshotItem.t.label.isNotEmpty)
                        Text(
                          snapshotItem.t.label,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 13),
                        )
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: 0,
                child: SizedBox(width: 4),
              ),
              CombinedAmountString(
                amount: snapshotItem.t.amount,
                originalAmount: snapshotItem.t.originalAmount,
                isExpense: snapshotItem.t.isExpense,
                currencyId: snapshotItem.t.currencyId,
                currencySymbol: snapshotItem.c.symbol,
                userCurrencyId: _userCurrencyId,
                titleFontSize: 17,
                subtitleFontSize: 11,
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
  Future _deleteItems(NLatestTransactionsResult tx) async {
    if (await showConfirmDialog(context, LocaleKeys.delete_dialog_title.tr(),
        LocaleKeys.delete_dialog_text.tr())) {
      Provider.of<AppDatabase>(context, listen: false)
          .transactionDao
          .deleteTransactionById(tx.t.id);
    }
  }

  Future _showActions(
      BuildContext context, NLatestTransactionsResult snapshot) async {
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
              title: Text(
                LocaleKeys.delete.tr(),
                style: const TextStyle(color: Colors.white),
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
                title: Text(LocaleKeys.share.tr()),
                leading: Icon(
                  Icons.share,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                onTap: () {
                  logMsg("Tapped share");
                },
              ),
            ),
          DecoratedCard(
            padding: 2,
            elevation: 0,
            child: ListTile(
              title: Text(LocaleKeys.edit.tr()),
              leading: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              onTap: () {
                // TODO
                // Navigator.pushReplacement(
                // context,
                // MaterialPageRoute(
                //   builder: (context) => AddPage(
                //       isExpense: snapshot.t.isExpense, transaction: snapshot),
                // ),
                // );
              },
            ),
          )
        ],
      ),
    );
  }
}
