part of 'settings_page.dart';

/// This class creates a [SettingSection] which shows some social
/// interaction settings, like enabling transaction share.
class SocialSection extends StatefulWidget {
  @override
  _SocialSectionState createState() => _SocialSectionState();
}

class _SocialSectionState extends State<SocialSection> {
  bool _isTxShareEnabled = UserSettings.getTXShare();

  @override
  Widget build(BuildContext context) {
    return SettingSection(
      title: LocaleKeys.settings_page_social.tr(),
      items: [
        SettingSwitchItem(
            title: LocaleKeys.settings_page_tx_share.tr(),
            priority: ItemPriority.disabled,
            description: LocaleKeys.settings_page_tx_share_desc.tr(),
            value: _isTxShareEnabled,
            onChanged: (val) {
              UserSettings.setTXShare(val: val);
              setState(() {
                _isTxShareEnabled = val;
              });
            }),
      ],
    );
  }
}
