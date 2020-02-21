import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListHeaderImage extends StatelessWidget {
  final String svgImage;
  final String semanticsLabel;
  final String subtitle;

  const ListHeaderImage(
      {Key key, this.svgImage, this.subtitle, this.semanticsLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SvgPicture.asset(
              svgImage ?? Images.SAVINGS,
              semanticsLabel: semanticsLabel ?? "",
              height: 140,
            ),
          ),
          Text(
            subtitle ?? "",
            style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
