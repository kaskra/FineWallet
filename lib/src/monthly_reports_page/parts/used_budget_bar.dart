import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/providers/providers.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class creates a widget that displays how much money
/// was spend in one month.
class UsedBudgetBar extends StatelessWidget {
  const UsedBudgetBar({
    Key key,
    @required this.model,
    this.padding,
  }) : super(key: key);

  final MonthWithDetails model;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: [
              AnimatedBudgetBar(
                height: 75,
                availableBudget: model.month.maxBudget,
                maxBudget: model.income,
                usedBudget: model.expense,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.reports_page_maximal_available_budget.tr(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${model.income.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).userCurrency}",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnimatedBudgetBar extends StatefulWidget {
  final double height;

  final double usedBudget;
  final double availableBudget;
  final double maxBudget;

  const AnimatedBudgetBar({
    Key key,
    this.usedBudget,
    this.availableBudget,
    this.maxBudget,
    this.height = 25,
  }) : super(key: key);

  @override
  _AnimatedBudgetBarState createState() => _AnimatedBudgetBarState();
}

class _AnimatedBudgetBarState extends State<AnimatedBudgetBar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _usedBudgetAnimation;
  Animation<double> _availableBudgetAnimation;

  double usedBudgetPercentage = 0;
  double availableBudgetPercentage = 0;

  @override
  void initState() {
    if (widget.maxBudget > 0) {
      availableBudgetPercentage = widget.availableBudget / widget.maxBudget;
      usedBudgetPercentage = widget.usedBudget / widget.maxBudget;
    } else {
      usedBudgetPercentage = 0.0;
      availableBudgetPercentage = 0.0;
    }

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _usedBudgetAnimation = Tween<double>(
      begin: 0.0,
      end: usedBudgetPercentage,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));

    _availableBudgetAnimation = Tween<double>(
      begin: 0.0,
      end: availableBudgetPercentage,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        size: Size.fromHeight(widget.height),
        painter: BudgetBarPainter(
            isError: _usedBudgetAnimation.value > 1.0,
            usedPercentage: _usedBudgetAnimation.value,
            availablePercentage: _availableBudgetAnimation.value,
            usedBudget: widget.usedBudget,
            availableBudget: widget.availableBudget,
            maxBudget: widget.maxBudget,
            availableColor: Colors.green,
            backgroundColor: Colors.black.withOpacity(0.1),
            centerTextColor: Provider.of<ThemeNotifier>(context).isDarkMode
                ? Colors.white
                : Colors.grey.shade900,
            usedColor: Theme.of(context).accentColor,
            indicatorBackgroundColor: Colors.grey.shade50,
            indicatorBorderColor: Colors.grey.shade300,
            currencySymbol:
                Provider.of<LocalizationNotifier>(context).userCurrency),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedBudgetBar oldWidget) {
    _controller.forward(from: 0.0);
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }
}

class BudgetBarPainter extends CustomPainter {
  final Paint _backgroundPaint;
  final Paint _usedPaint;
  final Paint _availablePaint;
  final Paint _errorPaint;
  final Paint _markerPaint;

  final Color backgroundColor;
  final Color usedColor;
  final Color availableColor;
  final Color errorColor;
  final Color indicatorBackgroundColor;
  final Color indicatorBorderColor;
  final Color markerColor;
  final Color centerTextColor;

  final bool isError;

  final double usedPercentage;
  final double availablePercentage;
  final double usedBudget;
  final double availableBudget;
  final double maxBudget;
  final String currencySymbol;

  // Statics
  static Radius radius = const Radius.circular(8.0);
  static Radius indicatorRadius = const Radius.circular(8.0);
  static double spaceToMarker = 4;
  static double padding = 4.0;
  static double borderWidth = 1.0;
  static double barRatioTop = 0.35;
  static double barRatioBottom = 0.65;

