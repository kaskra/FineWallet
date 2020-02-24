/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:39 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:FineWallet/main.dart';
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
}
