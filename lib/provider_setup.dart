/*
 * Project: FineWallet
 * Last Modified: Sunday, 22nd September 2019 6:34:36 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider<AppDatabase>(
    create: (_) => AppDatabase(),
    dispose: (_, db) => db.close(),
  ),
  ChangeNotifierProvider<NavigationNotifier>(
    create: (_) => NavigationNotifier(),
  ),
  ChangeNotifierProvider<BudgetNotifier>(
    create: (_) => BudgetNotifier(),
  ),
];

List<SingleChildWidget> dependentServices = [];

List<SingleChildWidget> uiConsumableProviders = [
  ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
  ),
  ChangeNotifierProvider<LocalizationNotifier>(
    create: (_) => LocalizationNotifier(),
  )
];
