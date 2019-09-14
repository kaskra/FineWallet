import 'package:FineWallet/resources/blocs/category_bloc.dart';
import 'package:FineWallet/resources/blocs/month_bloc.dart';
import 'package:FineWallet/resources/blocs/transaction_bloc.dart';
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
];

List<SingleChildCloneableWidget> dependentServices = [];

List<SingleChildCloneableWidget> uiConsumableProviders = [];
