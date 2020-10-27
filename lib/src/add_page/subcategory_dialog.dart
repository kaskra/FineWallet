import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/widgets/standalone/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubcategoryDialog extends StatefulWidget {
  const SubcategoryDialog({Key key, @required this.category, this.subcategory})
      : super(key: key);

  final Category category;
  final Subcategory subcategory;

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
    if (widget.subcategory != null) {
      _selectedSubcategory = widget.subcategory.id;
      _subcategory = widget.subcategory;
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
            Expanded(child: _buildSubcategoryList()),

            //children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    padding: const EdgeInsets.all(5),
                    //textColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      final String addNewSubcategory = await showDialog(
                          context: context,
                          builder: (context) => CreateSubcategoryDialog());
                          final subcategory = SubcategoriesCompanion.insert(categoryId: _category.id, name: addNewSubcategory);
                          Provider.of<AppDatabase>(context, listen: false ).categoryDao.insertSubcategory(subcategory);
                    },
                    child: Icon(Icons.add),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    padding: const EdgeInsets.all(5),
                    textColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      Navigator.of(context).pop(_subcategory);
                    },
                    child: const Text(
                      "OK",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            //  ],
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
          topLeft: Radius.circular(cardRadius),
          topRight: Radius.circular(cardRadius),
        ),
      ),
      height: 50,
      child: Center(
        child: Text(
          _category.name,
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
      builder: (context, AsyncSnapshot<List<Subcategory>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              for (var subs in snapshot.data) _buildSubcategoryListItem(subs)
            ],
          );
        } else {
          return const SizedBox();
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


  Widget _buildGeneralListItem(
      {@required String text,
      @required Color color,
      @required Function onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        color: color,
        child: SizedBox(
          height: 35,
          child: InkWell(
            onTap: () => onTap(),
            child: Stack(
              children: [
                // TODO
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton (
                        icon : Icon(Icons.remove),
                        color: Theme.of(context).colorScheme.onSurface,
                        onPressed: () async {
                          final bool deleteSubcategory = await showConfirmDialog(context, "Delete this subcategory?", "This will delete the subcategory.");
                        }
                      ),
                    ),
               // )
                //
                Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateSubcategoryDialog extends StatelessWidget {
  TextEditingController _addSubcategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add new subcategory',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            //schreibfeld
            TextField(
              controller: _addSubcategoryController,
              keyboardType: TextInputType.text,
              autofocus: true,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
            ),
            const SizedBox(
              height: 16,
            ),
            //Button
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                textColor: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  Navigator.of(context).pop(_addSubcategoryController.text.trim());
                },
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


