import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  String _ledgerFileUri;
  String _ledgerFileDisplayName;
  String _defaultCurrency;
  bool _currencyOnLeft;
  SharedPreferences prefs;

  set sharedPreferences(SharedPreferences preferences) {
    prefs = preferences;
  }

  String get ledgerFileUri {
    return _ledgerFileUri ?? prefs.getString('ledger_file_uri');
  }

  set ledgerFileUri(String ledgerFileUri) {
    prefs.setString('ledger_file_uri', ledgerFileUri);
    _ledgerFileUri = ledgerFileUri;
    notifyListeners();
  }

  String get ledgerFileDisplayName {
    return _ledgerFileDisplayName ??
        prefs.getString('ledger_file_display_name');
  }

  set ledgerFileDisplayName(String ledgerFileDisplayName) {
    prefs.setString('ledger_file_display_name', ledgerFileDisplayName);
    _ledgerFileDisplayName = ledgerFileDisplayName;
    notifyListeners();
  }

  String get defaultCurrency {
    return _defaultCurrency ?? prefs.getString('default_currency');
  }

  set defaultCurrency(String defaultCurrency) {
    prefs.setString('default_currency', defaultCurrency);
    _defaultCurrency = defaultCurrency;
    notifyListeners();
  }

  bool get currencyOnLeft {
    return _currencyOnLeft ?? prefs.getBool('currency_on_left');
  }

  set currencyOnLeft(bool currencyOnLeft) {
    prefs.setBool('currency_on_left', currencyOnLeft);
    _currencyOnLeft = currencyOnLeft;
    notifyListeners();
  }
}
