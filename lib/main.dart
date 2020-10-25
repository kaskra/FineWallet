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
import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/providers/navigation_notifier.dart';
import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/provider_setup.dart';
import 'package:FineWallet/src/add_page/add_page.dart';
import 'package:FineWallet/src/history_page/history_page.dart';
import 'package:FineWallet/src/monthly_reports_page/monthly_reports_page.dart';
import 'package:FineWallet/src/overview_page/overview_page.dart';
import 'package:FineWallet/src/profile_page/profile_page.dart';
import 'package:FineWallet/src/settings_page/settings_page.dart';
import 'package:FineWallet/src/welcome_pages/welcome_page.dart';
import 'package:FineWallet/src/widgets/bottom_bar_app_item.dart';
import 'package:FineWallet/src/widgets/sliding_menu.dart';
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
  bool _isSelectionModeActive = false;
  bool _showBottomBar = true;

  bool _isBudgetLoaded = false;
  bool _isLocalizationLoaded = false;

  Widget _buildBottomBar() {
    return FloatingActionButtonBottomAppBar(
      unselectedColor: Theme.of(context).colorScheme.onSecondary,
      selectedColor: Theme.of(context).colorScheme.onPrimary,
      items: [
        FloatingActionButtonBottomAppBarItem(
            iconData: Icons.person, text: LocaleKeys.nav_me.tr()),
        FloatingActionButtonBottomAppBarItem(
            iconData: Icons.equalizer, text: LocaleKeys.nav_statistics.tr()),
        FloatingActionButtonBottomAppBarItem(disabled: true),
        FloatingActionButtonBottomAppBarItem(
            iconData: Icons.home, text: LocaleKeys.nav_home.tr()),
        FloatingActionButtonBottomAppBarItem(
          iconData: Icons.list,
          text: LocaleKeys.nav_history.tr(),
        ),
      ],
      onTabSelected: (int index) {
        if (index !=
            Provider.of<NavigationNotifier>(context, listen: false).page) {
          setState(() {
            _isSelectionModeActive = false;
          });
          Provider.of<NavigationNotifier>(context, listen: false)
              .setPage(index);
        }
      },
      selectedIndex: Provider.of<NavigationNotifier>(context).page,
      isVisible: _showBottomBar,
    );
  }

  void _addTransaction(int leftRight) {
    if (leftRight == -1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AddPage(isExpense: false)));
    } else if (leftRight == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AddPage(isExpense: true)));
    }
    return;
  }

  void _navCallback(bool showNavBar) {
    setState(() {
      _showBottomBar = showNavBar;
    });
  }

  Widget _buildHistory() {
    return HistoryPage(
      onChangeSelectionMode: (b) {
        setState(() {
          _isSelectionModeActive = b;
        });
      },
      showFilters: UserSettings.getShowFilterSettings(),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          )
        ],
      );

  Future<void> _loadBudget() async {
    setState(() {
      _isBudgetLoaded = true;
    });
    final Month m = await Provider.of<AppDatabase>(context, listen: false)
        .monthDao
        .getCurrentMonth();
    Provider.of<BudgetNotifier>(context, listen: false).setBudget(m?.maxBudget);
  }

  Future _loadLocalizationAndCurrency() async {
    final allCurrencies = await Provider.of<AppDatabase>(context, listen: false)
        .currencyDao
        .getAllCurrencies();

    final currency = await Provider.of<AppDatabase>(context, listen: false)
        .currencyDao
        .getUserCurrency();

    // Load exchange rates and update currency table in database.
    if (currency != null) {
      setState(() {
        _isLocalizationLoaded = true;
      });
      final rates = await fetchExchangeRates(
          currency.abbrev, allCurrencies.map((c) => c.abbrev).toList());

      await Provider.of<AppDatabase>(context, listen: false)
          .currencyDao
          .updateExchangeRates(rates.rates, allCurrencies);

      UserSettings.setInputCurrency(currency.id);
      Provider.of<LocalizationNotifier>(context, listen: false)
          .setUserCurrencySymbol(currency.symbol);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBudgetLoaded) {
      _loadBudget();
    }
    if (!_isLocalizationLoaded) {
      _loadLocalizationAndCurrency();
    }

    final children = [
      const ProfilePage(),
      const MonthlyReportsPage(),
      const SizedBox(),
      const OverviewPage(),
      _buildHistory(),
    ];

    return Scaffold(
      appBar: _isSelectionModeActive ? null : _buildDefaultAppBar(),
      bottomNavigationBar: _buildBottomBar(),
      body: children[Provider.of<NavigationNotifier>(context).page],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom >= 50
          ? const SizedBox()
          : SlidingButtonMenu(
              onMenuFunction: _addTransaction,
              tapCallback: _navCallback,
            ),
    );
  }
}
