import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/add_page-rework/row_widgets.dart';
import 'package:FineWallet/src/add_page-rework/row_wrapper.dart';
import 'package:FineWallet/src/settings_page/settings_page.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPageRework extends StatefulWidget {
  AddPageRework({
    Key key,
    @required this.isExpense,
    this.transaction,
  }) : super(key: key);

  final bool isExpense;
  final TransactionsWithCategory transaction;

  @override
  _AddPageReworkState createState() => _AddPageReworkState();
}

class _AddPageReworkState extends State<AddPageRework> {
  /// The transactions that the user wants to edit.
  TransactionsWithCategory _transaction;

  /// The flag that signals if the page is loaded in edit or normal mode.
  bool _editing = false;

  /// The transaction money amount.
  double _amount = 0.00;

  /// The (original) transaction date.
  int _date = dayInMillis(DateTime.now());

  String _subcategoryName = "";
  int _subcategoryId = -1;

  bool _isRecurring = false;
  int _untilDate = dayInMillis(DateTime.now().add(Duration(days: 1)));
  int _recurrenceType = 1;

  /// State variables
  bool _hasError = false;

  @override
  void initState() {
    if (widget.transaction != null) {
      _transaction = widget.transaction;
      _editing = true;
      _amount = _transaction.amount;
      _date = _transaction.date;
      _subcategoryId = _transaction.subcategoryId;
      _subcategoryName = _transaction.subcategoryName;
      _isRecurring = _transaction.isRecurring;
      _untilDate = _transaction.recurringUntil;
      _recurrenceType = _transaction.recurringType;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Add ${widget.isExpense ? "Expense" : "Income"}',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: Theme.of(context).iconTheme,
        // TODO Remove after testing
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleSaving(),

        tooltip: 'Save transaction',
        label: Text(
          "SAVE",
          style: TextStyle(
              fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
        ), //Change Icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      //Change for different locations
      body: Center(
        child: Container(
          child: _buildBody(),
        ),
      ),
    );
  }

  void _handleSaving() {
    // Show snackbar
    if (_hasError) print("NOT WORKING WITH THIS!!");

    print(
        "Amount: $_amount, Date: ${DateTime.fromMillisecondsSinceEpoch(_date)}");

    if (_editing) {
      print("Save edited transaction!");
    } else {
      print("Save new transaction!");
    }
  }

  Widget _buildBody() {
    List<Widget> items = []
      ..addAll(_buildAmountRow())
      ..addAll(_buildCategoryRow())
      ..addAll(_buildDateRow())
      ..addAll(_buildRecurrenceRow());

    if (_isRecurring) {
      items.addAll(_buildRecurrenceChoices());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  List<Widget> _buildAmountRow() {
    return [
      Padding(
          padding: const EdgeInsets.only(top: 8),
          child: RowTitle(title: "Amount")),
      RowWrapper(
        iconSize: 24,
        leadingIcon: Icons.attach_money,
        isExpandable: false,
        isChild: false,
        child: EditableNumericInputText(
          defaultValue: _amount,
          onChanged: (value) {
            setState(() {
              _amount = value;
            });
          },
          onError: (value) {
            if (value) {
              print("Got error! No real double value!");
            }
            setState(() {
              _hasError = value;
            });
          },
        ),
      )
    ];
  }

  List<Widget> _buildCategoryRow() {
    return [
      RowTitle(title: "Category"),
      RowWrapper(
        iconSize: 24,
        leadingIcon: Icons.category,
        isExpandable: false,
        isChild: false,
        onTap: () async {
          var res = showDialog(
              context: context,
              child: CategoryChoiceDialog(
                isExpense: widget.isExpense,
              ));
        },
        child: Text(_subcategoryName ?? ""),
      ),
    ];
  }

  List<Widget> _buildDateRow() {
    var formatter = new DateFormat('dd.MM.yy');
    String formattedDate =
        formatter.format(DateTime.fromMillisecondsSinceEpoch(_date));

    return [
      RowTitle(title: "Date"),
      RowWrapper(
        iconSize: 24,
        leadingIcon: Icons.calendar_today,
        isExpandable: false,
        isChild: false,
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.fromMillisecondsSinceEpoch(_date),
            firstDate: DateTime(2000, 1, 1),
            lastDate: DateTime(2050, 12, 31),
            initialDatePickerMode: DatePickerMode.day,
          );
          if (pickedDate != null) {
            setState(() {
              _date = dayInMillis(pickedDate);
              if (_untilDate - dayInMillis(pickedDate) <
                  Duration.millisecondsPerDay) {
                _untilDate = dayInMillis(pickedDate.add(Duration(days: 1)));
              }
            });
            print(DateTime.fromMillisecondsSinceEpoch(_date));
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            formattedDate,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildRecurrenceRow() {
    return [
      RowTitle(title: "Recurrence"),
      RowWrapper(
        iconSize: 24,
        leadingIcon: Icons.replay,
        isExpandable: true,
        isExpanded: _isRecurring,
        isChild: false,
        onSwitch: (val) {
          setState(() {
            _isRecurring = val;
          });
        },
      ),
    ];
  }

  List<Widget> _buildRecurrenceChoices() {
    var formatter = new DateFormat('dd.MM.yy');
    String formattedDate =
        formatter.format(DateTime.fromMillisecondsSinceEpoch(_untilDate));

    return [
      RowChildDivider(),
      RowWrapper(
        leadingIcon: Icons.low_priority,
        iconSize: 20,
        isExpandable: false,
        isChild: true,
        onTap: () {},
        child: Text(""),
      ),
      RowWrapper(
        leadingIcon: Icons.access_time,
        iconSize: 20,
        isExpandable: false,
        isChild: true,
        onTap: () async {
          DateTime date =
              DateTime.fromMillisecondsSinceEpoch(_date).add(Duration(days: 1));
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.fromMillisecondsSinceEpoch(_untilDate),
            firstDate: DateTime(date.year, date.month, date.day),
            lastDate: DateTime(2050, 12, 31),
            initialDatePickerMode: DatePickerMode.day,
          );
          if (pickedDate != null) {
            setState(() {
              _untilDate = dayInMillis(pickedDate);
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            formattedDate,
            style: TextStyle(fontSize: 16),
          ),
        ),
      )
    ];
  }
}
