import 'package:flutter/material.dart';

/// This class is used to have recurring theme of column rows
/// of the add page.
class RowWrapper extends StatelessWidget {
  final IconData leadingIcon;
  final bool isExpandable;
  final double iconSize;
  final bool isExpanded;
  final Function onTap;
  final Function(bool) onSwitch;
  final bool isChild;
  final Widget child;

  const RowWrapper({
    Key key,
    @required this.leadingIcon,
    @required this.isExpandable,
    @required this.iconSize,
    this.isExpanded,
    this.onTap,
    @required this.isChild,
    this.child,
    this.onSwitch,
  })  : assert(leadingIcon != null),
        assert(isExpandable != null),
        assert(iconSize != null),
        assert(isChild != null),
        // ignore: avoid_bool_literals_in_conditional_expressions
        assert(isExpandable ? isExpanded != null : true),
        // ignore: avoid_bool_literals_in_conditional_expressions
        assert(isExpandable ? onSwitch != null : true),
        super(key: key);

  double get _iconPadding => 8;

  @override
  Widget build(BuildContext context) {
    final double leftInset = 10 * (isChild ? 4.0 : 1.0);

    return Container(
      padding: EdgeInsets.fromLTRB(leftInset, 4, 10, 4),
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: <Widget>[
          _buildLeading(context),
          if (isExpandable)
            _buildExpandableSwitch()
          else
            _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return SizedBox(
      width: iconSize + _iconPadding,
      height: iconSize + _iconPadding,
      child: Icon(
        leadingIcon,
        size: iconSize,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: iconSize + _iconPadding,
        child: onTap != null
            ? InkWell(
                onTap: () => onTap(),
                child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color:
                                  Theme.of(context).colorScheme.onBackground)),
                    ),
                    child:
                        Align(alignment: Alignment.centerRight, child: child)),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.onBackground)),
                ),
                child: Align(alignment: Alignment.centerRight, child: child)),
      ),
    );
  }

  Widget _buildExpandableSwitch() {
    return Expanded(
      child: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: iconSize + _iconPadding,
        child: Switch.adaptive(
          value: isExpanded,
          onChanged: (val) => onSwitch(val),
        ),
      ),
    );
  }
}
