import 'package:FineWallet/core/resources/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_sqflite_manager/flutter_sqflite_manager.dart';

class DBPage extends StatefulWidget {
  final Widget child;
  DBPage({Key key, @required this.child}) : super(key: key);

  _DBPageState createState() => _DBPageState();
}

class _DBPageState extends State<DBPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      future: DatabaseProvider.db.database,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SqfliteManager(
            child: widget.child,
            database: snapshot.data,
            enable: true,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
