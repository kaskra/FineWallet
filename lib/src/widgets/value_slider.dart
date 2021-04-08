import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetSlider extends StatefulWidget {
  const BudgetSlider({
    this.onChangeEnd,
    this.onChange,
    @required this.streamBuilder,
    @required this.flag,
  })  : assert(streamBuilder != null),
        assert(flag != null);

  @override
  _BudgetSliderState createState() => _BudgetSliderState();

  final Stream<double> Function(BuildContext) streamBuilder;
  final BudgetFlag flag;
  final Function(double value) onChangeEnd;
  final Function(double value) onChange;
}

class _BudgetSliderState extends State<BudgetSlider> {
  /// Build the slider, which calls sets the current maximum budget when getting changed.
  ///
  /// When the change ends, the database is updated.
  /// When the change starts, a new focus node is set, to force the keyboard to be closed.
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: StreamBuilder<double>(
        stream: widget.streamBuilder(context), //widget.streamBuilder(context),
        builder: (context, snapshot) {
          // Make sure that max is not smaller than the value to be displayed.
          // Happens while loading the monthly transactions.
          double max = snapshot.hasData ? snapshot.data : 0;
          if (max <
              (Provider.of<BudgetNotifier>(context)?.getBudget(widget.flag) ??
                  0)) {
            max = Provider.of<BudgetNotifier>(context).getBudget(widget.flag);
          }

          return Slider(
            onChangeEnd: (value) async {
              if (widget.onChangeEnd != null) {
                await widget.onChangeEnd(value);
              }
              Provider.of<BudgetNotifier>(context, listen: false)
                  .setBudget(value, widget.flag);
            },
            onChanged: (value) async {
              if (widget.onChange != null) {
                widget.onChange(value);
              }
              Provider.of<BudgetNotifier>(context, listen: false)
                  .setBudget(value, widget.flag);
            },
            onChangeStart: (value) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            value: Provider.of<BudgetNotifier>(context, listen: false)
                    ?.getBudget(widget.flag) ??
                0,
            max: max,
            divisions: 100,
          );
        },
      ),
    );
  }
}
