/*
 * Project: FineWallet
 * Last Modified: Sunday, 22nd September 2019 6:34:36 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/navigation_notifier.dart';
import 'package:FineWallet/src/profile_page/budget_notifier.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildCloneableWidget> independentServices = [
  Provider<AppDatabase>(
    builder: (_) => AppDatabase(),
    dispose: (_, db) => db.close(),
  ),
  ChangeNotifierProvider.value(
    value: NavigationNotifier(),
  ),
];

List<SingleChildCloneableWidget> dependentServices = [];

List<SingleChildCloneableWidget> uiConsumableProviders = [
  ChangeNotifierProvider.value(
    value: BudgetNotifier(),
  ),
];
