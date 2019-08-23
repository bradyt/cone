import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cone/src/add_transaction.dart';
import 'package:cone/src/cone_localizations.dart';
import 'package:cone/src/home.dart';
import 'package:cone/src/settings.dart';
import 'package:cone/src/settings_model.dart';

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
        Provider.of<SettingsModel>(context).currencyOnLeft ??= false;
        return prefs;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: sharedPreferences,
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        Widget result;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            result = const Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            result = MaterialApp(
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
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                accentColor: Colors.greenAccent,
              ),
              routes: <String, Widget Function(BuildContext)>{
                '/': (BuildContext context) => Home(),
                '/add-transaction': (BuildContext context) => AddTransaction(),
                '/settings': (BuildContext context) => Settings(),
              },
            );
        }
        return result;
      },
    );
  }
}
