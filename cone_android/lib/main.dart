import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cone/src/add_transaction.dart';
import 'package:cone/src/home.dart';
import 'package:cone/src/localizations.dart';
import 'package:cone/src/model.dart';
import 'package:cone/src/settings.dart';

void main() {
  runApp(
    ConeSharedPreferences(),
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
      builder: (BuildContext context) {
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
    return MaterialApp(
      title: 'cone.dev',
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
}
