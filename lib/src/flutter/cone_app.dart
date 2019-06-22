import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cone/src/flutter/add_transaction.dart';
import 'package:cone/src/flutter/cone_localizations.dart';
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
              localeListResolutionCallback: (Iterable<Locale> locales,
                  Iterable<Locale> supportedLocales) {
                Future.microtask(
                  () {
                    Provider.of<SettingsModel>(context).defaultCurrency ??=
                        NumberFormat.currency(locale: locales.first.toString())
                            .currencyName;
                  },
                );
                for (final Locale locale in locales) {
                  if (supportedLocales.contains(locale)) {
                    return locale;
                  }
                }
                return supportedLocales.first;
              },
              localizationsDelegates: const [
                ConeLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('es', 'MX'),
                Locale('pt', 'BR'),
              ],
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
