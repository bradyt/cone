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
      '0.00',
      locale.toString(),
    );
  }

  String get currencyName {
    return NumberFormat.currency(
      locale: locale.toString(),
    ).currencyName;
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'pt': {
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
      'expensesMiscellaneous': 'despesas:miscelânea',
      'assetsChecking': 'ativas:corrente',
      'defaultCurrency': 'Moeda padrão',
      'defaultAccountOne': 'Conta padrão one',
      'defaultAccountTwo': 'Conta padrão dois',
      'enterDefaultCurrency': 'Digite moeda predefinida',
      'enterFirstDefaultAccount': 'Digite primeira conta padrão',
      'enterSecondDefaultAccount': 'Digite conta segundo padrão',
      'submit': 'Enviar',
    },
    'en': {
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
      'expensesMiscellaneous': 'expenses:miscellaneous',
      'assetsChecking': 'assets:checking',
      'defaultCurrency': 'Default Currency',
      'defaultAccountOne': 'Default account one',
      'defaultAccountTwo': 'Default account two',
      'enterDefaultCurrency': 'Enter default currency',
      'enterFirstDefaultAccount': 'Enter first default account',
      'enterSecondDefaultAccount': 'Enter second default account',
      'submit': 'Submit',
    },
    'es': {
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
      'expensesMiscellaneous': 'gastos:diversos',
      'assetsChecking': 'bienes:cheques',
      'defaultCurrency': 'Moneda por defecto',
      'defaultAccountOne': 'Primera cuenta por defecto',
      'defaultAccountTwo': 'Segunda cuenta por defecto',
      'enterDefaultCurrency': 'Introduzca la moneda por defecto',
      'enterFirstDefaultAccount': 'Ingrese la primera cuenta predeterminada',
      'enterSecondDefaultAccount': 'Ingrese la segunda cuenta predeterminada',
      'submit': 'Enviar',
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

  String get expensesMiscellaneous {
    return _localizedValues[locale.languageCode]['expensesMiscellaneous'];
  }

  String get assetsChecking {
    return _localizedValues[locale.languageCode]['assetsChecking'];
  }

  String get addTransaction {
    return _localizedValues[locale.languageCode]['addTransaction'];
  }

  String get defaultCurrency {
    return _localizedValues[locale.languageCode]['defaultCurrency'];
  }

  String get defaultAccountOne {
    return _localizedValues[locale.languageCode]['defaultAccountOne'];
  }

  String get defaultAccountTwo {
    return _localizedValues[locale.languageCode]['defaultAccountTwo'];
  }

  String get enterDefaultCurrency {
    return _localizedValues[locale.languageCode]['enterDefaultCurrency'];
  }

  String get enterFirstDefaultAccount {
    return _localizedValues[locale.languageCode]['enterFirstDefaultAccount'];
  }

  String get enterSecondDefaultAccount {
    return _localizedValues[locale.languageCode]['enterSecondDefaultAccount'];
  }

  String get submit {
    return _localizedValues[locale.languageCode]['submit'];
  }
}

class ConeLocalizationsDelegate
    extends LocalizationsDelegate<ConeLocalizations> {
  const ConeLocalizationsDelegate();

  bool isSupported(Locale locale) => [
        'en',
        'es',
        'pt',
      ].contains(locale.languageCode);

  Future<ConeLocalizations> load(Locale locale) {
    return SynchronousFuture<ConeLocalizations>(ConeLocalizations(locale));
  }

  @override
  bool shouldReload(ConeLocalizationsDelegate old) => false;
}
