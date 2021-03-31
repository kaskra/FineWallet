import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/src/add_page/page.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CategoryInput extends StatelessWidget {
  final bool isExpense;
  final Subcategory subcategory;
  final TextEditingController _categoryController;

  final Function(Subcategory) onChanged;

  const CategoryInput({
    Key key,
    @required TextEditingController categoryController,
    @required this.onChanged,
    this.isExpense = true,
    this.subcategory,
  })  : assert(onChanged != null),
        _categoryController = categoryController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RowWrapper(
      child: TextFormField(
        controller: _categoryController,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: LocaleKeys.add_page_category.tr(),
          hintText: LocaleKeys.add_page_choose_category.tr(),
          icon: const Icon(Icons.category),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        readOnly: true,
        onTap: () async => _chooseCategory(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return LocaleKeys.add_page_subcategory_null.tr();
          }
          return null;
        },
      ),
    );
  }

  Future _chooseCategory(BuildContext context) async {
    // Let the user choose a category and subcategory.
    // Returning the Subcategory is enough, because
    // it also holds the category id.
    final Subcategory res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryChoiceDialog(
          isExpense: isExpense,
          selectedSubcategory: subcategory,
        );
      },
    );

    if (res != null) {
      logMsg("Return from Category: $res");
      onChanged(res);
      _categoryController.text = tryTranslatePreset(res);
    }
  }
}
