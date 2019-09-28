/*
 * Project: FineWallet
 * Last Modified: Saturday, 28th September 2019 12:05:21 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/models/transaction_model.dart';
import 'package:FineWallet/core/resources/blocs/overview_bloc.dart';
import 'package:FineWallet/core/resources/category_icon.dart';
import 'package:FineWallet/src/history_page/history_item_icon.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LastTransaction extends StatelessWidget {
  const LastTransaction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      horizontalMargin: 5,
      height: 100,
      ratio: 0.46,
      child: DecoratedCard(
        borderColor: Theme.of(context).colorScheme.primary,
        padding: 10,
        borderWidth: 0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          child: Column(
            children: <Widget>[
              _buildLastTransactionContent(),
              Text(
                "Lastest transaction",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 13),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastTransactionContent() {
    return Consumer<OverviewBloc>(
      builder: (context, bloc, child) {
        bloc.getLatestTransaction();
        return StreamBuilder<TransactionModel>(
          stream: bloc.latestTransaction,
          initialData: TransactionModel(
            amount: 0,
            isExpense: 1,
          ),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: _buildIcon(
                            context,
                            snapshot.data.category != null
                                ? CategoryIcon(snapshot.data.category - 1).data
                                : Icons.autorenew),
                      ),
                      // Text(
                      //   snapshot.data.subcategoryName ?? "",
                      //   style: TextStyle(
                      //     color: Theme.of(context).colorScheme.onSurface,
                      //     fontSize: 18,
                      //   ),
                      // ),
                      Text(
                        "${snapshot.data.isExpense == 1 && snapshot.data.amount > 0 ? "-" : ""}${snapshot.data.amount.toStringAsFixed(2)}€",
                        style: TextStyle(
                          color: snapshot.data.isExpense == 1
                              ? Colors.red
                              : Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  );
          },
        );
      },
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
