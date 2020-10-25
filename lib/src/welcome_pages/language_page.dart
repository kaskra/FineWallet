import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/welcome_pages/welcome_scaffold.dart';
import 'package:FineWallet/src/widgets/standalone/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScaffold(
      pageName: "language",
      onContinue: null,
      confirmContinue: () async {
        return showConfirmDialog(
          context,
          LocaleKeys.welcome_pages_language_confirm_title.tr(),
          LocaleKeys.welcome_pages_language_confirm_text.tr(),
        );
      },
      onBack: () {},
      enableContinue: true,
      headerImage: Image.asset(
        IMAGES.language,
        height: 150,
        semanticLabel: LocaleKeys.welcome_pages_language_semantic_label.tr(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.welcome_pages_language_title.tr(),
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
                    final Locale selectedLocale = await showDialog(
                        context: context,
                        builder: (context) => LanguageSelectionDialog());

                    if (selectedLocale != null) {
                      EasyLocalization.of(context).locale = selectedLocale;
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        // TODO get nicer string by extension?
                        context.locale.toString(),
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
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
            LocaleKeys.welcome_pages_language_text.tr(),
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.welcome_pages_language_warning.tr(),
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

class LanguageSelectionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locales = context.supportedLocales;

    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView.separated(
          itemCount: locales.length,
          separatorBuilder: (_, index) =>
              const Divider(indent: 24, endIndent: 24, height: 1),
          itemBuilder: (context, index) {
            final locale = locales[index];
            return ListTile(
                visualDensity: VisualDensity.compact,
                title: Center(child: Text(locale.toString())),
                onTap: () {
                  Navigator.of(context).pop(locale);
                });
          },
        ),
      ),
    );
  }
}
