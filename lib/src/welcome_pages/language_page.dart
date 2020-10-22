import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/src/welcome_pages/welcome_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScaffold(
      pageName: "language",
      onContinue: () {},
      onBack: () {},
      headerImage: Image.asset(
        IMAGES.language,
        height: 150,
        semanticLabel: "Home Currency",
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose your language",
            style: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 8),
          Text(
            "TODO implement internationalization and then this",
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle1
                .copyWith(fontWeight: FontWeight.normal, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
