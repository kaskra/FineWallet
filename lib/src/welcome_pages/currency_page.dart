import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/welcome_pages/welcome_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moor/moor.dart' hide Column;
import 'package:provider/provider.dart';

class CurrencyPage extends StatefulWidget {
  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  bool _selectedCurrency = false;

  bool _initialized = false;

  Future getUserCurrency() async {
    final currency =
        await Provider.of<AppDatabase>(context).currencyDao.getUserCurrency();
    if (currency != null) {
      setState(() {
        _selectedCurrency = true;
        _initialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      getUserCurrency();
    }

    return WelcomeScaffold(
      pageName: "currency",
      onContinue: () {},
      onBack: () {},
      enableContinue: _selectedCurrency,
      headerImage: Image.asset(
        IMAGES.savings,
        height: 150,
        semanticLabel: "Home Currency",
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  LocaleKeys.welcome_pages_currency_title.tr(),
                  style: Theme.of(context)
                      .primaryTextTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color:
                            Theme.of(context).primaryTextTheme.subtitle2.color),
                    padding: const EdgeInsets.all(0),
                  ),
                  onPressed: () async {
                    final Currency selectedCurrency = await showDialog(
                        context: context,
                        builder: (context) => CurrencySelectionDialog());

                    if (selectedCurrency != null) {
                      await Provider.of<AppDatabase>(context, listen: false)
                          .upsertUserProfile(UserProfilesCompanion(
                        id: const Value<int>(1),
                        currencyId: Value<int>(selectedCurrency.id),
                      ));

                      setState(() {
                        _selectedCurrency = true;
                      });
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StreamBuilder(
                          stream: Provider.of<AppDatabase>(context)
                              .currencyDao
                              .watchUserCurrency(),
                          builder: (context, AsyncSnapshot<Currency> snapshot) {
                            final currencyString =
                                snapshot.hasData ? snapshot.data.abbrev : "";

                            return Text(
                              currencyString,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .copyWith(fontWeight: FontWeight.normal),
                            );
                          }),
                      Icon(
                        Icons.chevron_right,
                        color:
                            Theme.of(context).primaryTextTheme.subtitle2.color,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.welcome_pages_currency_text.tr(),
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.welcome_pages_currency_warning.tr(),
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.normal, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class CurrencySelectionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: FutureBuilder(
          future:
              Provider.of<AppDatabase>(context).currencyDao.getAllCurrencies(),
          builder: (context, AsyncSnapshot<List<Currency>> snapshot) {
            List<Currency> currencies = [];
            if (snapshot.hasData) {
              currencies = snapshot.data;
            }

            return ListView.separated(
              itemCount: currencies.length,
              separatorBuilder: (_, index) =>
                  const Divider(indent: 24, endIndent: 24, height: 1),
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return ListTile(
                    visualDensity: VisualDensity.compact,
                    title: Center(
                        child: Text("${currency.abbrev} (${currency.symbol})")),
                    onTap: () {
                      Navigator.of(context).pop(currency);
                    });
              },
            );
          },
        ),
      ),
    );
  }
}
