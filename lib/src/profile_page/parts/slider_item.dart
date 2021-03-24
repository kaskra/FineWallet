import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SliderItem extends StatefulWidget {
  @override
  _SliderItemState createState() => _SliderItemState();
}

class _SliderItemState extends State<SliderItem> {
  /// Current month entity, holding the current available budget of the month.
  Month _currentMonth;

  /// The text editor controller for the slider-depending textfield.
  final TextEditingController _textEditingController = TextEditingController();

  /// Load the current month and set the overall maximum budget,
  /// the current maximum available budget, update the parent by
  /// calling onChanged event callback.
  Future _loadCurrentMonth() async {
    final m = await Provider.of<AppDatabase>(context, listen: false)
        .monthDao
        .getCurrentMonth();
    Provider.of<BudgetNotifier>(context, listen: false).setBudget(m?.maxBudget);

    setState(() {
      _currentMonth = m;
    });
    _textEditingController.text = m?.maxBudget?.toStringAsFixed(2);
  }

  /// Update the current month by updating the current monthly available budget in the entity.
  ///
  /// Then update the entity in the database.
  Future _updateMonthModel() async {
    final month = _currentMonth.copyWith(
        maxBudget: Provider.of<BudgetNotifier>(context, listen: false).budget);
    Provider.of<AppDatabase>(context, listen: false)
        .monthDao
        .updateMonth(month.toCompanion(true));
  }

  /// Build the center row with slider, suffix and the slider-depending textfield.
  Widget _buildSliderWithTextInput() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          InformationRow(
              padding:
              const EdgeInsets.only(bottom: 0.0, left: 8.0, right: 8.0),
              text: Text("Monthly Budget:", style: const TextStyle(fontSize: 14)),
              value: Container()),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: <Widget>[
                _ValueSlider(
                  onChangeEnd: (value) => _updateMonthModel(),
                  onChange: (value) =>
                      _textEditingController.text = value.toStringAsFixed(2),
                ),
                Text(
                  "${Provider.of<LocalizationNotifier>(context).userCurrency} ",
                  style: const TextStyle(fontSize: 16),
                ),
                _buildDependingTextField(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Set the maximum available budget.
  ///
  /// Clamp the value to [0, max] and
  /// update the parent by calling onChanged event callback.
  void _setMaxMonthlyBudget(double value, double max) {
    double temp = value;
    if (temp >= max) {
      temp = max;
    } else if (temp < 0) {
      temp = 0;
    }

    _textEditingController.text = temp.toStringAsFixed(2);
    Provider.of<BudgetNotifier>(context, listen: false).setBudget(temp);
  }

  /// The depending textfield shows the current value of the slider.
  ///
  /// It can be changed by keyboard input to a custom value.
  /// That value is then shown on the slider.
  Widget _buildDependingTextField() {
    return Expanded(
      child: StreamBuilder(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchMonthlyIncome(today()),
        builder: (context, AsyncSnapshot<double> snapshot) {
          final double max = snapshot.hasData ? snapshot.data : 0;

          return TextField(
            decoration: const InputDecoration(border: InputBorder.none),
            onSubmitted: (valueAsString) {
              final value = double.parse(valueAsString);
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentMonth == null) {
      _loadCurrentMonth();
    }

    return _buildSliderWithTextInput();
  }
}
//-------------------------------------------------------------------
class _ValueSlider extends StatefulWidget {
  const _ValueSlider({this.onChangeEnd, this.onChange});

  @override
  __ValueSliderState createState() => __ValueSliderState();

  final Function(double value) onChangeEnd;

  final Function(double value) onChange;
}

class __ValueSliderState extends State<_ValueSlider> {
  bool _loaded = false;

  /// Load current maximum budget from current month.
  Future _loadCurrentBudget() async {
    final month = await Provider.of<AppDatabase>(context, listen: false)
        .monthDao
        .getCurrentMonth();
    Provider.of<BudgetNotifier>(context, listen: false)
        .setBudget(month?.maxBudget);
    setState(() {
      _loaded = true;
    });
  }

  /// Build the slider, which calls sets the current maximum budget when getting changed.
  ///
  /// When the change ends, the database is updated.
  /// When the change starts, a new focus node is set, to force the keyboard to be closed.
  @override
  Widget build(BuildContext context) {
    if (!_loaded) _loadCurrentBudget();

    return Expanded(
      flex: 5,
      child: StreamBuilder(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchMonthlyIncome(today()),
        builder: (context, AsyncSnapshot<double> snapshot) {
          // Make sure that max is not smaller than the value to be displayed.
          // Happens while loading the monthly transactions.
          double max = snapshot.hasData ? snapshot.data : 0;
          if (max < (Provider.of<BudgetNotifier>(context)?.budget ?? 0)) {
            max = Provider.of<BudgetNotifier>(context).budget;
          }

          return Slider(
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd(value);
              }
              Provider.of<BudgetNotifier>(context, listen: false)
                  .setBudget(value);
            },
            onChanged: (value) {
              if (widget.onChange != null) {
                widget.onChange(value);
              }
              Provider.of<BudgetNotifier>(context, listen: false)
                  .setBudget(value);
            },
            onChangeStart: (value) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            value:
                Provider.of<BudgetNotifier>(context, listen: false)?.budget ??
                    0,
            max: max,
            divisions: 100,
          );
        },
      ),
    );
  }
}
