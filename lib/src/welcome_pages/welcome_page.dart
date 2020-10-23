import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/src/welcome_pages/welcome_scaffold.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScaffold(
      pageName: "welcome",
      enableContinue: true,
      headerImage: Image.asset(
        IMAGES.welcome,
        height: 150,
        semanticLabel: "Welcome",
      ),
      onContinue: () {},
      onBack: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to FineWallet!",
            style: Theme.of(context)
                .primaryTextTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            "In the next steps you will personalize the app to your liking.",
            style: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: "All of your data is saved ",
              children: const [
                TextSpan(
                    text: "only",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " on your device."),
              ],
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle2
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
