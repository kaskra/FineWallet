import 'package:FineWallet/src/widgets/section.dart';
import 'package:flutter/material.dart';

class LocalizationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Section(
      children: <SectionItem>[
        _buildLanguage(),
        _buildCurrency(),
      ],
    );
  }

  Widget _buildLanguage() {
    return SectionItem(
      title: "Language",
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: 1,
          style: TextStyle(color: Colors.black),
          isDense: true,
          onChanged: (val) {
            print(val);
          },
          items: [
            DropdownMenuItem(
              child: Text("ENG"),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text("GER"),
              value: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrency() {
    return SectionItem(
      title: "Currency Symbol",
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: 1,
          style: TextStyle(color: Colors.black),
          isDense: true,
          onChanged: (val) {
            print(val);
          },
          items: [
            DropdownMenuItem(
              child: Text("\$"),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text("€"),
              value: 2,
            ),
          ],
        ),
      ),
    );
  }
}
