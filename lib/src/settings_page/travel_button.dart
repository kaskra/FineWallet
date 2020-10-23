import 'package:FineWallet/data/exchange_rates.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/settings_page/parts/section.dart';
import 'package:FineWallet/src/settings_page/parts/section_button.dart';
import 'package:FineWallet/src/widgets/simple_pages/selection_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class creates a [Section] which shows the localization
/// settings, like which language and currency should be used etc.
class TravelButton extends StatefulWidget {
  @override
  _TravelButtonState createState() => _TravelButtonState();
}

class _TravelButtonState extends State<TravelButton> {
  int _selectedCurrency = 1;

  int _userCurrencyId = 1;

  Future initializeUserCurrency() async {
    _userCurrencyId = (await Provider.of<AppDatabase>(context, listen: false)
            .currencyDao
            .getUserCurrency())
        ?.id;
  }

  @override
  void initState() {
    initializeUserCurrency();
    setState(() {
      _selectedCurrency = UserSettings.getInputCurrency();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Currency>>(
      future: Provider.of<AppDatabase>(context).currencyDao.getAllCurrencies(),
      builder: (context, snapshot) {
        final items = <int, String>{};
        final currencies = <Currency>[];

        if (snapshot.hasData) {
          items.addEntries(snapshot.data.map((c) => MapEntry(c.id, c.abbrev)));
          currencies.addAll(snapshot.data);
        }

        final currencyString = snapshot.hasData ? items[_selectedCurrency] : "";

        return SectionButton(
          onPressed: () async {
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
                if (_selectedCurrency == _userCurrencyId) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text(
                          "You are now using your home currency as your input currency."),
                    ));
                } else {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text(
                          "You are now using $currencyString as your input currency. "
                          "Every transaction will be converted to your home currency."),
                    ));
                }
              }
            }
          },
          icon: Icon(
            Icons.airplanemode_active,
            color: Theme.of(context).textTheme.button.color,
          ),
          label: (_userCurrencyId == _selectedCurrency)
              ? "Travel to other currency area"
              : "Traveling using $currencyString",
        );
      },
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
