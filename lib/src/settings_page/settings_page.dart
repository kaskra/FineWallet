import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/settings_page/appearance_section.dart';
import 'package:FineWallet/src/settings_page/defaults_section.dart';
import 'package:FineWallet/src/settings_page/others_section.dart';
import 'package:FineWallet/src/settings_page/parts/section.dart';
import 'package:FineWallet/src/settings_page/social_section.dart';
import 'package:FineWallet/src/settings_page/travel_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class creates a page where the user can edit the application
/// settings in a list of [Section]s with [SectionTitle].
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
          const Text("Your home currency: "),
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
