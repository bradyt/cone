import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  String _defaultCurrency;
  String _defaultAccountOne;
  String _defaultAccountTwo;
  SharedPreferences prefs;

  set sharedPreferences(SharedPreferences preferences) {
    prefs = preferences;
  }

  String get defaultCurrency {
    return _defaultCurrency;
  }

  set defaultCurrency(String defaultCurrency) {
    prefs.setString('default_currency', defaultCurrency);
    _defaultCurrency = defaultCurrency;
    notifyListeners();
  }

  String get defaultAccountOne {
    return _defaultAccountOne;
  }

  set defaultAccountOne(String defaultAccountOne) {
    prefs.setString('default_account_one', defaultAccountOne);
    _defaultAccountOne = defaultAccountOne;
    notifyListeners();
  }

  String get defaultAccountTwo {
    return _defaultAccountTwo;
  }

  set defaultAccountTwo(String defaultAccountTwo) {
    prefs.setString('default_account_two', defaultAccountTwo);
    _defaultAccountTwo = defaultAccountTwo;
    notifyListeners();
  }
}
