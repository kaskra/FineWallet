part of 'settings_page.dart';

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
                  pageTitle: LocaleKeys.settings_page_currencies.tr(),
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
                    ..showSnackBar(SnackBar(
                      content:
                          Text(LocaleKeys.settings_page_snack_at_home.tr()),
                    ));
                } else {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text(LocaleKeys.settings_page_snack_traveling
                          .tr(args: [items[_selectedCurrency]])),
                    ));
                }
              }
            }
          },
          icon: Icon(
            Icons.airplanemode_active,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: (_userCurrencyId == _selectedCurrency)
              ? LocaleKeys.settings_page_travel.tr()
              : LocaleKeys.settings_page_while_travel
                  .tr(args: [currencyString]),
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
