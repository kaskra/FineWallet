import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/welcome_pages/welcome_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
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
            LocaleKeys.welcome_pages_welcome_title,
            style: Theme.of(context)
                .primaryTextTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ).tr(),
          const SizedBox(height: 20),
          Text(
            LocaleKeys.welcome_pages_welcome_next_steps.tr(),
            style: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: "${LocaleKeys.welcome_pages_welcome_data_1.tr()} ",
              children: [
                TextSpan(
                    text: LocaleKeys.welcome_pages_welcome_data_bold.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: " ${LocaleKeys.welcome_pages_welcome_data_2.tr()}"),
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
