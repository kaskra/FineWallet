/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:25 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/providers/navigation_notifier.dart';
import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/provider_setup.dart';
import 'package:FineWallet/src/add_page/add_page.dart';
import 'package:FineWallet/src/history_page/history.dart';
import 'package:FineWallet/src/overview_page/overview.dart';
import 'package:FineWallet/src/profile_page/profile.dart';
import 'package:FineWallet/src/settings_page/settings_page.dart';
import 'package:FineWallet/src/statistics_page/month_pages.dart';
import 'package:FineWallet/src/widgets/bottom_bar_app_item.dart';
import 'package:FineWallet/src/widgets/sliding_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSettings.init();
  runApp(MultiProvider(
    providers: providers,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FineWallet',
      theme: Provider.of<ThemeNotifier>(context).theme,
      home: MyHomePage(title: 'FineWallet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isSelectionModeActive = false;
  bool _showBottomBar = true;

  Widget _buildBottomBar() {
    return FloatingActionButtonBottomAppBar(
      unselectedColor: Theme.of(context).colorScheme.onSecondary,
      selectedColor: Theme.of(context).colorScheme.onPrimary,
      items: [
        FloatingActionButtonBottomAppBarItem(
            iconData: Icons.person, text: "Me"),
        FloatingActionButtonBottomAppBarItem(
            iconData: Icons.equalizer, text: "Statistics"),
        FloatingActionButtonBottomAppBarItem(disabled: true),
        FloatingActionButtonBottomAppBarItem(
            iconData: Icons.home, text: "Home"),
        FloatingActionButtonBottomAppBarItem(
          iconData: Icons.list,
          text: "History",
        ),
      ],
      onTabSelected: (int index) {
        if (index != Provider.of<NavigationNotifier>(context).page) {
          setState(() {
            _isSelectionModeActive = false;
          });
          Provider.of<NavigationNotifier>(context).setPage(index);
        }
      },
      selectedIndex: Provider.of<NavigationNotifier>(context).page,
      isVisible: _showBottomBar,
    );
  }

  void _addTransaction(int leftRight) {
    if (leftRight == -1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddPage("Income", 0)));
    } else if (leftRight == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddPage("Expense", 1)));
    }
    return;
  }

  void _navCallback(bool showNavBar) {
    setState(() {
      _showBottomBar = showNavBar;
    });
  }

  Widget _buildHistory() {
    return History(
      onChangeSelectionMode: (isSelectionModeOn) {
        setState(() {
          _isSelectionModeActive = isSelectionModeOn;
        });
      },
    );
  }

  Widget _buildDefaultAppBar() => AppBar(
        centerTitle: CENTER_APPBAR,
        elevation: APPBAR_ELEVATION,
        backgroundColor:
            Theme.of(context).primaryColor.withOpacity(APPBAR_OPACITY),
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom >= 50;
    var children = [
      ProfilePage(),
      const StatisticsPage(),
      const SizedBox(),
      const OverviewPage(),
      _buildHistory(),
    ];

    return Scaffold(
      appBar: _isSelectionModeActive ? null : _buildDefaultAppBar(),
      bottomNavigationBar: _buildBottomBar(),
      body: children[Provider.of<NavigationNotifier>(context).page],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: keyboardOpen
          ? SizedBox()
          : SlidingButtonMenu(
              onMenuFunction: _addTransaction,
              tapCallback: _navCallback,
            ),
    );
  }
}
