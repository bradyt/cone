import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  SharedPreferences prefs;

  String _defaultCurrency;
  String _defaultAccountOne;
  String _defaultAccountTwo;

  SettingsModel(this.prefs);

  String get defaultCurrency {
    if (_defaultCurrency == null) {
      _defaultCurrency = prefs.getString('default_currency');
      if (_defaultCurrency == null) {
        _defaultCurrency = 'USD';
        prefs.setString('default_currency', _defaultCurrency);
      }
      notifyListeners();
    }
    return _defaultCurrency;
  }

  set defaultCurrency(String defaultCurrency) {
    if (defaultCurrency != _defaultCurrency) {
      prefs.setString('default_currency', defaultCurrency);
      _defaultCurrency = defaultCurrency;
      notifyListeners();
    }
  }

  String get defaultAccountOne {
    if (_defaultAccountOne == null) {
      _defaultAccountOne = prefs.getString('default_account_one');
      if (_defaultAccountOne == null) {
        _defaultAccountOne = 'expenses:miscellaneous';
        prefs.setString('default_account_one', _defaultAccountOne);
      }
      notifyListeners();
    }
    return _defaultAccountOne;
  }

  set defaultAccountOne(String defaultAccountOne) {
    if (defaultAccountOne != _defaultAccountOne) {
      prefs.setString('default_account_one', defaultAccountOne);
      _defaultAccountOne = defaultAccountOne;
      notifyListeners();
    }
  }

  String get defaultAccountTwo {
    if (_defaultAccountTwo == null) {
      _defaultAccountTwo = prefs.getString('default_account_two');
      if (_defaultAccountTwo == null) {
        _defaultAccountTwo = 'assets:checking';
        prefs.setString('default_account_two', _defaultAccountTwo);
      }
      notifyListeners();
    }
    return _defaultAccountTwo;
  }

  set defaultAccountTwo(String defaultAccountTwo) {
    if (defaultAccountTwo != _defaultAccountTwo) {
      prefs.setString('default_account_two', defaultAccountTwo);
      _defaultAccountTwo = defaultAccountTwo;
      notifyListeners();
    }
  }
}
