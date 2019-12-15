import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:flutter/material.dart';

/// This class is used to create a section in a column that holds
/// a list of [SectionItem]s.
/// A section
///
class Section extends StatelessWidget {
  const Section({Key key, this.children}) : super(key: key);

  final List<SectionItem> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: DecoratedCard(
        borderRadius: BorderRadius.circular(10),
        borderWidth: 0,
        borderColor: Colors.orange,
        padding: 0,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class SectionItem extends StatelessWidget {
  final String title;
  final Widget trailing;

  const SectionItem({
    Key key,
    @required this.title,
    @required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationRow(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      text: Text(title),
      value: trailing,
    );
  }
}
