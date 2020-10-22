import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/src/welcome_pages/welcome_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FinishPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScaffold(
      pageName: "finish",
      onContinue: null,
      onBack: () {},
      headerImage: Image.asset(
        IMAGES.done,
        height: 150,
        semanticLabel: "Done",
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You have successfully set up your FineWallet profile!",
            style: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 20),
          Text(
            "Good luck and have fun saving your money!",
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle1
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
