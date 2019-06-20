/*
 * Developed by Lukas Krauch 20.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:finewallet/main.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Overview boxes', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final overviewBoxFinder = find.widgetWithText(Row, "0.00€");
    expect(overviewBoxFinder, findsNWidgets(9));

    final todayCard = find.widgetWithText(Row, "TODAY");

    expect(todayCard, findsOneWidget);
  });

  test('Get month name', () {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    for (int i = 1; i < 13; i++) {
      var name = getMonthName(i);
      expect(months[i - 1], name);
    }
  });

  testWidgets('Open statistics', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    var name = getMonthName(DateTime.now().month).toUpperCase();
    var statisticsBox = find.widgetWithText(InkWell, name);

    expect(statisticsBox, findsOneWidget);

//    await tester.tap(statisticsBox);
//    await tester.pump();
//
//    print(tester.allElements);
//
//    var charts = find.byType(MonthlyOverview);
//
//    expect(charts, findsOneWidget);
  });
}
