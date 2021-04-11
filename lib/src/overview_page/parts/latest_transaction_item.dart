import 'dart:async';

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/src/add_page/page.dart';
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
  Timer _timer;

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
    _initializeTimer();
    super.initState();
  }

  void _initializeTimer() {
    setState(() {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (controller.hasClients) {
          var currentPage = controller.page.round();
          if (currentPage < numLatestTransactions - 1) {
            currentPage++;
          } else {
            currentPage = 0;
          }
          controller.animateToPage(currentPage,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: StreamBuilder<List<TransactionWithDetails>>(
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
      BuildContext context, TransactionWithDetails snapshotItem) {
    return DecoratedCard(
      padding: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          if (_timer != null && _timer.isActive) {
            _timer.cancel();
          }
          await _showActions(context, snapshotItem);
          if (_timer != null && !_timer.isActive) {
            _initializeTimer();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: <Widget>[
              _buildIcon(
                  context,
                  IconData(snapshotItem.cc.iconCodePoint,
                      fontFamily: 'MaterialIcons')),
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
                      if (snapshotItem.label.isNotEmpty)
                        const SizedBox(height: 4),
                      if (snapshotItem.label.isNotEmpty)
                        Text(
                          snapshotItem.label,
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
                amount: snapshotItem.amount,
                originalAmount: snapshotItem.originalAmount,
                isExpense: snapshotItem.isExpense,
                currencyId: snapshotItem.currencyId,
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
  Future _deleteItems(TransactionWithDetails tx) async {
    if (await showConfirmDialog(context, LocaleKeys.delete_dialog_title.tr(),
        LocaleKeys.delete_dialog_text.tr())) {
      Provider.of<AppDatabase>(context, listen: false)
          .transactionDao
          .deleteTransactionById(tx.id);
    }
  }

  Future _showActions(
      BuildContext context, TransactionWithDetails snapshot) async {
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPage(
                      isExpense: snapshot.isExpense,
                      transaction: snapshot,
                    ),
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
