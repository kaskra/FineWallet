import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/welcome_pages/welcome_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class DarkModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScaffold(
      pageName: "dark_mode",
      onContinue: () {},
      onBack: () {},
      enableContinue: true,
      headerImage: Image.asset(
        IMAGES.darkMode,
        height: 150,
        semanticLabel: "Dark Mode",
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enable Dark Mode",
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              Switch(
                value: UserSettings.getDarkMode(),
                onChanged: (val) async {
                  Provider.of<ThemeNotifier>(context, listen: false)
                      .switchTheme(dark: val);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "You may enable dark mode if it is more relaxing for your eyes.",
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
