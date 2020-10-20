import 'package:flutter/material.dart';

/// Creates an image to be placed as the first element in a [ListView] or
/// scrollable [Column].
///
class ListHeaderImage extends StatelessWidget {
  final String image;
  final String semanticLabel;
  final String subtitle;
  final double height;

  const ListHeaderImage({
    Key key,
    this.image,
    this.subtitle,
    this.semanticLabel,
    this.height = 140,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image != null
        ? Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image.asset(
                      image,
                      semanticLabel: semanticLabel ?? "",
                      height: height,
                    ),
                  ),
                  Text(
                    subtitle ?? "",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
