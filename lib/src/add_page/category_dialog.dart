import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/add_page/subcategory_dialog.dart';
import 'package:flutter/material.dart';
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
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(cardRadius)),
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: <Widget>[
            _buildDialogHeader(),
            Expanded(child: _buildCategoryGrid()),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                padding: const EdgeInsets.all(5),
                textColor: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  if (_isSelectionValid()) {
                    Navigator.of(context).pop(_subcategory);
                  } else {
                    Navigator.of(context).pop(null);
                  }
                },
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
          "Select a category",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            decoration: TextDecoration.none,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            fontFamily: "roboto",
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
            .getAllCategoriesByType(widget.isExpense),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 3,
              children: <Widget>[
//                 TODO enable adding of categories
//                _buildCategoryAddItem(),
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

  /// UNUSED until adding of category/subcategory is implemented
  Widget _buildCategoryAddItem() {
    return _buildGeneralGridItem(
      color: Theme.of(context).colorScheme.secondary,
      onTap: () {
        print("Add new category !! TODO !!");
      },
      text: "Add Category",
      iconData: Icons.add,
    );
  }

  Widget _buildCategoryGridItem(Category c) {
    return _buildGeneralGridItem(
      color: _selectedCategory == c.id
          ? Theme.of(context).colorScheme.secondary
          : Colors.grey,
      onTap: () async {
        final res = await showDialog<Subcategory>(
          context: context,
          builder: (context) => SubcategoryDialog(
            category: c,
            subcategory: _subcategory,
          ),
        );

        if (res != null) {
          print("Result of subcategories: $res");
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
          // Reset state values
          setState(() {
            _selectedCategory = -1;
            _category = null;
            _subcategory = null;
          });
        }
      },
      text: c.name,
      iconData: CategoryIcon(c.id - 1).data,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
}
