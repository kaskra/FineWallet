import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/settings_page/parts/section.dart';
import 'package:FineWallet/src/widgets/simple_pages/selection_page.dart';
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
        _buildLanguage(),
        _buildCurrency(),
      ],
    );
  }

  Widget _buildLanguage() {
    // TODO remove, just placeholders
    Map<int, String> items = Map();
    items.putIfAbsent(1, () => "ENG");
    items.putIfAbsent(2, () => "GER");

    return SectionItem(
      title: "Language (UNUSED)",
      trailing: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            var res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SelectionPage(
                      pageTitle: "Languages",
                      selectedIndex: UserSettings.getLanguage(),
                      data: items,
                    )));
            if (res != null) {
              UserSettings.setLanguage(res);
              setState(() {
                _selectedLanguage = res;
              });
            }
          },
          child: Row(
            children: <Widget>[
              Text(items[_selectedLanguage]),
              Icon(
                Icons.keyboard_arrow_right,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrency() {
    // TODO just placeholders
    // TODO String should be currency abbrev., not symbol
    Map<int, String> items = Map();
    items.putIfAbsent(1, () => "\$");
    items.putIfAbsent(2, () => "€");

    return SectionItem(
      title: "Currency Symbol",
      trailing: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            var res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SelectionPage(
                      pageTitle: "Currencies",
                      selectedIndex: UserSettings.getCurrency(),
                      data: items,
                    )));
            if (res != null) {
              UserSettings.setCurrency(res);
              // TODO get symbol from database and provide it
              Provider.of<LocalizationNotifier>(context, listen: false)
                  .setCurrencySymbol(res);
              setState(() {
                _selectedCurrency = res;
              });
            }
          },
          child: Row(
            children: <Widget>[
              // TODO display name of currency (abbrev) instead of symbol
              Text(items[_selectedCurrency]),
              Icon(
                Icons.keyboard_arrow_right,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
