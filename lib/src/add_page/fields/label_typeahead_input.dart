import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/add_page/page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class LabelTypeAheadInput extends StatelessWidget {
  const LabelTypeAheadInput({
    Key key,
    @required this.isExpense,
    @required TextEditingController labelController,
    this.inputDecoration,
    this.focusNode,
  })  : _labelController = labelController,
        super(key: key);

  final bool isExpense;
  final TextEditingController _labelController;
  final InputDecoration inputDecoration;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Provider.of<AppDatabase>(context, listen: false)
          .transactionDao
          .getTransactionsLabels(isExpense: isExpense),
      builder: (context, snapshot) => RowWrapper(
        child: TypeAheadFormField<String>(
          noItemsFoundBuilder: (context) => ListTile(
            dense: true,
            title: Text(LocaleKeys.add_page_no_suggestions.tr()),
          ),
          textFieldConfiguration: TextFieldConfiguration(
            focusNode: focusNode ?? FocusNode(),
            controller: _labelController,
            textAlign: TextAlign.right,
            textInputAction: TextInputAction.done,
            maxLength: 30,
            // Fix for duplicating text when receiving focus from somewhere else
            keyboardType: TextInputType.visiblePassword,
            decoration: inputDecoration ??
                InputDecoration(
                  counterText: "",
                  labelText: LocaleKeys.add_page_label.tr(),
                  hintText: LocaleKeys.add_page_choose_label.tr(),
                  icon: const Icon(Icons.label_important),
                ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null) {
              return LocaleKeys.add_page_no_label.tr();
            }
            return null;
          },
          suggestionsCallback: (pattern) {
            final items = snapshot.data ?? [];
            return items.where((element) => element.contains(pattern));
          },
          itemBuilder: (context, suggestion) {
            return ListTile(title: Text(suggestion), dense: true);
          },
          onSuggestionSelected: (suggestion) {
            _labelController.text = suggestion;
          },
          onSaved: (suggestion) {
            _labelController.text = suggestion;
          },
        ),
      ),
    );
  }
}
