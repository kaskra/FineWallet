import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/material.dart';

class SocialSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Section(
      children: <SectionItem>[
        _buildShareToggle(),
      ],
    );
  }

  Widget _buildShareToggle() {
    return SectionItem(
      title: "Enable Sharing",
      trailing: Switch(
        value: true,
        onChanged: (val) {
          print("Enable sharing? $val");
        },
      ),
    );
  }
}
