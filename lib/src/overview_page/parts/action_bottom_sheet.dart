import 'package:flutter/material.dart';

class ActionBottomSheet extends StatelessWidget {
  final List<Widget> actions;

  const ActionBottomSheet({Key key, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) => _buildBody(context),
      onClosing: () {
        print("Closing!");
      },
      enableDrag: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      height: 65.0 * actions.length,
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
