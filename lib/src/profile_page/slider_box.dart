import 'package:FineWallet/core/models/month_model.dart';
import 'package:FineWallet/core/resources/blocs/month_bloc.dart';
import 'package:FineWallet/core/resources/month_provider.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/core/resources/transaction_provider.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The slider box widgets shows a slider with title, a slider-dependent text field and an text below the slider
class BudgetSlider extends StatefulWidget {
  BudgetSlider({Key key, this.onChanged, this.borderRadius = BorderRadius.zero})
      : super(key: key);

  final BorderRadius borderRadius;
  final Function(double budget) onChanged;

  _BudgetSliderState createState() => _BudgetSliderState();
}

class _BudgetSliderState extends State<BudgetSlider> {
  double _currentMaxMonthlyBudget = 0;
  MonthModel _currentMonth;
  double _overallMaxBudget = 0;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _loadCurrentMonth();
    super.initState();
  }

  void _loadCurrentMonth() async {
    TransactionList monthlyTransactions = await TransactionsProvider.db
        .getTransactionsOfMonth(dayInMillis(DateTime.now()));

    MonthModel currentMonth = await MonthProvider.db.getCurrentMonth();

    setState(() {
      _overallMaxBudget = monthlyTransactions.sumIncomes();
      _currentMaxMonthlyBudget = currentMonth.currentMaxBudget;
      _currentMonth = currentMonth;
    });

    _textEditingController.text = _currentMaxMonthlyBudget.toStringAsFixed(2);
    _setMaxMonthlyBudget(_currentMaxMonthlyBudget);
  }

  void _setMaxMonthlyBudget(double value) {
    if (value >= _overallMaxBudget) {
      value = _overallMaxBudget;
    } else if (value < 0) {
      value = 0;
    }

    _currentMaxMonthlyBudget = value;
    _textEditingController.text = value.toStringAsFixed(2);

    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }

  Future _updateMonthModel() async {
    _currentMonth?.currentMaxBudget = _currentMaxMonthlyBudget;
    Provider.of<MonthBloc>(context).updateMonth(_currentMonth);
  }

  Widget _buildSliderWithTextInput() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        children: <Widget>[
          _buildSlider(),
          Text(
            "€ ",
            style: const TextStyle(fontSize: 16),
          ),
          _buildDependendTextField()
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Expanded(
      flex: 3,
      child: Slider(
        onChangeEnd: (v) => _updateMonthModel(),
        onChanged: (value) {
          _setMaxMonthlyBudget(value);
        },
        onChangeStart: (value) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        value: _currentMaxMonthlyBudget,
        min: 0,
        max: _overallMaxBudget,
        divisions: 100,
      ),
    );
  }

  Widget _buildDependendTextField() {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(border: InputBorder.none),
        onSubmitted: (valueAsString) {
          double value = double.parse(valueAsString);
          _setMaxMonthlyBudget(value);
          _updateMonthModel();
        },
        onTap: () {
          _textEditingController.selection = TextSelection(
              baseOffset: 0, extentOffset: _textEditingController.text.length);
        },
        controller: _textEditingController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      context: context,
      child: DecoratedCard(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Monthly available budget",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            _buildSliderWithTextInput(),
            Align(
              alignment: Alignment.center,
              child: Text(
                  "Expected savings: ${(_overallMaxBudget - _currentMaxMonthlyBudget).toStringAsFixed(2)}€",
                  style: const TextStyle(fontSize: 14)),
            )
          ],
        ),
        borderRadius: widget.borderRadius,
      ),
    );
  }
}
