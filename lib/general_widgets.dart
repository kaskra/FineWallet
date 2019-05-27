import 'package:flutter/material.dart';
  
Widget generalCard(Widget child, BoxDecoration decoration){
  return Container(
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      color: Colors.white,
      child: Container(
        decoration: decoration,
        padding: EdgeInsets.all(10),
        child: child
      )
    )
  );
}