  BudgetBarPainter({
    this.backgroundColor = Colors.grey,
    this.usedColor = Colors.green,
    this.availableColor = Colors.grey,
    this.errorColor = Colors.red,
    this.indicatorBackgroundColor = Colors.grey,
    this.indicatorBorderColor = Colors.black,
    this.markerColor = Colors.white,
    this.centerTextColor = Colors.white,
    this.usedPercentage = 0.0,
    this.availablePercentage = 1.0,
    this.usedBudget = 0.0,
    this.availableBudget = 1.0,
    this.maxBudget = 1.0,
    this.currencySymbol = "\$",
    this.isError = false,
  })  : _backgroundPaint = Paint()..color = backgroundColor,
        _usedPaint = Paint()..color = usedColor,
        _availablePaint = Paint()..color = availableColor,
        _markerPaint = Paint()..color = markerColor,
        _errorPaint = Paint()..color = errorColor;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final minHeightBar = height * barRatioTop;
    final maxHeightBar = height * barRatioBottom;
    final heightBar = maxHeightBar - minHeightBar;

    final error = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, minHeightBar, width, heightBar), radius);

    final background = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, minHeightBar, width, heightBar),
      radius,
    );

    final available = RRect.fromRectAndCorners(
        Rect.fromLTWH(0, minHeightBar, width * availablePercentage, heightBar),
        topLeft: radius,
        bottomLeft: radius);

    final used = RRect.fromRectAndCorners(
        Rect.fromLTWH(0, minHeightBar, width * usedPercentage, heightBar),
        topLeft: radius,
        bottomLeft: radius);

    if (isError) {
      canvas.drawRRect(error, _errorPaint);
    } else {
      canvas.drawRRect(background, _backgroundPaint);
      canvas.drawRRect(available, _availablePaint);
      canvas.drawRRect(used, _usedPaint);
    }

    if (usedPercentage > 0 && usedPercentage < 1) {
      canvas.drawLine(Offset(width * usedPercentage, minHeightBar),
          Offset(width * usedPercentage, maxHeightBar), _markerPaint);
    }
    if (availablePercentage > 0 && availablePercentage < 1) {
      canvas.drawLine(Offset(width * availablePercentage, minHeightBar),
          Offset(width * availablePercentage, maxHeightBar), _markerPaint);
    }

    final String text =
        "${usedBudget.toStringAsFixed(2)} / ${availableBudget.toStringAsFixed(2)} $currencySymbol";

    final TextPainter tp = TextPainter()
      ..text = TextSpan(
          text: text,
          style: TextStyle(
            color: centerTextColor,
            fontWeight: FontWeight.bold,
          ))
      ..textDirection = TextDirection.ltr;
    tp.layout();
    tp.paint(canvas, size.center(Offset.zero) - tp.size.center(Offset.zero));

    drawMarker(canvas, size,
        dx: width * usedPercentage,
        dy: minHeightBar,
        barHeight: heightBar,
        amount: usedBudget,
        top: true);
    drawMarker(canvas, size,
        dx: width * availablePercentage,
        dy: minHeightBar,
        barHeight: heightBar,
        amount: availableBudget,
        top: false);
  }

  void drawMarker(
    Canvas canvas,
    Size size, {
    double dx,
    double dy,
    double barHeight,
    double amount,
    bool top,
  }) {
    final String text = "${amount.toStringAsFixed(2)}$currencySymbol";

    final TextPainter tp = TextPainter()
      ..text = TextSpan(text: text, style: const TextStyle(color: Colors.black))
      ..textDirection = TextDirection.ltr;
    tp.layout();

    final double length = tp.size.width + padding * 2;
    final double height = tp.size.height + padding * 2;

    final backgroundPaint = Paint()..color = indicatorBackgroundColor;
    final borderPaint = Paint()..color = indicatorBorderColor;

    var x = dx;
    var y = dy - height / 2 - spaceToMarker;

    if (!top) {
      y = dy + height * 1.5 + spaceToMarker;
    }

    if (x > size.width - length / 2) {
      x = size.width - length / 2;
    } else if (x < length / 2) {
      x = length / 2;
    }

    final backgroundRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          height: height,
          width: length,
        ),
        indicatorRadius);

    final borderRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          height: height + borderWidth * 2,
          width: length + borderWidth * 2,
        ),
        indicatorRadius);

    // Painting
    canvas.drawRRect(borderRect, borderPaint);
    canvas.drawRRect(backgroundRect, backgroundPaint);
    tp.paint(
        canvas, backgroundRect.outerRect.topLeft.translate(padding, padding));
  }

  @override
  bool shouldRepaint(BudgetBarPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(BudgetBarPainter oldDelegate) {
    return true;
  }
}
