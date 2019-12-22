import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/add_page-rework/category_dialog.dart';
import 'package:FineWallet/src/add_page-rework/recurrence_dialog.dart';
import 'package:FineWallet/src/add_page-rework/row_widgets.dart';
import 'package:FineWallet/src/add_page-rework/row_wrapper.dart';
import 'package:FineWallet/src/settings_page/settings_page.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  /// The chosen subcategory, holds id, name and category id.
  Subcategory _subcategory;

  bool _isRecurring = false;
  int _untilDate = dayInMillis(DateTime.now().add(Duration(days: 1)));

  /// State variables
  bool _hasError = false;
  Recurrence _recurrence;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    _getTransactionValues();
    super.initState();
  }

  Future _getTransactionValues() async {
    if (widget.transaction != null) {
      _transaction = widget.transaction;
      _editing = true;
      _amount = _transaction.amount;
      _date = _transaction.date;
      _subcategory = Subcategory(
        id: _transaction.subcategoryId,
        name: _transaction.subcategoryName,
        categoryId: _transaction.categoryId,
      );
      _recurrence = Recurrence(
        type: _transaction.recurringType,
        name: "",
      );
      _isRecurring = _transaction.isRecurring;
      _untilDate = _transaction.recurringUntil;

      if (_isRecurring) {
        // If recurring, set the date to the first of the recurrence.
        // With that every recurring instance is changed
        List<Transaction> txs = await Provider.of<AppDatabase>(context)
            .transactionDao
            .getAllTransactions();
        txs = txs.where((tx) => tx.id == _transaction.originalId).toList();
        txs = txs.where((t) => t.date <= dayInMillis(DateTime.now())).toList();
        _date = txs.toList().last.date;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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

  Tuple2<String, bool> _isValidTransaction() {
    Tuple2<String, bool> res;
    if (_amount < 0)
      return Tuple2<String, bool>(
          "The specified amount can only be positive!", false);
    if (_subcategory == null)
      return Tuple2<String, bool>("Please choose a category!", false);
    if (_isRecurring && _recurrence == null)
      return Tuple2<String, bool>(
          "Please specify which recurrence "
          "type you want to use!",
          false);
    // We don't need to check if date is at least a day before until date.
    // That is handled by the date picker.
    if (_isRecurring && _untilDate == null)
      return Tuple2<String, bool>(
          "Please choose an end date "
          "for the recurrence!",
          false);
    if (_date == null)
      return Tuple2<String, bool>(
          "Please choose a date for your transaction!", false);

    return Tuple2<String, bool>("", true);
  }

  void _handleSaving() {
    // Show snackbar with hints when error or not valid
    if (_hasError) {
      print("NOT WORKING WITH THIS!!");
      _showSnackBar("Your specified amount is not a number!");
    }

    Tuple2<String, bool> isValid = _isValidTransaction();
    if (!isValid.second) {
      _showSnackBar(isValid.first);
    }

    // TODO remove when done
    print("Amount: $_amount, "
        "Date: ${DateTime.fromMillisecondsSinceEpoch(_date)}, "
        "Cat: $_subcategory "
        "Recurrence: $_recurrence");

    if (_editing) {
      _updateTransaction();
      print("Save edited transaction!");
    } else {
      _addNewTransaction();
      print("Save new transaction!");
    }
    Navigator.of(context).pop();
  }

  void _addNewTransaction() async {
    var tx = Transaction(
      id: null,
      date: _date,
      isExpense: widget.isExpense,
      isRecurring: _isRecurring,
      amount: _amount,
      monthId: null,
      subcategoryId: _subcategory.id,
      recurringType: _isRecurring ? _recurrence.type : null,
      recurringUntil: _untilDate,
      originalId: null,
    );

    await Provider.of<AppDatabase>(context)
        .transactionDao
        .insertTransaction(tx);
  }

  void _updateTransaction() async {
    var tx = Transaction(
      id: _transaction.originalId,
      date: _date,
      isExpense: widget.isExpense,
      isRecurring: _isRecurring,
      amount: _amount,
      monthId: null,
      subcategoryId: _subcategory.id,
      recurringType: _isRecurring ? _recurrence.type : null,
      recurringUntil: _untilDate,
      originalId: _transaction.originalId,
    );
    await Provider.of<AppDatabase>(context)
        .transactionDao
        .updateTransaction(tx);
  }

  void _showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(value),
      backgroundColor: Colors.grey,
    ));
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
              if (_amount < 0) {
                _hasError = true;
              }
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
          // Let the user choose a category and subcategory.
          // Returning the Subcategory is enough, because
          // it also holds the category id.
          Subcategory res = await showDialog(
            context: context,
            child: CategoryChoiceDialog(
              isExpense: widget.isExpense,
              selectedSubcategory: _subcategory,
            ),
          );

          if (res != null) {
            print("Return from Category: $res");
            setState(() {
              _subcategory = res;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            _subcategory?.name ?? "",
            style: TextStyle(fontSize: 16),
          ),
        ),
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
        onTap: () async {
          Recurrence rec = await showDialog(
            context: context,
            child: RecurrenceDialog(
              recurrenceType: _recurrence?.type ?? -1,
            ),
          );
          if (rec != null) {
            setState(() {
              _recurrence = rec;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            _recurrence?.name ?? "",
            style: TextStyle(fontSize: 16),
          ),
        ),
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
