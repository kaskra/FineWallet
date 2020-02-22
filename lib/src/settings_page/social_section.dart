import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/settings_page/parts/section.dart';
import 'package:flutter/material.dart';

class SocialSection extends StatefulWidget {
  @override
  _SocialSectionState createState() => _SocialSectionState();
}

class _SocialSectionState extends State<SocialSection> {
  bool _isEnabled = true;

  @override
  void initState() {
    setState(() {
      _isEnabled = UserSettings.getTXShare();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Social",
      children: <SectionItem>[
        _buildShareToggle(),
      ],
    );
  }

  Widget _buildShareToggle() {
    return SectionItem(
      title: "Enable TX SHARE (UNUSED)",
      trailing: Switch(
        value: _isEnabled,
        onChanged: (val) {
          UserSettings.setTXShare(val);
          setState(() {
            _isEnabled = val;
          });
        },
      ),
    );
  }
}
