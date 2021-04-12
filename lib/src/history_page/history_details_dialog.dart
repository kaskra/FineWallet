part of 'history_page.dart';

class HistoryItemDetailsDialog extends StatefulWidget {
  final TransactionWithDetails transaction;

  const HistoryItemDetailsDialog({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  @override
  _HistoryItemDetailsDialogState createState() =>
      _HistoryItemDetailsDialogState();
}

class _HistoryItemDetailsDialogState extends State<HistoryItemDetailsDialog> {
  double _amount = 0.0;
  Subcategory _subcategory;
  BaseTransaction _baseTransaction;

  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final FocusNode _labelFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _amount =
          double.parse((widget.transaction.originalAmount).toStringAsFixed(2));
      _subcategory = widget.transaction.s;
      _labelController.text = widget.transaction.label;
    });
  }

  @override
  void dispose() {
    _labelFocus.dispose();
    super.dispose();
  }

  Future<Tuple2<BaseTransaction, RecurrenceType>> _loadBaseTransaction() async {
    // If recurring, set the date to the first of the recurrence.
    final BaseTransaction tx =
        await Provider.of<AppDatabase>(context, listen: false)
            .transactionDao
            .getBaseTransactionsById(widget.transaction.id);
    final recurrence = await Provider.of<AppDatabase>(context, listen: false)
        .getRecurrenceById(widget.transaction.recurrenceType);
    return Tuple2(tx, recurrence);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('history_item_details_key'),
      direction: DismissDirection.down,
      background: Container(color: Colors.black.withOpacity(0.3)),
      onDismissed: (_) => Navigator.of(context).pop(),
      confirmDismiss: (_) => _willPop(context),
      resizeDuration: null,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 4.0, bottom: 8.0),
          child: _applyInputTheme(
            Form(
              key: _formKey,
              onWillPop: () => _willPop(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _actions(),
                  const SizedBox(height: 8),
                  _title(),
                  const SizedBox(height: 4),
                  _dateText(),
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 4),
                  _amountRow(),
                  const SizedBox(height: 8),
                  _labelRow(),
                  const SizedBox(height: 8),
                  _categoryRow(),
                  if (_isUnlimitedRecurrence) _endUnlimitedRecurrence(),
                  if (_isLimitedRecurrence) _startUnlimitedRecurrence(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _willPop(BuildContext context) async {
    if (_hasChanged) {
      final isConfirmed = await showConfirmDialog(
          context,
          LocaleKeys.add_page_not_saved_title.tr(),
          LocaleKeys.add_page_not_saved_text.tr());
      return Future.value(isConfirmed);
    }
    return Future.value(true);
  }

  Widget _title() {
    final isLabelEmpty = _labelController.text.isEmpty;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: [
          Flexible(
              child: Center(
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.transaction.isExpense ? Colors.red : Colors.green,
              ),
            ),
          )),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () {
                if (!_labelFocus.hasFocus) {
                  _labelFocus.requestFocus();
                }
              },
              child: Text(
                isLabelEmpty
                    ? LocaleKeys.history_page_no_label.tr()
                    : _labelController.text,
                style: TextStyle(
                    fontSize: 20,
                    color: isLabelEmpty
                        ? Theme.of(context)
                            .textTheme
                            .bodyText2
                            .color
                            .withOpacity(0.6)
                        : null),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateText() {
    final formatter = DateFormat.MMMMEEEEd(context.locale.toLanguageTag());
    final isLimitedRecurrence = widget.transaction.until != null;
    final isRecurrence = widget.transaction.recurrenceType > 1;
    final showUntilDate = isRecurrence && isLimitedRecurrence;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FutureBuilder<Tuple2<BaseTransaction, RecurrenceType>>(
          future: _loadBaseTransaction(),
          builder: (context, snapshot) {
            DateTime date = DateTime.tryParse(widget.transaction.date);
            RecurrenceType recurrence;
            var recurrenceString = "";

            if (snapshot.hasData) {
              _baseTransaction = snapshot.data.first;
              date = _baseTransaction.date;
              recurrence = snapshot.data.second;
            }

            if (recurrence != null && recurrence.id > 1) {
              recurrenceString = fillOutRecurrenceName(
                  recurrence.name.tr(), date, recurrence.id, context);
              recurrenceString = recurrenceString.replaceRange(
                  0, 1, recurrenceString[0].toLowerCase());
            }

            return Row(
              children: [
                Flexible(child: Container()),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: formatter.format(date),
                          children: [
                            if (showUntilDate)
                              const TextSpan(text: "\t\t-\t\t"),
                            if (showUntilDate)
                              TextSpan(
                                  text: formatter
                                      .format(widget.transaction.until)),
                            if (recurrence != null && recurrence.id > 1)
                              const TextSpan(text: "\t\t⦁"), //\u2981 = dot
                          ],
                        ),
                      ),
                      if (recurrence != null && recurrence.id > 1)
                        Text(LocaleKeys.recurring_transaction_formatted.tr(
                          args: [recurrenceString],
                        )),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _actions() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20.0),
            radius: 30,
            onTap: () {
              Navigator.of(context).maybePop();
            },
            child: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: _hasChanged
                  ? Theme.of(context).accentColor
                  : Theme.of(context).scaffoldBackgroundColor,
              side: _hasChanged
                  ? null
                  : BorderSide(color: Theme.of(context).disabledColor),
            ),
            onPressed: _hasChanged
                ? () async {
                    await _save();
                  }
                : null,
            child: Text(
              LocaleKeys.add_page_fab_label.tr().toUpperCase(),
              style: TextStyle(
                color: _hasChanged
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).disabledColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _amountRow() {
    return EditableNumericInputText(
      autofocus: false,
      defaultValue: _amount,
      currencyId: widget.transaction.currencyId,
      onChanged: (value) {
        setState(() {
          _amount = value;
        });
      },
    );
  }

  Widget _labelRow() {
    return LabelTypeAheadInput(
      focusNode: _labelFocus,
      isExpense: widget.transaction.isExpense,
      labelController: _labelController,
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

  Widget _categoryRow() {
    _categoryController.text = tryTranslatePreset(_subcategory);
    return CategoryInput(
        isExpense: widget.transaction.isExpense,
        subcategory: _subcategory,
        categoryController: _categoryController,
        onChanged: (sub) {
          setState(() {
            _subcategory = sub;
          });
          print(_subcategory);
        });
  }

  Widget _endUnlimitedRecurrence() {
    final formatter = DateFormat.MMMMd(context.locale.toLanguageTag());
    final date = formatter.format(DateTime.parse(widget.transaction.date));

    return _button(
      onPressed: () async {
        await _save(endRecurrence: true);
      },
      title: LocaleKeys.add_page_stop_recurrence.tr(args: [date]),
      iconData: Icons.stop_rounded,
    );
  }

  Widget _startUnlimitedRecurrence() {
    return _button(
      onPressed: () async {
        await _save(startUnlimitedRecurrence: true);
      },
      title: LocaleKeys.add_page_start_recurrence.tr(),
      iconData: Icons.replay,
    );
  }

  Widget _button({
    @required void Function() onPressed,
    @required String title,
    @required IconData iconData,
  }) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              side: BorderSide(color: Theme.of(context).accentColor),
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: Icon(iconData)),
                Expanded(
                  flex: 5,
                  child: Text(
                    "$title${_hasChanged ? LocaleKeys.add_page_save_addition.tr() : ""}",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get _isUnlimitedRecurrence {
    return widget.transaction.recurrenceType > 1 &&
        widget.transaction.until == null;
  }

  bool get _isLimitedRecurrence {
    return widget.transaction.recurrenceType > 1 &&
        widget.transaction.until != null;
  }

  bool get _hasChanged {
    final unchangedAmount = double.parse(
        (widget.transaction.originalAmount ?? 0.0).toStringAsFixed(2));

    final unchangedLabel = widget.transaction.label;
    final unchangedSubcat = widget.transaction.subcategoryId;

    return _subcategory.id != unchangedSubcat ||
        _labelController.text != unchangedLabel ||
        _amount != unchangedAmount;
  }

  Future _save({
    bool endRecurrence = false,
    bool startUnlimitedRecurrence = false,
  }) async {
    if (_formKey.currentState.validate()) {
      final UpdateModifier modifier = await _getModifier();
      if (modifier == null) {
        return;
      }

      await _updateTransaction(
        modifier: modifier,
        endRecurrence: endRecurrence,
        startUnlimitedRecurrence: startUnlimitedRecurrence,
      );
      Navigator.of(context).pop();
    }
  }

  Future<UpdateModifier> _getModifier() async {
    var flag = UpdateModifierFlag.all;
    if (_hasChanged && widget.transaction.recurrenceType > 1) {
      final UpdateModifierFlag selectedFlag = await showDialog(
        context: context,
        builder: (context) => UpdateModifierDialog(),
      );

      if (selectedFlag != null) {
        flag = selectedFlag;
      } else {
        return null;
      }
    }
    final UpdateModifier modifier = UpdateModifier(
      flag,
      DateTime.parse(widget.transaction.date),
    );
    return modifier;
  }

  Future _updateTransaction({
    UpdateModifier modifier,
    bool endRecurrence = false,
    bool startUnlimitedRecurrence = false,
  }) async {
    assert(!(endRecurrence && startUnlimitedRecurrence));
    DateTime until = widget.transaction.until;

    if (endRecurrence) {
      until = DateTime.parse(widget.transaction.date);
    } else if (startUnlimitedRecurrence) {
      until = null;
    }

    final tx = BaseTransaction(
      id: widget.transaction.id,
      date: _baseTransaction.date,
      isExpense: widget.transaction.isExpense,
      amount: _amount,
      originalAmount: _amount,
      exchangeRate: null,
      monthId: null,
      subcategoryId: _subcategory.id,
      currencyId: widget.transaction.currencyId,
      label: _labelController.text.trim(),
      recurrenceType: widget.transaction.recurrenceType,
      until: until,
    );
    await Provider.of<AppDatabase>(context, listen: false)
        .transactionDao
        .updateTransaction(tx, modifier: modifier);
  }
}
