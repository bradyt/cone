import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  String _defaultCurrency;
  bool _currencyOnLeft;
  String _defaultAccountOne;
  String _defaultAccountTwo;
  SharedPreferences prefs;

  set sharedPreferences(SharedPreferences preferences) {
    prefs = preferences;
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
    return _currencyOnLeft ?? prefs.getBool('default_currency');
  }

  set currencyOnLeft(bool currencyOnLeft) {
    prefs.setBool('currency_on_left', currencyOnLeft);
    _currencyOnLeft = currencyOnLeft;
    notifyListeners();
  }

  String get defaultAccountOne {
    return _defaultAccountOne ?? prefs.getString('default_account_one');
  }

  set defaultAccountOne(String defaultAccountOne) {
    prefs.setString('default_account_one', defaultAccountOne);
    _defaultAccountOne = defaultAccountOne;
    notifyListeners();
  }

  String get defaultAccountTwo {
    return _defaultAccountTwo ?? prefs.getString('default_account_two');
  }

  set defaultAccountTwo(String defaultAccountTwo) {
    prefs.setString('default_account_two', defaultAccountTwo);
    _defaultAccountTwo = defaultAccountTwo;
    notifyListeners();
  }
}
