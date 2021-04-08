import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
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
import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({
    Key key,
    @required this.isExpense,
    this.transaction,
  }) : super(key: key);

  final bool isExpense;
  final TransactionWithDetails transaction;

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();

  /// The transactions that the user wants to edit.
  TransactionWithDetails _transaction;

  /// The input currency id
  int _inputCurrencyId = UserSettings.getInputCurrency();
  int _userCurrencyId = 1;

  /// The flag that signals if the page is loaded in edit or normal mode.
  bool _editing = false;

  /// The transaction money amount.
  double _amount = 0.00;

  /// Label text editing controller
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _recurrenceController = TextEditingController();
  final TextEditingController _untilDateController = TextEditingController();

  /// The chosen subcategory, holds id, name and category id.
  Subcategory _subcategory;

  bool _isLimitedRecurrence = true;
  RecurrenceType _recurrence;
  List<RecurrenceType> _recurrenceTypes = [];

  /// The transaction dates.
  DateTime _date = today();
  DateTime _untilDate = today().add(const Duration(days: 1));

  /// State variables
  bool _initialized = false;

  /// Get transaction if a transactions is given as input, then translate the
  /// resulting values into the state variables.
  ///
  /// This function is only executed once.
  ///
  Future _loadTransaction() async {
    if (widget.transaction != null) {
      _transaction = widget.transaction;
      _editing = true;

      _inputCurrencyId = _transaction.currencyId;

      // Get the original value of the transaction (before exchanging to user currency)
      // Make sure that currency-exchanged value is rounded to 2 decimals
      _amount = double.parse((_transaction.originalAmount).toStringAsFixed(2));

      _date = DateTime.parse(_transaction.date);
      _subcategory = _transaction.s;
      _labelController.text = _transaction.label;

      if (_transaction.recurrenceType > 1) {
        // If recurring, set the date to the first of the recurrence.
        final BaseTransaction tx =
            await Provider.of<AppDatabase>(context, listen: false)
                .transactionDao
                .getBaseTransactionsById(_transaction.id);
        _date = tx.date;
      }

      _recurrence = await Provider.of<AppDatabase>(context, listen: false)
          .getRecurrenceById(_transaction.recurrenceType);

      if (_transaction.until != null) {
        _untilDate = _transaction.until;
      }
      _isLimitedRecurrence = _transaction.until != null;
    } else {
      _recurrenceTypes = await Provider.of<AppDatabase>(context, listen: false)
          .getRecurrences();
      _recurrence = _recurrenceTypes[0];
    }
  }

  Future _loadUserCurrency() async {
    _userCurrencyId = (await Provider.of<AppDatabase>(context, listen: false)
            .currencyDao
            .getUserCurrency())
        ?.id;
  }

  void _addListeners() {
    Provider.of<AppDatabase>(context)
        .categoryDao
        .watchAllSubcategories()
        .listen((snapshot) {
      final subcats = snapshot.map((subcat) => subcat.id).toList();
      var text = "";

      if (_subcategory != null && subcats.isNotEmpty) {
        if (subcats.contains(_subcategory.id)) {
          text = tryTranslatePreset(_subcategory);
        } else {
          setState(() {
            _subcategory = null;
          });
        }
      }
      _categoryController.text = text;
    });
  }

  Future<bool> _initialize() async {
    if (!_initialized) {
      _addListeners();
      await _loadUserCurrency();
      await _loadTransaction();
      _initialized = true;
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      floatingActionButton: _floatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _body(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
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
    );
  }

  Center _body() {
    return Center(
      child: FutureBuilder(
          future: _initialize(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Form(
                key: _formKey,
                child: _applyInputTheme(_inputFormFields()),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async => _save(),
      tooltip: LocaleKeys.add_page_fab_tooltip.tr(),
      label: Text(
        LocaleKeys.add_page_fab_label.tr().toUpperCase(),
        style: TextStyle(
            fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
      ), //Change Icon
    );
  }

  Theme _applyInputTheme(Widget child) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(left: 12, right: 12),
          filled: true,
          fillColor: const Color(0x0a000000),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground)),
          labelStyle:
              TextStyle(color: Theme.of(context).colorScheme.onBackground),
          suffixStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
          errorStyle: const TextStyle(fontSize: 11),
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyText2.color.withOpacity(0.6),
          ),
        ),
      ),
      child: child,
    );
  }

  // bool _changedNonDateRelatedData() {
  //   final unchangedAmount =
  //       double.parse((_transaction?.originalAmount ?? 0.0).toStringAsFixed(2));
  //
  //   final unchangedLabel = _transaction.label;
  //   final unchangedSubcat = _transaction.subcategoryId;
  //
  //   return (_subcategory.id != unchangedSubcat ||
  //           _labelController.text != unchangedLabel ||
  //           _amount != unchangedAmount) &&
  //       _transaction.recurrenceType > 1;
  // }

  /// Creates or updates the transaction, if it is valid and there are no
  /// other problems.
  ///
  /// If there is a problem with any of the values a snackbar will
  /// appear and provide the needed information to the user.
  ///
  Future _save() async {
    if (_formKey.currentState.validate()) {
      if (_editing) {
        // var res = UpdateModifierFlag.all;
        // if (_changedNonDateRelatedData()) {
        //   res = await showDialog(
        //       context: context, builder: (context) => UpdateModifierDialog());
        // }
        // final UpdateModifier um =
        //     UpdateModifier(res, DateTime.parse(_transaction.date));
        await _updateTransaction();
      } else {
        await _addNewTransaction();
      }

      Navigator.of(context).pop();
    }
  }

  /// Creates a [Transaction] object and adds it to the database table
  /// `transactions`.
  ///
  Future _addNewTransaction() async {
    final tx = BaseTransaction(
      id: null,
      date: _date,
      isExpense: widget.isExpense,
      amount: _amount,
      originalAmount: _amount,
      exchangeRate: null,
      monthId: null,
      subcategoryId: _subcategory.id,
      currencyId: _inputCurrencyId,
      label: _labelController.text.trim(),
      recurrenceType: _recurrence.id,
      until: _isLimitedRecurrence ? _untilDate : null,
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
    final tx = BaseTransaction(
      id: _transaction.id,
      date: _date,
      isExpense: widget.isExpense,
      amount: _amount,
      originalAmount: _amount,
      exchangeRate: null,
      monthId: null,
      subcategoryId: _subcategory.id,
      currencyId: _inputCurrencyId,
      label: _labelController.text.trim(),
      recurrenceType: _recurrence.id,
      until: _isLimitedRecurrence ? _untilDate : null,
    );
    await Provider.of<AppDatabase>(context, listen: false)
        .transactionDao
        .updateTransaction(tx);
  }

  /// Builds the body structure .
  Widget _inputFormFields() {
    return ListView(
      children: [
        if (_inputCurrencyId != _userCurrencyId) _warning(),
        const Padding(padding: EdgeInsets.only(top: 16)),
        _amountRow(),
        const SizedBox(height: 8),
        _categoryRow(),
        const SizedBox(height: 8),
        _labelRow(),
        const Divider(),
        const SizedBox(height: 8),
        _dateRow(),
        const SizedBox(height: 8),
        _recurrenceRow(),
        const SizedBox(height: 8),
        if (_recurrence.id > 1) _untilRow(),
        if (_recurrence.id > 1) Container(height: 200),
      ],
    );
  }

  Widget _warning() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      color: Theme.of(context).accentColor,
      child: Center(
        child: RichText(
          text: TextSpan(
              text: "${LocaleKeys.add_page_not_home_currency.tr()} ",
              style: const TextStyle(fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                    text: LocaleKeys.add_page_not_home_currency_change.tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        logMsg("Change currency");
                        Navigator.pushReplacementNamed(context, "/settings");
                      },
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    )),
              ]),
        ),
      ),
    );
  }

  Widget _amountRow() {
    return EditableNumericInputText(
      defaultValue: _amount,
      currencyId: _inputCurrencyId,
      onChanged: (value) {
        setState(() {
          _amount = value;
        });
      },
    );
  }

  Widget _labelRow() {
    return LabelTypeAheadInput(
      isExpense: widget.isExpense,
      labelController: _labelController,
    );
  }

  Widget _categoryRow() {
    _categoryController.text = tryTranslatePreset(_subcategory);
    return CategoryInput(
        isExpense: widget.isExpense,
        subcategory: _subcategory,
        categoryController: _categoryController,
        onChanged: (sub) {
          setState(() {
            _subcategory = sub;
          });
          print(_subcategory);
        });
  }

  Widget _dateRow() {
    final formatter = DateFormat.yMd(context.locale.toLanguageTag());
    _dateController.text = formatter.format(_date);

    return DateInput(
      date: _date,
      dateController: _dateController,
      onChanged: (pickedDate) {
        setState(() {
          _date = pickedDate;
          if (_isUntilDateAtLeastOneDayAfterDate(pickedDate)) {
            _untilDate = pickedDate.add(const Duration(days: 1));
          }
          // Set recurrence to nth-occurrence of weekday when date in month
          // is currently selected and day is too high
          if (_date.day > 28 && _recurrence.id == 6) {
            _recurrence = _recurrenceTypes[4];
          } else if (!isInLastWeekOfMonth(_date) && _recurrence.id == 5) {
            _recurrence = _recurrenceTypes[3];
          } else if (isInLastWeekOfMonth(_date) && _recurrence.id == 4) {
            _recurrence = _recurrenceTypes[4];
          }
        });
      },
    );
  }

  bool _isUntilDateAtLeastOneDayAfterDate(DateTime pickedDate) =>
      _untilDate.difference(pickedDate).inDays < 1;

  Widget _recurrenceRow() {
    if (_recurrence != null) {
      _recurrenceController.text = fillOutRecurrenceName(
          _recurrence.name.tr(), _date, _recurrence.id, context);
    }
    return RecurrenceTypeInput(
      recurrenceController: _recurrenceController,
      onChanged: (rec) {
        setState(() {
          _recurrence = rec;
        });
      },
      recurrenceType: _recurrence,
      date: _date,
    );
  }

  Widget _untilRow() {
    final formatter = DateFormat.yMd(context.locale.toLanguageTag());
    _untilDateController.text = formatter.format(_untilDate);

    return UntilInput(
      untilController: _untilDateController,
      onChanged: (pickedDate) {
        setState(() {
          _untilDate = pickedDate;
        });
      },
      onSwitch: (isLimitedRecurrence) {
        setState(() {
          _isLimitedRecurrence = isLimitedRecurrence;
        });
      },
      untilDate: _untilDate,
      date: _date,
      isLimitedRecurrence: _isLimitedRecurrence,
    );
  }
}
