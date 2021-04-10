import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:supercharged/supercharged.dart';

class CircularCategoryChart extends StatefulWidget {
  final List<double> amounts;
  final List<String> names;
  final List<int> ids;

  const CircularCategoryChart(
      {Key key,
      @required this.amounts,
      @required this.names,
      @required this.ids})
      : assert(amounts != null),
        assert(names != null),
        assert(ids != null),
        super(key: key);

  @override
  _CircularCategoryChartState createState() => _CircularCategoryChartState();
}

class _CircularCategoryChartState extends State<CircularCategoryChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sections: _pieChartSections(context),
          centerSpaceRadius: 25,
          sectionsSpace: 1,
          pieTouchData: PieTouchData(
            enabled: true,
            touchCallback: (touch) {
              setState(() {
                final desiredTouch = touch.touchInput is! PointerExitEvent &&
                    touch.touchInput is! PointerUpEvent;
                if (desiredTouch && touch.touchedSection != null) {
                  _touchedIndex = touch.touchedSection.touchedSectionIndex;
                } else {
                  _touchedIndex = -1;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _pieChartSections(BuildContext context) {
    final accentHue =
        HSLColor.fromColor(Theme.of(context).accentColor).hue.toInt();
    final colorHue = ColorHue.custom(Range(accentHue - 10, accentHue + 10));

    final totalAmount = widget.amounts.sumByDouble((n) => n);

    return List.generate(widget.amounts.length, (index) {
      final bool isTouched = _touchedIndex == index;
      final double opacity = isTouched || _touchedIndex == -1 ? 1 : 0.6;

      final RandomColor _randomColor = RandomColor(widget.ids[index]);
      final color = _randomColor.randomColor(
        colorBrightness: ColorBrightness.light,
        colorHue: colorHue,
      );

      final textColor =
          color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

      return PieChartSectionData(
          showTitle: widget.amounts[index] / totalAmount > 0.07,
          value: widget.amounts[index],
          title: "${(widget.amounts[index] / totalAmount * 100).round()}%",
          color: color.withOpacity(opacity),
          radius: isTouched ? 50 : 40,
          titleStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor.withOpacity(opacity),
          ),
          badgePositionPercentageOffset: 1.4,
          badgeWidget: isTouched
              ? Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    widget.names[index],
                    style: TextStyle(color: textColor),
                  ),
                )
              : null);
    });
  }
}
