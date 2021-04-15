import 'dart:math' as math;

import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/providers/providers.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SliderItem extends StatefulWidget {
  const SliderItem({
    Key key,
    @required this.flag,
    @required this.streamBuilder,
    @required this.title,
  })  : assert(streamBuilder != null),
        assert(flag != null),
        assert(title != null),
        super(key: key);

  final BudgetFlag flag;
  final Stream<double> Function(BuildContext) streamBuilder;
  final String title;

  _SliderItemState createState() => _SliderItemState();
}

class _SliderItemState extends State<SliderItem> {
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

    if (m == null) {
      await Provider.of<AppDatabase>(context, listen: false)
          .monthDao
          .checkForCurrentMonth();
    }

    if (widget.flag == BudgetFlag.savings) {
      Provider.of<BudgetNotifier>(context, listen: false)
          .setBudget(m?.savingsBudget, widget.flag);
      _textEditingController.text = m?.savingsBudget?.toStringAsFixed(2);
    } else {
      Provider.of<BudgetNotifier>(context, listen: false)
          .setBudget(m?.maxBudget, widget.flag);
      _textEditingController.text = m?.maxBudget?.toStringAsFixed(2);
    }

    setState(() {
      _currentMonth = m;
    });
  }

  /// Update the current month by updating the current monthly available budget in the entity.
  ///
  /// Then update the entity in the database.
  Future _updateMonthModel() async {
    final month = _currentMonth.copyWith(
        savingsBudget: Provider.of<BudgetNotifier>(context, listen: false)
            .getBudget(BudgetFlag.savings),
        maxBudget: Provider.of<BudgetNotifier>(context, listen: false)
            .getBudget(BudgetFlag.monthly));

    await Provider.of<AppDatabase>(context, listen: false)
        .monthDao
        .updateMonth(month.toCompanion(false));
  }

  /// Set the maximum available budget.
  ///
  /// Clamp the value to [0, max] and
  /// update the parent by calling onChanged event callback.
  void _setMonthlyBudget(double value, double max) {
    double temp = value;
    if (temp >= max) {
      temp = max;
    } else if (temp < 0) {
      temp = 0;
    }

    _textEditingController.text = temp.toStringAsFixed(2);
    Provider.of<BudgetNotifier>(context, listen: false)
        .setBudget(temp, widget.flag);
  }

  /// Build the center row with slider, suffix and the slider-depending textfield.
  Widget _buildSliderWithTextInput() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          InformationRow(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              text: Text(widget.title, style: const TextStyle(fontSize: 14)),
              value: Container()),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: <Widget>[
                BudgetSlider(
                  flag: widget.flag,
                  streamBuilder: widget.streamBuilder,
                  onChangeEnd: (value) async {
                    await _updateMonthModel();
                  },
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

  /// The depending textfield shows the current value of the slider.
  ///
  /// It can be changed by keyboard input to a custom value.
  /// That value is then shown on the slider.
  Widget _buildDependingTextField() {
    return Expanded(
      child: StreamBuilder(
        stream: widget.streamBuilder(context),
        builder: (context, AsyncSnapshot<double> snapshot) {
          final double max =
              math.max(snapshot.hasData ? snapshot.data : 0, 0.0);
          return TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              filled: true,
            ),
            onSubmitted: (valueAsString) async {
              final value = double.tryParse(valueAsString) ?? 0.0;
              _setMonthlyBudget(value, max);
              await _updateMonthModel();
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
