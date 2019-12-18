import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:FineWallet/src/widgets/section_title.dart';
import 'package:flutter/material.dart';

/// This class is used to create a section in a column that holds
/// a list of [SectionItem]s.
/// A section is used to group rows of information together under
/// one [SectionTitle].
class Section extends StatelessWidget {
  const Section({Key key, this.children, this.title}) : super(key: key);

  final List<SectionItem> children;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionTitle(text: title),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: DecoratedCard(
            padding: 0,
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
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

class SectionItemDivider extends SectionItem {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 2,
    );
  }
}
