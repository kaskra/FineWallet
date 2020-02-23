import 'package:FineWallet/src/settings_page/appearance_section.dart';
import 'package:FineWallet/src/settings_page/defaults_section.dart';
import 'package:FineWallet/src/settings_page/localization_section.dart';
import 'package:FineWallet/src/settings_page/others_section.dart';
import 'package:FineWallet/src/settings_page/parts/section.dart';
import 'package:FineWallet/src/settings_page/social_section.dart';
import 'package:flutter/material.dart';

/// This class creates a page where the user can edit the application
/// settings in a list of [Section]s with [SectionTitle].
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppearanceSection(),
              LocalizationSection(),
              SocialSection(),
              DefaultsSection(),
              OthersSection(),
            ],
          ),
        ),
      ),
    );
  }
}
