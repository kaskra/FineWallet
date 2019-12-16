import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/profile_page/budget_notifier.dart';
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
  BudgetSlider({Key key, double widthRatio = 1})
      : this.screenWidthRatio = widthRatio,
        super(key: key);

  final double screenWidthRatio;

  _BudgetSliderState createState() => _BudgetSliderState();
}

class _BudgetSliderState extends State<BudgetSlider> {
  /// Current month entity, holding the current available budget of the month.
  Month _currentMonth;

  /// The text editor controller for the slider-depending textfield.
  TextEditingController _textEditingController = TextEditingController();

  /// Load the current month and set the overall maximum budget,
  /// the current maximum available budget, update the parent by
  /// calling onChanged event callback.
  void _loadCurrentMonth() async {
    Month m =
        await Provider.of<AppDatabase>(context).monthDao.getCurrentMonth();
    Provider.of<BudgetNotifier>(context).setBudget(m.maxBudget);

    setState(() {
      _currentMonth = m;
    });
    _textEditingController.text = m.maxBudget.toStringAsFixed(2);
  }

  /// Update the current month by updating the current monthly available budget in the entity.
  ///
  /// Then update the entity in the database.
  Future _updateMonthModel() async {
    Month month = _currentMonth.copyWith(
        maxBudget: Provider.of<BudgetNotifier>(context).budget);
    Provider.of<AppDatabase>(context)
        .monthDao
        .updateMonth(month.createCompanion(true));
  }

  /// Build the center row with slider, suffix and the slider-depending textfield.
  Widget _buildSliderWithTextInput() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        children: <Widget>[
          _ValueSlider(
            onChangeEnd: (value) => _updateMonthModel(),
            onChange: (value) =>
                _textEditingController.text = value.toStringAsFixed(2),
          ),
          Text(
            "€ ",
            style: TextStyle(fontSize: 16),
          ),
          _buildDependingTextField(),
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

    _textEditingController.text = value.toStringAsFixed(2);
    Provider.of<BudgetNotifier>(context).setBudget(value);
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
            .watchMonthlyIncome(DateTime.now()),
        builder: (context, snapshot) {
          double max = snapshot.hasData ? snapshot.data : 0;

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
      ),
    );
  }

  /// Build the information row for total available budget (savings plus monthly available budget).
  Widget _buildAvailableBudget() {
    return new InformationRow(
      text: Text(
        "Total available budget: ",
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      value: StreamBuilder<double>(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchTotalSavings(),
        builder: (context, snapshot) {
          double maxBudget = snapshot.data ?? 0;
          maxBudget += Provider.of<BudgetNotifier>(context)?.budget ?? 0;
          return Text(
            "${maxBudget.toStringAsFixed(2)}€",
            style: TextStyle(fontSize: 14),
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
        style: TextStyle(fontWeight: FontWeight.bold),
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
      value: StreamBuilder(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchMonthlyIncome(DateTime.now()),
        builder: (context, snapshot) {
          double max = snapshot.hasData ? snapshot.data : 0;
          return Text(
            " ${(max - (Provider.of<BudgetNotifier>(context)?.budget ?? 0)).toStringAsFixed(2)}€",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

    return ExpandToWidth(
      ratio: widget.screenWidthRatio,
      child: DecoratedCard(
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
  bool _loaded = false;

  /// Load current maximum budget from current month.
  _loadCurrentBudget() async {
    Month m =
        await Provider.of<AppDatabase>(context).monthDao.getCurrentMonth();
    Provider.of<BudgetNotifier>(context).setBudget(m.maxBudget);
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
      flex: 3,
      child: StreamBuilder(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchMonthlyIncome(DateTime.now()),
        builder: (context, snapshot) {
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
              Provider.of<BudgetNotifier>(context).setBudget(value);
            },
            onChanged: (value) {
              if (widget.onChange != null) {
                widget.onChange(value);
              }
              Provider.of<BudgetNotifier>(context).setBudget(value);
            },
            onChangeStart: (value) {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            value: Provider.of<BudgetNotifier>(context)?.budget ?? 0,
            min: 0,
            max: max,
            divisions: 100,
          );
        },
      ),
    );
  }
}
