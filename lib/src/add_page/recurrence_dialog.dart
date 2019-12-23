import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class creates a dialog that is used to choose a recurrence type.
///
/// Possible recurrence types are stored in the database table `recurrences`.
///
class RecurrenceDialog extends StatefulWidget {
  RecurrenceDialog({Key key, @required this.recurrenceType}) : super(key: key);

  final int recurrenceType;

  @override
  _RecurrenceDialogState createState() => _RecurrenceDialogState();
}

class _RecurrenceDialogState extends State<RecurrenceDialog> {
  int _recurrenceType = -1;
  String _recurrenceName = "";

  @override
  void initState() {
    if (widget.recurrenceType != null) {
      _recurrenceType = widget.recurrenceType;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(CARD_RADIUS)),
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: <Widget>[
            _buildDialogHeader(),
            Expanded(child: _buildSubcategoryList()),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                padding: const EdgeInsets.all(5),
                textColor: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  // This should always be right, if it is
                  // not there is a problem.
                  if (_recurrenceType != -1 && _recurrenceName != "") {
                    Navigator.of(context).pop(Recurrence(
                        type: _recurrenceType, name: _recurrenceName));
                  } else {
                    print("Wrong Recurrence type or name!");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(CARD_RADIUS),
          topRight: Radius.circular(CARD_RADIUS),
        ),
      ),
      height: 50,
      child: Center(
        child: Text(
          "Recurrence",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            decoration: TextDecoration.none,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            fontFamily: "roboto",
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategoryList() {
    return FutureBuilder(
      future: Provider.of<AppDatabase>(context).getRecurrences(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              for (var rec in snapshot.data) _buildRecurrenceItem(rec)
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _buildRecurrenceItem(Recurrence rec) {
    if (_recurrenceType == rec.type && _recurrenceName == "") {
      _recurrenceName = rec.name;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        color: _recurrenceType == rec.type
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey,
        child: Container(
          height: 35,
          child: InkWell(
            onTap: () {
              setState(() {
                _recurrenceType = rec.type;
                _recurrenceName = rec.name;
              });
            },
            child: Center(
              child: Container(
                child: Text(
                  rec.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
