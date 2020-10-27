import 'dart:core';

import 'package:flutter/material.dart';

const Map<String, String> localeToLanguage = {
  "en": "English",
  "de": "Deutsch",
};

extension FullLanguage on Locale {
  String getFullLanguageName() => localeToLanguage.containsKey(languageCode)
      ? localeToLanguage[languageCode]
      : languageCode;
}
