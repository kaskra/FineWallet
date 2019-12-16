import 'package:FineWallet/src/settings_page/appearance_section.dart';
import 'package:FineWallet/src/settings_page/charts_section.dart';
import 'package:FineWallet/src/settings_page/localization_section.dart';
import 'package:FineWallet/src/settings_page/others_section.dart';
import 'package:FineWallet/src/settings_page/social_section.dart';
import 'package:FineWallet/src/widgets/section.dart';
import 'package:FineWallet/src/widgets/section_title.dart';
import 'package:flutter/material.dart';

/// This class creates a page where the user can edit the application
/// settings in a list of [Section]s.
///
/// Before each section there should be a [SectionTitle] to describe what the
/// user sees in the following section.
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
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
              SectionTitle(text: "Appearance"),
              AppearanceSection(),
              SectionTitle(text: "\n!! BELOW IS NOT USED CURRENTLY !! \n"),
              SectionTitle(text: "Localization"),
              LocalizationSection(),
              SectionTitle(text: "Social"),
              SocialSection(),
              SectionTitle(text: "Charts"),
              ChartsSection(),
              SectionTitle(text: "Other"),
              OthersSection(),
            ],
          ),
        ),
      ),
    );
  }
}
