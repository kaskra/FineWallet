import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class creates a dialog that is used to choose a recurrence type.
///
/// Possible recurrence types are stored in the database table `recurrences`.
///
class RecurrenceDialog extends StatefulWidget {
  const RecurrenceDialog({
    Key key,
    @required this.recurrenceType,
    @required this.date,
  })  : assert(date != null),
        assert(recurrenceType != null),
        super(key: key);

  final int recurrenceType;
  final DateTime date;

  @override
  _RecurrenceDialogState createState() => _RecurrenceDialogState();
}

class _RecurrenceDialogState extends State<RecurrenceDialog> {
  int _recurrenceType = -1;

  @override
  void initState() {
    if (widget.recurrenceType != null) {
      _recurrenceType = widget.recurrenceType;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FutureBuilder(
        future: Provider.of<AppDatabase>(context).getRecurrences(),
        builder: (context, AsyncSnapshot<List<RecurrenceType>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              shrinkWrap: true,
              children: <Widget>[
                for (var rec in snapshot.data)
                  // Do not show 'monthly exact date' option, when above day 28
                  if (widget.date.day <= 28 || rec.id != 5) _recurrenceItem(rec)
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _recurrenceItem(RecurrenceType rec) {
    return RadioListTile<int>(
      selected: _recurrenceType == rec.id,
      title: Text(
          fillOutRecurrenceName(rec.name.tr(), widget.date, rec.id, context)),
      value: rec.id,
      dense: true,
      groupValue: _recurrenceType,
      onChanged: (value) {
        setState(() {
          _recurrenceType = value;
        });
        Navigator.of(context).pop(rec);
      },
    );
  }
}
