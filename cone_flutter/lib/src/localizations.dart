import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import 'package:cone/src/localized_values.dart' show localizedValues;

class ConeLocalizations {
  ConeLocalizations(this.locale);

  final Locale locale;

  static ConeLocalizations? of(BuildContext context) {
    return Localizations.of<ConeLocalizations>(context, ConeLocalizations);
  }

  NumberFormat get numberFormat {
    return NumberFormat(
      '0.00########',
      locale.toString(),
    );
  }

  String? get currencyName {
    return NumberFormat.currency(
      locale: locale.toString(),
    ).currencyName;
  }

  static final Map<String, Map<String, String>> _localizedValues =
      localizedValues;

  String? get addTransaction {
    return _localizedValues[locale.languageCode]!['addTransaction'];
  }

  String? get currencyOnLeft {
    return _localizedValues[locale.languageCode]!['currencyOnLeft'];
  }

  String? get defaultCurrency {
    return _localizedValues[locale.languageCode]!['defaultCurrency'];
  }

  String? get enterDefaultCurrency {
    return _localizedValues[locale.languageCode]!['enterDefaultCurrency'];
  }

  String? get ledgerFile {
    return _localizedValues[locale.languageCode]!['ledgerFile'];
  }

  String? get numberLocale {
    return _localizedValues[locale.languageCode]!['numberLocale'];
  }

  String? get reverseSort {
    return _localizedValues[locale.languageCode]!['reverseSort'];
  }

  String? get settings {
    return _localizedValues[locale.languageCode]!['settings'];
  }

  String? get spacing {
    return _localizedValues[locale.languageCode]!['spacing'];
  }

  String? get submit {
    return _localizedValues[locale.languageCode]!['submit'];
  }
}

class ConeLocalizationsDelegate
    extends LocalizationsDelegate<ConeLocalizations> {
  const ConeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fil',
        'fr',
        'hi',
        'in',
        'it',
        'ja',
        'pt',
        'ru',
        'th',
        'zh',
      ].contains(locale.languageCode);

  @override
  Future<ConeLocalizations> load(Locale locale) {
    return SynchronousFuture<ConeLocalizations>(ConeLocalizations(locale));
  }

  @override
  bool shouldReload(ConeLocalizationsDelegate old) => false;
}
