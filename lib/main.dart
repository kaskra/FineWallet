/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:25 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/exchange_rates.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/providers.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/provider_setup.dart';
import 'package:FineWallet/src/add_page/page.dart';
import 'package:FineWallet/src/history_page/page.dart';
import 'package:FineWallet/src/monthly_reports_page/page.dart';
import 'package:FineWallet/src/overview_page/page.dart';
import 'package:FineWallet/src/profile_page/page.dart';
import 'package:FineWallet/src/settings_page/page.dart';
import 'package:FineWallet/src/settings_page/settings_page.dart';
import 'package:FineWallet/src/welcome_pages/welcome_page.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await UserSettings.init();
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
      Locale('de'),
    ],
    fallbackLocale: const Locale('en'),
    useOnlyLangCode: true,
    path: 'resources/langs',
    child: MultiProvider(
      providers: providers,
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logMsg("Starting up app.");
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'FineWallet',
      theme: Provider.of<ThemeNotifier>(context).theme,
      routes: {
        "/expense": (context) => const AddPage(isExpense: true),
        "/income": (context) => const AddPage(isExpense: false),
        "/settings": (context) => SettingsPage(),
        "/filter_settings": (context) => const DefaultFilterSettingsPage(),
      },
      home: UserSettings.getInitialized() ? const MyHomePage() : WelcomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showBottomBar = true;
  List<Widget> _children;

  bool _isBudgetLoaded = false;
  bool _isLocalizationLoaded = false;

  Widget _buildBottomBar() {
    return FloatingActionButtonBottomBar(
      unselectedColor: Theme.of(context).colorScheme.onSecondary,
      selectedColor: Theme.of(context).colorScheme.onPrimary,
      items: [
        FloatingActionButtonBottomAppItem(
            iconData: Icons.person, text: LocaleKeys.nav_me.tr()),
        FloatingActionButtonBottomAppItem(
            iconData: Icons.equalizer, text: LocaleKeys.nav_statistics.tr()),
        FloatingActionButtonBottomAppItem(disabled: true),
        FloatingActionButtonBottomAppItem(
            iconData: Icons.home, text: LocaleKeys.nav_home.tr()),
        FloatingActionButtonBottomAppItem(
          iconData: Icons.list,
          text: LocaleKeys.nav_history.tr(),
        ),
      ],
      onTabSelected: (int index) {
        if (index !=
            Provider.of<NavigationNotifier>(context, listen: false).page) {
          Provider.of<SelectionModeNotifier>(context, listen: false)
              .setMode(SelectionMode.off);
          Provider.of<NavigationNotifier>(context, listen: false)
              .setPage(index);
        }
      },
      selectedIndex: Provider.of<NavigationNotifier>(context).page,
      isVisible: _showBottomBar,
    );
  }

  PreferredSizeWidget _buildDefaultAppBar() => AppBar(
        centerTitle: isAppBarCentered,
        elevation: appBarElevation,
        backgroundColor:
            Theme.of(context).primaryColor.withOpacity(appBarOpacity),
        title: const Text("FineWallet"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          )
        ],
      );

  Future _loadBudget() async {
    if (_isBudgetLoaded) return;
    _isBudgetLoaded = true;

    final Month m = await Provider.of<AppDatabase>(context, listen: false)
        .monthDao
        .getCurrentMonth();
    await Provider.of<BudgetNotifier>(context, listen: false)
        .setBudget(m?.maxBudget);
  }

  Future _loadLocalizationAndCurrency() async {
    if (_isLocalizationLoaded) return;

    final allCurrencies = await Provider.of<AppDatabase>(context, listen: false)
        .currencyDao
        .getAllCurrencies();

    final currency = await Provider.of<AppDatabase>(context, listen: false)
        .currencyDao
        .getUserCurrency();

    // Load exchange rates and update currency table in database.
    if (currency != null) {
      _isLocalizationLoaded = true;

      await fetchExchangeRates(
              currency.abbrev, allCurrencies.map((c) => c.abbrev).toList())
          .then((rates) async {
        await Provider.of<AppDatabase>(context, listen: false)
            .currencyDao
            .updateExchangeRates(rates.rates, allCurrencies);
      });

      UserSettings.setInputCurrency(currency.id);
      await Provider.of<LocalizationNotifier>(context, listen: false)
          .setUserCurrencySymbol(currency.symbol);
    }
  }

  void _loadPages() {
    _children = [
      const ProfilePage(),
      const MonthlyReportsPage(),
      const SizedBox(),
      const OverviewPage(),
      HistoryPage(showFilters: UserSettings.getShowFilterSettings()),
    ];
  }

  Future _initStates() async {
    await _loadBudget();
    await _loadLocalizationAndCurrency();
    setState(() {});
    await Future.delayed(const Duration(seconds: 5));
  }

  PreferredSizeWidget _chooseAppBar(BuildContext context) {
    return Provider.of<SelectionModeNotifier>(context).isOn
        ? null
        : _buildDefaultAppBar();
  }

  bool _isInitialized() {
    return _isLocalizationLoaded && _isBudgetLoaded;
  }

  Widget _chooseFloatingActionButton(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom >= 50
        ? const SizedBox()
        : SlidingButtonMenu(
            onMenuFunction: _addTransaction,
            tapCallback: _navCallback,
          );
  }

  SlideTransition transition(
      BuildContext context, Animation<double> animation, Widget child) {
    final direction = Provider.of<NavigationNotifier>(context, listen: false)
        .navigationDirection;
    var begin = 1.0;
    if (direction == NavigationDirection.right) {
      begin = -1.0;
    }

    final offsetAnimation =
        Tween<Offset>(begin: Offset(begin, 0.0), end: const Offset(0.0, 0.0))
            .animate(animation);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  void _addTransaction(int leftRight) {
    if (leftRight == -1) {
      Navigator.pushNamed(context, "/income");
    } else if (leftRight == 1) {
      Navigator.pushNamed(context, "/expense");
    }
  }

  void _navCallback(bool showNavBar) {
    setState(() {
      _showBottomBar = showNavBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadPages();

    return FutureBuilder(
      future: _isInitialized() ? null : _initStates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return Scaffold(
            appBar: _chooseAppBar(context),
            bottomNavigationBar: _buildBottomBar(),
            body: WillPopScope(
              onWillPop: () async {
                Provider.of<NavigationNotifier>(context, listen: false)
                    .goBack();
                return false;
              },
              child: AnimatedSwitcher(
                transitionBuilder: (child, animation) =>
                    transition(context, animation, child),
                duration: const Duration(milliseconds: 150),
                child: _children[Provider.of<NavigationNotifier>(context).page],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _chooseFloatingActionButton(context),
          );
        }
      },
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    Key key,
  }) : super(key: key);

  // TODO animation
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.orange,
      body: Center(child: Icon(Icons.title)),
    );
  }
}
