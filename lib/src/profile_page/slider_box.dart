import 'package:FineWallet/core/models/month_model.dart';
import 'package:FineWallet/core/resources/blocs/month_bloc.dart';
import 'package:FineWallet/core/resources/month_provider.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/core/resources/transaction_provider.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The slider box widgets shows a slider with title, a slider-dependent text field
/// and a text below the slider for more information about the value.
///
/// The slider box is rendered to screen width with an optional ratio.
class BudgetSlider extends StatefulWidget {
  BudgetSlider(
      {Key key,
      this.onChanged,
      this.borderRadius = BorderRadius.zero,
      double widthRatio = 1})
      : this.screenWidthRatio = widthRatio,
        super(key: key);

  final BorderRadius borderRadius;
  final Function(double budget) onChanged;
  final double screenWidthRatio;

  _BudgetSliderState createState() => _BudgetSliderState();
}

class _BudgetSliderState extends State<BudgetSlider> {
  /// Current month entity, holding the current available budget of the month.
  MonthModel _currentMonth;

  /// The maximum available budget for the month.
  double _currentMaxMonthlyBudget = 0;

  /// The overall maximum budget, which depends on all incomes of the month.
  ///
  /// Sum of all incomes of the current month.
  double _overallMaxBudget = 0;

  /// The text editor controller for the slider-dependend textfield.
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _loadCurrentMonth();
    super.initState();
  }

  /// Load the current month and set the overall maximum budget,
  /// the current maximum available budget, update the parent by
  /// calling onChanged event callback.
  void _loadCurrentMonth() async {
    TransactionList monthlyTransactions = await TransactionsProvider.db
        .getTransactionsOfMonth(dayInMillis(DateTime.now()));

    MonthModel currentMonth = await MonthProvider.db.getCurrentMonth();

    if (currentMonth == null) {
      currentMonth = new MonthModel(
        currentMaxBudget: 0.0,
        monthlyExpenses: 0.0,
        savings: 0.0,
        firstDayOfMonth: getFirstDateOfMonth(DateTime.now()),
      );
      Provider.of<MonthBloc>(context).add(currentMonth);
    }

    setState(() {
      _overallMaxBudget = monthlyTransactions.sumIncomes();
      _currentMaxMonthlyBudget = currentMonth.currentMaxBudget;
      _currentMonth = currentMonth;
    });

    _textEditingController.text = _currentMaxMonthlyBudget.toStringAsFixed(2);
    _setMaxMonthlyBudget(_currentMaxMonthlyBudget);
  }

  /// Set the maximum available budget.
  ///
  /// Clamp the value to [0, overall max budget],
  /// update the parent by calling onChanged event callback.
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

  /// Update the current month by updating the current monthly available budget in the entity.
  ///
  /// Then update the entity in the database.
  Future _updateMonthModel() async {
    _currentMonth?.currentMaxBudget = _currentMaxMonthlyBudget;
    Provider.of<MonthBloc>(context).updateMonth(_currentMonth);
  }

  /// Build the center row with slider, suffix and the slider-dependend textfield.
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
          _buildDependendTextField(),
        ],
      ),
    );
  }

  /// Build the slider, which calls sets the current maximum budget when getting changed.
  ///
  /// When the change ends, the database is updated.
  /// When the change starts, a new focus node is set, to force the keyboard to be closed.
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

  /// The dependend textfield shows the current value of the slider.
  ///
  /// It can be changed by keyboard input to a custom value.
  /// That value is then shown on the slider.
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

  /// Show overall available budget (savings plus monthly available budget).
  Widget _buildOverallBudget() {
    return Consumer<MonthBloc>(
      builder: (context, bloc, child) {
        bloc.getSavings();
        return StreamBuilder<double>(
          stream: bloc.savings,
          builder: (context, snapshot) {
            double maxBudget = 0;
            if (snapshot.hasData) {
              maxBudget = snapshot.data + _currentMaxMonthlyBudget;
            }
            return Text(
              "${maxBudget.toStringAsFixed(2)}€",
              style: TextStyle(fontSize: 14),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      ratio: widget.screenWidthRatio,
      child: DecoratedCard(
        borderColor: Theme.of(context).colorScheme.primary,
        borderWidth: 0,
        borderRadius: widget.borderRadius,
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
            new InformationRow(
              text: Text(
                "Overall available budget: ",
                style: TextStyle(fontSize: 14),
              ),
              value: _buildOverallBudget(),
            ),
            new InformationRow(
              text: Text(
                "Expected savings: ",
                style: TextStyle(fontSize: 14),
              ),
              value: Text(
                " ${(_overallMaxBudget - _currentMaxMonthlyBudget).toStringAsFixed(2)}€",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
