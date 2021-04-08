import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/welcome_pages/welcome_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class StartingSavingsPage extends StatefulWidget {
  @override
  _StartingSavingsPageState createState() => _StartingSavingsPageState();
}

class _StartingSavingsPageState extends State<StartingSavingsPage> {
  final TextEditingController _controller = TextEditingController();

  bool _initialized = false;

  String _suffixSymbol = "";
  UserProfile _userProfile;

  Future _loadSuffixSymbol() async {
    final userProfile =
        await Provider.of<AppDatabase>(context, listen: false).getUserProfile();

    final currency = await Provider.of<AppDatabase>(context, listen: false)
        .currencyDao
        .getCurrencyById(userProfile.currencyId);

    print(userProfile);
    setState(() {
      _userProfile = userProfile;
      _controller.text = _userProfile.startingSavings.toStringAsFixed(2);
      _suffixSymbol = currency.symbol;
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _loadSuffixSymbol();
    }

    return WelcomeScaffold(
      pageName: "starting_savings",
      onContinue: () async {
        await _validateAndSend(_controller.text);
      },
      onBack: () {},
      confirmContinue: () => _validate(_controller.text),
      enableContinue: true,
      headerImage: Image.asset(
        IMAGES.darkMode,
        height: 150,
        semanticLabel: "Starting Savings",
      ),
      child: _applyInputTheme(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Enter your savings",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Here you can enter your starting savings.",
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle2
                  .copyWith(fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 24,
            ),
            _numberField(),
          ],
        ),
      ),
    );
  }

  Theme _applyInputTheme(Widget child) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(left: 12, right: 12),
          filled: true,
          fillColor: const Color(0x0a000000),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground)),
          labelStyle:
              TextStyle(color: Theme.of(context).colorScheme.onBackground),
          suffixStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
          errorStyle: const TextStyle(fontSize: 11),
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyText2.color.withOpacity(0.6),
          ),
        ),
      ),
      child: child,
    );
  }

  Widget _numberField() {
    return TextFormField(
      controller: _controller,
      textAlign: TextAlign.right,
      textInputAction: TextInputAction.done,
      enableInteractiveSelection: false,
      enableSuggestions: false,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        suffixText: _suffixSymbol,
        labelText: LocaleKeys.add_page_amount.tr(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        filled: true,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null ||
            double.tryParse(value.replaceAll(",", ".")) == null) {
          return LocaleKeys.add_page_not_a_number.tr();
        }
        return null;
      },
      autocorrect: false,
      onTap: () {
        _controller.selection =
            TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      },
    );
  }

  Future<bool> _validate(String text) {
    return Future.value(
        text != null && double.tryParse(text.replaceAll(",", ".")) != null);
  }

  Future<bool> _validateAndSend(String text) async {
    final res = double.tryParse(text.replaceAll(",", "."));
    if (res != null) {
      final updatedUserProfile =
          _userProfile.copyWith(startingSavings: res).toCompanion(false);
      await Provider.of<AppDatabase>(context, listen: false)
          .upsertUserProfile(updatedUserProfile);
      return true;
    } else {
      return false;
    }
  }
}
