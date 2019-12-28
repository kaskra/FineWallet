import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/settings_page/localization_pages/language_selection_page.dart';
import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        _buildLanguage2(),
        _buildCurrency(),
      ],
    );
  }

  Widget _buildLanguage2() {
    return SectionItem(
      title: "Language (UNUSED)",
      // TODO write language name in front of arrow (get database here and send snapshot to other page)
      trailing: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LanguageSelectionPage(
                    selectedIndex: UserSettings.getLanguage())));
          },
          child: Icon(
            Icons.keyboard_arrow_right,
          ),
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
            Provider.of<LocalizationNotifier>(context).setCurrencySymbol(val);
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
