import 'package:FineWallet/core/models/month_model.dart';
import 'package:FineWallet/core/resources/blocs/month_bloc.dart';
import 'package:FineWallet/core/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/core/resources/month_provider.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
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
  /// The maximum available budget for the month.
  double _currentMaxMonthlyBudget = 0;

  /// Current month entity, holding the current available budget of the month.
  MonthModel _currentMonth;

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
    MonthModel currentMonth = await MonthProvider.db.getCurrentMonth();

    setState(() {
      _currentMaxMonthlyBudget = currentMonth.currentMaxBudget;
      _currentMonth = currentMonth;
    });

    _textEditingController.text = _currentMaxMonthlyBudget.toStringAsFixed(2);

    if (widget.onChanged != null) {
      widget.onChanged(_currentMaxMonthlyBudget);
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
          _ValueSlider(
            onChangeEnd: (value) {
              setState(() {
                _currentMaxMonthlyBudget = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged(value);
              }
              _updateMonthModel();
            },
            onChange: (value) =>
                _textEditingController.text = value.toStringAsFixed(2),
          ),
          Text(
            "€ ",
            style: const TextStyle(fontSize: 16),
          ),
          _buildDependendTextField(),
        ],
      ),
    );
  }

  /// Set the maximum available budget.
  ///
  /// Clamp the value to [0, max] and
  /// update the parent by calling onChanged event callback.
  void _setMaxMonthlyBudget(double value, double max) {
    if (value >= max) {
      value = max;
    } else if (value < 0) {
      value = 0;
    }

    _currentMaxMonthlyBudget = value;
    _textEditingController.text = value.toStringAsFixed(2);

    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }

  /// The dependend textfield shows the current value of the slider.
  ///
  /// It can be changed by keyboard input to a custom value.
  /// That value is then shown on the slider.
  Widget _buildDependendTextField() {
    return Expanded(
      child: Consumer<TransactionBloc>(
        builder: (context, bloc, _) {
          bloc.getMonthlyTransactions();
          return StreamBuilder<TransactionList>(
            stream: bloc.monthlyTransactions,
            builder: (context, snapshot) {
              double max = snapshot.hasData ? snapshot.data.sumIncomes() : 0;

              return TextField(
                decoration: InputDecoration(border: InputBorder.none),
                onSubmitted: (valueAsString) {
                  double value = double.parse(valueAsString);
                  _setMaxMonthlyBudget(value, max);
                  _updateMonthModel();
                },
                onTap: () {
                  _textEditingController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _textEditingController.text.length);
                },
                controller: _textEditingController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              );
            },
          );
        },
      ),
    );
  }

  /// Build the information row for total available budget (savings plus monthly available budget).
  Widget _buildAvailableBudget() {
    return new InformationRow(
      text: Text(
        "Total available budget: ",
        style: TextStyle(fontSize: 14),
      ),
      value: Consumer<MonthBloc>(
        builder: (context, bloc, child) {
          bloc.getSavings();
          return StreamBuilder<double>(
            stream: bloc.savings,
            builder: (context, snapshot) {
              double maxBudget = snapshot.data ?? 0;
              maxBudget += _currentMaxMonthlyBudget;
              return Text(
                "${maxBudget.toStringAsFixed(2)}€",
                style: TextStyle(fontSize: 14),
              );
            },
          );
        },
      ),
    );
  }

  /// Build slider title text
  Widget _buildTitle() {
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        "Monthly available budget",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Build expected savings for current month.
  Widget _buildExpectedSavings() {
    return new InformationRow(
      text: Text(
        "Expected savings: ",
        style: TextStyle(fontSize: 14),
      ),
      value: Consumer<TransactionBloc>(
        builder: (context, bloc, _) {
          bloc.getMonthlyTransactions();
          return StreamBuilder<TransactionList>(
            stream: bloc.monthlyTransactions,
            builder: (context, snapshot) {
              double max = snapshot.hasData ? snapshot.data.sumIncomes() : 0;

              return Text(
                " ${(max - _currentMaxMonthlyBudget).toStringAsFixed(2)}€",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          );
        },
      ),
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
            _buildTitle(),
            _buildSliderWithTextInput(),
            _buildAvailableBudget(),
            _buildExpectedSavings()
          ],
        ),
      ),
    );
  }
}

class _ValueSlider extends StatefulWidget {
  _ValueSlider({this.onChangeEnd, this.onChange});

  @override
  __ValueSliderState createState() => __ValueSliderState();

  final Function(double value) onChangeEnd;

  final Function(double value) onChange;
}

class __ValueSliderState extends State<_ValueSlider> {
  double _value = 0;

  @override
  void initState() {
    _loadCurrentBudget();
    super.initState();
  }

  /// Load current maximum budget from current month.
  _loadCurrentBudget() async {
    MonthModel currentMonth = await MonthProvider.db.getCurrentMonth();

    setState(() {
      _value = currentMonth.currentMaxBudget;
    });
  }

  /// Build the slider, which calls sets the current maximum budget when getting changed.
  ///
  /// When the change ends, the database is updated.
  /// When the change starts, a new focus node is set, to force the keyboard to be closed.
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Consumer<TransactionBloc>(
        builder: (context, bloc, _) {
          bloc.getMonthlyTransactions();
          return StreamBuilder<TransactionList>(
            stream: bloc.monthlyTransactions,
            builder: (context, snapshot) {
              double max = 1;
              if (snapshot.hasData) {
                max = snapshot.data.sumIncomes();
              }
              return Slider(
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd(value);
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                  if (widget.onChange != null) {
                    widget.onChange(value);
                  }
                },
                onChangeStart: (value) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                value: _value,
                min: 0,
                max: max,
                divisions: 100,
              );
            },
          );
        },
      ),
    );
  }
}
