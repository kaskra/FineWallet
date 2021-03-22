import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/logger.dart';
import 'package:FineWallet/src/add_page/create_dialog.dart';
import 'package:FineWallet/src/add_page/deletion_denial_dialog.dart';
import 'package:FineWallet/src/add_page/page.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' as moor;
import 'package:provider/provider.dart';

/// This class is used as a [Dialog] where the user can choose a category
/// as well as a subcategory.
///
/// The categories are displayed in a [GridView], the subcategories in a [ListView].
///
class CategoryChoiceDialog extends StatefulWidget {
  final bool isExpense;
  final Subcategory selectedSubcategory;

  const CategoryChoiceDialog({
    Key key,
    @required this.isExpense,
    this.selectedSubcategory,
  }) : super(key: key);

  @override
  _CategoryChoiceDialogState createState() => _CategoryChoiceDialogState();
}

class _CategoryChoiceDialogState extends State<CategoryChoiceDialog> {
  int _selectedCategory = -1;
  Subcategory _subcategory;
  Category _category;

  @override
  void initState() {
    if (widget.selectedSubcategory != null) {
      _selectedCategory = widget.selectedSubcategory.categoryId;
      _subcategory = widget.selectedSubcategory;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.1,
        horizontal: MediaQuery.of(context).size.width * 0.1,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDialogHeader(),
            Expanded(child: _buildCategoryGrid()),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(5),
                  primary: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  if (_isSelectionValid()) {
                    Navigator.of(context).pop(_subcategory);
                  } else {
                    Navigator.of(context).pop(null);
                  }
                },
                child: Text(
                  LocaleKeys.ok.tr().toUpperCase(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Checks that the selected category and subcategory fit together
  /// and are valid.
  bool _isSelectionValid() {
    if (_category != null) {
      if (_selectedCategory != null && _selectedCategory != -1) {
        if (_subcategory != null) {
          if (_subcategory.categoryId == _category.id &&
              _subcategory.categoryId == _selectedCategory) {
            return true;
          }
        }
      }
    }
    return false;
  }

  Widget _buildDialogHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(cardRadius),
          topRight: Radius.circular(cardRadius),
        ),
      ),
      height: 50,
      child: Center(
        child: Text(
          LocaleKeys.add_page_select_category.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        decoration: TextDecoration.none,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        fontFamily: "roboto",
      ),
      child: FutureBuilder<List<Category>>(
        future: Provider.of<AppDatabase>(context)
            .categoryDao
            .getAllCategoriesByType(isExpense: widget.isExpense),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 3,
              children: <Widget>[
                _buildCategoryAddItem(),
                for (Category c in snapshot.data) _buildCategoryGridItem(c)
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildCategoryAddItem() {
    return _buildGeneralGridItem(
      color: Colors.grey.shade400,
      onTap: () async {
        await handleNewCategory(context);
      },
      text: LocaleKeys.add_page_add_category_text.tr(),
      iconData: Icons.add,
    );
  }

  Future handleNewCategory(BuildContext context) async {
    final String newCategory = await showDialog(
        context: context,
        builder: (context) => CreateDialog(
              title: LocaleKeys.add_page_add_category_dialog_title.tr(),
            ));
    if (newCategory != null) {
      final category = CategoriesCompanion.insert(
          name: newCategory,
          isExpense: moor.Value(widget.isExpense),
          isPreset: const moor.Value(false));
      Provider.of<AppDatabase>(context, listen: false)
          .categoryDao
          .insertCategory(category);
    }
  }

  Widget _buildCategoryGridItem(Category c) {
    return Stack(
      children: [
        _buildGeneralGridItem(
          color: _selectedCategory == c.id
              ? Theme.of(context).colorScheme.secondary
              : Colors.grey,
          onTap: () async {
            var res = await showDialog<Subcategory>(
              context: context,
              builder: (context) => SubcategoryDialog(
                category: c,
                subcategory: _subcategory,
              ),
            );

            if (res != null) {
              logMsg("Result of subcategories: $res");
              // Set state values
              setState(() {
                _subcategory = res;
                _selectedCategory = c.id;
                _category = c;
              });

              if (_isSelectionValid()) {
                Navigator.of(context).pop(_subcategory);
              }
            } else {
              if (_subcategory != null) {
                logMsg(
                    "Returned from subcategory dialog without choosing. Do not change selected subcategory.");
                res = _subcategory;
              } else {
                // Reset state values
                setState(() {
                  _selectedCategory = -1;
                  _category = null;
                  _subcategory = null;
                });
              }
            }
          },
          text: tryTranslatePreset(c),
          iconData: CategoryIcon(c.id - 1).data,
        ),
        if (!c.isPreset)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.red),
              child: InkWell(
                onTap: () async {
                  await deleteSubcategory(c);
                },
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGeneralGridItem(
      {@required Color color,
      @required Function onTap,
      @required String text,
      @required IconData iconData}) {
    return GridTile(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(7),
          child: Material(
            color: color,
            borderRadius: BorderRadius.circular(cardRadius),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => onTap(),
              child: Container(
                padding: const EdgeInsets.all(7),
                constraints: const BoxConstraints.expand(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      iconData,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        text,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future deleteSubcategory(Category category) async {
    final bool deleteCategory = await showConfirmDialog(
      context,
      LocaleKeys.add_page_category_delete_confirm_title.tr(),
      LocaleKeys.add_page_category_delete_confirm_text.tr(),
    );

    if (deleteCategory) {
      try {
        logMsg("Attempt to delete category $category");
        await removeCategoryFromDatabase(category);
      } catch (e) {
        logMsg("Could not delete category.");
        logMsg("Error: $e");
        showDeletionDenialDialog();
      }
    }
  }

  void showDeletionDenialDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeletionDenialDialog(
          denialTitle: LocaleKeys.add_page_category_alert_title.tr(),
          denialText: LocaleKeys.add_page_category_alert_text.tr(),
        );
      },
    );
  }

  Future removeCategoryFromDatabase(Category category) async {
    await Provider.of<AppDatabase>(context, listen: false)
        .categoryDao
        .deleteCategoryWithSubcategories(category.id);

    if (_subcategory.categoryId == category.id) {
      setState(() {
        _selectedCategory = -1;
        _category = null;
        _subcategory = null;
      });
    } else {
      setState(() {});
    }
  }
}
