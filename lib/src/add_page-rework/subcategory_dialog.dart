import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubcategoryDialog extends StatefulWidget {
  SubcategoryDialog({Key key, @required this.category}) : super(key: key);

  final Category category;

  @override
  _SubcategoryDialogState createState() => _SubcategoryDialogState();
}

class _SubcategoryDialogState extends State<SubcategoryDialog> {
  Category _category;

  int _selectedSubcategory = -1;
  Subcategory _subcategory;

  @override
  void initState() {
    if (widget.category != null) {
      _category = widget.category;
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
            Expanded(child: _buildSubcategoryList()),
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
                  Navigator.of(context).pop(_subcategory);
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
          "${_category.name}",
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

  Widget _buildSubcategoryList() {
    return FutureBuilder(
      future: Provider.of<AppDatabase>(context)
          .categoryDao
          .getAllSubcategoriesOf(_category.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
//              TODO implement adding of subcategories
//              _buildAddSubcategoryItem(),
              for (var subs in snapshot.data) _buildSubcategoryListItem(subs)
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _buildSubcategoryListItem(Subcategory sub) {
    return _buildGeneralListItem(
      text: sub.name,
      color: _selectedSubcategory == sub.id
          ? Theme.of(context).colorScheme.secondary
          : Colors.grey,
      onTap: () {
        setState(() {
          _selectedSubcategory = sub.id;
          _subcategory = sub;
        });
      },
    );
  }

  Widget _buildAddSubcategoryItem() {
    return _buildGeneralListItem(
      text: "+",
      color: Theme.of(context).colorScheme.secondary,
      onTap: () {
        print("Add new subcategory !! TODO !!");
      },
    );
  }

  Widget _buildGeneralListItem(
      {@required String text,
      @required Color color,
      @required Function onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        color: color,
        child: Container(
          height: 35,
          child: InkWell(
            onTap: () => onTap(),
            child: Center(
              child: Container(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
