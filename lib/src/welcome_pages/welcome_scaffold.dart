import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/main.dart';
import 'package:FineWallet/src/welcome_pages/currency_page.dart';
import 'package:FineWallet/src/welcome_pages/dark_mode_page.dart';
import 'package:FineWallet/src/welcome_pages/finish_page.dart';
import 'package:FineWallet/src/welcome_pages/language_page.dart';
import 'package:FineWallet/src/welcome_pages/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScaffold extends StatelessWidget {
  final Image headerImage;
  final Widget child;
  final void Function() onContinue;
  final void Function() onBack;
  final String pageName;

  const WelcomeScaffold({
    Key key,
    this.headerImage,
    @required this.child,
    @required this.onContinue,
    @required this.onBack,
    @required this.pageName,
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
          if (onContinue != null && !isLastPage)
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  onContinue();
                  Navigator.of(context).push(_continueRoute(pageName));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Continue",
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
                      "Back",
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
                      _createRoute(const MyHomePage(title: 'FineWallet')),
                      (route) => false);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Finish",
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
}
