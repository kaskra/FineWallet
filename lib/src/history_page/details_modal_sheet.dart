part of 'history_page.dart';

class HistoryItemDetailsModalSheet extends StatefulWidget {
  final TransactionWithDetails transaction;

  const HistoryItemDetailsModalSheet({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  @override
  _HistoryItemDetailsModalSheetState createState() =>
      _HistoryItemDetailsModalSheetState();
}

class _HistoryItemDetailsModalSheetState
    extends State<HistoryItemDetailsModalSheet> {
  double _amount = 0.0;
  Subcategory _subcategory;

  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final FocusNode _labelFocus = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();

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
    if (widget.transaction.recurrenceType > 1) {
      // If recurring, set the date to the first of the recurrence.
      final BaseTransaction tx =
          await Provider.of<AppDatabase>(context, listen: false)
              .transactionDao
              .getBaseTransactionsById(widget.transaction.id);
      final recurrence = await Provider.of<AppDatabase>(context, listen: false)
          .getRecurrenceById(widget.transaction.recurrenceType);
      return Tuple2(tx, recurrence);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 4.0, bottom: 8.0),
        child: _applyInputTheme(
          Form(
            key: _formKey,
            onWillPop: () {
              logMsg("Want to pop scope");
              return Future.value(true);
            },
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    final isLabelEmpty = _labelController.text.isEmpty;

    return Row(
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
            )),
      ],
    );
  }

  Widget _dateText() {
    final formatter = DateFormat.MMMMEEEEd(context.locale.toLanguageTag());
    final isLimitedRecurrence = widget.transaction.until != null;
    final isRecurrence = widget.transaction.recurrenceType > 1;
    final showUntilDate = isRecurrence && isLimitedRecurrence;

    return FutureBuilder<Tuple2<BaseTransaction, RecurrenceType>>(
        future: _loadBaseTransaction(),
        builder: (context, snapshot) {
          final date = snapshot.data?.first?.date ??
              DateTime.tryParse(widget.transaction.date);
          final recurrence = snapshot.hasData ? snapshot.data.second : null;

          var recurrenceString = "";
          if (recurrence != null) {
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
                          if (showUntilDate) const TextSpan(text: "\t\t-\t\t"),
                          if (showUntilDate)
                            TextSpan(
                                text:
                                    formatter.format(widget.transaction.until)),
                          if (recurrence != null)
                            const TextSpan(text: "\t\t⦁"), //\u2981 = dot
                        ],
                      ),
                    ),
                    if (recurrence != null)
                      Text(LocaleKeys.recurring_transaction_formatted.tr(
                        args: [recurrenceString],
                      )),
                  ],
                ),
              ),
            ],
          );
        });
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
              // TODO show dialog if unsaved changes
              Navigator.of(context).maybePop();
            },
            child: const Icon(Icons.close),
          ),
          TextButton(
            style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).accentColor),
            onPressed: () {
              // TODO show button only if changed label, amount or category ??
            },
            child: Text(LocaleKeys.add_page_fab_label.tr().toUpperCase()),
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
}
