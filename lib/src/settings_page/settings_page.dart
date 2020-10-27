import 'package:FineWallet/data/exchange_rates.dart';
import 'package:FineWallet/data/extensions/locale_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/src/settings_page/page.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:clean_settings/clean_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'appearance_section.dart';
part 'defaults_section.dart';
part 'others_section.dart';
part 'social_section.dart';
part 'travel_button.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO styling comes with version 0.1.6, add it then
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_page_title.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          _header(),
          AppearanceSection(),
          SocialSection(),
          DefaultsSection(),
          OthersSection(),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TravelButton(),
          _buildUserCurrency(context),
        ],
      ),
    );
  }

  Widget _buildUserCurrency(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Row(
        children: [
          Text("${LocaleKeys.settings_page_home_currency.tr()}: "),
          FutureBuilder<Currency>(
            future:
                Provider.of<AppDatabase>(context).currencyDao.getUserCurrency(),
            builder: (context, snapshot) {
              return Text(
                snapshot.hasData ? snapshot.data.abbrev : "",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
