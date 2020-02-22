import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:flutter/material.dart';

class ListHeaderImage extends StatelessWidget {
  final String image;
  final String semanticLabel;
  final String subtitle;

  const ListHeaderImage(
      {Key key, this.image, this.subtitle, this.semanticLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Image.asset(
                image ?? Images.SAVINGS,
                semanticLabel: semanticLabel ?? "",
                height: 140,
              ),
            ),
            Text(
              subtitle ?? "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
