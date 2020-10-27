import 'dart:async';

import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/main.dart';
import 'package:FineWallet/src/welcome_pages/pages.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScaffold extends StatelessWidget {
  final Image headerImage;
  final Widget child;
  final void Function() onContinue;
  final void Function() onBack;
  final bool enableContinue;
  final Future<bool> Function() confirmContinue;
  final String pageName;

  const WelcomeScaffold({
    Key key,
    this.headerImage,
    @required this.child,
    @required this.onContinue,
    @required this.onBack,
    @required this.pageName,
    this.enableContinue = false,
    this.confirmContinue,
  })  : assert(pageName != null),
        assert(child != null),
        super(key: key);

  Map<String, Route> get _routes => {
        "welcome": _createRoute(WelcomePage()),
        "dark_mode": _createRoute(DarkModePage()),
        "currency": _createRoute(CurrencyPage()),
        "language": _createRoute(LanguagePage()),
        "finish": _createRoute(FinishPage()),
      };

  Map<String, String> get _welcomeChain => {
        "welcome": "language",
        "language": "currency",
        "currency": "dark_mode",
        "dark_mode": "finish",
      };

  Route _continueRoute(String currentPage) =>
      _welcomeChain.containsKey(currentPage)
          ? _routes[_welcomeChain[currentPage]]
          : MaterialPageRoute(builder: null);

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = !_welcomeChain.containsKey(pageName);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _backdropCircle(context),
          Center(
            child: Align(
              alignment: const Alignment(0, -1 / 3),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    headerImage,
                    const SizedBox(height: 60),
                    child,
                  ],
                ),
              ),
            ),
          ),
          if ((onContinue != null || confirmContinue != null) &&
              !isLastPage &&
              enableContinue)
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () async {
                  var continueAvailable = false;
                  if (confirmContinue != null) {
                    continueAvailable = await confirmContinue();
                  } else {
                    continueAvailable = true;
                    onContinue();
                  }
                  if (continueAvailable) {
                    Navigator.of(context).push(_continueRoute(pageName));
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.continueText.tr(),
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_right,
                      color: Theme.of(context).primaryTextTheme.subtitle2.color,
                    ),
                  ],
                ),
              ),
            ),
          if (onBack != null)
            Align(
              alignment: Alignment.bottomLeft,
              child: FlatButton(
                onPressed: () {
                  onBack();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_left,
                      color: Theme.of(context).primaryTextTheme.subtitle2.color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      LocaleKeys.backText.tr(),
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ),
          if (isLastPage)
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  UserSettings.setInitialized(val: true);
                  Navigator.of(context).pushAndRemoveUntil(
                      _createRoute(const MyHomePage()), (route) => false);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.doneText.tr(),
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.check_sharp,
                      size: 18,
                      color: Theme.of(context).primaryTextTheme.subtitle2.color,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Route _createRoute(Widget target) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) => target,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(
          CurveTween(curve: Curves.ease),
        );

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  Widget _backdropCircle(BuildContext context) {
    const double radius = 770;
    final double dx = MediaQuery.of(context).size.width - radius / 2;
    final double dy = MediaQuery.of(context).size.height - radius / 2;

    return Positioned(
      left: dx,
      top: dy,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).accentColor.withOpacity(0.2)),
        width: radius,
        height: radius,
      ),
    );
  }
}
