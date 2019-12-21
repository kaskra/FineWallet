import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// This class creates a [Divider] that is used to divide the row
/// parent from its children.
class RowChildDivider extends StatelessWidget {
  const RowChildDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: 20,
      endIndent: 15,
      thickness: 0.2,
      height: 1,
    );
  }
}

/// This class is used to create a specific [Text] widget right above the row.
class RowTitle extends StatelessWidget {
  const RowTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48),
      child: Text(
        title,
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}

class EditableNumericInputText extends StatefulWidget {
  final double defaultValue;

  final Function(double) onChanged;
  final Function(bool) onError;

  const EditableNumericInputText({
    Key key,
    this.defaultValue = 0.0,
    @required this.onChanged,
    this.onError,
  }) : super(key: key);

  @override
  _EditableNumericInputTextState createState() =>
      _EditableNumericInputTextState();
}

class _EditableNumericInputTextState extends State<EditableNumericInputText> {
  TextEditingController _controller;

  bool _foundError = false;

  @override
  void initState() {
    if (widget.defaultValue != null) {
      _controller = TextEditingController.fromValue(
          TextEditingValue(text: widget.defaultValue.toStringAsFixed(2)));
    } else {
      _controller = TextEditingController();
    }
    _controller.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _foundError ? Colors.red.withOpacity(0.8) : Colors.transparent,
      ),
      child: TextFormField(
        textAlign: TextAlign.right,
        textInputAction: TextInputAction.done,
        enableInteractiveSelection: false,
        enableSuggestions: false,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          suffixStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
          suffixText: Provider.of<LocalizationNotifier>(context).currency,
        ),
        onChanged: (value) {
          var res = double.tryParse(value);
          setState(() {
            _foundError = (res == null);
          });
          if (widget.onError != null) {
            widget.onError(_foundError);
          }
        },
        onFieldSubmitted: (value) {
          _validateAndSend(value);
        },
        onSaved: (value) {
          _validateAndSend(value);
        },
        maxLines: 1,
        autofocus: true,
        autocorrect: false,
      ),
    );
  }

  void _validateAndSend(String text) {
    if (widget.onChanged != null) {
      var res = double.tryParse(text);
      if (res == null) {
        setState(() {
          _foundError = true;
        });
      } else {
        setState(() {
          _foundError = false;
        });
        widget.onChanged(res);
        if (widget.onError != null) {
          widget.onError(_foundError);
        }
      }
    }
  }
}

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
    return GridTile(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CARD_RADIUS),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(CARD_RADIUS),
            clipBehavior: Clip.hardEdge,
            color: Theme.of(context).colorScheme.secondary,
            child: InkWell(
              onTap: () {
                print("Tapped ADDING");
              },
              child: Container(
                padding: const EdgeInsets.all(7),
                constraints: BoxConstraints.expand(),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      size: 30,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Add Category",
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

  Widget _buildCategoryGridItem(Category c) {
    return GridTile(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(7),
          child: Material(
            color: _selectedCategory == c.id
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey,
            borderRadius: BorderRadius.circular(CARD_RADIUS),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () {
                print("Tapped ${c.name}");
                setState(() {
                  _selectedCategory = c.id;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(7),
                constraints: BoxConstraints.expand(),
                child: Column(
                  children: <Widget>[
                    Icon(
                      CategoryIcon(c.id - 1).data,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        c.name,
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
