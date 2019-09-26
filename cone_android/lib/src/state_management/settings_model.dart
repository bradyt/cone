import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart' show NumberSymbols;
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;
import 'package:shared_preferences/shared_preferences.dart';

enum Spacing {
  zero,
  one,
}

class SettingsModel {
  SettingsModel({@required SharedPreferences sharedPreferences})
      : assert(sharedPreferences != null,
            'Please wait for shared preferences before initializing model') {
    _prefs = sharedPreferences;
    // ignore: cascade_invocations
    _prefs
      ..setBool('debug_mode', !kReleaseMode && (debugMode ?? false))
      ..setString('number_locale', numberLocale ?? Intl.systemLocale)
      ..setString(
          'default_currency',
          defaultCurrency ??
              NumberFormat.currency(locale: Intl.systemLocale).currencyName)
      ..setBool(
          'currency_on_left',
          currencyOnLeft ??
              numberFormatSymbols[numberLocale].CURRENCY_PATTERN.endsWith('0')
                  as bool)
      ..setInt('spacing', spacing.index);
  }

  SharedPreferences _prefs;
  bool get debugMode => _prefs.getBool('debug_mode');
  String get numberLocale => _prefs.getString('number_locale');
  String get defaultCurrency => _prefs.getString('default_currency');
  bool get currencyOnLeft => _prefs.getBool('currency_on_left');
  Spacing get spacing {
    if (_prefs.getInt('spacing') == null) {
      if ((numberFormatSymbols[numberLocale] as NumberSymbols)
          .CURRENCY_PATTERN
          .contains('\u00A0')) {
        _prefs.setInt('spacing', Spacing.one.index);
      } else {
        _prefs.setInt('spacing', Spacing.zero.index);
      }
    }
    return Spacing.values[_prefs.getInt('spacing')];
  }

  String get ledgerFileUri => _prefs.getString('ledger_file_uri');
  String get ledgerFileDisplayName =>
      _prefs.getString('ledger_file_display_name');

  void toggleDebugMode() =>
      _prefs.setBool('debug_mode', !_prefs.getBool('debug_mode'));

  set numberLocale(String _numberLocale) =>
      _prefs.setString('number_locale', _numberLocale);

  set defaultCurrency(String _defaultCurrency) =>
      _prefs.setString('default_currency', _defaultCurrency);

  void toggleCurrencyOnLeft() =>
      _prefs.setBool('currency_on_left', !_prefs.getBool('currency_on_left'));

  void toggleSpacing() =>
      _prefs.setInt('spacing', (spacing == Spacing.zero) ? 1 : 0);

  void setLedgerFile(String ledgerFileUri, String ledgerFileDisplayName) {
    _prefs
      ..setString('ledger_file_uri', ledgerFileUri)
      ..setString('ledger_file_display_name', ledgerFileDisplayName);
  }
}
