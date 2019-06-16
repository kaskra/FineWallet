/*
 * Developed by Lukas Krauch 16.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.showAppBar: true});

  final bool showAppBar;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildBody() {
    return Center(
      child: Icon(
        Icons.favorite_border,
        size: 80,
        color: Colors.red.shade400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffd8e7ff),
      appBar: widget.showAppBar
          ? AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: _buildBody(),
      ),
    );
  }
}
