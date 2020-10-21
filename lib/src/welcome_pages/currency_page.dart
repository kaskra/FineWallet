import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/src/welcome_pages/welcome_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CurrencyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScaffold(
      pageName: "currency",
      onContinue: () {},
      onBack: () {},
      headerImage: Image.asset(
        IMAGES.savings,
        height: 150,
        semanticLabel: "Home Currency",
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose your home currency",
            style: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 8),
          Text(
            "Warning! You cannot change your home currency later on!",
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
