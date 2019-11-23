import 'package:FineWallet/data/moor_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoorTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: StreamBuilder<Month>(
          stream: Provider.of<AppDatabase>(context).monthDao.getCurrentMonth(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String t = "";
              t += snapshot.data.id.toString() + " \n";
              t += snapshot.data.maxBudget.toStringAsFixed(2) + " \n";
              t += snapshot.data.firstDate.toString() + " \n";
              t += snapshot.data.lastDate.toString();
              return Column(
                children: <Widget>[
                  Text(t),
                  FlatButton(
                    onPressed: () {
                      var updatedMonth = snapshot.data
                          .copyWith(maxBudget: snapshot.data.maxBudget + 50);
                      Provider.of<AppDatabase>(context)
                          .monthDao
                          .updateMonth(updatedMonth);
                    },
                    child: Text("Increase budget"),
                    color: Colors.green,
                  ),
                  FlatButton(
                    onPressed: () {
                      var updatedMonth = snapshot.data
                          .copyWith(maxBudget: snapshot.data.maxBudget - 50);
                      Provider.of<AppDatabase>(context)
                          .monthDao
                          .updateMonth(updatedMonth);
                    },
                    child: Text("Decrease budget"),
                    color: Colors.red,
                  )
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
