import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FineWallet/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/models/transaction_model.dart';
import 'package:FineWallet/general/general_widgets.dart';
import 'package:FineWallet/utils.dart';

class WeekOverview extends StatelessWidget {
  WeekOverview(BuildContext context) : this.context = context;

  final BuildContext context;

  Widget _buildNameWidget(int day) {
    bool isToday = day == DateTime.now().weekday;

    return Text(isToday ? "Today" : getDayName(day),
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal));
  }

  BoxDecoration _buildDayDecoration(int day) {
    bool isToday = day == DateTime.now().weekday;
    return isToday
        ? BoxDecoration(
            border: Border.all(
                width: 2, color: Theme.of(context).colorScheme.secondary))
        : const BoxDecoration();
  }

  Widget _buildDay(int day, double budget) {
    return generalCard(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildNameWidget(day),
            _buildExpenseString(budget)
          ],
        ),
        decoration: _buildDayDecoration(day));
  }

  Expanded _buildExpenseString(double budget) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          "${(budget > 0) ? "-" : ""}${budget.toStringAsFixed(2)}€",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<TransactionBloc>(builder: (_, bloc, child) {
        bloc.getLastWeekTransactions();
        return StreamBuilder(
          stream: bloc.lastWeekTransactions,
          builder:
              (context, AsyncSnapshot<List<SumOfTransactionModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  for (SumOfTransactionModel m in snapshot.data)
                    _buildDay(m.date, m.amount.toDouble())
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      }),
    );
  }
}
