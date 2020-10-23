import 'package:FineWallet/data/exchange_rates.dart';
import 'package:FineWallet/data/moor_database.dart';
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
      _selectedCurrency = UserSettings.getInputCurrency();
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

  SectionItem _buildLanguage() {
    // TODO remove, just placeholders
    final items = <int, String>{};
    items.putIfAbsent(1, () => "ENG");
    items.putIfAbsent(2, () => "GER");

    return SectionItem(
      title: "Language (UNUSED)",
      trailing: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final int res = await Navigator.of(context).push(MaterialPageRoute(
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

  SectionItem _buildCurrency() {
    return SectionItem(
      title: "Input Currency",
      trailing: FutureBuilder<List<Currency>>(
          future:
              Provider.of<AppDatabase>(context).currencyDao.getAllCurrencies(),
          builder: (context, snapshot) {
            final items = <int, String>{};
            final currencies = <Currency>[];

            if (snapshot.hasData) {
              items.addEntries(
                  snapshot.data.map((c) => MapEntry(c.id, c.abbrev)));
              currencies.addAll(snapshot.data);
            }

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final int res = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectionPage(
                        pageTitle: "Currencies",
                        selectedIndex: UserSettings.getInputCurrency(),
                        data: items,
                      ),
                    ),
                  );
                  if (res != null) {
                    final currency = snapshot.data[res - 1];
                    if (currency != null) {
                      UserSettings.setInputCurrency(res);
                      _updateExchangeRates(currencies);
                      setState(() {
                        _selectedCurrency = res;
                      });
                    }
                  }
                },
                child: snapshot.hasData
                    ? Row(
                        children: <Widget>[
                          Text(items[_selectedCurrency]),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ],
                      )
                    : const Text("Loading..."),
              ),
            );
          }),
    );
  }

  Future _updateExchangeRates(List<Currency> allCurrencies) async {
    final currency = await Provider.of<AppDatabase>(context, listen: false)
        .currencyDao
        .getUserCurrency();

    // Load exchange rates and update currency table in database.
    final rates = await fetchExchangeRates(
        currency.abbrev, allCurrencies.map((c) => c.abbrev).toList());

    await Provider.of<AppDatabase>(context, listen: false)
        .currencyDao
        .updateExchangeRates(rates.rates, allCurrencies);
  }
}
