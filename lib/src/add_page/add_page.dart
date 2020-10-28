import 'package:FineWallet/color_themes.dart';
import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/src/add_page/page.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({
    Key key,
    @required this.isExpense,
    this.transaction,
  }) : super(key: key);

  final bool isExpense;
  final TransactionWithCategoryAndCurrency transaction;

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  /// The transactions that the user wants to edit.
  TransactionWithCategoryAndCurrency _transaction;

  /// The input currency id
  int _inputCurrencyId = UserSettings.getInputCurrency();
  int _userCurrencyId = 1;

  /// The flag that signals if the page is loaded in edit or normal mode.
  bool _editing = false;

  /// The transaction money amount.
  double _amount = 0.00;

  /// Label text editing controller
  final TextEditingController _labelController = TextEditingController();

  /// The (original) transaction date.
  DateTime _date = today();

  /// The chosen subcategory, holds id, name and category id.
  Subcategory _subcategory;

  bool _isRecurring = false;
  RecurrenceType _recurrence;

  DateTime _untilDate = today().add(const Duration(days: 1));

  /// State variables
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _hasError = false;
  bool _initialized = false;

  /// Get transaction if a transactions is given as input, then translate the
  /// resulting values into the state variables.
  ///
  /// This function is only executed once.
  ///
  Future _getTransactionValues() async {
    if (widget.transaction != null) {
      _transaction = widget.transaction;
      _editing = true;

      _inputCurrencyId = _transaction.tx.currencyId;

      // Get the original value of the transaction (before exchanging to user currency)
      _amount =
          double.parse((_transaction.tx.originalAmount).toStringAsFixed(2));

      // Make sure that currency-exchanged value is rounded to 2 decimals
      _date = _transaction.tx.date;
      _subcategory = _transaction.sub;
      _labelController.text = _transaction.tx.label;
      _isRecurring = _transaction.tx.isRecurring;
      _untilDate = _transaction.tx.until;

      if (_isRecurring) {
        // If recurring, set the date to the first of the recurrence.
        // With that every recurring instance is changed
        List<Transaction> txs =
            await Provider.of<AppDatabase>(context, listen: false)
                .transactionDao
                .getAllTransactions();
        txs = txs.where((tx) => tx.id == _transaction.tx.originalId).toList();
        txs = txs.where((t) => t.date.isBeforeOrEqual(today())).toList();
        _date = txs.toList().last.date;

        final List<RecurrenceType> recurrenceName =
            await Provider.of<AppDatabase>(context, listen: false)
                .getRecurrences();
        _recurrence = recurrenceName
            .where((r) => r.type == _transaction.tx.recurrenceType)
            .first;
      }
    }
    _userCurrencyId = (await Provider.of<AppDatabase>(context, listen: false)
            .currencyDao
            .getUserCurrency())
        ?.id;

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _getTransactionValues();
    }

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          LocaleKeys.add_page_title.tr(args: [
            if (widget.isExpense)
              LocaleKeys.expense.tr()
            else
              LocaleKeys.income.tr()
          ]),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
        iconTheme: Theme.of(context).iconTheme,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleSaving(),
        tooltip: LocaleKeys.add_page_fab_tooltip.tr(),
        label: Text(
          LocaleKeys.add_page_fab_label.tr().toUpperCase(),
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

  /// Checks if the selected and specified transactions values are valid.
  ///
  /// Return
  /// ------
  /// [Tuple2] with a snackbar string and a boolean value that indicates
  /// if there is a problem.
  ///
  Tuple2<String, bool> _isValidTransaction() {
    if (_amount == 0) {
      return Tuple2<String, bool>(
          LocaleKeys.add_page_amount_equals_zero.tr(), false);
    }

    if (_amount < 0) {
      return Tuple2<String, bool>(
          LocaleKeys.add_page_amount_smaller_zero.tr(), false);
    }

    if (_subcategory == null) {
      return Tuple2<String, bool>(
          LocaleKeys.add_page_subcategory_null.tr(), false);
    }

    if (_isRecurring && _recurrence == null) {
      return Tuple2<String, bool>(
          LocaleKeys.add_page_recurrence_null.tr(), false);
    }

    // We don't need to check if date is at least a day before until date.
    // That is handled by the date picker.
    if (_isRecurring && _untilDate == null) {
      return Tuple2<String, bool>(
          LocaleKeys.add_page_recurrence_no_end.tr(), false);
    }

    if (_date == null) {
      return Tuple2<String, bool>(LocaleKeys.add_page_date_null.tr(), false);
    }

    return Tuple2<String, bool>("", true);
  }

  /// Creates or updates the transaction, if it is valid and there are no
  /// other problems.
  ///
  /// If there is a problem with any of the values a snackbar will
  /// appear and provide the needed information to the user.
  ///
  void _handleSaving() {
    // Show snackbar with hints when error
    if (_hasError) {
      _showSnackBar(LocaleKeys.add_page_not_a_number.tr());
      return;
    }

    // Show snackbar with hints when not valid
    final Tuple2<String, bool> isValid = _isValidTransaction();
    if (!isValid.second) {
      _showSnackBar(isValid.first);
      return;
    }

    if (_editing) {
      _updateTransaction();
      logMsg("Save edited transaction!");
    } else {
      _addNewTransaction();
      logMsg("Save new transaction!");
    }
    Navigator.of(context).pop();
  }

  /// Creates a [Transaction] object and adds it to the database table
  /// `transactions`.
  ///
  Future _addNewTransaction() async {
    final tx = Transaction(
      id: null,
      date: _date,
      isExpense: widget.isExpense,
      isRecurring: _isRecurring,
      amount: _amount,
      originalAmount: _amount,
      exchangeRate: null,
      monthId: null,
      subcategoryId: _subcategory.id,
      recurrenceType: _isRecurring ? _recurrence.type : null,
      until: _untilDate,
      currencyId: _inputCurrencyId,
      label: _labelController.text.trim(),
    );

    await Provider.of<AppDatabase>(context, listen: false)
        .transactionDao
        .insertTransaction(tx);
  }

  /// Creates a [Transaction] object and updates that transaction in
  /// the database table `transactions`.
  ///
  /// The transaction is identified by its `originalId`, because recurrences
  /// have a unique `id` value, but the same `originalId`
  /// as the original transaction.
  ///
  Future _updateTransaction() async {
    final tx = Transaction(
      id: _transaction.tx.originalId,
      date: _date,
      isExpense: widget.isExpense,
      isRecurring: _isRecurring,
      amount: _amount,
      originalAmount: _amount,
      exchangeRate: null,
      monthId: null,
      subcategoryId: _subcategory.id,
      recurrenceType: _isRecurring ? _recurrence.type : null,
      until: _untilDate,
      originalId: _transaction.tx.originalId,
      currencyId: _inputCurrencyId,
      label: _labelController.text.trim(),
    );
    await Provider.of<AppDatabase>(context, listen: false)
        .transactionDao
        .updateTransaction(tx);
  }

  /// Shows a snackbar with a specified text.
  ///
  void _showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      backgroundColor: Colors.grey,
    ));
  }

  /// Builds the body structure .
  Widget _buildBody() {
    final List<Widget> items = [
      _buildWarning(),
      ..._buildAmountRow(),
      ..._buildCategoryRow(),
      ..._buildLabelRow(),
      ..._buildDateRow(),
      ..._buildRecurrenceRow()
    ];

    if (_isRecurring) {
      items.addAll(_buildRecurrenceChoices());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  Widget _buildWarning() {
    return _inputCurrencyId != _userCurrencyId
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            color: Theme.of(context).accentColor,
            child: Center(
              child: RichText(
                text: TextSpan(
                    text: "${LocaleKeys.add_page_not_home_currency.tr()} ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                          text:
                              LocaleKeys.add_page_not_home_currency_change.tr(),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              logMsg("Change currency");
                              Navigator.pushReplacementNamed(
                                  context, "/settings");
                            },
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                    ]),
              ),
            ),
          )
        : Container();
  }

  List<Widget> _buildAmountRow() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: RowTitle(title: LocaleKeys.add_page_amount.tr()),
      ),
      RowWrapper(
        iconSize: 24,
        leadingIcon: Icons.attach_money,
        isExpandable: false,
        isChild: false,
        child: EditableNumericInputText(
          defaultValue: _amount,
          currencyId: _inputCurrencyId,
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
              logMsg("Got error! No real double value ${_amount.toString()}!");
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
      RowTitle(title: LocaleKeys.add_page_category.tr()),
      RowWrapper(
        iconSize: 24,
        leadingIcon: Icons.category,
        isExpandable: false,
        isChild: false,
        onTap: () async {
          // Let the user choose a category and subcategory.
          // Returning the Subcategory is enough, because
          // it also holds the category id.
          final Subcategory res = await showDialog(
            context: context,
            child: CategoryChoiceDialog(
              isExpense: widget.isExpense,
              selectedSubcategory: _subcategory,
            ),
          );

          if (res != null) {
            logMsg("Return from Category: $res");
            setState(() {
              _subcategory = res;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            tryTranslatePreset(_subcategory), //?.name ?? ""),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildLabelRow() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: RowTitle(title: LocaleKeys.add_page_label.tr()),
      ),
      FutureBuilder<List<String>>(
        future: Provider.of<AppDatabase>(context, listen: false)
            .transactionDao
            .getTransactionsLabels(isExpense: widget.isExpense),
        builder: (context, snapshot) => RowWrapper(
          iconSize: 24,
          leadingIcon: Icons.label_important,
          isExpandable: false,
          isChild: false,
          // TODO use TypeAheadFormField when reworking add page
          child: TypeAheadField<String>(
            noItemsFoundBuilder: (context) => ListTile(
              dense: true,
              title: Text(LocaleKeys.add_page_no_suggestions.tr()),
            ),
            textFieldConfiguration: TextFieldConfiguration(
              controller: _labelController,
              textAlign: TextAlign.right,
            ),
            suggestionsCallback: (pattern) {
              final items = snapshot.data ?? [];
              return items.where((element) => element.contains(pattern));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion), dense: true);
            },
            onSuggestionSelected: (suggestion) {
              _labelController.text = suggestion;
            },
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildDateRow() {
    final formatter = DateFormat.yMd(context.locale.toLanguageTag());
    final String formattedDate = formatter.format(_date);

    return [
      RowTitle(title: LocaleKeys.add_page_date.tr()),
      RowWrapper(
        iconSize: 24,
        leadingIcon: Icons.calendar_today,
        isExpandable: false,
        isChild: false,
        onTap: () async {
          final pickedDate = await showDatePicker(
              context: context,
              initialDate: _date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2050, 12, 31),
              builder: (context, child) {
                // Needed to correct the issue that the selection marker in
                // date picker had the same color as the background.
                return Theme(
                  data: Provider.of<ThemeNotifier>(context).isDarkMode
                      ? ThemeData.dark().copyWith(
                          colorScheme: darkColorScheme,
                        )
                      : ThemeData.light().copyWith(
                          colorScheme:
                              colorScheme.copyWith(onSurface: Colors.black),
                          buttonTheme: const ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                        ),
                  child: child,
                );
              });
          if (pickedDate != null) {
            setState(() {
              _date = pickedDate;
              if (_untilDate.difference(pickedDate).inDays.abs() < 1) {
                _untilDate = pickedDate.add(const Duration(days: 1));
              }
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            formattedDate,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildRecurrenceRow() {
    return [
      RowTitle(title: LocaleKeys.add_page_recurrence.tr()),
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
    final formatter = DateFormat.yMd(context.locale.toLanguageTag());
    final String formattedDate = formatter.format(_untilDate);

    return [
      const RowChildDivider(),
      RowWrapper(
        leadingIcon: Icons.low_priority,
        iconSize: 20,
        isExpandable: false,
        isChild: true,
        onTap: () async {
          final RecurrenceType rec = await showDialog(
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
            _recurrence?.name?.tr() ?? "",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      RowWrapper(
        leadingIcon: Icons.access_time,
        iconSize: 20,
        isExpandable: false,
        isChild: true,
        onTap: () async {
          final DateTime date = _date.add(const Duration(days: 1));
          final pickedDate = await showDatePicker(
              context: context,
              initialDate: _untilDate,
              firstDate: DateTime(date.year, date.month, date.day),
              lastDate: DateTime(2050, 12, 31),
              builder: (context, child) {
                return Theme(
                  data: Provider.of<ThemeNotifier>(context).isDarkMode
                      ? ThemeData.dark().copyWith(
                          colorScheme: darkColorScheme,
                        )
                      : ThemeData.light().copyWith(
                          colorScheme:
                              colorScheme.copyWith(onSurface: Colors.black),
                          buttonTheme: const ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                        ),
                  child: child,
                );
              });
          if (pickedDate != null) {
            setState(() {
              _untilDate = pickedDate;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            formattedDate,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      )
    ];
  }
}
