import 'package:FineWallet/data/exchange_rates.dart';
import 'package:FineWallet/data/extensions/locale_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/theme_notifier.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/src/settings_page/page.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'appearance_section.dart';
part 'defaults_section.dart';
part 'others_section.dart';
part 'social_section.dart';
part 'travel_button.dart';

/// This class creates a page where the user can edit the application
/// settings in a list of [Section]s with [SectionTitle].
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TravelButton(),
              _buildUserCurrency(context),
              AppearanceSection(),
              SocialSection(),
              DefaultsSection(),
              OthersSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCurrency(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
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
