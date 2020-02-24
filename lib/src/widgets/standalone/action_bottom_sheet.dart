import 'package:flutter/material.dart';

class ActionBottomSheet extends StatelessWidget {
  final List<Widget> actions;
  final double itemHeight;

  const ActionBottomSheet({Key key, this.actions, this.itemHeight = 75})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) => _buildBody(context),
      onClosing: () {},
      enableDrag: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      height: itemHeight * actions.length,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: actions,
        ),
      ),
    );
  }
}
