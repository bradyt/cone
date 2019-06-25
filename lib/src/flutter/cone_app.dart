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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
      builder: (BuildContext context) => SettingsModel(),
      child: ConeSettings(),
    );
  }
}

class ConeSettings extends StatefulWidget {
  @override
  ConeSettingsState createState() => ConeSettingsState();
}

class ConeSettingsState extends State<ConeSettings> {
  Future<SharedPreferences> sharedPreferences;

  @override
  void initState() {
    super.initState();
    sharedPreferences = SharedPreferences.getInstance().then(
      (SharedPreferences prefs) {
        Provider.of<SettingsModel>(context).sharedPreferences = prefs;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: sharedPreferences,
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return MaterialApp(
              localeListResolutionCallback: (Iterable<Locale> locales,
                  Iterable<Locale> supportedLocales) {
                Future<void>.microtask(
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
              localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                ConeLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const <Locale>[
                Locale('en', 'US'),
                Locale('es', 'MX'),
                Locale('pt', 'BR'),
              ],
              theme: ThemeData(
                primarySwatch: Colors.green,
                accentColor: Colors.amberAccent,
              ),
              routes: <String, Widget Function(BuildContext)>{
                '/': (BuildContext context) => Home(),
                '/add-transaction': (BuildContext context) => AddTransaction(),
                '/settings': (BuildContext context) => Settings(),
              },
            );
        }
      },
    );
  }
}
