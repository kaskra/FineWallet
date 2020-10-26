part of 'settings_page.dart';

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
      title: LocaleKeys.settings_page_social.tr(),
      children: <SectionItem>[
        _buildShareToggle(),
      ],
    );
  }

  SectionItem _buildShareToggle() {
    return SectionItem(
      title: LocaleKeys.settings_page_tx_share.tr(),
      trailing: Switch(
        activeColor: Theme.of(context).accentColor,
        value: _isEnabled,
        onChanged: (val) {
          UserSettings.setTXShare(val: val);
          setState(() {
            _isEnabled = val;
          });
        },
      ),
    );
  }
}
