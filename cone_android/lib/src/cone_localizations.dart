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
      'date': 'Encontro',
      'description': 'Descrição',
      'account': 'Conta',
      'enterADate': 'Insira uma data.',
      'tryRFC3339': 'Tente RFC 3339.',
      'enterADescription': 'Digite uma descrição.',
      'enterAnAccount': 'Digite uma Conta',
      'enterAnAmount': 'Digite um valor',
      'secondEmptyAmount': 'Quantidade segunda vazio',
      'settings': 'Definições',
      'defaultCurrency': 'Moeda padrão',
      'currencyOnLeft': 'Moeda à esquerda',
      'enterDefaultCurrency': 'Digite moeda predefinida',
      'submit': 'Enviar',
    },
    'en': <String, String>{
      'addTransaction': 'Add transaction',
      'date': 'Date',
      'description': 'Description',
      'account': 'Account',
      'enterADate': 'Enter a date.',
      'tryRFC3339': 'Try RFC 3339.',
      'enterADescription': 'Enter a description.',
      'enterAnAccount': 'Enter an account',
      'enterAnAmount': 'Enter an amount',
      'secondEmptyAmount': 'Second empty amount',
      'settings': 'Settings',
      'defaultCurrency': 'Default Currency',
      'currencyOnLeft': 'Currency on left',
      'enterDefaultCurrency': 'Enter default currency',
      'submit': 'Submit',
    },
    'es': <String, String>{
      'addTransaction': 'Añadir transacción',
      'date': 'Fecha',
      'description': 'Descripción',
      'currency': 'Moneda',
      'enterADate': 'Ingrese una fecha.',
      'tryRFC3339': 'Probar RFC 3339.',
      'enterADescription': 'Ingrese una descripción.',
      'enterAnAccount': 'Ingresa una cuenta',
      'enterAnAmount': 'Ingrese una cantidad',
      'secondEmptyAmount': 'Segunda cantidad vacía',
      'settings': 'Ajustes',
      'defaultCurrency': 'Moneda por defecto',
      'currencyOnLeft': 'Moneda a la izquierda',
      'enterDefaultCurrency': 'Introduzca la moneda por defecto',
      'submit': 'Enviar',
    },
    'ru': <String, String>{
      'addTransaction': 'Добавить транзакцию',
      'date': 'Дата',
      'description': 'Описание',
      'account': 'Счет',
      'enterADate': 'Введите дату.',
      'tryRFC3339': 'Попытаться RFC 3339.',
      'enterADescription': 'Введите описание.',
      'enterAnAccount': 'Введите счет',
      'enterAnAmount': 'Введите сумму',
      'secondEmptyAmount': 'Второй счёт пуст',
      'settings': 'Настройки',
      'defaultCurrency': 'Валюта по-умолчанию',
      'currencyOnLeft': 'Валюта слева',
      'enterDefaultCurrency': 'Введите валюту по-умолчанию',
      'submit': 'Принять',
    },
  };

  String get date {
    return _localizedValues[locale.languageCode]['date'];
  }

  String get description {
    return _localizedValues[locale.languageCode]['description'];
  }

  String get account {
    return _localizedValues[locale.languageCode]['account'];
  }

  String get enterADate {
    return _localizedValues[locale.languageCode]['enterADate'];
  }

  String get tryRFC3339 {
    return _localizedValues[locale.languageCode]['tryRFC3339'];
  }

  String get enterADescription {
    return _localizedValues[locale.languageCode]['enterADescription'];
  }

  String get enterAnAccount {
    return _localizedValues[locale.languageCode]['enterAnAccount'];
  }

  String get enterAnAmount {
    return _localizedValues[locale.languageCode]['enterAnAmount'];
  }

  String get secondEmptyAmount {
    return _localizedValues[locale.languageCode]['secondEmptyAmount'];
  }

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
