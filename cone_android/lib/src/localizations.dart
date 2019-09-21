import 'dart:ui';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

class ConeLocalizations {
  ConeLocalizations(this.locale);

  final Locale locale;

  static ConeLocalizations of(BuildContext context) {
    return Localizations.of<ConeLocalizations>(context, ConeLocalizations);
  }

  NumberFormat get numberFormat {
    return NumberFormat(
      '0.00########',
      locale.toString(),
    );
  }

  String get currencyName {
    return NumberFormat.currency(
      locale: locale.toString(),
    ).currencyName;
  }

  static final Map<String, Map<String, String>> _localizedValues =
      <String, Map<String, String>>{
    'pt': <String, String>{
      'addTransaction': 'Adicionar transação',
      'settings': 'Definições',
      'defaultCurrency': 'Moeda padrão',
      'currencyOnLeft': 'Moeda à esquerda',
      'enterDefaultCurrency': 'Digite moeda predefinida',
      'submit': 'Enviar',
    },
    'en': <String, String>{
      'addTransaction': 'Add transaction',
      'settings': 'Settings',
      'defaultCurrency': 'Default Currency',
      'currencyOnLeft': 'Currency on left',
      'enterDefaultCurrency': 'Enter default currency',
      'submit': 'Submit',
    },
    'es': <String, String>{
      'addTransaction': 'Añadir transacción',
      'settings': 'Ajustes',
      'defaultCurrency': 'Moneda por defecto',
      'currencyOnLeft': 'Moneda a la izquierda',
      'enterDefaultCurrency': 'Introduzca la moneda por defecto',
      'submit': 'Enviar',
    },
    'ru': <String, String>{
      'addTransaction': 'Добавить транзакцию',
      'settings': 'Настройки',
      'defaultCurrency': 'Валюта по-умолчанию',
      'currencyOnLeft': 'Валюта слева',
      'enterDefaultCurrency': 'Введите валюту по-умолчанию',
      'submit': 'Принять',
    },
  };

  String get settings {
    return _localizedValues[locale.languageCode]['settings'];
  }

  String get addTransaction {
    return _localizedValues[locale.languageCode]['addTransaction'];
  }

  String get defaultCurrency {
    return _localizedValues[locale.languageCode]['defaultCurrency'];
  }

  String get currencyOnLeft {
    return _localizedValues[locale.languageCode]['currencyOnLeft'];
  }

  String get enterDefaultCurrency {
    return _localizedValues[locale.languageCode]['enterDefaultCurrency'];
  }

  String get submit {
    return _localizedValues[locale.languageCode]['submit'];
  }
}

class ConeLocalizationsDelegate
    extends LocalizationsDelegate<ConeLocalizations> {
  const ConeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'es',
        'pt',
        'ru',
      ].contains(locale.languageCode);

  @override
  Future<ConeLocalizations> load(Locale locale) {
    return SynchronousFuture<ConeLocalizations>(ConeLocalizations(locale));
  }

  @override
  bool shouldReload(ConeLocalizationsDelegate old) => false;
}
