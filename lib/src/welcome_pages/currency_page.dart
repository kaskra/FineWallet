import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/src/welcome_pages/welcome_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moor/moor.dart' hide Column;
import 'package:provider/provider.dart';

class CurrencyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScaffold(
      pageName: "currency",
      onContinue: () {},
      onBack: () {},
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
                  "Choose your home currency",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ),
              Expanded(
                child: OutlineButton(
                  borderSide: BorderSide(
                      color:
                          Theme.of(context).primaryTextTheme.subtitle2.color),
                  padding: const EdgeInsets.all(0),
                  onPressed: () async {
                    final Currency selectedCurrency = await showDialog(
                        context: context,
                        builder: (context) => CurrencySelectionDialog());
                    if (selectedCurrency != null) {
                      await Provider.of<AppDatabase>(context, listen: false)
                          .addUserProfile(UserProfilesCompanion(
                        id: const Value<int>(1),
                        currencyId: Value<int>(selectedCurrency.id),
                      ));
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
            "Warning! You cannot change your home currency later on!",
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.normal),
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
                    title: Center(child: Text(currency.abbrev)),
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
