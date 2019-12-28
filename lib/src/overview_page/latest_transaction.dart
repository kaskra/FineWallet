/*
 * Project: FineWallet
 * Last Modified: Saturday, 28th September 2019 12:05:21 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/add_page/add_page.dart';
import 'package:FineWallet/src/overview_page/action_bottom_sheet.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/icon_wrapper.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LatestTransaction extends StatelessWidget {
  const LatestTransaction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      horizontalMargin: 5,
      height: 100,
      ratio: 0.46,
      child: DecoratedCard(
        padding: 10,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildLastTransactionContent(context),
              Text(
                "Latest transaction",
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastTransactionContent(BuildContext context) {
    return StreamBuilder<TransactionsWithCategory>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchLatestTransaction(),
      builder: (context, snapshot) {
        return InkWell(
          onTap: () async {
            if (snapshot.hasData) {
              await _showActions(context, snapshot);
            }
          },
          child: !snapshot.hasData
              ? _buildPlaceholder()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: _buildIcon(
                          context,
                          snapshot.data.categoryId != null
                              ? CategoryIcon(snapshot.data.categoryId - 1).data
                              : Icons.autorenew),
                    ),
                    FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "${snapshot.data.isExpense && snapshot.data.amount > 0 ? "-" : ""}${snapshot.data.amount.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
                        style: TextStyle(
                          color: snapshot.data.isExpense
                              ? Colors.red
                              : Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }

  Future _showActions(BuildContext context,
      AsyncSnapshot<TransactionsWithCategory> snapshot) async {
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
                      isExpense: snapshot.data.isExpense,
                      transaction: snapshot.data),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Center _buildPlaceholder() {
    return const Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Text(
          "---",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ), //CircularProgressIndicator(),
    );
  }

  Widget _buildIcon(BuildContext context, IconData iconData) {
    return IconWrapper(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(5),
        color: Theme.of(context).colorScheme.secondary,
        child: Icon(
          iconData,
          size: 25,
        ),
      ),
    );
  }
}
