import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cone/src/flutter/add_transaction.dart';
import 'package:cone/src/flutter/home.dart';
import 'package:cone/src/flutter/settings.dart';
import 'package:cone/src/flutter/settings_model.dart';

class ConeApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => SettingsModel(),
      child: ConeSettings(),
    );
  }
}

class ConeSettings extends StatefulWidget {
  ConeSettingsState createState() => ConeSettingsState();
}

class ConeSettingsState extends State<ConeSettings> {
  Future<SharedPreferences> sharedPreferences;

  initState() {
    super.initState();
    sharedPreferences = SharedPreferences.getInstance().then(
      (SharedPreferences prefs) {
        Provider.of<SettingsModel>(context).sharedPreferences = prefs;
        Provider.of<SettingsModel>(context).defaultCurrency ??= 'USD';
        Provider.of<SettingsModel>(context).defaultAccountOne ??=
            'expenses:miscellaneous';
        Provider.of<SettingsModel>(context).defaultAccountTwo ??=
            'assets:checking';
      },
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sharedPreferences,
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.green,
                accentColor: Colors.amberAccent,
              ),
              routes: {
                '/': (context) => Home(),
                '/add-transaction': (context) => AddTransaction(),
                '/settings': (context) => Settings(),
              },
            );
        }
      },
    );
  }
}
