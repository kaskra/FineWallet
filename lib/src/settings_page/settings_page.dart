import 'package:FineWallet/src/settings_page/appearance_section.dart';
import 'package:FineWallet/src/settings_page/charts_section.dart';
import 'package:FineWallet/src/settings_page/localization_section.dart';
import 'package:FineWallet/src/settings_page/others_section.dart';
import 'package:FineWallet/src/settings_page/social_section.dart';
import 'package:FineWallet/src/widgets/section_title.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
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

              // default share options
              // etc.
            ],
          ),
        ),
      ),
    );
  }
}
