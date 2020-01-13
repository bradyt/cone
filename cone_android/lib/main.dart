import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cone/src/add_transaction.dart';
import 'package:cone/src/home.dart';
import 'package:cone/src/localizations.dart';
import 'package:cone/src/model.dart';
import 'package:cone/src/settings.dart';
import 'package:cone/src/state_management/settings_model.dart'
    show ConeBrightness;

void main({bool snapshots = false}) {
  runApp(
    Provider<bool>.value(
      value: snapshots,
      child: ConeSharedPreferences(),
    ),
  );
}

class ConeSharedPreferences extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider<SharedPreferences>.value(
      value: SharedPreferences.getInstance(),
      child: ConeProvider(),
    );
  }
}

class ConeProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SharedPreferences prefs = Provider.of<SharedPreferences>(context);

    if (prefs == null) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('cone'),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return ChangeNotifierProvider<ConeModel>(
      create: (BuildContext context) {
        return ConeModel(
          sharedPreferences: prefs,
        );
      },
      child: ConeApp(),
    );
  }
}

class ConeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConeBrightness brightness = ConeModel.of(context).brightness;
    return MaterialApp(
      title: 'cone',
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        ConeLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', 'US'),
        Locale('de'),
        Locale('es', 'MX'),
        Locale('fil'),
        Locale('fr'),
        Locale('hi'),
        Locale('in'),
        Locale('it'),
        Locale('ja'),
        Locale('pt', 'BR'),
        Locale('ru', 'RU'),
        Locale('th'),
        Locale('zh'),
      ],
      theme: (brightness == ConeBrightness.dark)
          ? ThemeData(
              brightness: Brightness.dark,
              accentColor: Colors.greenAccent,
            )
          : ThemeData(
              primarySwatch: Colors.green,
              accentColor: Colors.amberAccent,
            ),
      darkTheme: (brightness == ConeBrightness.auto)
          ? ThemeData(
              brightness: Brightness.dark,
              accentColor: Colors.greenAccent,
            )
          : null,
      routes: <String, Widget Function(BuildContext)>{
        '/': (BuildContext context) => Home(),
        '/add-transaction': (BuildContext context) => AddTransaction(),
        '/settings': (BuildContext context) => Settings(),
      },
    );
  }
}
