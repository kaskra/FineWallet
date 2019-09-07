import 'package:FineWallet/resources/blocs/month_bloc.dart';
import 'package:FineWallet/statistics/monthly_overview.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayOverview extends StatelessWidget {
  const DayOverview(BuildContext context, {Key key})
      : this.context = context,
        super(key: key);

  final BuildContext context;

  // TODO refactor visuals when refactoring overview page
  Widget _overviewBox(String title, double amount, bool last, Function onTap) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: Theme.of(context).primaryColor),
        margin: EdgeInsets.only(right: last ? 4 : 2.5, left: last ? 2.5 : 4),
        child: Material(
          color: Theme.of(context).colorScheme.primary,
          child: InkWell(
            onTap: () => onTap(),
            child: Container(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildCaptionText(),
                    Text(
                      "${amount.toStringAsFixed(2)}€",
                      style: TextStyle(
                          color: amount <= 0
                              ? Theme.of(context).accentTextTheme.body1.color
                              : Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Text _buildCaptionText() {
    return Text(
      "Spare budget",
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: 10,
      ),
    );
  }

  void _onMonthTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyOverview(
          initialMonth: DateTime.now(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Consumer<MonthBloc>(builder: (_, bloc, child) {
        bloc.getBudgetOverview();
        return StreamBuilder<Map<String, double>>(
          stream: bloc.budgetOverview,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, double>> snapshot) {
            if (snapshot.hasData) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _overviewBox(
                      "TODAY", snapshot.data['dayBudget'], false, () {}),
                  _overviewBox(getMonthName(DateTime.now().month).toUpperCase(),
                      snapshot.data['monthSpareBudget'], true, _onMonthTap),
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
          },
        );
      }),
    );
  }
}
