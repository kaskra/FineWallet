import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/material.dart';

/// This class creates a [Section] which shows the localization
/// settings, like which language and currency should be used etc.
class LocalizationSection extends StatefulWidget {
  @override
  _LocalizationSectionState createState() => _LocalizationSectionState();
}

class _LocalizationSectionState extends State<LocalizationSection> {
  int _selectedCurrency = 1;

  int _selectedLanguage = 2;

  @override
  void initState() {
    setState(() {
      _selectedCurrency = UserSettings.getCurrency();
      _selectedLanguage = UserSettings.getLanguage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Localization",
      children: <SectionItem>[
        _buildLanguage(),
        _buildCurrency(),
      ],
    );
  }

  Widget _buildLanguage() {
    return SectionItem(
      title: "Language (UNUSED)",
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _selectedLanguage,
          isDense: true,
          onChanged: (val) {
            UserSettings.setLanguage(val);
            setState(() {
              _selectedLanguage = val;
            });
          },
          items: [
            DropdownMenuItem(
              child: Text("ENG"),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text("GER"),
              value: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrency() {
    return SectionItem(
      title: "Currency Symbol",
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _selectedCurrency,
          isDense: true,
          onChanged: (val) {
            UserSettings.setCurrency(val);
            setState(() {
              _selectedCurrency = val;
            });
          },
          items: [
            DropdownMenuItem(
              child: Text("\$"),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text("€"),
              value: 2,
            ),
          ],
        ),
      ),
    );
  }
}
