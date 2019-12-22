import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/add_page-rework/subcategory_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class is used as a [Dialog] where the user can choose a category
/// as well as a subcategory.
///
/// The categories are displayed in a [GridView], the subcategories in a [ListView].
///
class CategoryChoiceDialog extends StatefulWidget {
  final bool isExpense;
  final int selectedCategory;

  const CategoryChoiceDialog({
    Key key,
    @required this.isExpense,
    this.selectedCategory,
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
    if (widget.selectedCategory != null) {
      _selectedCategory = widget.selectedCategory;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(CARD_RADIUS)),
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
                  Navigator.of(context).pop(true);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(CARD_RADIUS),
          topRight: Radius.circular(CARD_RADIUS),
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

  Widget _buildCategoryAddItem() {
    return _buildGeneralGridItem(
      color: Theme.of(context).colorScheme.secondary,
      onTap: () {
        print("Tapped ADDED!");
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
        setState(() {
          _selectedCategory = c.id;
          _category = c;
        });

        var res = await showDialog(
          context: context,
          child: SubcategoryDialog(
            category: c,
          ),
        );

        if (res != null) {
          print("Result of subcategories: $res");
          setState(() {
            _subcategory = res;
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
            borderRadius: BorderRadius.circular(CARD_RADIUS),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => onTap(),
              child: Container(
                padding: const EdgeInsets.all(7),
                constraints: BoxConstraints.expand(),
                child: Column(
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
