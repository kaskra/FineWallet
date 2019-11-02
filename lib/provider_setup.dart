/*
 * Project: FineWallet
 * Last Modified: Sunday, 22nd September 2019 6:34:36 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/resources/blocs/category_bloc.dart';
import 'package:FineWallet/core/resources/blocs/month_bloc.dart';
import 'package:FineWallet/core/resources/blocs/overview_bloc.dart';
import 'package:FineWallet/core/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/navigation_notifier.dart';
import 'package:FineWallet/src/profile_page/budget_notifier.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildCloneableWidget> independentServices = [
  Provider(
    dispose: (context, bloc) => bloc.dispose(),
    builder: (context) => TransactionBloc(),
  ),
  Provider(
    dispose: (context, bloc) => bloc.dispose(),
    builder: (context) => MonthBloc(),
  ),
  Provider(
    dispose: (context, bloc) => bloc.dispose(),
    builder: (context) => CategoryBloc(),
  ),
  Provider(
    builder: (context) => OverviewBloc(),
    dispose: (context, bloc) => bloc.dispose(),
  ),
  ChangeNotifierProvider.value(
    value: NavigationNotifier(),
  ),
  ChangeNotifierProvider.value(
    value: BudgetNotifier(),
  ),
];

List<SingleChildCloneableWidget> dependentServices = [];

List<SingleChildCloneableWidget> uiConsumableProviders = [];
