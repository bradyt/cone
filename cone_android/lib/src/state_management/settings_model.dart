import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel {
  SettingsModel({@required SharedPreferences sharedPreferences})
      : assert(sharedPreferences != null,
            'Please wait for shared preferences before initializing model') {
    _prefs = sharedPreferences;
    _prefs
      ..setBool(
        'debug_mode',
        !kReleaseMode && (_prefs.getBool('debug_mode') ?? false),
      )
      ..setString(
        'default_currency',
        defaultCurrency ??
            NumberFormat.currency(locale: Intl.systemLocale).currencyName,
      )
      ..setBool(
        'currency_on_left',
        _prefs.getBool('currency_on_left') ?? false,
      );
  }

  SharedPreferences _prefs;
  bool get debugMode => _prefs.getBool('debug_mode');
  String get defaultCurrency => _prefs.getString('default_currency');
  bool get currencyOnLeft => _prefs.getBool('currency_on_left');
  String get ledgerFileUri => _prefs.getString('ledger_file_uri');
  String get ledgerFileDisplayName =>
      _prefs.getString('ledger_file_display_name');

  void toggleDebugMode() =>
      _prefs.setBool('debug_mode', !_prefs.getBool('debug_mode'));

  set defaultCurrency(String _defaultCurrency) =>
      _prefs.setString('default_currency', _defaultCurrency);

  void toggleCurrencyOnLeft() =>
      _prefs.setBool('currency_on_left', !_prefs.getBool('currency_on_left'));

  void setLedgerFile(String ledgerFileUri, String ledgerFileDisplayName) {
    _prefs
      ..setString('ledger_file_uri', ledgerFileUri)
      ..setString('ledger_file_display_name', ledgerFileDisplayName);
  }
}
